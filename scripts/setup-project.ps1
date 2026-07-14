<#
.SYNOPSIS
    Sets up a new project or installs Engineering OS into an existing one.

.DESCRIPTION
    Creates the folder structure for the chosen technology stack, copies the
    ready-to-run starter template, installs the Engineering OS handbook and
    Claude Code commands, and replaces the project name placeholder in all
    generated files.

    Interactive mode: run without -ProjectType / -Frontend / -Backend flags
    and the script will prompt for each choice.

    Non-interactive mode: pass all flags directly (useful for CI or scripts).

.PARAMETER ProjectName
    Name of the new project (kebab-case recommended).
    When combined with -ProjectPath, this name is used instead of the directory name.

.PARAMETER DestinationPath
    Directory where the new project folder will be created.
    Defaults to the parent folder of the Engineering OS repo.

.PARAMETER ProjectPath
    When used alone: full path to an existing project directory where Engineering OS
    will be installed (uses the directory name as the project name).
    When combined with -ProjectName: treated as the parent directory — the project
    is created as a subfolder named after -ProjectName.

.PARAMETER ProjectType
    Type of project. Accepted values:
      frontend   — frontend only
      backend    — backend only
      fullstack  — frontend + backend
      skip       — create base directories only, no technology scaffold

.PARAMETER Frontend
    Frontend technology. Accepted values:
      flutter    — Flutter / Dart
      angular    — Angular / TypeScript
      react      — React / TypeScript  (Vite)
      vue        — Vue / TypeScript    (Vite)
      skip       — skip frontend scaffold

.PARAMETER Backend
    Backend technology. Accepted values:
      fastapi    — FastAPI / Python
      nestjs     — NestJS / TypeScript
      spring     — Spring Boot / Java or Kotlin
      dotnet     — .NET / C#
      go         — Go
      skip       — skip backend scaffold

.PARAMETER BackendArch
    Backend architecture pattern. Accepted values:
      hexagonal  — Hexagonal Architecture (Ports & Adapters)  [default]
      clean      — Clean Architecture  (api/ + config/ + database/ + external/ + http/)

.EXAMPLE
    .\setup-project.ps1 -ProjectName "my-app"

    Interactive setup. The script asks for project type, technologies, and
    architecture. Creates the project in the parent folder of Engineering OS.

.EXAMPLE
    .\setup-project.ps1 -ProjectName "my-app" -DestinationPath "C:\Projects"

    Interactive setup. Creates the project at C:\Projects\my-app.

.EXAMPLE
    .\setup-project.ps1 -ProjectPath "C:\Projects\my-existing-app"

    Installs Engineering OS into an existing project. Adds CLAUDE.md,
    .engineering-os/, and .claude/commands/ without touching existing files.

.EXAMPLE
    .\setup-project.ps1 -ProjectName "my-api" -ProjectType backend -Backend fastapi -BackendArch hexagonal

    Non-interactive. Creates a FastAPI + Hexagonal Architecture project.

.EXAMPLE
    .\setup-project.ps1 -ProjectName "my-app" -ProjectType fullstack -Frontend react -Backend fastapi -BackendArch clean

    Non-interactive. Creates a React + FastAPI project with Clean Architecture
    on the backend.

.EXAMPLE
    .\setup-project.ps1 -ProjectName "mobile-app" -ProjectType frontend -Frontend flutter

    Non-interactive. Creates a Flutter project.

.NOTES
    Starter templates live in:  templates/starters/<technology>/
    Handbook lives in:          .engineering-os/handbook/  (inside each project)
    Commands available after setup inside Claude Code:
      /help            Full command reference
      /define          Turn an idea into stories and tasks
      /create-feature  Implement a feature end-to-end
      /fix-bug         Investigate and fix a bug
      /review          Code review an implementation
      /adr             Document an architecture decision
      /test            Design and implement a test suite
#>
# Engineering OS - Project Setup Script

