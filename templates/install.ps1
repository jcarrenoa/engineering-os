<#
.SYNOPSIS
    Installs all project dependencies based on the detected technology stack.
.NOTES
    Run from the project root:  .\install.ps1
    Or double-click:            install.bat

    Detection rules:
      pubspec.yaml     -> Flutter  : flutter pub get
      requirements.txt -> Python  : uv  OR  pip  (prompted on first run)
      go.mod           -> Go      : go mod download
      pom.xml          -> Spring  : mvn dependency:resolve
      *.csproj         -> .NET    : dotnet restore
      package.json     -> Node.js : bun  OR  pnpm  (prompted on first run)

    Preferences are saved to .eng-config.json in the project root.
    Delete that file to re-select package managers on the next run.
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

function Save-EngConfig($cfg) {
    $cfg | ConvertTo-Json | Set-Content $configFile -Encoding UTF8
}

function Select-PythonPkgManager {
    Write-Host ""
    Write-Host "  Select a Python package manager:" -ForegroundColor Cyan
    Write-Host "    [1] uv   (fast, modern - recommended)" -ForegroundColor White
    Write-Host "    [2] pip  (standard)" -ForegroundColor White
    $choice = ""
    while ($choice -notin @('1', '2')) {
        $choice = (Read-Host "  Enter choice (1/2)").Trim()
    }
    if ($choice -eq '1') { return "uv" } else { return "pip" }
}

function Select-TSPkgManager {
    Write-Host ""
    Write-Host "  Select a TypeScript / Node package manager:" -ForegroundColor Cyan
    Write-Host "    [1] bun   (fast, modern - recommended)" -ForegroundColor White
    Write-Host "    [2] pnpm  (standard)" -ForegroundColor White
    $choice = ""
    while ($choice -notin @('1', '2')) {
        $choice = (Read-Host "  Enter choice (1/2)").Trim()
    }
    if ($choice -eq '1') { return "bun" } else { return "pnpm" }
}

function Get-RequiredManagers {
    $dirs = if ((Test-Path "frontend") -and (Test-Path "backend")) { @("frontend", "backend") } else { @(".") }
    $result = @{ Python = $false; TS = $false }
    foreach ($d in $dirs) {
        if (-not (Test-Path $d)) { continue }
        $abs = (Resolve-Path $d).Path
        if (Test-Path (Join-Path $abs "requirements.txt")) { $result.Python = $true }
        if (Test-Path (Join-Path $abs "package.json"))     { $result.TS     = $true }
    }
    return $result
}

# ── Python installers ──────────────────────────────────────────────────────────

function Install-PythonWithUv($abs, $dir) {
    if (-not (Test-Cmd "uv")) {
        Write-Host "  uv not found - installing via pip..." -ForegroundColor Yellow
        $pythonCmd = $null
        foreach ($c in @('python', 'py')) {
            if (Test-Cmd $c) {
                $worked = $false
                try { & $c --version *>&1 | Out-Null; $worked = ($LASTEXITCODE -eq 0) } catch {}
                if ($worked) { $pythonCmd = $c; break }
            }
        }
        if (-not $pythonCmd) {
            Write-Host "  [ERROR] Python not found - cannot install uv." -ForegroundColor Red
            Write-Host "          Install Python from https://python.org then re-run." -ForegroundColor DarkGray
            Write-Host ""
            return
        }
        & $pythonCmd -m pip install uv --quiet
        $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
        if (-not (Test-Cmd "uv")) {
            Write-Host "  [ERROR] uv install failed. Try manually: pip install uv" -ForegroundColor Red
            Write-Host ""
            return
        }
    }
    Push-Location $abs
    uv venv .venv
    uv pip install -r requirements.txt
    Pop-Location
    Write-Host "  [OK] Python deps installed (uv)" -ForegroundColor Green
    Write-Host "       Activate with: $dir\.venv\Scripts\activate" -ForegroundColor DarkGray
}

