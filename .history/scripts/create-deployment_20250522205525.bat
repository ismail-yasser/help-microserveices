@echo off
echo ===================================================
echo Kubernetes Deployment Creator - All Services
echo ===================================================
echo.

:: Check if argument provided
if "%1"=="" (
    echo Creating deployments for all services...
    set SERVICE_NAME=all
) else (
    echo Creating deployment for %1...
    set SERVICE_NAME=%1
)

:: Check Kubernetes connection
echo Checking Kubernetes connection...
kubectl version --short >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: Cannot connect to Kubernetes.
    echo Make sure your Kubernetes cluster (minikube/kind) is running.
    exit /b 1
)

:: Get Docker Hub username
set /p DOCKER_USERNAME=Enter your Docker Hub username [ismaill370]: 
if "%DOCKER_USERNAME%"=="" set DOCKER_USERNAME=ismaill370

:: Get image tag
set /p IMAGE_TAG=Enter image tag [latest]: 
if "%IMAGE_TAG%"=="" set IMAGE_TAG=latest

echo.
echo Using Docker Hub account: %DOCKER_USERNAME%
echo Using image tag: %IMAGE_TAG%
echo.

if "%SERVICE_NAME%"=="all" (
    call :apply_all_configs
) else (
    call :apply_specific_configs %SERVICE_NAME%
)

echo.
echo All operations completed successfully!
echo.
echo You can check pod status with:
echo kubectl get pods
pause
exit /b 0

:apply_all_configs
echo.
echo ===================================================
echo Applying Kubernetes Configurations for All Services
echo ===================================================

:: Create ConfigMaps first
echo Creating and applying ConfigMaps...
call :create_configmap help-service
call :create_configmap user-service

:: Create and apply Help Service
echo.
echo Creating and applying Help Service resources...
call :create_deployment help-service 3002
call :create_service help-service 3002
call :create_hpa help-service

:: Create and apply User Service
echo.
echo Creating and applying User Service resources...
call :create_deployment user-service 3003
call :create_service user-service 3003
call :create_hpa user-service

:: Create and apply Frontend
echo.
echo Creating and applying Frontend resources...
call :create_deployment frontend 3000
call :create_service frontend 3000 NodePort

echo.
echo All Kubernetes configurations applied successfully!
echo Waiting for deployments to be ready...

kubectl rollout status deployment/frontend
kubectl rollout status deployment/help-service
kubectl rollout status deployment/user-service

echo.
echo Checking pod status...
kubectl get pods

exit /b 0

:apply_specific_configs
set SERVICE=%1
echo.
echo ===================================================
echo Applying Kubernetes Configurations for %SERVICE%
echo ===================================================

if "%SERVICE%"=="frontend" (
    echo Creating and applying Frontend resources...
    call :create_deployment frontend 3000
    call :create_service frontend 3000 NodePort
) else if "%SERVICE%"=="help-service" (
    echo Creating and applying Help Service ConfigMap...
    call :create_configmap help-service
    
    echo Creating and applying Help Service resources...
    call :create_deployment help-service 3002
    call :create_service help-service 3002
    call :create_hpa help-service
) else if "%SERVICE%"=="user-service" (
    echo Creating and applying User Service ConfigMap...
    call :create_configmap user-service
    
    echo Creating and applying User Service resources...
    call :create_deployment user-service 3003
    call :create_service user-service 3003
    call :create_hpa user-service
) else (
    echo ERROR: Invalid service name: %SERVICE%
    echo Available services: frontend, help-service, user-service
    exit /b 1
)

echo.
echo %SERVICE% Kubernetes configurations applied successfully!
echo Waiting for deployment to be ready...
kubectl rollout status deployment/%SERVICE%

echo.
echo Checking pod status...
kubectl get pods -l app=%SERVICE%

exit /b 0

:create_deployment
set SVC_NAME=%1
set PORT=%2
echo Creating deployment for %SVC_NAME%...

:: Create temporary deployment YAML
echo apiVersion: apps/v1 > temp-deployment.yaml
echo kind: Deployment >> temp-deployment.yaml
echo metadata: >> temp-deployment.yaml
echo   name: %SVC_NAME% >> temp-deployment.yaml
echo   labels: >> temp-deployment.yaml
echo     app: %SVC_NAME% >> temp-deployment.yaml
echo spec: >> temp-deployment.yaml
echo   replicas: 2 >> temp-deployment.yaml
echo   selector: >> temp-deployment.yaml
echo     matchLabels: >> temp-deployment.yaml
echo       app: %SVC_NAME% >> temp-deployment.yaml
echo   template: >> temp-deployment.yaml
echo     metadata: >> temp-deployment.yaml
echo       labels: >> temp-deployment.yaml
echo         app: %SVC_NAME% >> temp-deployment.yaml
echo     spec: >> temp-deployment.yaml
echo       containers: >> temp-deployment.yaml
echo       - name: %SVC_NAME% >> temp-deployment.yaml
echo         image: %DOCKER_USERNAME%/%SVC_NAME%:%IMAGE_TAG% >> temp-deployment.yaml
echo         ports: >> temp-deployment.yaml
echo         - containerPort: %PORT% >> temp-deployment.yaml

:: Add environment variables for backend services
if NOT "%SVC_NAME%"=="frontend" (
    echo         envFrom: >> temp-deployment.yaml
    echo         - configMapRef: >> temp-deployment.yaml
    echo             name: %SVC_NAME%-config >> temp-deployment.yaml
)