param(
    [Parameter(Mandatory = $false, HelpMessage = "Name of the new project (kebab-case recommended)")]
    [string]$ProjectName = "",

    [Parameter(Mandatory = $false, HelpMessage = "Where to create the project. Defaults to the parent folder of Engineering OS.")]
    [string]$DestinationPath = "",

    [Parameter(Mandatory = $false, HelpMessage = "Full path to an existing project directory.")]
    [string]$ProjectPath = "",

    [Parameter(Mandatory = $false, HelpMessage = "Project type: frontend, backend, fullstack, or skip")]
    [ValidateSet("frontend", "backend", "fullstack", "skip", "")]
    [string]$ProjectType = "",

    [Parameter(Mandatory = $false, HelpMessage = "Frontend technology: flutter, angular, react, vue, or skip")]
    [ValidateSet("flutter", "angular", "react", "vue", "skip", "")]
    [string]$Frontend = "",

    [Parameter(Mandatory = $false, HelpMessage = "Backend technology: fastapi, nestjs, spring, dotnet, go, or skip")]
    [ValidateSet("fastapi", "nestjs", "spring", "dotnet", "go", "skip", "")]
    [string]$Backend = "",

    [Parameter(Mandatory = $false, HelpMessage = "Backend architecture: hexagonal or clean")]
    [ValidateSet("hexagonal", "clean", "")]
    [string]$BackendArch = ""
)

$ErrorActionPreference = "Stop"

# ── UTF-8 without BOM writer (PowerShell 5.1 -Encoding utf8 adds BOM, which breaks JSON) ──

function Write-Utf8NoBom([string]$Path, [string]$Content) {
    $enc = [System.Text.UTF8Encoding]::new($false)
    [System.IO.File]::WriteAllText($Path, $Content, $enc)
}

# ── Resolve paths ──────────────────────────────────────────────────────────────

$EngineeringOsRoot = Split-Path $PSScriptRoot -Parent

# Determine project root and name
if ($ProjectPath -ne "") {
    if ($ProjectName -ne "") {
        # Both provided: use ProjectPath as the parent, create subfolder named ProjectName
        $ProjectRoot = Join-Path $ProjectPath $ProjectName
        $IsExisting  = Test-Path $ProjectRoot
    } else {
        # Only ProjectPath: install into that exact existing directory
        $ProjectRoot = $ProjectPath
        $ProjectName = Split-Path $ProjectPath -Leaf
        $IsExisting  = $true
    }
} elseif ($ProjectName -ne "") {
    if ($DestinationPath -eq "") {
        $DestinationPath = Split-Path $EngineeringOsRoot -Parent
    }
    $ProjectRoot = Join-Path $DestinationPath $ProjectName
    $IsExisting  = Test-Path $ProjectRoot
} else {
    Write-Host "[ERROR] Provide -ProjectName or -ProjectPath." -ForegroundColor Red
    Write-Host "        Examples:" -ForegroundColor DarkGray
    Write-Host "          .\setup-project.ps1 -ProjectName 'my-project'" -ForegroundColor DarkGray
    Write-Host "          .\setup-project.ps1 -ProjectPath 'C:\Projects\my-project'" -ForegroundColor DarkGray
    exit 1
}

$FrameworkDest = Join-Path $ProjectRoot ".engineering-os"
$Mode          = if ($IsExisting) { "Installing into existing project" } else { "Creating new project" }

# ── Header ─────────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "Engineering OS - Project Setup" -ForegroundColor Cyan
Write-Host "-----------------------------------------" -ForegroundColor DarkGray
Write-Host "  Mode          : $Mode"
Write-Host "  Project name  : $ProjectName"
Write-Host "  Project path  : $ProjectRoot"
Write-Host "  Framework at  : $EngineeringOsRoot"
Write-Host "-----------------------------------------" -ForegroundColor DarkGray
Write-Host ""

# ── Validate sources ───────────────────────────────────────────────────────────

$RequiredSources = @(
    (Join-Path $EngineeringOsRoot "handbook"),
    (Join-Path $EngineeringOsRoot "workflows"),
    (Join-Path $EngineeringOsRoot "agents"),
    (Join-Path $EngineeringOsRoot "templates"),
    (Join-Path $EngineeringOsRoot ".claude\commands"),
    (Join-Path $EngineeringOsRoot "ENGINEERING_OS.md")
)

foreach ($Source in $RequiredSources) {
    if (-not (Test-Path $Source)) {
        Write-Host "[ERROR] Required source not found: $Source" -ForegroundColor Red
        Write-Host "        Run this script from inside the Engineering OS repository." -ForegroundColor Red
        exit 1
    }
}

