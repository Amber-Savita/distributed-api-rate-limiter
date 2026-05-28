# Start Redis in Docker (if needed) and run the rate_limiter executable
# Run from project root: .\scripts\run_server.ps1

Write-Host "Starting Redis (Docker) and running rate_limiter..."
$root = Split-Path -Parent $PSScriptRoot

# Start or run redis-server container
$container = docker ps -a --format "{{.Names}}" | Select-String -Pattern "^redis-server$"
if (-not $container) {
    Write-Host "Creating redis-server container..."
    docker run -d -p 6379:6379 --name redis-server redis:latest
} else {
    $running = docker ps --format "{{.Names}}" | Select-String -Pattern "^redis-server$"
    if (-not $running) {
        Write-Host "Starting existing redis-server container..."
        docker start redis-server
    } else {
        Write-Host "redis-server already running"
    }
}

# Path to executable (Release build)
$exe = Join-Path $root "build\rate_limiter.exe"
if (-not (Test-Path $exe)) {
    Write-Error "Executable not found at $exe. Run scripts\bootstrap.ps1 first to build."
    exit 1
}

Write-Host "Launching server: $exe"
Start-Process -FilePath $exe -WorkingDirectory (Split-Path $exe)
Write-Host "Server started. Endpoint: http://localhost:18080/request"
