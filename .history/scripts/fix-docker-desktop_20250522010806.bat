@echo off
echo ===================================================
echo Docker Desktop Comprehensive Troubleshooter
echo ===================================================
echo.
echo This script will perform several operations to fix Docker Desktop issues:
echo 1. Stop all Docker-related services
echo 2. Clear Docker data
echo 3. Reset Docker network settings
echo 4. Reset Kubernetes configuration
echo 5. Restart Docker Desktop cleanly
echo.
echo WARNING: This will remove all containers, images, volumes, and networks!
echo Press Ctrl+C to cancel or any key to continue...
pause > nul

echo.
echo ===================================================
echo Step 1: Stopping Docker Services
echo ===================================================
echo.

echo Stopping Docker Desktop...
taskkill /f /im "Docker Desktop.exe" 2>nul
echo Stopping Docker Backend...
taskkill /f /im "com.docker.backend.exe" 2>nul
echo Stopping Docker Service...
net stop docker 2>nul
echo Stopping WSL...
wsl --shutdown 2>nul

echo.
echo ===================================================
echo Step 2: Clearing Docker Data
echo ===================================================
echo.

echo Removing Docker Desktop settings...
if exist "%APPDATA%\Docker\settings.json" (
    echo Backing up settings...
    copy "%APPDATA%\Docker\settings.json" "%APPDATA%\Docker\settings.json.bak"
)

echo Removing Docker data directories...
rmdir /s /q "%LOCALAPPDATA%\Docker\wsl" 2>nul
rmdir /s /q "%LOCALAPPDATA%\Docker\log" 2>nul

echo Clearing problematic Docker files...
del /f /q "%APPDATA%\Docker\application-data\docker-desktop.lock" 2>nul
del /f /q "%LOCALAPPDATA%\Docker\log\host" 2>nul

echo.
echo ===================================================
echo Step 3: Resetting Docker Network
echo ===================================================
echo.

echo Resetting Windows networking components...
netsh winsock reset
netsh int ip reset

echo.
echo ===================================================
echo Step 4: Resetting Kubernetes
echo ===================================================
echo.

echo Removing local Kubernetes configuration...
rmdir /s /q "%USERPROFILE%\.kube" 2>nul
echo Creating empty .kube directory...
mkdir "%USERPROFILE%\.kube" 2>nul

echo.
echo ===================================================
echo Step 5: Final Cleanup
echo ===================================================
echo.

:: Final check to ensure Docker processes are not running
taskkill /f /im "Docker Desktop.exe" 2>nul
taskkill /f /im "com.docker.backend.exe" 2>nul
taskkill /f /im "dockerd.exe" 2>nul
taskkill /f /im "vpnkit.exe" 2>nul
taskkill /f /im "docker.exe" 2>nul

echo.
echo ===================================================
echo Step 6: Restart Computer
echo ===================================================
echo.

echo Docker Desktop troubleshooting completed.
echo It's recommended to restart your computer before starting Docker Desktop again.
echo.
echo Would you like to restart your computer now? (Y/N)
choice /c YN /m "Restart now"
if errorlevel 2 goto no_restart
if errorlevel 1 goto yes_restart

:yes_restart
echo Restarting computer in 10 seconds...
shutdown /r /t 10 /c "Restarting computer to complete Docker Desktop troubleshooting"
goto end

:no_restart
echo.
echo Please remember to restart your computer manually before starting Docker Desktop.
echo.

:end
echo.
pause
