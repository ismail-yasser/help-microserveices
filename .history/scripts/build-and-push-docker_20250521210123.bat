@echo off
echo Building and pushing Docker images...

:: Build and push Help Service
cd services\help-service
docker build -t ismaill370/help-service:latest .
docker push ismaill370/help-service:latest
cd ../..

:: Build and push User Service
cd services\user-service
docker build -t ismaill370/user-service:latest .
docker push ismaill370/user-service:latest
cd ../..

:: Build and push Frontend
cd frontend
docker build -t ismaill370/frontend:latest .
docker push ismaill370/frontend:latest
cd ..

echo Docker images built and pushed successfully!
pause
