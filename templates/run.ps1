<#
.SYNOPSIS
    Starts the dev server(s) for the project in separate terminal windows.
.NOTES
    Run from the project root:  .\run.ps1
    Or double-click:            run.bat

    Start commands per technology:
      Flutter              -> flutter run
      React / Vue (Vite)   -> bun dev  /  pnpm dev
      Angular              -> bun start  /  pnpm start
      NestJS               -> bun run start:dev  /  pnpm run start:dev
      FastAPI              -> .venv python -m uvicorn app.main:app --reload
      Go                   -> go run .\cmd\api\main.go
      Spring Boot          -> mvn spring-boot:run
      .NET                 -> dotnet run

    The package manager used for TypeScript/Node projects is read from
    .eng-config.json (written by install.ps1 on first run).
#>

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$configFile = Join-Path $PSScriptRoot ".eng-config.json"

function Test-Cmd($name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

function Read-EngConfig {
    if (Test-Path $configFile) {
        $raw = Get-Content $configFile -Raw | ConvertFrom-Json
        $py = if ($raw.python_pkg) { $raw.python_pkg } else { "pip" }
        $ts = if ($raw.ts_pkg)     { $raw.ts_pkg     } else { "pnpm" }
        return [PSCustomObject]@{ python_pkg = $py; ts_pkg = $ts }
    }
    return [PSCustomObject]@{ python_pkg = "pip"; ts_pkg = "pnpm" }
}

$config = Read-EngConfig

function Start-Service {
    param([string]$dir, [string]$label)

    if (-not (Test-Path $dir)) { return }

    $abs = (Resolve-Path $dir).Path
    $cmd = $null

    # Flutter
    if (Test-Path (Join-Path $abs "pubspec.yaml")) {
        if (-not (Test-Cmd "flutter")) {
            Write-Host "  [SKIP] Flutter SDK not found - install it and re-run." -ForegroundColor Yellow
            Write-Host ""
            return
        }
        $cmd = "flutter run"

    # Angular (check before generic package.json)
    } elseif (Test-Path (Join-Path $abs "angular.json")) {
        if ($config.ts_pkg -eq "bun") { $cmd = "bun start" } else { $cmd = "pnpm start" }

    # NestJS (check before generic package.json)
    } elseif (Test-Path (Join-Path $abs "nest-cli.json")) {
        if ($config.ts_pkg -eq "bun") { $cmd = "bun run start:dev" } else { $cmd = "pnpm run start:dev" }

    # React / Vue (Vite)
    } elseif (Test-Path (Join-Path $abs "package.json")) {
        if ($config.ts_pkg -eq "bun") { $cmd = "bun dev" } else { $cmd = "pnpm dev" }

    # FastAPI (Python) — uses .venv regardless of uv/pip choice
    } elseif (Test-Path (Join-Path $abs "requirements.txt")) {
        $venvPy = Join-Path $abs ".venv\Scripts\python.exe"
        if (-not (Test-Path $venvPy)) {
            Write-Host "  [WARN] .venv not found in $label - run install.bat first." -ForegroundColor Yellow
            Write-Host ""
            return
        }
        $cmd = "& '.\\.venv\\Scripts\\python.exe' -m uvicorn app.main:app --reload --port 8000"

    # Go
    } elseif (Test-Path (Join-Path $abs "go.mod")) {
        if (-not (Test-Cmd "go")) {
            Write-Host "  [SKIP] Go not found - install Go and re-run." -ForegroundColor Yellow
            Write-Host ""
            return
        }
        $cmd = "go run .\cmd\api\main.go"

    # Spring Boot (Maven)
    } elseif (Test-Path (Join-Path $abs "pom.xml")) {
        $cmd = if (Test-Path (Join-Path $abs "mvnw.cmd")) { ".\mvnw.cmd spring-boot:run" } else { "mvn spring-boot:run" }

    # .NET
    } elseif (Get-ChildItem $abs -Filter "*.csproj" -ErrorAction SilentlyContinue | Select-Object -First 1) {
        if (-not (Test-Cmd "dotnet")) {
            Write-Host "  [SKIP] .NET SDK not found - install it and re-run." -ForegroundColor Yellow
            Write-Host ""
            return
        }
        $cmd = "dotnet run"

    } else {
        Write-Host "  [SKIP] No recognized project in $label" -ForegroundColor DarkGray
        Write-Host ""
        return
    }

    Write-Host "  $label  ->  $cmd" -ForegroundColor DarkGray
    Start-Process powershell -ArgumentList @(
        "-NoExit", "-NoProfile", "-ExecutionPolicy", "Bypass",
        "-Command", "[console]::Title = '$label'; Set-Location '$abs'; $cmd"
    )
    Write-Host "  [OK] $label window opened" -ForegroundColor Green
    Write-Host ""
}

# ── Entry point ────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "Starting dev servers" -ForegroundColor Cyan
Write-Host "-----------------------------------------"
Write-Host ""

if ((Test-Path "frontend") -and (Test-Path "backend")) {
    Start-Service "frontend" "Frontend"
    Start-Service "backend"  "Backend"
} else {
    Start-Service "." "Project"
}

Write-Host "-----------------------------------------"
Write-Host "Done. Check the opened windows for logs." -ForegroundColor Green
Write-Host ""
