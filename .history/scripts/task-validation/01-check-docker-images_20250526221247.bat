@echo off
echo ========================================
echo TASK 1: BUILD AND PUSH DOCKER IMAGES
echo ========================================
echo.

echo Checking Docker images on DockerHub...
echo.

echo 1. User Service Image:
docker pull ismaill370/user-service:latest >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ FOUND: ismaill370/user-service:latest
) else (
    echo   ❌ NOT FOUND: ismaill370/user-service:latest
)

echo 2. Help Service Image:
docker pull ismaill370/help-service:latest >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ FOUND: ismaill370/help-service:latest
) else (
    echo   ❌ NOT FOUND: ismaill370/help-service:latest
)

echo 3. Frontend Image:
docker pull ismaill370/frontend:latest >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ FOUND: ismaill370/frontend:latest
) else (
    echo   ❌ NOT FOUND: ismaill370/frontend:latest
)

echo.
echo Checking local Dockerfiles...
echo.

if exist "services\user-service\Dockerfile" (
    echo   ✅ User Service Dockerfile exists
) else (
    echo   ❌ User Service Dockerfile missing
)

if exist "services\help-service\Dockerfile" (
    echo   ✅ Help Service Dockerfile exists
) else (
    echo   ❌ Help Service Dockerfile missing
)

if exist "frontend\Dockerfile" (
    echo   ✅ Frontend Dockerfile exists
) else (
    echo   ❌ Frontend Dockerfile missing
)

echo.
echo ========================================
echo TASK 1 VALIDATION COMPLETE
echo ========================================
pause
