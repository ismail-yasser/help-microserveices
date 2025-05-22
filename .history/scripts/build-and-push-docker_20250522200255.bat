
@echo off
echo ===============================================
echo Docker Image Build and Push Script
echo ===============================================

REM Check if parameters are provided
if "%1"=="" (
    echo Usage: build-and-push-docker.bat [service-name] [dockerhub-username] [tag]
    echo.
    echo Available services:
    echo   frontend
    echo   help-service
    echo   user-service
    echo   all - to build and push all services
    echo.
    echo Example: build-and-push-docker.bat help-service ismaill370 latest
    exit /b 1
)

set SERVICE=%1
set USERNAME=%2
set TAG=%3

if "%USERNAME%"=="" (
    echo DockerHub username is required
    exit /b 1
)

if "%TAG%"=="" (
    set TAG=latest
    echo Tag not specified. Using 'latest'
)

echo.
echo Service: %SERVICE%
echo DockerHub Username: %USERNAME%
echo Tag: %TAG%
echo.

cd /d %~dp0..

if "%SERVICE%"=="all" (
    call :build_service frontend
    call :build_service help-service
    call :build_service user-service
) else (
    call :build_service %SERVICE%
)

echo.
echo All operations completed successfully!
exit /b 0

:build_service
set SERVICE_NAME=%1
set SERVICE_PATH=.
set DOCKERFILE_PATH=.

if "%SERVICE_NAME%"=="frontend" (
    set SERVICE_PATH=frontend
    set DOCKERFILE_PATH=frontend/Dockerfile
) else (
    set SERVICE_PATH=services\%SERVICE_NAME%
    set DOCKERFILE_PATH=services\%SERVICE_NAME%\Dockerfile
)

echo.
echo ========================================
echo Building %SERVICE_NAME% image...
echo ========================================

if not exist "%DOCKERFILE_PATH%" (
    echo Error: Dockerfile not found at %DOCKERFILE_PATH%
    exit /b 1
)

echo Building docker image %USERNAME%/%SERVICE_NAME%:%TAG%
cd /d %~dp0..\%SERVICE_PATH%
docker build -t %USERNAME%/%SERVICE_NAME%:%TAG% .
if %ERRORLEVEL% neq 0 (
    echo Error building %SERVICE_NAME% image
    exit /b %ERRORLEVEL%
)

echo.
echo ========================================
echo Pushing %SERVICE_NAME% image to DockerHub...
echo ========================================

docker push %USERNAME%/%SERVICE_NAME%:%TAG%
if %ERRORLEVEL% neq 0 (
    echo Error pushing %SERVICE_NAME% image
    exit /b %ERRORLEVEL%
)

echo.
echo %SERVICE_NAME% image successfully built and pushed to DockerHub as %USERNAME%/%SERVICE_NAME%:%TAG%
cd /d %~dp0..

exit /b 0