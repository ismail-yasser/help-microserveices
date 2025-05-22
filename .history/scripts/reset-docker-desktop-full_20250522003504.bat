@echo off
echo ===================================================
echo Docker Desktop Reset and Cleanup Script
echo ===================================================
echo.
echo This script will:
echo 1. Stop Docker services
echo 2. Kill Docker processes
echo 3. Clean Docker data and settings folders
echo 4. Unregister WSL Docker components
echo 5. Clean temp Docker files
echo.
echo WARNING: THIS WILL RESET DOCKER DESKTOP TO FACTORY SETTINGS!
echo ALL CONTAINERS, IMAGES, AND CUSTOM SETTINGS WILL BE LOST!
echo.
set /p confirm="Continue? (y/n): "
if /i not "%confirm%"=="y" goto :end

echo.
echo ===================================================
echo Stopping Docker services...
echo ===================================================
net stop com.docker.service >nul 2>&1
net stop docker >nul 2>&1
sc stop docker >nul 2>&1

echo.
echo ===================================================
echo Killing Docker processes...
echo ===================================================
taskkill /f /im "Docker Desktop.exe" >nul 2>&1
taskkill /f /im "Docker.exe" >nul 2>&1
taskkill /f /im "dockerd.exe" >nul 2>&1
taskkill /f /im "com.docker.proxy.exe" >nul 2>&1
taskkill /f /im "com.docker.vpnkit.exe" >nul 2>&1
taskkill /f /im "com.docker.backend.exe" >nul 2>&1
taskkill /f /im "com.docker.service" >nul 2>&1

echo.
echo ===================================================
echo Cleaning Docker data folders...
echo ===================================================
echo Stopping WSL...
wsl --shutdown >nul 2>&1

echo.
echo ===================================================
echo Cleaning Docker configuration...
echo ===================================================
if exist "%APPDATA%\Docker\settings.json" (
    echo Backing up Docker settings to %USERPROFILE%\Desktop\docker-settings-backup.json
    copy "%APPDATA%\Docker\settings.json" "%USERPROFILE%\Desktop\docker-settings-backup.json" >nul 2>&1
)

echo Cleaning Docker settings and configuration files...
rmdir /s /q "%APPDATA%\Docker" >nul 2>&1
rmdir /s /q "%LOCALAPPDATA%\Docker" >nul 2>&1
rmdir /s /q "%ProgramData%\Docker" >nul 2>&1
rmdir /s /q "%ProgramData%\DockerDesktop" >nul 2>&1

echo.
echo ===================================================
echo Cleaning WSL components...
echo ===================================================
echo Listing and unregistering Docker distros from WSL...
wsl --list >nul 2>&1
wsl --unregister docker-desktop >nul 2>&1
wsl --unregister docker-desktop-data >nul 2>&1

echo.
echo ===================================================
echo Reset complete!
echo ===================================================
echo.
echo 1. Please restart your computer 
echo 2. Start Docker Desktop
echo 3. If problems persist, consider reinstalling Docker Desktop
echo.
echo Note: Your Docker settings were backed up to %USERPROFILE%\Desktop\docker-settings-backup.json if available.
echo.

:end
pause
