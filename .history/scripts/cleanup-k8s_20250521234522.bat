@echo off
echo Cleaning up Kubernetes resources...

:: Navigate to the project root
cd ..

:: Delete ConfigMaps
echo Deleting ConfigMaps...
kubectl delete -f k8s\help-service-configmap.yaml
kubectl delete -f k8s\user-service-configmap.yaml

:: Delete Help Service
kubectl delete -f k8s\help-service-deployment.yaml
kubectl delete -f k8s\help-service.yaml
kubectl delete -f k8s\help-service-hpa.yaml

:: Delete User Service
kubectl delete -f k8s\user-service-deployment.yaml
kubectl delete -f k8s\user-service.yaml
kubectl delete -f k8s\user-service-hpa.yaml

:: Delete Frontend
kubectl delete -f k8s\frontend-deployment.yaml
kubectl delete -f k8s\frontend-service.yaml

echo Kubernetes resources cleaned up successfully!
pause