:: Add health checks
echo         livenessProbe: >> temp-deployment.yaml
echo           httpGet: >> temp-deployment.yaml
if "%SVC_NAME%"=="frontend" (
    echo             path: / >> temp-deployment.yaml
) else if "%SVC_NAME%"=="help-service" (
    echo             path: /api/help/health >> temp-deployment.yaml
) else if "%SVC_NAME%"=="user-service" (
    echo             path: /api/users/health >> temp-deployment.yaml
)
echo             port: %PORT% >> temp-deployment.yaml
echo           initialDelaySeconds: 30 >> temp-deployment.yaml
echo           periodSeconds: 10 >> temp-deployment.yaml
echo         readinessProbe: >> temp-deployment.yaml
echo           httpGet: >> temp-deployment.yaml
if "%SVC_NAME%"=="frontend" (
    echo             path: / >> temp-deployment.yaml
) else if "%SVC_NAME%"=="help-service" (
    echo             path: /api/help/health >> temp-deployment.yaml
) else if "%SVC_NAME%"=="user-service" (
    echo             path: /api/users/health >> temp-deployment.yaml
)
echo             port: %PORT% >> temp-deployment.yaml
echo           initialDelaySeconds: 5 >> temp-deployment.yaml
echo           periodSeconds: 5 >> temp-deployment.yaml

:: Add resource limits
echo         resources: >> temp-deployment.yaml
echo           limits: >> temp-deployment.yaml
echo             cpu: "500m" >> temp-deployment.yaml
echo             memory: "512Mi" >> temp-deployment.yaml
echo           requests: >> temp-deployment.yaml
echo             cpu: "200m" >> temp-deployment.yaml
echo             memory: "256Mi" >> temp-deployment.yaml

:: Apply the deployment
kubectl apply -f temp-deployment.yaml
del temp-deployment.yaml
exit /b 0

:create_service
set SVC_NAME=%1
set PORT=%2
set TYPE=%3

echo Creating service for %SVC_NAME%...

:: Create temporary service YAML
echo apiVersion: v1 > temp-service.yaml
echo kind: Service >> temp-service.yaml
echo metadata: >> temp-service.yaml
echo   name: %SVC_NAME% >> temp-service.yaml
echo spec: >> temp-service.yaml
echo   selector: >> temp-service.yaml
echo     app: %SVC_NAME% >> temp-service.yaml

if "%TYPE%"=="NodePort" (
    echo   type: NodePort >> temp-service.yaml
    echo   ports: >> temp-service.yaml
    echo   - port: %PORT% >> temp-service.yaml
    echo     targetPort: %PORT% >> temp-service.yaml
    echo     nodePort: 30080 >> temp-service.yaml
) else (
    echo   type: ClusterIP >> temp-service.yaml
    echo   ports: >> temp-service.yaml
    echo   - port: %PORT% >> temp-service.yaml
    echo     targetPort: %PORT% >> temp-service.yaml
)

:: Apply the service
kubectl apply -f temp-service.yaml
del temp-service.yaml
exit /b 0

:create_configmap
set SVC_NAME=%1
echo Creating ConfigMap for %SVC_NAME%...

:: Create temporary ConfigMap YAML
echo apiVersion: v1 > temp-configmap.yaml
echo kind: ConfigMap >> temp-configmap.yaml
echo metadata: >> temp-configmap.yaml
echo   name: %SVC_NAME%-config >> temp-configmap.yaml
echo data: >> temp-configmap.yaml

if "%SVC_NAME%"=="help-service" (
    echo   MONGODB_URI: "mongodb://mongodb:27017/helpdb" >> temp-configmap.yaml
    echo   JWT_SECRET: "your-jwt-secret" >> temp-configmap.yaml
    echo   PORT: "3002" >> temp-configmap.yaml
) else if "%SVC_NAME%"=="user-service" (
    echo   MONGODB_URI: "mongodb://mongodb:27017/userdb" >> temp-configmap.yaml
    echo   JWT_SECRET: "your-jwt-secret" >> temp-configmap.yaml
    echo   PORT: "3003" >> temp-configmap.yaml
)

:: Apply the ConfigMap
kubectl apply -f temp-configmap.yaml
del temp-configmap.yaml
exit /b 0

:create_hpa
set SVC_NAME=%1
echo Creating HPA for %SVC_NAME%...

:: Create temporary HPA YAML
echo apiVersion: autoscaling/v2 > temp-hpa.yaml
echo kind: HorizontalPodAutoscaler >> temp-hpa.yaml
echo metadata: >> temp-hpa.yaml
echo   name: %SVC_NAME%-hpa >> temp-hpa.yaml
echo spec: >> temp-hpa.yaml
echo   scaleTargetRef: >> temp-hpa.yaml
echo     apiVersion: apps/v1 >> temp-hpa.yaml
echo     kind: Deployment >> temp-hpa.yaml
echo     name: %SVC_NAME% >> temp-hpa.yaml
echo   minReplicas: 2 >> temp-hpa.yaml
echo   maxReplicas: 5 >> temp-hpa.yaml
echo   metrics: >> temp-hpa.yaml
echo   - type: Resource >> temp-hpa.yaml
echo     resource: >> temp-hpa.yaml
echo       name: cpu >> temp-hpa.yaml
echo       target: >> temp-hpa.yaml
echo         type: Utilization >> temp-hpa.yaml
echo         averageUtilization: 70 >> temp-hpa.yaml

:: Apply the HPA
kubectl apply -f temp-hpa.yaml
del temp-hpa.yaml
exit /b 0
