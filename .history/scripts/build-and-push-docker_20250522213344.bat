@echo off
:: Build and push Docker images for all services and frontend

:: Build and push help-service
docker build -t ismaill370/help-service:latest ..\services\help-service
docker push ismaill370/help-service:latest

:: Build and push user-service
docker build -t ismaill370/user-service:latest ..\services\user-service
docker push ismaill370/user-service:latest

:: Build and push frontend
docker build -t ismaill370/frontend:latest ..\frontend
docker push ismaill370/frontend:latest

echo All Docker images built and pushed successfully!