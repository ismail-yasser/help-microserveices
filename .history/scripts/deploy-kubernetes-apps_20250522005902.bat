@echo off
echo ===================================================
echo Kubernetes Deployment Helper
echo ===================================================
echo.

echo This script will help deploy your application to Kubernetes
echo after Docker Desktop issues are resolved.
echo.
echo Checking Kubernetes connection...
kubectl version
if %errorlevel% neq 0 (
    echo ERROR: Cannot connect to Kubernetes.
    echo Make sure Docker Desktop is running with Kubernetes enabled.
    goto end
)

echo.
echo Kubernetes connection successful!
echo.

echo ===================================================
echo Step 1: Delete existing deployments and services
echo ===================================================
echo.

echo Deleting existing deployments...
kubectl delete -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\frontend-deployment.yaml 2>nul
kubectl delete -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\help-service-deployment.yaml 2>nul
kubectl delete -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\user-service-deployment.yaml 2>nul

echo Deleting existing services...
kubectl delete -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\frontend-service.yaml 2>nul
kubectl delete -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\help-service.yaml 2>nul
kubectl delete -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\user-service.yaml 2>nul

echo.
echo Waiting for resources to be fully deleted...
timeout /t 10 > nul

echo.
echo ===================================================
echo Step 2: Apply service configurations
echo ===================================================
echo.

echo Applying service configurations...
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\frontend-service.yaml
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\help-service.yaml
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\user-service.yaml

echo.
echo ===================================================
echo Step 3: Apply deployment configurations
echo ===================================================
echo.

echo Applying deployment configurations...
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\frontend-deployment.yaml
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\help-service-deployment.yaml
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\user-service-deployment.yaml

echo.
echo ===================================================
echo Step 4: Check deployment status
echo ===================================================
echo.

echo Waiting for deployments to initialize...
timeout /t 10 > nul

echo Checking pod status...
kubectl get pods

echo.
echo Checking service status...
kubectl get services

echo.
echo ===================================================
echo Step 5: Verify port forwards
echo ===================================================
echo.

echo Verifying that required ports are available...
:: Check if ports are in use
netstat -ano | find "3000" > nul
if %errorlevel% equ 0 (
    echo WARNING: Port 3000 is already in use. You might have port conflicts.
    echo Use the check-port-conflicts.bat script to identify and resolve them.
)

netstat -ano | find "3001" > nul
if %errorlevel% equ 0 (
    echo WARNING: Port 3001 is already in use. You might have port conflicts.
    echo Use the check-port-conflicts.bat script to identify and resolve them.
)

echo.
echo ===================================================
echo Deployment Complete
echo ===================================================
echo.
echo Your Kubernetes deployment is complete.
echo.
echo Next steps:
echo 1. Use test-load-balancing-clean.bat to test your deployment
echo 2. Check logs with kubectl logs if needed
echo 3. Access your frontend at http://localhost:30080 (NodePort)
echo    or use port-forward to access at http://localhost:3001
echo.
echo Press any key to exit...

:end
pause > nul
