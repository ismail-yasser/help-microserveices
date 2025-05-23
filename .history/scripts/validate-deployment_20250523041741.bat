@echo off
echo Validating Kubernetes deployment...
echo.

REM Check nodes status
echo Checking node status:
kubectl get nodes
echo.

REM Check pods status
echo Checking pod status:
kubectl get pods
echo.

REM Check services
echo Checking services:
kubectl get svc
echo.

REM Check ingress
echo Checking ingress:
kubectl get ingress
echo.

REM Check configmaps and secrets
echo Checking ConfigMaps:
kubectl get configmaps
echo.

echo Checking Secrets:
kubectl get secrets
echo.

REM Check if frontend pods are running
echo Validating frontend deployment:
kubectl get pods -l app=frontend
set FRONTEND_PODS="%errorlevel%"
if %FRONTEND_PODS% == "0" (
    echo Frontend pods are running successfully.
) else (
    echo Frontend pods may have issues. Check the logs with: kubectl logs -l app=frontend
)
echo.

REM Check if user-service pods are running
echo Validating user-service deployment:
kubectl get pods -l app=user-service
set USER_PODS="%errorlevel%"
if %USER_PODS% == "0" (
    echo User service pods are running successfully.
) else (
    echo User service pods may have issues. Check the logs with: kubectl logs -l app=user-service
)
echo.

REM Check if help-service pods are running
echo Validating help-service deployment:
kubectl get pods -l app=help-service
set HELP_PODS="%errorlevel%"
if %HELP_PODS% == "0" (
    echo Help service pods are running successfully.
) else (
    echo Help service pods may have issues. Check the logs with: kubectl logs -l app=help-service
)
echo.

echo Validation complete!
echo.
echo Access the application at:
echo Frontend: http://frontend.local
echo User Service API: http://user-service.local
echo Help Service API: http://help-service.local
echo.
echo For local development, you can use port forwarding:
echo kubectl port-forward service/frontend 8080:3001
echo kubectl port-forward service/user-service 8081:3000
echo kubectl port-forward service/help-service 8082:3002