function Install-PythonWithPip($abs, $dir) {
    $pythonCmd = $null
    foreach ($candidate in @('python', 'py')) {
        if (Test-Cmd $candidate) {
            $worked = $false
            try {
                & $candidate --version *>&1 | Out-Null
                $worked = ($LASTEXITCODE -eq 0)
            } catch { $worked = $false }
            if ($worked) { $pythonCmd = $candidate; break }
        }
    }

    if (-not $pythonCmd) {
        Write-Host "  [SKIP] Python not found or only the Windows Store alias is present." -ForegroundColor Yellow
        Write-Host "         Install Python from https://python.org (check 'Add to PATH')," -ForegroundColor DarkGray
        Write-Host "         or disable the alias: Settings > Apps > App execution aliases." -ForegroundColor DarkGray
        return
    }

    $venv = Join-Path $abs ".venv"
    if (-not (Test-Path $venv)) {
        Write-Host "  Creating virtual environment ($pythonCmd)..." -ForegroundColor DarkGray
        & $pythonCmd -m venv $venv
        if ($LASTEXITCODE -ne 0) {
            Write-Host "  venv not available - installing virtualenv..." -ForegroundColor DarkGray
            & $pythonCmd -m pip install virtualenv --quiet
            & $pythonCmd -m virtualenv $venv
        }
    }
    $pipExe = Join-Path $venv "Scripts\pip.exe"
    if (-not (Test-Path $pipExe)) {
        Write-Host "  [ERROR] Virtual environment creation failed. Check your Python installation." -ForegroundColor Red
        Write-Host ""
        return
    }
    & $pipExe install --upgrade pip --quiet
    & $pipExe install -r (Join-Path $abs "requirements.txt")
    Write-Host "  [OK] Python deps installed (pip)" -ForegroundColor Green
    Write-Host "       Activate with: $dir\.venv\Scripts\activate" -ForegroundColor DarkGray
}

# ── TypeScript / Node installers ───────────────────────────────────────────────

function Install-TSWithBun($abs) {
    if (-not (Test-Cmd "bun")) {
        Write-Host "  bun not found - installing via npm..." -ForegroundColor Yellow
        if (-not (Test-Cmd "npm")) {
            Write-Host "  [ERROR] npm not found. Install Node.js from https://nodejs.org or bun from https://bun.sh" -ForegroundColor Red
            Write-Host ""
            return
        }
        npm install -g bun | Out-Null
        $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
    }
    if (Test-Cmd "bun") {
        Push-Location $abs
        bun install
        Pop-Location
        Write-Host "  [OK] Node deps installed (bun)" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] bun still not in PATH - falling back to pnpm" -ForegroundColor Yellow
        Install-TSWithPnpm $abs
    }
}

function Install-TSWithPnpm($abs) {
    if (-not (Test-Cmd "pnpm")) {
        Write-Host "  pnpm not found - installing via npm..." -ForegroundColor Yellow
        if (-not (Test-Cmd "npm")) {
            Write-Host "  [ERROR] npm not found. Install Node.js from https://nodejs.org" -ForegroundColor Red
            Write-Host ""
            return
        }
        npm install -g pnpm | Out-Null
        $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
    }
    if (Test-Cmd "pnpm") {
        Push-Location $abs
        pnpm install
        Pop-Location
        Write-Host "  [OK] Node deps installed (pnpm)" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] pnpm still not in PATH - falling back to npm install" -ForegroundColor Yellow
        Push-Location $abs
        npm install
        Pop-Location
        Write-Host "  [OK] Node deps installed (npm fallback)" -ForegroundColor Green
    }
}

# ── Main installer ─────────────────────────────────────────────────────────────

