@echo off
echo ==========================================
echo ⏹️ STOPPING SERVICES
echo ==========================================
echo.

echo ⚠️ WARNING: This will scale all services to 0 replicas
echo This will stop all running pods but keep the deployments
echo.
set /p confirm="Continue? (y/n): "
if /i not "%confirm%"=="y" (
    echo Operation cancelled.
    exit /b 0
)

echo.
echo Stopping all deployments...
echo.

echo 📦 1. Scaling User Service to 0 replicas...
kubectl scale deployment user-service-deployment --replicas=0 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ User Service stopped
) else (
    echo ❌ Failed to stop User Service
)

echo 📦 2. Scaling Help Service to 0 replicas...
kubectl scale deployment help-service-deployment --replicas=0 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Help Service stopped
) else (
    echo ❌ Failed to stop Help Service
)

echo 📦 3. Scaling Frontend to 0 replicas...
kubectl scale deployment frontend-deployment --replicas=0 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Frontend stopped
) else (
    echo ❌ Failed to stop Frontend
)

echo.
echo ⏳ Waiting for pods to terminate...
timeout /t 10 /nobreak >nul

echo.
echo 📊 Current Status:
kubectl get deployments
echo.
kubectl get pods

echo.
echo ✅ Services stopped successfully!
echo.
echo To restart services: scripts\start-services.bat
echo To completely remove: scripts\cleanup-project.bat
