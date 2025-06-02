@echo off
echo ==========================================
echo 🔄 UPDATE DOCKER IMAGES
echo ==========================================
echo.

echo This script will update Docker images for all services
echo.

echo Select update method:
echo [1] Pull latest images (if using :latest tag)
echo [2] Update to specific version
echo [3] Rebuild and push images
echo.
set /p method="Enter your choice (1-3): "

if "%method%"=="1" goto pull_latest
if "%method%"=="2" goto specific_version
if "%method%"=="3" goto rebuild_push

echo Invalid choice.
exit /b 1

:pull_latest
echo.
echo 📥 Pulling latest images...
echo ==========================================

echo Updating User Service image...
kubectl set image deployment/user-service-deployment user-service=ismailyasser/user-service:latest
if %errorlevel% equ 0 (
    echo ✅ User Service image updated
    kubectl rollout status deployment/user-service-deployment
) else (
    echo ❌ Failed to update User Service image
)

echo.
echo Updating Help Service image...
kubectl set image deployment/help-service-deployment help-service=ismailyasser/help-service:latest
if %errorlevel% equ 0 (
    echo ✅ Help Service image updated
    kubectl rollout status deployment/help-service-deployment
) else (
    echo ❌ Failed to update Help Service image
)

echo.
echo Updating Frontend image...
kubectl set image deployment/frontend-deployment frontend=ismailyasser/frontend:latest
if %errorlevel% equ 0 (
    echo ✅ Frontend image updated
    kubectl rollout status deployment/frontend-deployment
) else (
    echo ❌ Failed to update Frontend image
)
goto end

:specific_version
echo.
echo 🏷️ Updating to specific version...
echo ==========================================
set /p version="Enter version tag (e.g., v1.2.0): "

echo Updating User Service to version %version%...
kubectl set image deployment/user-service-deployment user-service=ismailyasser/user-service:%version%
if %errorlevel% equ 0 (
    echo ✅ User Service updated to %version%
    kubectl rollout status deployment/user-service-deployment
) else (
    echo ❌ Failed to update User Service
)

echo.
echo Updating Help Service to version %version%...
kubectl set image deployment/help-service-deployment help-service=ismailyasser/help-service:%version%
if %errorlevel% equ 0 (
    echo ✅ Help Service updated to %version%
    kubectl rollout status deployment/help-service-deployment
) else (
    echo ❌ Failed to update Help Service
)

echo.
echo Updating Frontend to version %version%...
kubectl set image deployment/frontend-deployment frontend=ismailyasser/frontend:%version%
if %errorlevel% equ 0 (
    echo ✅ Frontend updated to %version%
    kubectl rollout status deployment/frontend-deployment
) else (
    echo ❌ Failed to update Frontend
)
goto end

:rebuild_push
echo.
echo 🔨 Rebuilding and pushing images...
echo ==========================================
echo ⚠️ This requires Docker and access to push to registry

echo.
echo Building User Service...
if exist "%~dp0..\services\user-service\Dockerfile" (
    cd "%~dp0..\services\user-service"
    docker build -t ismailyasser/user-service:latest .
    docker push ismailyasser/user-service:latest
    echo ✅ User Service image rebuilt and pushed
) else (
    echo ❌ User Service Dockerfile not found
)

echo.
echo Building Help Service...
if exist "%~dp0..\services\help-service\Dockerfile" (
    cd "%~dp0..\services\help-service"
    docker build -t ismailyasser/help-service:latest .
    docker push ismailyasser/help-service:latest
    echo ✅ Help Service image rebuilt and pushed
) else (
    echo ❌ Help Service Dockerfile not found
)

echo.
echo Building Frontend...
if exist "%~dp0..\frontend\Dockerfile" (
    cd "%~dp0..\frontend"
    docker build -t ismailyasser/frontend:latest .
    docker push ismailyasser/frontend:latest
    echo ✅ Frontend image rebuilt and pushed
) else (
    echo ❌ Frontend Dockerfile not found
)

echo.
echo Updating Kubernetes deployments with new images...
kubectl rollout restart deployment/user-service-deployment
kubectl rollout restart deployment/help-service-deployment
kubectl rollout restart deployment/frontend-deployment

echo ⏳ Waiting for rollout to complete...
kubectl rollout status deployment/user-service-deployment
kubectl rollout status deployment/help-service-deployment
kubectl rollout status deployment/frontend-deployment
goto end

:end
echo.
echo 📊 Current Deployment Status:
echo ==========================================
kubectl get deployments
echo.
kubectl get pods

echo.
echo ✅ Image update process completed!
echo.
echo Check health: scripts\health-checks.bat
echo Check status: scripts\check-status.bat
