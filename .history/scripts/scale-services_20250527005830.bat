@echo off
echo ==========================================
echo 📏 SCALING SERVICES
echo ==========================================
echo.

echo Current deployment status:
kubectl get deployments
echo.

echo Select service to scale:
echo [1] User Service
echo [2] Help Service  
echo [3] Frontend
echo [4] All Services
echo.
set /p service_choice="Enter your choice (1-4): "

echo.
set /p replica_count="Enter number of replicas (1-10): "

REM Validate replica count
if %replica_count% lss 1 (
    echo Invalid replica count. Must be between 1-10.
    exit /b 1
)
if %replica_count% gtr 10 (
    echo Invalid replica count. Must be between 1-10.
    exit /b 1
)

echo.
echo Scaling to %replica_count% replicas...
echo.

if "%service_choice%"=="1" goto scale_user
if "%service_choice%"=="2" goto scale_help
if "%service_choice%"=="3" goto scale_frontend
if "%service_choice%"=="4" goto scale_all

echo Invalid choice.
exit /b 1

:scale_user
echo 📦 Scaling User Service to %replica_count% replicas...
kubectl scale deployment user-service-deployment --replicas=%replica_count%
if %errorlevel% equ 0 (
    echo ✅ User Service scaled successfully
    kubectl rollout status deployment/user-service-deployment
) else (
    echo ❌ Failed to scale User Service
)
goto end

:scale_help
echo 📦 Scaling Help Service to %replica_count% replicas...
kubectl scale deployment help-service-deployment --replicas=%replica_count%
if %errorlevel% equ 0 (
    echo ✅ Help Service scaled successfully
    kubectl rollout status deployment/help-service-deployment
) else (
    echo ❌ Failed to scale Help Service
)
goto end

:scale_frontend
echo 📦 Scaling Frontend to %replica_count% replicas...
kubectl scale deployment frontend-deployment --replicas=%replica_count%
if %errorlevel% equ 0 (
    echo ✅ Frontend scaled successfully
    kubectl rollout status deployment/frontend-deployment
) else (
    echo ❌ Failed to scale Frontend
)
goto end

:scale_all
echo 📦 Scaling all services to %replica_count% replicas...
kubectl scale deployment user-service-deployment --replicas=%replica_count%
kubectl scale deployment help-service-deployment --replicas=%replica_count%
kubectl scale deployment frontend-deployment --replicas=%replica_count%

echo ⏳ Waiting for all deployments to scale...
kubectl rollout status deployment/user-service-deployment
kubectl rollout status deployment/help-service-deployment  
kubectl rollout status deployment/frontend-deployment
echo ✅ All services scaled successfully
goto end

:end
echo.
echo 📊 Current Status:
kubectl get deployments
echo.
kubectl get pods

echo.
echo ✅ Scaling operation completed!
echo.
echo Check status with: scripts\check-status.bat
