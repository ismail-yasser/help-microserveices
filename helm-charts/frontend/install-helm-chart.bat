@echo off
REM Install User Service Helm Chart
REM Usage: install-helm-chart.bat [environment] [release-name]
REM Examples:
REM   install-helm-chart.bat development user-service-dev
REM   install-helm-chart.bat production user-service-prod

setlocal enabledelayedexpansion

set ENVIRONMENT=%1
set RELEASE_NAME=%2

if "%ENVIRONMENT%"=="" (
    set ENVIRONMENT=development
)

if "%RELEASE_NAME%"=="" (
    set RELEASE_NAME=user-service
)

echo Installing User Service Helm Chart...
echo Environment: %ENVIRONMENT%
echo Release Name: %RELEASE_NAME%
echo.

REM Check if Helm is installed
helm version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Helm is not installed or not in PATH
    echo Please install Helm: https://helm.sh/docs/intro/install/
    exit /b 1
)

REM Check if kubectl is installed
kubectl version --client >nul 2>&1
if errorlevel 1 (
    echo ERROR: kubectl is not installed or not in PATH
    echo Please install kubectl and configure cluster access
    exit /b 1
)

REM Validate chart
echo Validating Helm chart...
helm lint "./helm-charts/user-service"
if errorlevel 1 (
    echo ERROR: Chart validation failed
    exit /b 1
)

REM Set values file based on environment
set VALUES_FILE=""
if "%ENVIRONMENT%"=="production" (
    set VALUES_FILE=-f "./helm-charts/user-service/values-production.yaml"
)
if "%ENVIRONMENT%"=="development" (
    set VALUES_FILE=-f "./helm-charts/user-service/values-development.yaml"
)

REM Prompt for required secrets
echo.
echo Required Configuration:
echo.
set /p MONGO_URI="Enter MongoDB URI: "
set /p JWT_SECRET="Enter JWT Secret: "

if "%MONGO_URI%"=="" (
    echo ERROR: MongoDB URI is required
    exit /b 1
)

if "%JWT_SECRET%"=="" (
    echo ERROR: JWT Secret is required
    exit /b 1
)

REM Create namespace if it doesn't exist
echo.
echo Creating namespace if needed...
kubectl create namespace %ENVIRONMENT% --dry-run=client -o yaml | kubectl apply -f -

REM Install or upgrade the chart
echo.
echo Installing Helm chart...
helm upgrade --install %RELEASE_NAME% "./helm-charts/user-service" ^
    %VALUES_FILE% ^
    --set secret.MONGO_URI="%MONGO_URI%" ^
    --set secret.JWT_SECRET="%JWT_SECRET%" ^
    --namespace %ENVIRONMENT% ^
    --wait --timeout=300s

if errorlevel 1 (
    echo ERROR: Helm installation failed
    exit /b 1
)

echo.
echo SUCCESS: User Service deployed successfully!
echo.
echo To check the status:
echo   kubectl get pods -n %ENVIRONMENT% -l app.kubernetes.io/name=user-service
echo.
echo To view logs:
echo   kubectl logs -n %ENVIRONMENT% -l app.kubernetes.io/name=user-service -f
echo.
echo To test the service:
echo   kubectl port-forward -n %ENVIRONMENT% svc/%RELEASE_NAME% 3000:3000
echo   curl http://localhost:3000/health
echo.

endlocal
