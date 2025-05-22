@echo off
echo ===================================================
echo Docker Desktop Complete Reinstallation Script
echo ===================================================
echo.
echo WARNING: This script will uninstall Docker Desktop and remove all Docker data
echo          including images, containers, volumes, and settings.
echo.
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
echo Step 2: Uninstalling Docker Desktop
echo ===================================================
echo.

echo Looking for Docker Desktop uninstaller...
set "uninstaller="
if exist "%PROGRAMFILES%\Docker\Docker\Docker Desktop Installer.exe" (
    set "uninstaller=%PROGRAMFILES%\Docker\Docker\Docker Desktop Installer.exe"
) else if exist "%PROGRAMW6432%\Docker\Docker\Docker Desktop Installer.exe" (
    set "uninstaller=%PROGRAMW6432%\Docker\Docker\Docker Desktop Installer.exe"
)

if not defined uninstaller (
    echo Could not locate Docker Desktop uninstaller.
    echo Please uninstall Docker Desktop manually from Add/Remove Programs.
    goto cleanup_data
)

echo Running Docker Desktop uninstaller...
echo "%uninstaller%" uninstall
start /wait "" "%uninstaller%" uninstall

:cleanup_data
echo.
echo ===================================================
echo Step 3: Cleaning Docker Data
echo ===================================================
echo.

echo Removing Docker data folders...
rmdir /s /q "%APPDATA%\Docker" 2>nul
rmdir /s /q "%LOCALAPPDATA%\Docker" 2>nul
rmdir /s /q "%PROGRAMDATA%\Docker" 2>nul
rmdir /s /q "%PROGRAMDATA%\DockerDesktop" 2>nul
rmdir /s /q "%USERPROFILE%\.docker" 2>nul
rmdir /s /q "%USERPROFILE%\.kube" 2>nul

echo.
echo ===================================================
echo Step 4: Resetting Network Components
echo ===================================================
echo.

echo Resetting Windows networking components...
netsh winsock reset
netsh int ip reset

echo.
echo ===================================================
echo Step 5: Restart Computer
echo ===================================================
echo.

echo Docker Desktop uninstallation and cleanup completed.
echo.
echo IMPORTANT NEXT STEPS:
echo 1. Restart your computer now
echo 2. After restart, download the latest Docker Desktop installer from:
echo    https://www.docker.com/products/docker-desktop/
echo 3. Install Docker Desktop with admin rights
echo 4. During setup, select WSL 2 backend (recommended)
echo 5. Enable Kubernetes in Docker Desktop settings after installation
echo.
echo Would you like to restart your computer now? (Y/N)
choice /c YN /m "Restart now"
if errorlevel 2 goto no_restart
if errorlevel 1 goto yes_restart

:yes_restart
echo Restarting computer in 10 seconds...
shutdown /r /t 10 /c "Restarting computer to complete Docker Desktop removal"
goto end

:no_restart
echo.
echo Please remember to restart your computer manually before reinstalling Docker Desktop.
echo.

:end
echo.
pause
