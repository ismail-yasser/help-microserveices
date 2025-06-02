@echo off
echo ==========================================
echo ⚡ HELM CHARTS DEPLOYMENT
echo ==========================================
echo.

REM Check if helm is available
helm version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Helm is not installed or not in PATH
    echo Please install Helm from https://helm.sh/docs/intro/install/
    exit /b 1
)

REM Check if helm-charts directory exists
if not exist "%~dp0..\helm-charts\" (
    echo ❌ helm-charts directory not found
    echo Expected location: %~dp0..\helm-charts\
    exit /b 1
)

echo ✅ Helm is available
echo Current Helm releases:
helm list
echo.

echo Select deployment environment:
echo [1] Development (dev values)
echo [2] Production (prod values)
echo [3] Custom (specify values file)
echo.
set /p env_choice="Enter your choice (1-3): "

set VALUES_FILE=""
if "%env_choice%"=="1" set VALUES_FILE="values-dev.yaml"
if "%env_choice%"=="2" set VALUES_FILE="values-prod.yaml"
if "%env_choice%"=="3" (
    set /p VALUES_FILE="Enter values file name: "
)

echo.
echo 📦 1. Installing/Upgrading User Service...
cd "%~dp0..\helm-charts\user-service"
if not "%VALUES_FILE%"=="" if exist "%VALUES_FILE%" (
    helm upgrade --install user-service . -f %VALUES_FILE%
) else (
    helm upgrade --install user-service .
)
if %errorlevel% equ 0 (
    echo ✅ User Service Helm chart deployed successfully
) else (
    echo ❌ Failed to deploy User Service Helm chart
)

echo.
echo 📦 2. Installing/Upgrading Help Service...
cd "%~dp0..\helm-charts\help-service"
if not "%VALUES_FILE%"=="" if exist "%VALUES_FILE%" (
    helm upgrade --install help-service . -f %VALUES_FILE%
) else (
    helm upgrade --install help-service .
)
if %errorlevel% equ 0 (
    echo ✅ Help Service Helm chart deployed successfully
) else (
    echo ❌ Failed to deploy Help Service Helm chart
)

echo.
echo 📦 3. Installing/Upgrading Frontend...
if exist "%~dp0..\helm-charts\frontend\" (
    cd "%~dp0..\helm-charts\frontend"
    if not "%VALUES_FILE%"=="" if exist "%VALUES_FILE%" (
        helm upgrade --install frontend . -f %VALUES_FILE%
    ) else (
        helm upgrade --install frontend .
    )
    if %errorlevel% equ 0 (
        echo ✅ Frontend Helm chart deployed successfully
    ) else (
        echo ❌ Failed to deploy Frontend Helm chart
    )
) else (
    echo ⚠️ Frontend Helm chart not found, skipping
)

echo.
echo ⏳ Waiting for Helm deployments to be ready...
timeout /t 15 /nobreak >nul

echo.
echo 📊 Helm Deployment Status:
echo ==========================================
helm list
echo.
kubectl get deployments
echo.
kubectl get services
echo.
kubectl get pods

echo.
echo ✅ Helm charts deployment completed!
echo.
echo To check Helm releases:
echo   helm list
echo.
echo To rollback if needed:
echo   helm rollback [RELEASE_NAME] [REVISION]
echo.
echo To access services:
echo   call scripts\get-service-urls.bat
