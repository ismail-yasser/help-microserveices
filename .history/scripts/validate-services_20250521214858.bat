@echo off
echo Validating services...

:: Navigate to the project root
cd ..

:: Check Help Service
kubectl get pods -l app=help-service
kubectl get svc help-service

:: Check User Service
kubectl get pods -l app=user-service
kubectl get svc user-service

:: Check Frontend
kubectl get pods -l app=frontend
kubectl get svc frontend

pause
