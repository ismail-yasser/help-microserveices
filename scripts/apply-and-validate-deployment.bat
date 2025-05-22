@echo off
:: Apply and validate Kubernetes deployments for all services and frontend

:: Apply and validate help-service deployment
echo Applying help-service deployment...
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\help-service-deployment.yaml
echo Validating help-service deployment...
kubectl rollout status deployment/help-service-deployment

:: Apply and validate user-service deployment
echo Applying user-service deployment...
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\user-service-deployment.yaml
echo Validating user-service deployment...
kubectl rollout status deployment/user-service-deployment

:: Apply and validate frontend deployment
echo Applying frontend deployment...
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\frontend-deployment.yaml
echo Validating frontend deployment...
kubectl rollout status deployment/frontend-deployment

:: Display the status of all pods
echo Displaying pod status...
kubectl get pods -o wide
