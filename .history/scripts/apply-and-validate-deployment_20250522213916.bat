@echo off
:: Apply and validate Kubernetes deployment

:: Apply the deployment
echo Applying help-service deployment...
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\help-service-deployment.yaml

:: Validate the deployment
echo Validating help-service deployment...
kubectl rollout status deployment/help-service-deployment

:: Display the status of pods
echo Displaying pod status...
kubectl get pods -o wide
