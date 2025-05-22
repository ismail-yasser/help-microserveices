@echo off
echo Docker Desktop Reset Helper
echo ===================================
echo This script will help clean up Docker Desktop settings and files
echo WARNING: This will remove all Docker containers, images, volumes, and settings
echo.
echo Please ensure Docker Desktop is completely closed before proceeding
echo.
set /p continue="Are you sure you want to continue? (y/n): "
if /i not "%continue%"=="y" (
  echo Operation cancelled.
  goto :end
)

echo.
echo Stopping Docker services if running...
sc stop docker
sc stop com.docker.service

echo.
echo Killing any remaining Docker processes...
taskkill /f /im "Docker Desktop.exe" 2>nul
taskkill /f /im "dockerd.exe" 2>nul
taskkill /f /im "com.docker.service.exe" 2>nul
taskkill /f /im "vpnkit.exe" 2>nul
taskkill /f /im "com.docker.vpnkit.exe" 2>nul
taskkill /f /im "com.docker.dev-envs.exe" 2>nul

echo.
echo Cleaning Docker settings folders...
if exist "%APPDATA%\Docker\" (
  echo Cleaning %APPDATA%\Docker\
  rd /s /q "%APPDATA%\Docker\"
)

if exist "%USERPROFILE%\.docker\" (
  echo Cleaning %USERPROFILE%\.docker\
  rd /s /q "%USERPROFILE%\.docker\"
)

if exist "%ProgramData%\Docker\" (
  echo Cleaning %ProgramData%\Docker\ (this may require admin privileges)
  rd /s /q "%ProgramData%\Docker\" 2>nul
  if errorlevel 1 (
    echo Could not clean %ProgramData%\Docker\ - you may need to run this script as administrator
  )
)

if exist "%ProgramData%\DockerDesktop\" (
  echo Cleaning %ProgramData%\DockerDesktop\ (this may require admin privileges)
  rd /s /q "%ProgramData%\DockerDesktop\" 2>nul
  if errorlevel 1 (
    echo Could not clean %ProgramData%\DockerDesktop\ - you may need to run this script as administrator
  )
)

echo.
echo Cleaning WSL Docker distro...
wsl --unregister docker-desktop
wsl --unregister docker-desktop-data

echo.
echo Clean-up complete.
echo Please reinstall Docker Desktop from the official website.
echo.

:end
pause
