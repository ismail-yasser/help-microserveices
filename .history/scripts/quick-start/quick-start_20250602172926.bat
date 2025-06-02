@echo off
setlocal enabledelayedexpansion

:: Quick Start Script
:: This script provides a fast way to get the project running

echo ================================================
echo    Microservices Project Quick Start
echo ================================================
echo.

set "QUICK_MODE=false"
set "ENVIRONMENT=development"

:: Parse command line arguments
if "%1"=="--quick" set "QUICK_MODE=true"
if "%1"=="--prod" set "ENVIRONMENT=production"

if "!QUICK_MODE!"=="true" (
    echo Running in QUICK MODE - minimal checks, fast deployment
    echo.
) else (
    echo Running in STANDARD MODE - full validation and setup
    echo.
    echo Select deployment mode:
    echo 1. Quick Start (minimal setup, fastest)
    echo 2. Development Setup (full dev environment)
    echo 3. Production Deployment (full validation)
    echo.
    set /p "MODE_CHOICE=Enter choice (1-3): "
    
    if "!MODE_CHOICE!"=="1" set "QUICK_MODE=true"
    if "!MODE_CHOICE!"=="2" set "ENVIRONMENT=development"
    if "!MODE_CHOICE!"=="3" set "ENVIRONMENT=production"
)

echo.
echo Selected mode: !ENVIRONMENT!
echo.

if "!QUICK_MODE!"=="true" (
    goto :quick_start
) else if "!ENVIRONMENT!"=="development" (
    goto :dev_setup
) else if "!ENVIRONMENT!"=="production" (
    goto :prod_setup
)

:quick_start
echo ================================================
echo    QUICK START MODE
echo ================================================
echo.

:: Minimal checks
echo [1/4] Quick checks...
docker version >nul 2>&1 || (echo ❌ Docker not running && goto :error)
kubectl cluster-info >nul 2>&1 || (echo ❌ No Kubernetes cluster && goto :error)
echo ✓ Essential tools available

echo.
echo [2/4] Starting cluster (if needed)...
minikube status | findstr "Running" >nul 2>&1
if %errorLevel% neq 0 (
    echo Starting Minikube...
    minikube start --driver=docker >nul 2>&1
)

echo.
echo [3/4] Quick build and deploy...
cd /d "%~dp0.."

:: Quick Docker build
echo Building images...
docker build -t user-service:latest ./user-service >nul 2>&1
docker build -t help-service:latest ./help-service >nul 2>&1
docker build -t frontend:latest ./frontend >nul 2>&1

:: Quick deploy
echo Deploying...
kubectl apply -f k8s/ >nul 2>&1

echo.
echo [4/4] Getting access URLs...
timeout /t 10 >nul 2>&1
call "%~dp0..\utilities\get-service-urls.bat"

goto :quick_complete

:dev_setup
echo ================================================
echo    DEVELOPMENT SETUP MODE
echo ================================================
echo.
echo Running comprehensive development setup...
call "%~dp0setup-development.bat"
goto :complete

:prod_setup
echo ================================================
echo    PRODUCTION DEPLOYMENT MODE
echo ================================================
echo.
echo Running production deployment with validation...
call "%~dp0..\deployment\deploy-production.bat"
goto :complete

:quick_complete
echo.
echo ================================================
echo    Quick Start Complete! ⚡
echo ================================================
echo.
echo Your microservices are now running!
echo.
echo Quick Commands:
echo - Check status: kubectl get pods
echo - View logs: kubectl logs -l app=user-service
echo - Access services: scripts\utilities\get-service-urls.bat
echo - Manage project: scripts\management\manage-project.bat
echo.
echo For full management capabilities, use: scripts\management\manage-project.bat
echo.
goto :end

:complete
echo.
echo ================================================
echo    Setup Complete! 🚀
echo ================================================
echo.
echo Your environment is ready for development!
echo Use scripts\manage-project.bat for ongoing management.
echo.
goto :end

:error
echo.
echo ❌ Quick start failed!
echo.
echo Prerequisites:
echo 1. Docker Desktop must be installed and running
echo 2. kubectl must be installed
echo 3. Minikube must be installed (or other Kubernetes cluster available)
echo.
echo Try running the full setup: scripts\setup-development.bat
echo.
pause
exit /b 1

:end
pause
endlocal
