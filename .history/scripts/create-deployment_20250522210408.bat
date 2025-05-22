@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo Kubernetes Deployment Creator - All Services
echo ===================================================
echo.

REM Set K8S_DIR relative to this script
set "K8S_DIR=..\k8s"

REM Check Kubernetes connection
kubectl version --short >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: Cannot connect to Kubernetes. Ensure minikube/kind is running.
    exit /b 1
)

REM Deploy each service
for %%S in (frontend help-service user-service) do (
    echo.
    echo Deploying %%S...
    kubectl apply -f "!K8S_DIR!\%%S-deployment.yaml"
    if !ERRORLEVEL! neq 0 (
        echo ERROR: Failed to apply deployment for %%S
        exit /b 1
    )
    echo Waiting for deployment %%S to be ready...
    kubectl rollout status deployment/%%S
)

echo.
echo All deployments applied successfully!
echo.
kubectl get pods -o wide
pause
endlocal
exit /b 0
