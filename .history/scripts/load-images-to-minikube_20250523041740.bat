@echo off
echo Loading Docker images into Minikube...

REM Get the minikube Docker environment
echo Make sure you have run 'minikube docker-env | Invoke-Expression' in PowerShell before running this script

REM Load the frontend image
echo Loading frontend image...
docker tag frontend:latest frontend:local
minikube image load frontend:local || echo Failed to load frontend image

REM Load the user-service image
echo Loading user-service image...
docker tag user-service:latest user-service:local
minikube image load user-service:local || echo Failed to load user-service image

REM Load the help-service image
echo Loading help-service image...
docker tag help-service:latest help-service:local
minikube image load help-service:local || echo Failed to load help-service image

echo Image loading complete!
