@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo Kubernetes Deployment Creator - All Services
echo ===================================================
echo.

set K8S_DIR=c:\Users\IsmailYasserIsmailAb\Desktop\project\k8s
mkdir "%K8S_DIR%" 2>nul

:: Set default or use provided service name
if "%1"=="" (
    echo Creating deployments for all services...
    set ALL_SERVICES=true
) else (
    set SERVICE_NAME=%1
    set ALL_SERVICES=false
    echo Creating deployment for %SERVICE_NAME%...
    set DEPLOYMENT_PATH=%K8S_DIR%\%SERVICE_NAME%-deployment.yaml
)

:: Check Kubernetes connection
echo Checking Kubernetes connection...
kubectl version --short >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Cannot connect to Kubernetes.
    echo Make sure your Kubernetes cluster (minikube/kind) is running.
    exit /b 1
)

:: Choose image name
set /p DOCKER_USERNAME=Enter your Docker Hub username [ismaill370]: 
if "%DOCKER_USERNAME%"=="" set DOCKER_USERNAME=ismaill370

set /p IMAGE_TAG=Enter image tag [latest]: 
if "%IMAGE_TAG%"=="" set IMAGE_TAG=latest

if "%ALL_SERVICES%"=="true" (
    call :create_deployment frontend
    call :create_deployment help-service
    call :create_deployment user-service
    
    echo.
    echo All deployments created successfully!
    goto :apply_deployments
) else (
    call :create_deployment %SERVICE_NAME%
    goto :apply_deployments
)

:create_deployment
set SERVICE_NAME=%1
set DEPLOYMENT_PATH=%K8S_DIR%\%SERVICE_NAME%-deployment.yaml

echo.
echo ===================================================
echo Creating Kubernetes Deployment for %SERVICE_NAME%
echo ===================================================
echo.

