@echo off
setlocal enabledelayedexpansion
echo ==========================================
echo 🚀 KUBERNETES MICROSERVICES DEPLOYMENT
echo ==========================================
echo.
echo This script will deploy the complete microservices project
echo to your Kubernetes cluster (Minikube, K3d, or GKE).
echo.

REM Check if kubectl is available
kubectl version --client >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ kubectl is not installed or not in PATH
    echo Please install kubectl and try again.
    pause
    exit /b 1
)

REM Check if cluster is accessible
kubectl cluster-info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Kubernetes cluster is not accessible
    echo Please ensure your cluster is running and kubectl is configured.
    echo.
    echo For Minikube: minikube start
    echo For other clusters: kubectl config current-context
    pause
    exit /b 1
)

echo ✅ Kubernetes cluster is accessible
kubectl config current-context
echo.

echo Select deployment method:
echo [1] Quick Deploy (Kubernetes manifests)
echo [2] Production Deploy (Helm charts) 
echo [3] Development Deploy (with monitoring)
echo [4] Complete Deploy (everything)
echo.
set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" goto quick_deploy
if "%choice%"=="2" goto helm_deploy
if "%choice%"=="3" goto dev_deploy
if "%choice%"=="4" goto complete_deploy

echo Invalid choice. Exiting.
pause
exit /b 1

:quick_deploy
echo.
echo 🚀 QUICK DEPLOYMENT - Kubernetes Manifests
echo ==========================================
call "%~dp0deploy-k8s-manifests.bat"
goto end

:helm_deploy
echo.
echo 🚀 PRODUCTION DEPLOYMENT - Helm Charts  
echo ==========================================
call "%~dp0deploy-helm-charts.bat"
goto end

:dev_deploy
echo.
echo 🚀 DEVELOPMENT DEPLOYMENT - With Monitoring
echo ==========================================
call "%~dp0deploy-development.bat"
goto end

:complete_deploy
echo.
echo 🚀 COMPLETE DEPLOYMENT - Everything
echo ==========================================
echo.
echo This will deploy:
echo - All Kubernetes manifests
echo - Helm charts for production services
echo - Monitoring and metrics
echo - Ingress controller (if available)
echo.
set /p confirm="Continue? (y/n): "
if /i not "%confirm%"=="y" goto end

call "%~dp0deploy-k8s-manifests.bat"
call "%~dp0deploy-helm-charts.bat"
call "%~dp0deploy-monitoring.bat"
call "%~dp0deploy-ingress.bat"

:end
echo.
echo ==========================================
echo 🎉 DEPLOYMENT COMPLETE!
echo ==========================================
echo.
echo Next steps:
echo 1. Check deployment status: kubectl get all
echo 2. Access services: call scripts\get-service-urls.bat
echo 3. View logs: call scripts\view-logs.bat
echo 4. Monitor services: call scripts\monitor-services.bat
echo.
pause
