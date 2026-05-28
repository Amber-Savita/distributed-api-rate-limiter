# Bootstrap the project: fetch deps, generate crow_all.h, configure and build
# Run from project root: .\scripts\bootstrap.ps1

Write-Host "Bootstrapping project..."

$root = Split-Path -Parent $PSScriptRoot

# Clone hiredis if missing
if (-not (Test-Path "$root\external\hiredis\hiredis.c")) {
    Write-Host "Cloning hiredis..."
    git clone https://github.com/redis/hiredis.git "$root\external\hiredis"
}

# Clone Crow if missing
if (-not (Test-Path "$root\external\crow\CMakeLists.txt")) {
    Write-Host "Cloning Crow..."
    git clone https://github.com/CrowCpp/Crow.git "$root\external\crow"
}

# Generate crow_all.h if missing
if (-not (Test-Path "$root\external\crow\crow_all.h")) {
    Write-Host "Generating crow_all.h..."
    Push-Location "$root\external\crow\scripts"
    if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
        Write-Error "Python not found. Install Python to generate crow_all.h or add crow_all.h manually."
        Pop-Location
        exit 1
    }
    python merge_all.py ..\include ..\crow_all.h
    Pop-Location
}

# Prepare build directory
if (Test-Path "$root\build") { Remove-Item -Recurse -Force "$root\build" }
New-Item -ItemType Directory -Path "$root\build" | Out-Null
Push-Location "$root\build"

# Ensure cmake exists
if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
    Write-Error "cmake not found. Install CMake and ensure it's in PATH."
    Pop-Location
    exit 1
}

# Configure and build
Write-Host "Configuring with CMake..."
cmake ..
if ($LASTEXITCODE -ne 0) { Write-Error "cmake configure failed"; Pop-Location; exit 1 }

Write-Host "Building project..."
cmake --build . --config Release
if ($LASTEXITCODE -ne 0) { Write-Error "Build failed"; Pop-Location; exit 1 }

Pop-Location
Write-Host "Bootstrap complete. To start Redis and run server: .\scripts\run_server.ps1"