# Validate existing project path
if ($IsExisting -and -not (Test-Path $ProjectRoot)) {
    Write-Host "[ERROR] Directory not found: $ProjectRoot" -ForegroundColor Red
    exit 1
}

# ── Create project root ────────────────────────────────────────────────────────

if (-not (Test-Path $ProjectRoot)) {
    New-Item -ItemType Directory -Path $ProjectRoot | Out-Null
}

# ── Technology stack selection ─────────────────────────────────────────────────

function Read-MenuChoice($prompt, $options) {
    Write-Host ""
    Write-Host $prompt -ForegroundColor Cyan
    for ($i = 0; $i -lt $options.Count; $i++) {
        Write-Host "  $($i + 1). $($options[$i])"
    }
    Write-Host "  0. Skip"
    Write-Host ""
    do {
        $raw = Read-Host "  Choice"
        $n   = $raw -as [int]
    } while ($null -eq $n -or $n -lt 0 -or $n -gt $options.Count)
    if ($n -eq 0) { return "skip" }
    return $options[$n - 1]
}

Write-Host "Technology stack setup..." -ForegroundColor Yellow

# Project type
if ($ProjectType -eq "") {
    $ptChoice = Read-MenuChoice "What type of project is this?" @(
        "Frontend only",
        "Backend only",
        "Full-Stack"
    )
    $ProjectType = switch ($ptChoice) {
        "Frontend only" { "frontend"  }
        "Backend only"  { "backend"   }
        "Full-Stack"    { "fullstack" }
        default         { "skip"      }
    }
}

# Frontend technology
$needFrontend = $ProjectType -eq "frontend" -or $ProjectType -eq "fullstack"
if ($needFrontend -and $Frontend -eq "") {
    $feChoice = Read-MenuChoice "Frontend technology?" @(
        "Flutter / Dart",
        "Angular / TypeScript",
        "React / TypeScript",
        "Vue / TypeScript"
    )
    $Frontend = switch ($feChoice) {
        "Flutter / Dart"       { "flutter" }
        "Angular / TypeScript" { "angular" }
        "React / TypeScript"   { "react"   }
        "Vue / TypeScript"     { "vue"     }
        default                { "skip"    }
    }
}

# Backend technology
$needBackend = $ProjectType -eq "backend" -or $ProjectType -eq "fullstack"
if ($needBackend -and $Backend -eq "") {
    $beChoice = Read-MenuChoice "Backend technology?" @(
        "FastAPI / Python",
        "NestJS / TypeScript",
        "Spring Boot / Java or Kotlin",
        ".NET / C#",
        "Go"
    )
    $Backend = switch ($beChoice) {
        "FastAPI / Python"             { "fastapi" }
        "NestJS / TypeScript"          { "nestjs"  }
        "Spring Boot / Java or Kotlin" { "spring"  }
        ".NET / C#"                    { "dotnet"  }
        "Go"                           { "go"      }
        default                        { "skip"    }
    }
}

# Backend architecture pattern
if ($needBackend -and $Backend -ne "skip" -and $Backend -ne "" -and $BackendArch -eq "") {
    $baChoice = Read-MenuChoice "Backend architecture pattern?" @(
        "Hexagonal Architecture (Ports & Adapters)",
        "Clean Architecture"
    )
    $BackendArch = switch ($baChoice) {
        "Hexagonal Architecture (Ports & Adapters)" { "hexagonal" }
        "Clean Architecture"                         { "clean"     }
        default                                      { "hexagonal" }
    }
}

# ── Create base directories (depends on project type) ──────────────────────────

Write-Host "Setting up project structure..." -ForegroundColor Yellow

$BaseDirs = if ($ProjectType -eq "fullstack") {
    @("frontend", "backend", "docs\adr", "scripts", "tests\e2e")
} else {
    @("tests\unit", "tests\integration", "tests\e2e", "docs\adr", "scripts", "config")
}

foreach ($Dir in $BaseDirs) {
    $DirPath = Join-Path $ProjectRoot $Dir
    if (-not (Test-Path $DirPath)) {
        New-Item -ItemType Directory -Path $DirPath | Out-Null
    }
}