:: Create the deployment.yaml file if it doesn't exist
if not exist "%DEPLOYMENT_PATH%" (
    echo Creating new deployment file: %DEPLOYMENT_PATH%
    
    echo apiVersion: apps/v1 > "%DEPLOYMENT_PATH%"
    echo kind: Deployment >> "%DEPLOYMENT_PATH%"
    echo metadata: >> "%DEPLOYMENT_PATH%"
    echo   name: %SERVICE_NAME% >> "%DEPLOYMENT_PATH%"
    echo   labels: >> "%DEPLOYMENT_PATH%"
    echo     app: %SERVICE_NAME% >> "%DEPLOYMENT_PATH%"
    echo spec: >> "%DEPLOYMENT_PATH%"
    echo   replicas: 2 >> "%DEPLOYMENT_PATH%"
    echo   selector: >> "%DEPLOYMENT_PATH%"
    echo     matchLabels: >> "%DEPLOYMENT_PATH%"
    echo       app: %SERVICE_NAME% >> "%DEPLOYMENT_PATH%"
    echo   template: >> "%DEPLOYMENT_PATH%"
    echo     metadata: >> "%DEPLOYMENT_PATH%"
    echo       labels: >> "%DEPLOYMENT_PATH%"
    echo         app: %SERVICE_NAME% >> "%DEPLOYMENT_PATH%"
    echo     spec: >> "%DEPLOYMENT_PATH%"
    echo       containers: >> "%DEPLOYMENT_PATH%"
    echo       - name: %SERVICE_NAME% >> "%DEPLOYMENT_PATH%"
    
    if "%SERVICE_NAME%"=="frontend" (
        echo         image: %DOCKER_USERNAME%/%SERVICE_NAME%:%IMAGE_TAG% >> "%DEPLOYMENT_PATH%"
        echo         ports: >> "%DEPLOYMENT_PATH%"
        echo         - containerPort: 3000 >> "%DEPLOYMENT_PATH%"
    ) else if "%SERVICE_NAME%"=="help-service" (
        echo         image: %DOCKER_USERNAME%/%SERVICE_NAME%:%IMAGE_TAG% >> "%DEPLOYMENT_PATH%"
        echo         ports: >> "%DEPLOYMENT_PATH%"
        echo         - containerPort: 3002 >> "%DEPLOYMENT_PATH%"
        echo         envFrom: >> "%DEPLOYMENT_PATH%"
        echo         - configMapRef: >> "%DEPLOYMENT_PATH%"
        echo             name: %SERVICE_NAME%-config >> "%DEPLOYMENT_PATH%"
    ) else if "%SERVICE_NAME%"=="user-service" (
        echo         image: %DOCKER_USERNAME%/%SERVICE_NAME%:%IMAGE_TAG% >> "%DEPLOYMENT_PATH%"
        echo         ports: >> "%DEPLOYMENT_PATH%"
        echo         - containerPort: 3003 >> "%DEPLOYMENT_PATH%"
        echo         envFrom: >> "%DEPLOYMENT_PATH%"
        echo         - configMapRef: >> "%DEPLOYMENT_PATH%"
        echo             name: %SERVICE_NAME%-config >> "%DEPLOYMENT_PATH%"
    )
    
    :: Add liveness and readiness probes
    if "%SERVICE_NAME%"=="frontend" (
        echo         livenessProbe: >> "%DEPLOYMENT_PATH%"
        echo           httpGet: >> "%DEPLOYMENT_PATH%"
        echo             path: / >> "%DEPLOYMENT_PATH%"
        echo             port: 3000 >> "%DEPLOYMENT_PATH%"
        echo           initialDelaySeconds: 30 >> "%DEPLOYMENT_PATH%"
        echo           periodSeconds: 10 >> "%DEPLOYMENT_PATH%"
        echo         readinessProbe: >> "%DEPLOYMENT_PATH%"
        echo           httpGet: >> "%DEPLOYMENT_PATH%"
        echo             path: / >> "%DEPLOYMENT_PATH%"
        echo             port: 3000 >> "%DEPLOYMENT_PATH%"
        echo           initialDelaySeconds: 5 >> "%DEPLOYMENT_PATH%"
        echo           periodSeconds: 5 >> "%DEPLOYMENT_PATH%"
    ) else if "%SERVICE_NAME%"=="help-service" (
        echo         livenessProbe: >> "%DEPLOYMENT_PATH%"
        echo           httpGet: >> "%DEPLOYMENT_PATH%"
        echo             path: /api/help/health >> "%DEPLOYMENT_PATH%"
        echo             port: 3002 >> "%DEPLOYMENT_PATH%"
        echo           initialDelaySeconds: 30 >> "%DEPLOYMENT_PATH%"
        echo           periodSeconds: 10 >> "%DEPLOYMENT_PATH%"
        echo         readinessProbe: >> "%DEPLOYMENT_PATH%"
        echo           httpGet: >> "%DEPLOYMENT_PATH%"
        echo             path: /api/help/health >> "%DEPLOYMENT_PATH%"
        echo             port: 3002 >> "%DEPLOYMENT_PATH%"
        echo           initialDelaySeconds: 5 >> "%DEPLOYMENT_PATH%"
        echo           periodSeconds: 5 >> "%DEPLOYMENT_PATH%"
    ) else if "%SERVICE_NAME%"=="user-service" (
        echo         livenessProbe: >> "%DEPLOYMENT_PATH%"
        echo           httpGet: >> "%DEPLOYMENT_PATH%"
        echo             path: /api/users/health >> "%DEPLOYMENT_PATH%"
        echo             port: 3003 >> "%DEPLOYMENT_PATH%"
        echo           initialDelaySeconds: 30 >> "%DEPLOYMENT_PATH%"
        echo           periodSeconds: 10 >> "%DEPLOYMENT_PATH%"
        echo         readinessProbe: >> "%DEPLOYMENT_PATH%"
        echo           httpGet: >> "%DEPLOYMENT_PATH%"
        echo             path: /api/users/health >> "%DEPLOYMENT_PATH%"
        echo             port: 3003 >> "%DEPLOYMENT_PATH%"
        echo           initialDelaySeconds: 5 >> "%DEPLOYMENT_PATH%"
        echo           periodSeconds: 5 >> "%DEPLOYMENT_PATH%"
    )
    
    :: Add resource limits for HPA to work
    echo         resources: >> "%DEPLOYMENT_PATH%"
    echo           limits: >> "%DEPLOYMENT_PATH%"
    echo             cpu: "500m" >> "%DEPLOYMENT_PATH%"
    echo             memory: "512Mi" >> "%DEPLOYMENT_PATH%"
    echo           requests: >> "%DEPLOYMENT_PATH%"
    echo             cpu: "200m" >> "%DEPLOYMENT_PATH%"
    echo             memory: "256Mi" >> "%DEPLOYMENT_PATH%"
    
    echo Deployment file created successfully.
) else (
    echo Deployment file already exists: %DEPLOYMENT_PATH%
    echo Updating image to: %DOCKER_USERNAME%/%SERVICE_NAME%:%IMAGE_TAG%
    
    :: Replace the image line in the existing deployment file
    powershell -Command "(Get-Content '%DEPLOYMENT_PATH%') -replace 'image: .*/%SERVICE_NAME%:.*', 'image: %DOCKER_USERNAME%/%SERVICE_NAME%:%IMAGE_TAG%' | Set-Content '%DEPLOYMENT_PATH%'"
)

