@echo off
echo ===================================================
echo Docker Desktop and Kubernetes Restart Script
echo ===================================================
echo.

echo This script will restart Docker Desktop with optimized settings for Kubernetes.
echo.

:: First, check if Docker Desktop is running
echo Checking Docker Desktop status...
tasklist | find "Docker Desktop.exe" > nul
if %errorlevel% equ 0 (
    echo Stopping Docker Desktop...
    taskkill /f /im "Docker Desktop.exe"
    timeout /t 5 > nul
)

:: Check for leftover Docker processes
echo Checking for leftover Docker processes...
taskkill /f /im "com.docker.backend.exe" 2>nul
taskkill /f /im "dockerd.exe" 2>nul
taskkill /f /im "vpnkit.exe" 2>nul

:: Stop WSL
echo Shutting down WSL...
wsl --shutdown

:: Make sure Docker settings are correctly configured for Kubernetes
echo Setting up Docker Desktop configuration for Kubernetes...
if not exist "%APPDATA%\Docker\settings.json.bak" (
    if exist "%APPDATA%\Docker\settings.json" (
        echo Backing up Docker settings...
        copy "%APPDATA%\Docker\settings.json" "%APPDATA%\Docker\settings.json.bak"
    )
)

:: Wait a moment
timeout /t 3 > nul

:: Start Docker Desktop
echo Starting Docker Desktop...
start "" "%PROGRAMFILES%\Docker\Docker\Docker Desktop.exe"

echo.
echo Docker Desktop is starting. Please wait for it to fully initialize.
echo This may take a few minutes.
echo.
echo Once Docker is running:
echo 1. Check that Kubernetes is enabled in Docker Desktop settings
echo 2. Wait for the Kubernetes icon to turn green
echo 3. Run 'kubectl get nodes' to verify connectivity
echo.
echo Press any key to exit...
pause > nul