Write-Host "  [OK] Project directories" -ForegroundColor Green

# ── Scaffold technology-specific directories ───────────────────────────────────

function New-Dirs($root, [string[]]$paths) {
    foreach ($p in $paths) {
        $full = Join-Path $root $p
        if (-not (Test-Path $full)) {
            New-Item -ItemType Directory -Path $full -Force | Out-Null
        }
    }
}

$feRoot = if ($ProjectType -eq "fullstack") { Join-Path $ProjectRoot "frontend" } else { $ProjectRoot }
$beRoot = if ($ProjectType -eq "fullstack") { Join-Path $ProjectRoot "backend"  } else { $ProjectRoot }

if ($Frontend -ne "" -and $Frontend -ne "skip") {
    $feDirs = switch ($Frontend) {
        "flutter" { @(
            "lib\features\auth\presentation\views",
            "lib\features\auth\presentation\viewmodels",
            "lib\features\auth\domain\entities",
            "lib\features\auth\domain\repositories",
            "lib\features\auth\domain\use_cases",
            "lib\features\auth\data\repositories",
            "lib\features\auth\data\datasources",
            "lib\features\auth\data\models",
            "lib\shared\ui",
            "lib\shared\utils",
            "lib\core\network",
            "lib\core\storage",
            "lib\core\config"
        ) }
        "angular" { @(
            "src\app\features\auth\presentation\views",
            "src\app\features\auth\presentation\viewmodels",
            "src\app\features\auth\domain\entities",
            "src\app\features\auth\domain\repositories",
            "src\app\features\auth\domain\use-cases",
            "src\app\features\auth\data\repositories",
            "src\app\features\auth\data\datasources",
            "src\app\features\auth\data\models",
            "src\app\shared\ui",
            "src\app\shared\utils",
            "src\app\core\network",
            "src\app\core\storage",
            "src\app\core\config"
        ) }
        { $_ -eq "react" -or $_ -eq "vue" } { @(
            "src\features\auth\presentation\views",
            "src\features\auth\presentation\viewmodels",
            "src\features\auth\domain\entities",
            "src\features\auth\domain\repositories",
            "src\features\auth\domain\use-cases",
            "src\features\auth\data\repositories",
            "src\features\auth\data\datasources",
            "src\features\auth\data\models",
            "src\shared\ui",
            "src\shared\utils",
            "src\core\network",
            "src\core\storage",
            "src\core\config"
        ) }
    }
    New-Dirs $feRoot $feDirs
    Write-Host "  [OK] Frontend structure ($Frontend)" -ForegroundColor Green
}