function Install-Dir {
    param([string]$dir, [string]$label, [PSCustomObject]$config)

    Write-Host $label -ForegroundColor Cyan

    if (-not (Test-Path $dir)) {
        Write-Host "  [SKIP] Directory not found." -ForegroundColor DarkGray
        Write-Host ""
        return
    }

    $abs = (Resolve-Path $dir).Path

    # Flutter
    if (Test-Path (Join-Path $abs "pubspec.yaml")) {
        if (-not (Test-Cmd "flutter")) {
            Write-Host "  [SKIP] Flutter SDK not found - install it and re-run." -ForegroundColor Yellow
        } else {
            Push-Location $abs
            flutter pub get
            Pop-Location
            if ($LASTEXITCODE -ne 0) {
                Write-Host "  [ERROR] flutter pub get failed - see output above." -ForegroundColor Red
            } else {
                Write-Host "  [OK] Flutter deps installed" -ForegroundColor Green
            }
        }

    # Python / FastAPI
    } elseif (Test-Path (Join-Path $abs "requirements.txt")) {
        Write-Host "  Package manager: $($config.python_pkg)" -ForegroundColor DarkGray
        if ($config.python_pkg -eq "uv") {
            Install-PythonWithUv $abs $dir
        } else {
            Install-PythonWithPip $abs $dir
        }

    # Go
    } elseif (Test-Path (Join-Path $abs "go.mod")) {
        if (-not (Test-Cmd "go")) {
            Write-Host "  [SKIP] Go not found - install Go and re-run." -ForegroundColor Yellow
        } else {
            $goModContent = Get-Content (Join-Path $abs "go.mod") -Raw
            if ($goModContent -match '(?m)^\s*require') {
                Push-Location $abs
                go mod download
                Pop-Location
                Write-Host "  [OK] Go modules downloaded" -ForegroundColor Green
            } else {
                Write-Host "  [OK] No external Go modules - nothing to download" -ForegroundColor Green
            }
        }

    # Spring Boot (Maven)
    } elseif (Test-Path (Join-Path $abs "pom.xml")) {
        $mvnCmd = $null
        if (Test-Cmd "mvn") {
            $mvnCmd = "mvn"
        } elseif (Test-Path (Join-Path $abs "mvnw.cmd")) {
            $mvnCmd = Join-Path $abs "mvnw.cmd"
        } elseif (Test-Path (Join-Path $abs "mvnw")) {
            $mvnCmd = Join-Path $abs "mvnw"
        }
        if (-not $mvnCmd) {
            Write-Host "  [SKIP] Maven not found - install Maven or add the mvnw wrapper." -ForegroundColor Yellow
        } else {
            Push-Location $abs
            & $mvnCmd dependency:resolve -q
            Pop-Location
            Write-Host "  [OK] Maven deps resolved" -ForegroundColor Green
        }

    # .NET
    } elseif (Get-ChildItem $abs -Filter "*.csproj" -ErrorAction SilentlyContinue | Select-Object -First 1) {
        if (-not (Test-Cmd "dotnet")) {
            Write-Host "  [SKIP] .NET SDK not found - install it and re-run." -ForegroundColor Yellow
        } else {
            Push-Location $abs
            dotnet restore
            Pop-Location
            Write-Host "  [OK] .NET packages restored" -ForegroundColor Green
        }

    # Node.js (React / Vue / Angular / NestJS)
    } elseif (Test-Path (Join-Path $abs "package.json")) {
        Write-Host "  Package manager: $($config.ts_pkg)" -ForegroundColor DarkGray
        if ($config.ts_pkg -eq "bun") {
            Install-TSWithBun $abs
        } else {
            Install-TSWithPnpm $abs
        }

    # Nothing detected
    } else {
        Write-Host "  [SKIP] No recognized dependency file found." -ForegroundColor DarkGray
    }

    Write-Host ""
}

# ── Entry point ────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "Installing dependencies" -ForegroundColor Cyan
Write-Host "-----------------------------------------"

$configExists = Test-Path $configFile
$config       = Read-EngConfig
$required     = Get-RequiredManagers
$configDirty  = $false

if ($required.Python -and (-not $configExists)) {
    Write-Host ""
    Write-Host "Python project detected." -ForegroundColor Yellow
    $config.python_pkg = Select-PythonPkgManager
    $configDirty = $true
}

if ($required.TS -and (-not $configExists)) {
    Write-Host ""
    Write-Host "TypeScript / Node project detected." -ForegroundColor Yellow
    $config.ts_pkg = Select-TSPkgManager
    $configDirty = $true
}

if ($configDirty) {
    Save-EngConfig $config
    Write-Host ""
    Write-Host "  Preferences saved to .eng-config.json" -ForegroundColor DarkGray
    Write-Host "  (Delete that file to re-select package managers on the next run)" -ForegroundColor DarkGray
}

Write-Host ""

if ((Test-Path "frontend") -and (Test-Path "backend")) {
    Install-Dir "frontend" "Frontend" $config
    Install-Dir "backend"  "Backend"  $config
} else {
    Install-Dir "." "Project" $config
}

Write-Host "-----------------------------------------"
Write-Host "Done." -ForegroundColor Green
Write-Host ""
