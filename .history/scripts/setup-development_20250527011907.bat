@echo off
setlocal enabledelayedexpansion

:: Setup Development Environment Script
:: This script sets up a complete development environment for the microservices project

echo ================================================
echo    Microservices Development Environment Setup
echo ================================================
echo.

:: Check if running in administrator mode
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo WARNING: Not running as administrator. Some operations may fail.
    echo It's recommended to run this script as administrator.
    echo.
    pause
)

echo [1/8] Checking prerequisites...
echo.

:: Check Docker
docker version >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: Docker is not installed or not running
    echo Please install Docker Desktop and ensure it's running
    goto :error
) else (
    echo ✓ Docker is running
)

:: Check Kubernetes
kubectl version --client >nul 2>&1
if %errorLevel% neq 0 (
    echo ERROR: kubectl is not installed
    echo Please install kubectl
    goto :error
) else (
    echo ✓ kubectl is available
)

:: Check Helm
helm version >nul 2>&1
if %errorLevel% neq 0 (
    echo WARNING: Helm is not installed
    echo Helm charts deployment will not be available
) else (
    echo ✓ Helm is available
)

:: Check Node.js
node --version >nul 2>&1
if %errorLevel% neq 0 (
    echo WARNING: Node.js is not installed
    echo Frontend development features will be limited
) else (
    echo ✓ Node.js is available
)

echo.
echo [2/8] Starting Minikube (if not running)...
echo.

:: Check if Minikube is running
kubectl cluster-info >nul 2>&1
if %errorLevel% neq 0 (
    echo Starting Minikube...
    minikube start --driver=docker --memory=4096 --cpus=2
    if %errorLevel% neq 0 (
        echo ERROR: Failed to start Minikube
        goto :error
    )
) else (
    echo ✓ Kubernetes cluster is running
)

echo.
echo [3/8] Enabling required Minikube addons...
echo.

:: Enable required addons
minikube addons enable ingress
minikube addons enable metrics-server
minikube addons enable dashboard

echo.
echo [4/8] Setting up Docker environment...
echo.

:: Set Docker environment to use Minikube's Docker daemon
echo Setting Docker environment to use Minikube...
FOR /f "tokens=*" %%i IN ('minikube docker-env --shell cmd') DO %%i

echo.
echo [5/8] Building Docker images...
echo.

:: Navigate to project root
cd /d "%~dp0.."

:: Build user service
echo Building user-service...
docker build -t user-service:latest ./user-service
if %errorLevel% neq 0 (
    echo ERROR: Failed to build user-service
    goto :error
)

:: Build help service
echo Building help-service...
docker build -t help-service:latest ./help-service
if %errorLevel% neq 0 (
    echo ERROR: Failed to build help-service
    goto :error
)

:: Build frontend
echo Building frontend...
docker build -t frontend:latest ./frontend
if %errorLevel% neq 0 (
    echo ERROR: Failed to build frontend
    goto :error
)

echo.
echo [6/8] Creating development namespace...
echo.

:: Create development namespace
kubectl create namespace development --dry-run=client -o yaml | kubectl apply -f -

:: Set context to development namespace
kubectl config set-context --current --namespace=development

echo.
echo [7/8] Installing development dependencies...
echo.

:: Install frontend dependencies
if exist "./frontend/package.json" (
    echo Installing frontend dependencies...
    cd frontend
    npm install
    cd ..
)

:: Install user-service dependencies
if exist "./user-service/package.json" (
    echo Installing user-service dependencies...
    cd user-service
    npm install
    cd ..
)

:: Install help-service dependencies
if exist "./help-service/package.json" (
    echo Installing help-service dependencies...
    cd help-service
    npm install
    cd ..
)

echo.
echo [8/8] Setting up development configuration...
echo.

:: Create development ConfigMaps
echo Applying development ConfigMaps...
kubectl apply -f k8s/user-service-config.yaml -n development
kubectl apply -f k8s/help-service-config.yaml -n development

:: Apply development-specific manifests
echo Deploying development services...
kubectl apply -f k8s/ -n development

echo.
echo ================================================
echo    Development Environment Setup Complete!
echo ================================================
echo.
echo Development namespace: development
echo.
echo Next steps:
echo 1. Run 'kubectl get pods -n development' to check pod status
echo 2. Run 'minikube dashboard' to open Kubernetes dashboard
echo 3. Use 'scripts\manage-project.bat' for project management
echo 4. Access services using 'scripts\get-service-urls.bat'
echo.
echo Development tools:
echo - Docker images built and ready
echo - Kubernetes cluster configured
echo - Development namespace created
echo - Dependencies installed
echo.
echo Happy coding! 🚀
echo.
pause
goto :end

:error
echo.
echo ❌ Setup failed! Please check the errors above.
echo.
pause
exit /b 1

:end
endlocal