if ($Backend -ne "" -and $Backend -ne "skip") {
    $beDirs = if ($BackendArch -eq "clean") {
        switch ($Backend) {
            "fastapi" { @(
                "app\api\routers",
                "app\api\services",
                "app\api\repositories",
                "app\config",
                "app\database",
                "app\external",
                "app\http"
            ) }
            "nestjs" { @(
                "src\api\routers",
                "src\api\services",
                "src\api\repositories",
                "src\config",
                "src\database",
                "src\external",
                "src\http"
            ) }
            "spring" { @(
                "src\main\java\api\routers",
                "src\main\java\api\services",
                "src\main\java\api\repositories",
                "src\main\java\config",
                "src\main\java\database",
                "src\main\java\external",
                "src\main\java\http",
                "src\main\resources",
                "src\test\java"
            ) }
            "dotnet" { @(
                "Api\Routers",
                "Api\Services",
                "Api\Repositories",
                "Config",
                "Database",
                "External",
                "Http"
            ) }
            "go" { @(
                "internal\api\routers",
                "internal\api\services",
                "internal\api\repositories",
                "internal\config",
                "internal\database",
                "internal\external",
                "internal\http",
                "cmd\api"
            ) }
        }
    } else {
        # hexagonal (default)
        switch ($Backend) {
            "fastapi" { @(
                "app\domain\entities",
                "app\domain\value_objects",
                "app\domain\aggregates",
                "app\domain\repositories",
                "app\domain\services",
                "app\domain\events",
                "app\application\use_cases",
                "app\application\ports",
                "app\application\dtos",
                "app\adapters\inbound\http",
                "app\adapters\inbound\messaging",
                "app\adapters\outbound\persistence",
                "app\adapters\outbound\external"
            ) }
            "nestjs" { @(
                "src\domain\entities",
                "src\domain\value-objects",
                "src\domain\aggregates",
                "src\domain\repositories",
                "src\domain\services",
                "src\domain\events",
                "src\application\use-cases",
                "src\application\ports",
                "src\application\dtos",
                "src\adapters\inbound\http",
                "src\adapters\inbound\messaging",
                "src\adapters\outbound\persistence",
                "src\adapters\outbound\external"
            ) }
            "spring" { @(
                "src\main\java\domain\entities",
                "src\main\java\domain\valueobjects",
                "src\main\java\domain\aggregates",
                "src\main\java\domain\repositories",
                "src\main\java\domain\services",
                "src\main\java\domain\events",
                "src\main\java\application\usecases",
                "src\main\java\application\ports",
                "src\main\java\application\dtos",
                "src\main\java\adapters\inbound\http",
                "src\main\java\adapters\outbound\persistence",
                "src\main\java\adapters\outbound\external",
                "src\main\resources",
                "src\test\java"
            ) }
            "dotnet" { @(
                "Domain\Entities",
                "Domain\ValueObjects",
                "Domain\Aggregates",
                "Domain\Repositories",
                "Domain\Services",
                "Domain\Events",
                "Application\UseCases",
                "Application\Ports",
                "Application\DTOs",
                "Infrastructure\Adapters\Inbound\Http",
                "Infrastructure\Adapters\Outbound\Persistence",
                "Infrastructure\Adapters\Outbound\External"
            ) }
            "go" { @(
                "internal\domain\entities",
                "internal\domain\repositories",
                "internal\domain\services",
                "internal\domain\events",
                "internal\application\usecases",
                "internal\application\ports",
                "internal\application\dtos",
                "internal\adapters\inbound\http",
                "internal\adapters\outbound\persistence",
                "internal\adapters\outbound\external",
                "cmd\api"
            ) }
        }
    }
    New-Dirs $beRoot $beDirs
    Write-Host "  [OK] Backend structure ($Backend / $BackendArch)" -ForegroundColor Green
}

# ── Write config/stack.md (prevents Claude from asking about the stack again) ──

$StackConfigDir = Join-Path $ProjectRoot ".engineering-os\config"
New-Item -ItemType Directory -Path $StackConfigDir -Force | Out-Null

$feDisplay = if ($Frontend -ne "" -and $Frontend -ne "skip") { $Frontend } else { "none" }
$beDisplay = if ($Backend  -ne "" -and $Backend  -ne "skip") { $Backend  } else { "none" }
$baDisplay = if ($BackendArch -ne "")                         { $BackendArch } else { "none" }

$StackContent = @"
# Project Stack

This file was generated by setup-project.ps1. Do not edit manually.
Claude reads this on startup to skip technology stack questions.

## Project type
$ProjectType

## Frontend
- Technology : $feDisplay
- Architecture: MVVM + Clean Architecture

## Backend
- Technology  : $beDisplay
- Architecture: $baDisplay
"@

Write-Utf8NoBom (Join-Path $StackConfigDir "stack.md") $StackContent

Write-Host "  [OK] .engineering-os/config/stack.md written" -ForegroundColor Green

# ── Copy starter templates ──────────────────────────────────────────────────────

Write-Host "Copying starter templates..." -ForegroundColor Yellow

$feTemplateMap = @{
    "flutter" = "flutter-dart"
    "angular" = "angular-typescript"
    "react"   = "react-typescript"
    "vue"     = "vue-typescript"
}
$beTemplateMap = @{
    "fastapi" = "fastapi-python"
    "nestjs"  = "nestjs-typescript"
    "spring"  = "spring-java"
    "dotnet"  = "dotnet-csharp"
    "go"      = "go"
}

$templatesToCopy = @()
if ($Frontend -ne "" -and $Frontend -ne "skip" -and $feTemplateMap.ContainsKey($Frontend)) {
    $templatesToCopy += $feTemplateMap[$Frontend]
}
if ($Backend -ne "" -and $Backend -ne "skip" -and $beTemplateMap.ContainsKey($Backend)) {
    $templatesToCopy += $beTemplateMap[$Backend]
}

