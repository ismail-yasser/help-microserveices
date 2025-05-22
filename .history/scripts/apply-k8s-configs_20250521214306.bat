@echo off
echo Applying Kubernetes configurations...

:: Apply Help Service
kubectl apply -f ..\k8s\help-service-deployment.yaml
kubectl apply -f ..\k8s\help-service.yaml
kubectl apply -f ..\k8s\help-service-hpa.yaml

:: Apply User Service
kubectl apply -f ..\k8s\user-service-deployment.yaml
kubectl apply -f ..\k8s\user-service.yaml
kubectl apply -f ..\k8s\user-service-hpa.yaml

:: Apply Frontend
kubectl apply -f ..\k8s\frontend-deployment.yaml
kubectl apply -f ..\k8s\frontend-service.yaml

echo Kubernetes configurations applied successfully!
pause