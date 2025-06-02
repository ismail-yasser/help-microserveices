@echo off
setlocal enabledelayedexpansion
echo ==========================================
echo 🔧 MICROSERVICES MANAGEMENT CONSOLE
echo ==========================================
echo.

:main_menu
echo Select an operation:
echo.
echo 🚀 DEPLOYMENT & LIFECYCLE:
echo [1] Deploy Project (Full deployment)
echo [2] Start Services (if stopped)
echo [3] Stop Services (scale to 0)
echo [4] Restart Services (rolling restart)
echo [5] Scale Services (change replica count)
echo.
echo 📊 MONITORING & STATUS:
echo [6] Check Status (pods, services, health)
echo [7] View Logs (service logs)
echo [8] Monitor Resources (CPU, memory)
echo [9] Get Service URLs (access endpoints)
echo.
echo 🔄 MAINTENANCE:
echo [10] Update Images (pull latest)
echo [11] Rollback Deployment
echo [12] Clean Up (remove all)
echo [13] Backup Configuration
echo [14] Run Health Checks
echo.
echo [0] Exit
echo.
set /p choice="Enter your choice (0-14): "

if "%choice%"=="1" call "%~dp0deploy-project.bat" && goto main_menu
if "%choice%"=="2" call "%~dp0start-services.bat" && goto main_menu  
if "%choice%"=="3" call "%~dp0stop-services.bat" && goto main_menu
if "%choice%"=="4" call "%~dp0restart-services.bat" && goto main_menu
if "%choice%"=="5" call "%~dp0scale-services.bat" && goto main_menu
if "%choice%"=="6" call "%~dp0check-status.bat" && goto main_menu
if "%choice%"=="7" call "%~dp0view-logs.bat" && goto main_menu
if "%choice%"=="8" call "%~dp0monitor-resources.bat" && goto main_menu
if "%choice%"=="9" call "%~dp0get-service-urls.bat" && goto main_menu
if "%choice%"=="10" call "%~dp0update-images.bat" && goto main_menu
if "%choice%"=="11" call "%~dp0rollback-deployment.bat" && goto main_menu
if "%choice%"=="12" call "%~dp0cleanup-project.bat" && goto main_menu
if "%choice%"=="13" call "%~dp0backup-config.bat" && goto main_menu
if "%choice%"=="14" call "%~dp0health-checks.bat" && goto main_menu
if "%choice%"=="0" goto exit

echo Invalid choice. Please try again.
timeout /t 2 /nobreak >nul
cls
goto main_menu

:exit
echo.
echo Thank you for using the Microservices Management Console!
echo.