foreach ($tmpl in $templatesToCopy) {
    $tmplPath = Join-Path $EngineeringOsRoot "templates\starters\$tmpl"
    $isFe    = $feTemplateMap.Values -contains $tmpl
    $destDir = if ($ProjectType -eq "fullstack") {
        if ($isFe) { $feRoot } else { $beRoot }
    } else {
        $ProjectRoot
    }
    if (-not (Test-Path $destDir)) { New-Item -ItemType Directory -Path $destDir | Out-Null }

    # Flutter requires android/, ios/, web/ etc. generated by flutter create.
    # We create the project in a temp dir (avoids conflicts with existing scaffold dirs),
    # then merge everything into destDir and overlay our lib/main.dart.
    if ($tmpl -eq "flutter-dart") {
        $dartSafe = $ProjectName -replace '-', '_'
        if (Get-Command "flutter" -ErrorAction SilentlyContinue) {
            $tempFlutter = Join-Path ([System.IO.Path]::GetTempPath()) "eos_flutter_$([System.Guid]::NewGuid().ToString('N').Substring(0,8))"
            Write-Host "  Running flutter create (this may take a moment)..." -ForegroundColor DarkGray
            flutter create --project-name $dartSafe --org com.example $tempFlutter
            if ($LASTEXITCODE -eq 0) {
                # Merge all Flutter-generated files into destDir (preserves our scaffold dirs)
                Get-ChildItem $tempFlutter -Force | ForEach-Object {
                    Copy-Item $_.FullName $destDir -Recurse -Force
                }
                # Overwrite lib/main.dart with our health-check UI
                Copy-Item (Join-Path $tmplPath "lib\main.dart") (Join-Path $destDir "lib\main.dart") -Force
                # Add http dependency to pubspec.yaml
                $pubspecPath = Join-Path $destDir "pubspec.yaml"
                $ps = Get-Content $pubspecPath -Raw -Encoding utf8
                if ($ps -notmatch '\bhttp\b') {
                    $ps = $ps -replace '(?m)(^dependencies:\s*\r?\n)', "`$1  http: ^1.2.1`n"
                    Write-Utf8NoBom $pubspecPath $ps
                }
                Remove-Item $tempFlutter -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "  [OK] Template: $tmpl (flutter create)" -ForegroundColor Green
            } else {
                Remove-Item $tempFlutter -Recurse -Force -ErrorAction SilentlyContinue
                Write-Host "  [ERROR] flutter create failed - check your Flutter installation." -ForegroundColor Red
            }
        } else {
            # Flutter not installed: copy template files as fallback
            if (Test-Path $tmplPath) {
                Copy-Item -Path "$tmplPath\*" -Destination $destDir -Recurse -Force
            }
            Write-Host "  [WARN] Flutter SDK not found - copied template files only." -ForegroundColor Yellow
            Write-Host "         Run 'flutter create . --project-name $dartSafe' inside $destDir after installing Flutter." -ForegroundColor DarkGray
        }
        continue
    }

    if (Test-Path $tmplPath) {
        Copy-Item -Path "$tmplPath\*" -Destination $destDir -Recurse -Force
        Write-Host "  [OK] Template: $tmpl" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] Template not found: $tmplPath" -ForegroundColor Yellow
    }
}

# Replace __PROJECT_NAME__ in all text files
# Dart identifiers (pubspec.yaml name field) cannot contain hyphens — use underscores there
$dartSafeName = $ProjectName -replace '-', '_'

$textExts = @('.json', '.html', '.ts', '.tsx', '.vue', '.dart', '.yaml', '.yml',
              '.toml', '.txt', '.py', '.properties', '.cs', '.go', '.java',
              '.xml', '.mod', '.csproj', '.env', '.css', '.gradle', '.kts')

$scanRoots = if ($ProjectType -eq "fullstack") { @($feRoot, $beRoot) } else { @($ProjectRoot) }

