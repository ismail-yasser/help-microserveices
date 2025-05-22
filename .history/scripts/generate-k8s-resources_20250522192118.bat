@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo Kubernetes Resource Generator
echo ===================================================
echo.

if "%1"=="" (
    echo Please provide a service name
    echo Usage: generate-k8s-resources.bat [service-name] [docker-username] [port]
    exit /b 1
)

set SERVICE=%1
set DOCKER_USERNAME=%2
set PORT=3000

if not "%3"=="" (
    set PORT=%3
)

if "%DOCKER_USERNAME%"=="" (
    set /p DOCKER_USERNAME=Enter your DockerHub username: 
)

set K8S_DIR=..\k8s

echo Generating Kubernetes resources for %SERVICE%...
echo Docker Image: %DOCKER_USERNAME%/%SERVICE%:latest
echo Container Port: %PORT%
echo.

:: Create directory if it doesn't exist
if not exist %K8S_DIR% mkdir %K8S_DIR%

:: Create Deployment file
echo Generating deployment file...
(
    echo apiVersion: apps/v1
    echo kind: Deployment
    echo metadata:
    echo   name: %SERVICE%
    echo   labels:
    echo     app: %SERVICE%
    echo spec:
    echo   replicas: 2
    echo   selector:
    echo     matchLabels:
    echo       app: %SERVICE%
    echo   template:
    echo     metadata:
    echo       labels:
    echo         app: %SERVICE%
    echo     spec:
    echo       containers:
    echo       - name: %SERVICE%
    echo         image: %DOCKER_USERNAME%/%SERVICE%:latest
    echo         ports:
    echo         - containerPort: %PORT%
    echo         env:
    echo         - name: POD_NAME
    echo           valueFrom:
    echo             fieldRef:
    echo               fieldPath: metadata.name
    echo         - name: HOSTNAME
    echo           valueFrom:
    echo             fieldRef:
    echo               fieldPath: spec.nodeName
    echo         resources:
    echo           limits:
    echo             cpu: 500m
    echo             memory: 512Mi
    echo           requests:
    echo             cpu: 200m
    echo             memory: 256Mi
    echo         livenessProbe:
    echo           httpGet:
    echo             path: /health
    echo             port: %PORT%
    echo           initialDelaySeconds: 30
    echo           periodSeconds: 10
    echo           timeoutSeconds: 5
    echo           failureThreshold: 3
    echo         readinessProbe:
    echo           httpGet:
    echo             path: /health
    echo             port: %PORT%
    echo           initialDelaySeconds: 5
    echo           periodSeconds: 5
    echo           timeoutSeconds: 2
    echo           successThreshold: 1
    echo           failureThreshold: 3
) > %K8S_DIR%\%SERVICE%-deployment.yaml

:: Create Service file
echo Generating service file...
(
    echo apiVersion: v1
    echo kind: Service
    echo metadata:
    echo   name: %SERVICE%
    echo   labels:
    echo     app: %SERVICE%
    echo spec:
    echo   type: ClusterIP
    echo   ports:
    echo   - port: 80
    echo     targetPort: %PORT%
    echo     protocol: TCP
    echo   selector:
    echo     app: %SERVICE%
) > %K8S_DIR%\%SERVICE%.yaml

:: Create ConfigMap file
echo Generating configmap file...
(
    echo apiVersion: v1
    echo kind: ConfigMap
    echo metadata:
    echo   name: %SERVICE%-config
    echo   labels:
    echo     app: %SERVICE%
    echo data:
    echo   # Add your configuration key-value pairs here
    echo   NODE_ENV: "production"
    echo   # Add more environment variables as needed
) > %K8S_DIR%\%SERVICE%-configmap.yaml

:: Create HPA file
echo Generating HPA file...
(
    echo apiVersion: autoscaling/v2
    echo kind: HorizontalPodAutoscaler
    echo metadata:
    echo   name: %SERVICE%-hpa
    echo   labels:
    echo     app: %SERVICE%
    echo spec:
    echo   scaleTargetRef:
    echo     apiVersion: apps/v1
    echo     kind: Deployment
    echo     name: %SERVICE%
    echo   minReplicas: 2
    echo   maxReplicas: 10
    echo   metrics:
    echo   - type: Resource
    echo     resource:
    echo       name: cpu
    echo       target:
    echo         type: Utilization
    echo         averageUtilization: 80
    echo   - type: Resource
    echo     resource:
    echo       name: memory
    echo       target:
    echo         type: Utilization
    echo         averageUtilization: 80
) > %K8S_DIR%\%SERVICE%-hpa.yaml

echo.
echo ===================================================
echo Kubernetes resources generated successfully!
echo ===================================================
echo.
echo Files created:
echo - %K8S_DIR%\%SERVICE%-deployment.yaml
echo - %K8S_DIR%\%SERVICE%.yaml
echo - %K8S_DIR%\%SERVICE%-configmap.yaml
echo - %K8S_DIR%\%SERVICE%-hpa.yaml
echo.
echo Next steps:
echo 1. Edit the generated files to customize as needed
echo 2. Build and push your Docker image with: build-and-push-docker.bat %SERVICE% %DOCKER_USERNAME%
echo 3. Deploy to Kubernetes with: deploy-k8s-service.bat %SERVICE%
echo.

exit /b 0
