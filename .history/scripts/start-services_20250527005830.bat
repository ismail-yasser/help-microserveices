@echo off
echo ==========================================
echo ▶️ STARTING SERVICES
echo ==========================================
echo.

echo Starting all deployments...
echo.

echo 📦 1. Scaling User Service to 2 replicas...
kubectl scale deployment user-service-deployment --replicas=2 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ User Service started
) else (
    echo ❌ Failed to start User Service
)

echo 📦 2. Scaling Help Service to 2 replicas...
kubectl scale deployment help-service-deployment --replicas=2 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Help Service started
) else (
    echo ❌ Failed to start Help Service
)

echo 📦 3. Scaling Frontend to 2 replicas...
kubectl scale deployment frontend-deployment --replicas=2 >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Frontend started
) else (
    echo ❌ Failed to start Frontend
)

echo.
echo ⏳ Waiting for pods to start...
timeout /t 15 /nobreak >nul

echo.
echo 📊 Current Status:
kubectl get deployments
echo.
kubectl get pods

echo.
echo ✅ Services startup completed!
echo.
echo Check status with: scripts\check-status.bat
