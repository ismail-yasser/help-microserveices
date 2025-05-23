@echo off
REM Script to apply GKE-specific resources

REM Parse command line arguments
set PROJECT_ID=
set CLUSTER_NAME=
set ZONE=

:parse_args
if "%~1"=="" goto end_parse_args
if "%~1"=="--project-id" (
    set PROJECT_ID=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="--cluster" (
    set CLUSTER_NAME=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="--zone" (
    set ZONE=%~2
    shift
    shift
    goto parse_args
)
if "%~1"=="-h" (
    goto display_usage
)
if "%~1"=="--help" (
    goto display_usage
)
echo Unknown option: %~1
goto display_usage

:end_parse_args
REM Check if required parameters are provided
if "%PROJECT_ID%"=="" goto missing_params
if "%CLUSTER_NAME%"=="" goto missing_params
if "%ZONE%"=="" goto missing_params
goto continue_script

:missing_params
echo Error: Missing required parameters.
:display_usage
echo Usage: %0 [OPTIONS]
echo Apply GKE-specific resources to the cluster
echo.
echo Options:
echo   --project-id ID      Google Cloud Project ID
echo   --cluster NAME       GKE Cluster name
echo   --zone ZONE          GKE Cluster zone
echo   -h, --help           Display this help message
echo.
exit /b 1

:continue_script
REM Set GKE context
echo Setting GKE context...
gcloud container clusters get-credentials %CLUSTER_NAME% --zone %ZONE% --project %PROJECT_ID%

REM Apply GKE-specific configurations
echo Applying GKE-specific configurations...

REM Create namespace if it doesn't exist
kubectl get namespace production >nul 2>&1 || kubectl create namespace production

REM Set context to production namespace
kubectl config set-context --current --namespace=production

REM Apply GKE-specific services
echo Applying GKE LoadBalancer services...
kubectl apply -f k8s/gke/frontend-service.yaml

REM Apply regular k8s resources but with production namespace
echo Applying regular Kubernetes resources to production namespace...
kubectl apply -f k8s/help-service-secret.yaml -n production
kubectl apply -f k8s/user-service-secret.yaml -n production
kubectl apply -f k8s/help-service-configmap.yaml -n production
kubectl apply -f k8s/user-service-configmap.yaml -n production
kubectl apply -f k8s/frontend-configmap.yaml -n production

REM Apply deployments with namespace
set /p DOCKER_USERNAME=Enter your Docker Hub username: 

echo Applying deployments with Docker Hub images...
kubectl apply -f k8s/frontend-deployment.yaml -n production
kubectl apply -f k8s/user-service-deployment.yaml -n production
kubectl apply -f k8s/help-service-deployment.yaml -n production

REM Apply other services
kubectl apply -f k8s/help-service-service.yaml -n production
kubectl apply -f k8s/user-service-service.yaml -n production

echo.
echo Waiting for deployments to be ready...
kubectl rollout status deployment/frontend-deployment -n production --timeout=180s
kubectl rollout status deployment/user-service-deployment -n production --timeout=180s
kubectl rollout status deployment/help-service-deployment -n production --timeout=180s

echo.
echo Deployments complete! Getting service endpoints...
kubectl get services -n production

REM Get the external IP for frontend service
for /f "tokens=*" %%i in ('kubectl get svc frontend -n production -o jsonpath^="{.status.loadBalancer.ingress[0].ip}"') do (
    set FRONTEND_IP=%%i
)

echo.
echo Your application is available at: http://%FRONTEND_IP%
