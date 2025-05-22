@echo off
echo ===================================================
echo Kubernetes Deployment Helper
echo ===================================================
echo.

echo This script will deploy your microservices to Kubernetes.
echo.

echo Checking Kubernetes connection...
kubectl version --client
if %errorlevel% neq 0 (
    echo ERROR: kubectl not found or not in path.
    echo Please install kubectl or add it to your PATH.
    goto end
)

kubectl get nodes > nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Cannot connect to Kubernetes cluster.
    echo Make sure your Kubernetes cluster is running.
    goto end
)

echo.
echo Kubernetes connection successful!
echo.

echo ===================================================
echo Step 1: Apply ConfigMaps
echo ===================================================
echo.

echo Applying ConfigMaps...
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\help-service-configmap.yaml
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\user-service-configmap.yaml

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
echo Step 4: Apply HPA configurations
echo ===================================================
echo.

echo Applying Horizontal Pod Autoscalers...
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\help-service-hpa.yaml
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\user-service-hpa.yaml

echo.
echo ===================================================
echo Step 5: Check deployment status
echo ===================================================
echo.

echo Waiting for deployments to initialize...
timeout /t 5 > nul

echo Checking pod status...
kubectl get pods

echo.
echo Checking service status...
kubectl get services

echo.
echo Checking HPA status...
kubectl get hpa

echo.
echo ===================================================
echo Deployment Complete
echo ===================================================
echo.
echo Your microservices have been deployed to Kubernetes.
echo.
echo Next steps:
echo 1. Test load balancing with test-load-balancing.bat
echo 2. Check API endpoints with test-health-endpoints.bat
echo 3. Access your frontend at http://localhost:30080 (NodePort)
echo.
echo Press any key to exit...

:end
pause > nul