foreach ($scanRoot in $scanRoots) {
    Get-ChildItem $scanRoot -Recurse -File |
      Where-Object { $_.Extension -in $textExts -and $_.FullName -notlike "*\.engineering-os\*" } |
      ForEach-Object {
        $content = Get-Content $_.FullName -Raw -Encoding utf8 -ErrorAction SilentlyContinue
        if ($content -and $content -match '__PROJECT_NAME__') {
            $replacement = if ($_.Name -eq 'pubspec.yaml') { $dartSafeName } else { $ProjectName }
            Write-Utf8NoBom $_.FullName ($content -replace '__PROJECT_NAME__', $replacement)
        }
      }

    # Rename files whose name contains __PROJECT_NAME__ (e.g. .csproj)
    Get-ChildItem $scanRoot -Recurse -File |
      Where-Object { $_.Name -like '*__PROJECT_NAME__*' } |
      ForEach-Object {
        Rename-Item -Path $_.FullName -NewName ($_.Name -replace '__PROJECT_NAME__', $ProjectName)
      }
}

Write-Host "  [OK] Project name applied" -ForegroundColor Green

# ── Copy framework into .engineering-os/ (always overwrite — it is gitignored) ─

if (Test-Path $FrameworkDest) {
    Remove-Item -Path $FrameworkDest -Recurse -Force
}
New-Item -ItemType Directory -Path $FrameworkDest | Out-Null

$FoldersToCopy = @("handbook", "workflows", "agents", "templates", "config")

foreach ($Folder in $FoldersToCopy) {
    Copy-Item `
        -Path (Join-Path $EngineeringOsRoot $Folder) `
        -Destination (Join-Path $FrameworkDest $Folder) `
        -Recurse
}

Write-Host "  [OK] .engineering-os/ installed (handbook, workflows, agents, templates)" -ForegroundColor Green

# ── Pre-fill handbook/00-vision.md with project name (only if still a template) ─

$VisionPath    = Join-Path $FrameworkDest "handbook\00-vision.md"
$VisionContent = Get-Content $VisionPath -Raw -Encoding utf8

if ($VisionContent -match "\[Name of the project\]") {
    $VisionContent = $VisionContent -replace "\[Name of the project\]", $ProjectName
    Write-Utf8NoBom $VisionPath $VisionContent
    Write-Host "  [OK] handbook/00-vision.md pre-filled" -ForegroundColor Green
}

# ── Create CLAUDE.md (overwrite — it is a generated bootstrap file) ────────────

$ClaudeMdContent = Get-Content (Join-Path $EngineeringOsRoot "ENGINEERING_OS.md") -Raw -Encoding utf8

$ClaudeMdContent = $ClaudeMdContent -replace "(?<![`.\w])handbook/",  ".engineering-os/handbook/"
$ClaudeMdContent = $ClaudeMdContent -replace "(?<![`.\w])agents/",    ".engineering-os/agents/"
$ClaudeMdContent = $ClaudeMdContent -replace "(?<![`.\w])workflows/", ".engineering-os/workflows/"
$ClaudeMdContent = $ClaudeMdContent -replace "(?<![`.\w])templates/", ".engineering-os/templates/"

Write-Utf8NoBom (Join-Path $ProjectRoot "CLAUDE.md") $ClaudeMdContent

Write-Host "  [OK] CLAUDE.md updated" -ForegroundColor Green

# ── Copy .claude/commands/ (always overwrite — framework files) ────────────────

$CommandsDest = Join-Path $ProjectRoot ".claude\commands"
New-Item -ItemType Directory -Path $CommandsDest -Force | Out-Null

$CommandFiles = Get-ChildItem -Path (Join-Path $EngineeringOsRoot ".claude\commands") -Filter "*.md"

foreach ($File in $CommandFiles) {
    $Content = Get-Content $File.FullName -Raw -Encoding utf8

    $Content = $Content -replace "(?<![`.\w])handbook/",  ".engineering-os/handbook/"
    $Content = $Content -replace "(?<![`.\w])workflows/", ".engineering-os/workflows/"
    $Content = $Content -replace "(?<![`.\w])agents/",    ".engineering-os/agents/"
    $Content = $Content -replace "(?<![`.\w])templates/", ".engineering-os/templates/"

    Write-Utf8NoBom (Join-Path $CommandsDest $File.Name) $Content
}

Write-Host "  [OK] .claude/commands/ updated" -ForegroundColor Green

# ── Copy install scripts to project root ───────────────────────────────────────

