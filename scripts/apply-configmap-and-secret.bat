x@echo off
:: Apply ConfigMaps and Secrets for all services

:: Apply ConfigMap for help-service
echo Applying ConfigMap for help-service...
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\help-service-configmap.yaml

:: Apply ConfigMap for user-service
echo Applying ConfigMap for user-service...
kubectl apply -f c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s\user-service-configmap.yaml

:: Apply Secret for sensitive data (if needed)
echo Applying Secret for sensitive data...
kubectl create secret generic app-secrets --from-literal=JWT_SECRET=your-jwt-secret --from-literal=MONGO_URI=your-mongo-uri

echo ConfigMaps and Secrets applied successfully!
