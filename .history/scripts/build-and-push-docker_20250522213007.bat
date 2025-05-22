@echo off
:: Build and push Docker images for all services and frontend

:: Set variables
set DOCKERHUB_USERNAME=ismaill370
set IMAGE_TAG=latest

:: Define services
set SERVICES=help-service user-service frontend

:: Loop through each service
for %%S in (%SERVICES%) do (
    echo Building and pushing Docker image for %%S...
    cd ..\services\%%S
    docker build -t %DOCKERHUB_USERNAME%/%%S:%IMAGE_TAG% .
    docker push %DOCKERHUB_USERNAME%/%%S:%IMAGE_TAG%
    cd ..\..
)

echo All Docker images built and pushed successfully!