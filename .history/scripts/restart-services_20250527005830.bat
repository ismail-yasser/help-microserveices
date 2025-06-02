@echo off
echo ==========================================
echo 🔄 RESTARTING SERVICES
echo ==========================================
echo.

echo This will perform a rolling restart of all services
echo.

echo 📦 1. Restarting User Service...
kubectl rollout restart deployment/user-service-deployment >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ User Service restart initiated
    kubectl rollout status deployment/user-service-deployment --timeout=60s
) else (
    echo ❌ Failed to restart User Service
)

echo.
echo 📦 2. Restarting Help Service...
kubectl rollout restart deployment/help-service-deployment >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Help Service restart initiated
    kubectl rollout status deployment/help-service-deployment --timeout=60s
) else (
    echo ❌ Failed to restart Help Service
)

echo.
echo 📦 3. Restarting Frontend...
kubectl rollout restart deployment/frontend-deployment >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Frontend restart initiated
    kubectl rollout status deployment/frontend-deployment --timeout=60s
) else (
    echo ❌ Failed to restart Frontend
)

echo.
echo 📊 Current Status:
kubectl get deployments
echo.
kubectl get pods

echo.
echo ✅ Services restart completed!
echo.
echo Check status with: scripts\check-status.bat