echo.
echo ===================================================
echo Applying Kubernetes Deployment for %SERVICE_NAME%
echo ===================================================
echo.

echo Applying deployment to Kubernetes...
if exist "%DEPLOYMENT_PATH%" (
    kubectl apply -f "%DEPLOYMENT_PATH%"
    if %errorlevel% neq 0 (
        echo ERROR: Failed to apply %SERVICE_NAME% deployment.
        exit /b 1
    )
    
    echo.
    echo Waiting for %SERVICE_NAME% deployment to be ready...
    kubectl rollout status deployment/%SERVICE_NAME%
)

exit /b 0

:apply_deployments
echo.
echo ===================================================
echo Applying Kubernetes Deployments
echo ===================================================
echo.

if "%ALL_SERVICES%"=="true" (
    for %%s in (frontend help-service user-service) do (
        set CURRENT_DEP=!K8S_DIR!\%%s-deployment.yaml
        if exist "!CURRENT_DEP!" (
            echo Applying %%s deployment...
            kubectl apply -f "!CURRENT_DEP!"
            if !errorlevel! neq 0 (
                echo WARNING: Failed to apply %%s deployment.
            ) else (
                echo Successfully applied %%s deployment.
                kubectl rollout status deployment/%%s
            )
        )
    )
) else (
    echo Applying %SERVICE_NAME% deployment...
    kubectl apply -f "%DEPLOYMENT_PATH%"
    if %errorlevel% neq 0 (
        echo ERROR: Failed to apply deployment.
        exit /b 1
    )
    
    echo Waiting for deployment to be ready...
    kubectl rollout status deployment/%SERVICE_NAME%
)

echo.
echo ===================================================
echo Kubernetes Deployment Status
echo ===================================================
echo.

echo Checking pod status...
if "%ALL_SERVICES%"=="true" (
    kubectl get pods -l app=frontend -o wide
    kubectl get pods -l app=help-service -o wide
    kubectl get pods -l app=user-service -o wide
) else (
    kubectl get pods -l app=%SERVICE_NAME% -o wide
)

echo.
if "%ALL_SERVICES%"=="true" (
    echo Successfully deployed all services with 2 replicas each.
    echo.
    echo You can monitor all deployments with:
    echo kubectl get deployments -o wide
    echo.
    echo To view all running pods:
    echo kubectl get pods -o wide
    echo.
    echo To see detailed information about a specific deployment:
    echo kubectl describe deployment [service-name]
) else (
    echo Successfully deployed %SERVICE_NAME% with 2 replicas.
    echo.
    echo You can monitor the deployment status with:
    echo kubectl get deployment %SERVICE_NAME% -o wide
    echo.
    echo To view the running pods:
    echo kubectl get pods -l app=%SERVICE_NAME% -o wide
    echo.
    echo To see detailed information about the deployment:
    echo kubectl describe deployment %SERVICE_NAME%
)

endlocal
