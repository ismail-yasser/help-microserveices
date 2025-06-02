@echo off
echo ==========================================
echo 🎯 KUBERNETES MANIFESTS DEPLOYMENT
echo ==========================================
echo.

REM Check if k8s directory exists
if not exist "%~dp0..\k8s\" (
    echo ❌ k8s directory not found
    echo Expected location: %~dp0..\k8s\
    exit /b 1
)

echo Deploying Kubernetes manifests...
echo.

echo 📦 1. Deploying User Service...
kubectl apply -f "%~dp0..\k8s\user-service\" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ User Service deployed successfully
) else (
    echo ❌ Failed to deploy User Service
)

echo 📦 2. Deploying Help Service...
kubectl apply -f "%~dp0..\k8s\help-service\" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Help Service deployed successfully
) else (
    echo ❌ Failed to deploy Help Service
)

echo 📦 3. Deploying Frontend...
kubectl apply -f "%~dp0..\k8s\frontend\" >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Frontend deployed successfully
) else (
    echo ❌ Failed to deploy Frontend
)

echo 📦 4. Deploying ConfigMaps and Secrets...
if exist "%~dp0..\k8s\config\" (
    kubectl apply -f "%~dp0..\k8s\config\" >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ ConfigMaps and Secrets deployed successfully
    ) else (
        echo ❌ Failed to deploy ConfigMaps and Secrets
    )
) else (
    echo ⚠️ No config directory found, skipping ConfigMaps/Secrets
)

echo 📦 5. Deploying HPA (Horizontal Pod Autoscaler)...
if exist "%~dp0..\k8s\hpa\" (
    kubectl apply -f "%~dp0..\k8s\hpa\" >nul 2>&1
    if %errorlevel% equ 0 (
        echo ✅ HPA deployed successfully
    ) else (
        echo ❌ Failed to deploy HPA
    )
) else (
    REM Try to find HPA configs in service directories
    kubectl apply -f "%~dp0..\k8s\user-service\*hpa*.yaml" >nul 2>&1
    kubectl apply -f "%~dp0..\k8s\help-service\*hpa*.yaml" >nul 2>&1
    kubectl apply -f "%~dp0..\k8s\frontend\*hpa*.yaml" >nul 2>&1
    echo ✅ HPA configurations applied
)

echo.
echo ⏳ Waiting for deployments to be ready...
timeout /t 10 /nobreak >nul

echo.
echo 📊 Deployment Status:
echo ==========================================
kubectl get deployments
echo.
kubectl get services
echo.
kubectl get pods

echo.
echo ✅ Kubernetes manifests deployment completed!
echo.
echo To check if all pods are running:
echo   kubectl get pods
echo.
echo To access services:
echo   call scripts\get-service-urls.bat
