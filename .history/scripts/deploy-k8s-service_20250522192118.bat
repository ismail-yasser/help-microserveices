@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo Kubernetes Deployment Script
echo ===================================================
echo.

if "%1"=="" (
    echo Please provide a service name: frontend, help-service, or user-service
    echo Usage: deploy-k8s-service.bat [service-name]
    exit /b 1
)

set SERVICE=%1

echo Deploying %SERVICE% to Kubernetes...
echo.

:: Check Kubernetes connection
echo Checking Kubernetes connection...
kubectl version --client >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: kubectl not found or not configured
    echo Make sure Kubernetes (minikube or kind) is running
    exit /b 1
)

:: Check if deployment file exists
set DEPLOYMENT_FILE=..\k8s\%SERVICE%-deployment.yaml
if not exist %DEPLOYMENT_FILE% (
    echo ERROR: Deployment file not found: %DEPLOYMENT_FILE%
    exit /b 1
)

:: Check if service file exists
set SERVICE_FILE=..\k8s\%SERVICE%.yaml
if not exist %SERVICE_FILE% (
    echo ERROR: Service file not found: %SERVICE_FILE%
    exit /b 1
)

:: Check for ConfigMap
set CONFIGMAP_FILE=..\k8s\%SERVICE%-configmap.yaml
set HAS_CONFIGMAP=false
if exist %CONFIGMAP_FILE% (
    set HAS_CONFIGMAP=true
)

echo.
echo ===================================================
echo Step 1: Apply ConfigMap (if available)
echo ===================================================
echo.

if "%HAS_CONFIGMAP%"=="true" (
    echo Applying ConfigMap for %SERVICE%...
    kubectl apply -f %CONFIGMAP_FILE%
    if %errorlevel% neq 0 (
        echo ERROR: Failed to apply ConfigMap
        exit /b 1
    )
    echo ConfigMap applied successfully!
) else (
    echo No ConfigMap found for %SERVICE%, skipping...
)

echo.
echo ===================================================
echo Step 2: Apply Service
echo ===================================================
echo.

echo Applying Service for %SERVICE%...
kubectl apply -f %SERVICE_FILE%
if %errorlevel% neq 0 (
    echo ERROR: Failed to apply Service
    exit /b 1
)
echo Service applied successfully!

echo.
echo ===================================================
echo Step 3: Apply Deployment
echo ===================================================
echo.

echo Applying Deployment for %SERVICE%...
kubectl apply -f %DEPLOYMENT_FILE%
if %errorlevel% neq 0 (
    echo ERROR: Failed to apply Deployment
    exit /b 1
)
echo Deployment applied successfully!

echo.
echo ===================================================
echo Step 4: Check for HPA Configuration
echo ===================================================
echo.

set HPA_FILE=..\k8s\%SERVICE%-hpa.yaml
if exist %HPA_FILE% (
    echo Applying HPA for %SERVICE%...
    kubectl apply -f %HPA_FILE%
    if %errorlevel% neq 0 (
        echo WARNING: Failed to apply HPA. Make sure metrics-server is installed
        echo To install metrics-server in minikube: minikube addons enable metrics-server
    ) else (
        echo HPA applied successfully!
    )
) else (
    echo No HPA configuration found for %SERVICE%, skipping...
)

echo.
echo ===================================================
echo Step 5: Verify Deployment Status
echo ===================================================
echo.

echo Waiting for deployment to stabilize...
timeout /t 5 > nul

echo Checking pod status...
kubectl get pods -l app=%SERVICE% -o wide
echo.

echo Checking service status...
kubectl get service -l app=%SERVICE%
echo.

echo Checking deployment status...
kubectl get deployment -l app=%SERVICE%
echo.

if exist %HPA_FILE% (
    echo Checking HPA status...
    kubectl get hpa -l app=%SERVICE%
    echo.
)

echo.
echo ===================================================
echo Deployment Complete!
echo ===================================================
echo.
echo Next steps:
echo 1. Verify pods are running with: kubectl get pods -l app=%SERVICE%
echo 2. Check logs with: kubectl logs -l app=%SERVICE%
echo 3. For load balancing test, use the test-load-balancing.bat script
echo.

exit /b 0
