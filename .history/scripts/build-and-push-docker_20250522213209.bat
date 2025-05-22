@echo off
:: Build and push Docker images for all services and frontend

:: Set variables
set DOCKERHUB_USERNAME=ismaill370
set IMAGE_TAG=latest

:: Build and push help-service
echo Building and pushing Docker image for help-service...
cd ..\services\help-service
docker build -t %DOCKERHUB_USERNAME%/help-service:%IMAGE_TAG% .
docker push %DOCKERHUB_USERNAME%/help-service:%IMAGE_TAG%
cd ..\..

:: Build and push user-service
echo Building and pushing Docker image for user-service...
cd ..\services\user-service
docker build -t %DOCKERHUB_USERNAME%/user-service:%IMAGE_TAG% .
docker push %DOCKERHUB_USERNAME%/user-service:%IMAGE_TAG%
cd ..\..

:: Build and push frontend
echo Building and pushing Docker image for frontend...
cd ..\frontend
docker build -t %DOCKERHUB_USERNAME%/frontend:%IMAGE_TAG% .
docker push %DOCKERHUB_USERNAME%/frontend:%IMAGE_TAG%
cd ..\

echo All Docker images built and pushed successfully!