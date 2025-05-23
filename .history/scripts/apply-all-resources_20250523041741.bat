@echo off
echo Applying all Kubernetes resources in the correct order...
echo.

REM Apply ConfigMaps first
echo Applying ConfigMaps...
kubectl apply -f k8s/user-service-configmap.yaml
kubectl apply -f k8s/help-service-configmap.yaml
kubectl apply -f k8s/frontend-configmap.yaml
echo ConfigMaps applied successfully.
echo.

REM Apply Secrets next
echo Applying Secrets...
kubectl apply -f k8s/user-service-secret.yaml
kubectl apply -f k8s/help-service-secret.yaml
echo Secrets applied successfully.
echo.

REM Apply deployments
echo Applying Deployments...
kubectl apply -f k8s/user-service-deployment.yaml
kubectl apply -f k8s/help-service-deployment.yaml
kubectl apply -f k8s/frontend-deployment.yaml
echo Deployments applied successfully.
echo.

REM Apply services
echo Applying Services...
kubectl apply -f k8s/user-service.yaml
kubectl apply -f k8s/help-service.yaml
kubectl apply -f k8s/frontend-service.yaml
echo Services applied successfully.
echo.

REM Apply ingress last
echo Applying Ingress...
kubectl apply -f k8s/ingress.yaml
echo Ingress applied successfully.
echo.

echo Waiting for deployments to be ready...
kubectl rollout status deployment/frontend-deployment
kubectl rollout status deployment/user-service-deployment
kubectl rollout status deployment/help-service-deployment

echo All resources have been applied!
echo.

echo You can now run the validation script to check the deployment status:
echo .\scripts\validate-deployment.bat
echo.

echo To access the application, make sure you've added the host entries:
echo Run: powershell -ExecutionPolicy Bypass -File .\scripts\add-host-entries.ps1
