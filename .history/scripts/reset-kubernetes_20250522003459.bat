@echo off
echo ===================================================
echo Kubernetes Reset and Reinstall Script
echo ===================================================
echo.
echo This script will:
echo 1. Reset Kubernetes configuration
echo 2. Verify Docker Desktop Kubernetes is enabled
echo 3. Reapply all Kubernetes configurations
echo.
echo Make sure Docker Desktop is running before proceeding!
echo.
set /p confirm="Continue? (y/n): "
if /i not "%confirm%"=="y" goto :end

echo.
echo ===================================================
echo Verifying Docker is running...
echo ===================================================
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Docker is not running. Please start Docker Desktop first.
    goto :end
)

echo.
echo ===================================================
echo Resetting Kubernetes components...
echo ===================================================
kubectl delete --all deployments --namespace=default
kubectl delete --all services --namespace=default
kubectl delete --all pods --namespace=default

echo.
echo ===================================================
echo Applying Kubernetes configurations...
echo ===================================================
cd ..\k8s

echo Applying namespace...
kubectl apply -f namespace.yaml

echo Applying secrets...
kubectl apply -f secrets.yaml

echo Applying configmaps...
kubectl apply -f configmap.yaml

echo Applying services...
kubectl apply -f user-service.yaml
kubectl apply -f help-service.yaml
kubectl apply -f frontend-service.yaml

echo Applying deployments...
kubectl apply -f user-deployment.yaml
kubectl apply -f help-deployment.yaml
kubectl apply -f frontend-deployment.yaml

echo.
echo ===================================================
echo Verifying deployments...
echo ===================================================
kubectl get deployments
kubectl get services

echo.
echo ===================================================
echo Reset and reinstall complete!
echo ===================================================
echo.
echo Please wait a few moments for all pods to start up.
echo Run 'kubectl get pods' to verify all pods are running.
echo.

:end
pause