foreach ($rootFile in @("install.ps1", "install.bat", "run.ps1", "run.bat")) {
    $src = Join-Path $EngineeringOsRoot "templates\$rootFile"
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination (Join-Path $ProjectRoot $rootFile) -Force
    }
}

Write-Host "  [OK] install.ps1 / install.bat / run.ps1 / run.bat" -ForegroundColor Green

# ── Update .gitignore (add entry if missing, never overwrite the whole file) ───

$GitignorePath  = Join-Path $ProjectRoot ".gitignore"
$GitignoreEntry = ".engineering-os/"

if (Test-Path $GitignorePath) {
    $GitignoreContent = Get-Content $GitignorePath -Raw -Encoding utf8
    if ($GitignoreContent -notmatch [regex]::Escape($GitignoreEntry)) {
        $existing = [System.IO.File]::ReadAllText($GitignorePath)
        Write-Utf8NoBom $GitignorePath ($existing.TrimEnd() + "`n$GitignoreEntry`n")
        Write-Host "  [OK] .gitignore updated (added .engineering-os/)" -ForegroundColor Green
    } else {
        Write-Host "  [OK] .gitignore already contains .engineering-os/" -ForegroundColor DarkGray
    }
} else {
    Write-Utf8NoBom $GitignorePath $GitignoreEntry
    Write-Host "  [OK] .gitignore created" -ForegroundColor Green
}

# ── Keep docs/adr/ tracked in git ─────────────────────────────────────────────

$GitkeepPath = Join-Path $ProjectRoot "docs\adr\.gitkeep"
if (-not (Test-Path $GitkeepPath)) {
    "" | Set-Content -Path $GitkeepPath -Encoding utf8
}

# ── Done ───────────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "-----------------------------------------" -ForegroundColor DarkGray
Write-Host "  Engineering OS installed at: $ProjectRoot" -ForegroundColor Green
Write-Host "-----------------------------------------" -ForegroundColor DarkGray
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "  1. Install dependencies:"
Write-Host "     $ProjectRoot\install.bat"
Write-Host ""
Write-Host "  2. Start dev servers:"
Write-Host "     $ProjectRoot\run.bat"
Write-Host ""
Write-Host "  3. Open the project in Claude Code."
Write-Host "     Claude will read CLAUDE.md automatically on the first message"
Write-Host "     and ask about your technology stack before doing anything else."
Write-Host ""
Write-Host "  3. Fill in your project vision:"
Write-Host "     $ProjectRoot\.engineering-os\handbook\00-vision.md"
if ($Frontend -ne "" -and $Frontend -ne "skip") {
    Write-Host ""
    Write-Host "  3. Rename the example feature:"
    $featurePath = switch ($Frontend) {
        "flutter" { "lib\features\auth\" }
        "angular" { "src\app\features\auth\" }
        default   { "src\features\auth\" }
    }
    Write-Host "     $ProjectRoot\$featurePath  →  your first real feature"
}
if ($Backend -ne "" -and $Backend -ne "skip") {
    Write-Host ""
    Write-Host "  3. Start with a use case:"
    $ucPath = switch ($Backend) {
        "fastapi" { "app\application\use_cases\" }
        "nestjs"  { "src\application\use-cases\" }
        "spring"  { "src\main\java\application\usecases\" }
        "dotnet"  { "Application\UseCases\" }
        "go"      { "internal\application\usecases\" }
        default   { "" }
    }
    if ($ucPath -ne "") {
        Write-Host "     $ProjectRoot\$ucPath"
    }
    if ($BackendArch -eq "clean") {
        Write-Host "     Then wire it: routers\ → services\ → repositories\"
    } else {
        Write-Host "     Outbound ports (repo interfaces) → application\ports\"
    }
}
Write-Host ""
Write-Host "  Available commands inside Claude Code:"
Write-Host "     /help             Show the full command reference"
Write-Host "     /define           Turn an idea into stories and tasks"
Write-Host "     /create-feature   Plan and implement a new feature"
Write-Host "     /fix-bug          Investigate and fix a bug"
Write-Host "     /review           Code review an implementation"
Write-Host "     /adr              Document an architecture decision"
Write-Host "     /test             Design and implement a test suite"
Write-Host ""
