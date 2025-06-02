@echo off
echo ==========================================
echo 🧹 PROJECT CLEANUP
echo ==========================================
echo.

echo ⚠️ WARNING: This will remove ALL project resources
echo This includes:
echo - All deployments (user-service, help-service, frontend)
echo - All services
echo - All ConfigMaps and Secrets
echo - All HPA configurations
echo - All Helm releases (if any)
echo.

set /p confirm="Are you sure you want to continue? (yes/no): "
if /i not "%confirm%"=="yes" (
    echo Operation cancelled.
    exit /b 0
)

echo.
echo 🔄 Starting cleanup process...
echo.

echo 📦 1. Removing Helm releases...
helm list --short | findstr -v "^$" >nul 2>&1
if %errorlevel% equ 0 (
    echo Found Helm releases:
    helm list
    echo.
    
    REM Uninstall known releases
    helm uninstall user-service >nul 2>&1
    if %errorlevel% equ 0 echo ✅ User Service Helm release removed
    
    helm uninstall help-service >nul 2>&1
    if %errorlevel% equ 0 echo ✅ Help Service Helm release removed
    
    helm uninstall frontend >nul 2>&1
    if %errorlevel% equ 0 echo ✅ Frontend Helm release removed
) else (
    echo No Helm releases found
)

echo.
echo 📦 2. Removing Kubernetes deployments...
kubectl delete deployment user-service-deployment >nul 2>&1
if %errorlevel% equ 0 echo ✅ User Service deployment removed

kubectl delete deployment help-service-deployment >nul 2>&1
if %errorlevel% equ 0 echo ✅ Help Service deployment removed

kubectl delete deployment frontend-deployment >nul 2>&1
if %errorlevel% equ 0 echo ✅ Frontend deployment removed

echo.
echo 📦 3. Removing services...
kubectl delete service user-service >nul 2>&1
if %errorlevel% equ 0 echo ✅ User Service service removed

kubectl delete service help-service >nul 2>&1
if %errorlevel% equ 0 echo ✅ Help Service service removed

kubectl delete service frontend >nul 2>&1
if %errorlevel% equ 0 echo ✅ Frontend service removed

echo.
echo 📦 4. Removing ConfigMaps...
kubectl delete configmap --selector=app=user-service >nul 2>&1
kubectl delete configmap --selector=app=help-service >nul 2>&1
kubectl delete configmap --selector=app=frontend >nul 2>&1
echo ✅ ConfigMaps removed

echo.
echo 📦 5. Removing Secrets...
kubectl delete secret --selector=app=user-service >nul 2>&1
kubectl delete secret --selector=app=help-service >nul 2>&1
kubectl delete secret --selector=app=frontend >nul 2>&1
echo ✅ Secrets removed

echo.
echo 📦 6. Removing HPA configurations...
kubectl delete hpa user-service-hpa >nul 2>&1
kubectl delete hpa help-service-hpa >nul 2>&1
kubectl delete hpa frontend-hpa >nul 2>&1
echo ✅ HPA configurations removed

echo.
echo 📦 7. Removing Ingress configurations...
kubectl delete ingress --all >nul 2>&1
echo ✅ Ingress configurations removed

echo.
echo 📦 8. Cleaning up any remaining resources...
REM Remove any pods that might still be running
kubectl delete pods --selector=app=user-service --grace-period=0 --force >nul 2>&1
kubectl delete pods --selector=app=help-service --grace-period=0 --force >nul 2>&1
kubectl delete pods --selector=app=frontend --grace-period=0 --force >nul 2>&1

REM Remove any remaining resources by applying delete to directories
if exist "%~dp0..\k8s\user-service\" (
    kubectl delete -f "%~dp0..\k8s\user-service\" >nul 2>&1
)
if exist "%~dp0..\k8s\help-service\" (
    kubectl delete -f "%~dp0..\k8s\help-service\" >nul 2>&1
)
if exist "%~dp0..\k8s\frontend\" (
    kubectl delete -f "%~dp0..\k8s\frontend\" >nul 2>&1
)

echo ✅ Remaining resources cleaned up

echo.
echo ⏳ Waiting for resources to be fully removed...
timeout /t 10 /nobreak >nul

echo.
echo 📊 Final Status Check:
echo ==========================================
echo Remaining deployments:
kubectl get deployments 2>nul
echo.
echo Remaining services:
kubectl get services | findstr -v "kubernetes"
echo.
echo Remaining pods:
kubectl get pods 2>nul

echo.
echo ✅ PROJECT CLEANUP COMPLETED!
echo ==========================================
echo.
echo All project resources have been removed from the cluster.
echo.
echo To redeploy the project:
echo   scripts\deploy-project.bat
echo.
echo To deploy with Helm:
echo   scripts\deploy-helm-charts.bat
