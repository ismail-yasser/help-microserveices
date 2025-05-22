
@echo off
echo ===============================================
echo Docker Image Build and Push Script
echo ===============================================

REM Default values - MODIFY THESE TO YOUR PREFERENCES
set DEFAULT_SERVICE=all
set DEFAULT_USERNAME=ismaill370
set DEFAULT_TAG=latest

REM Check if parameters are provided, otherwise use defaults
if "%1"=="" (
    set SERVICE=%DEFAULT_SERVICE%
    echo No service specified, using default: %DEFAULT_SERVICE%
) else (
    set SERVICE=%1
)

if "%2"=="" (
    set USERNAME=%DEFAULT_USERNAME%
    echo No username specified, using default: %DEFAULT_USERNAME%
) else (
    set USERNAME=%2
)

if "%3"=="" (
    set TAG=%DEFAULT_TAG%
    echo No tag specified, using default: %DEFAULT_TAG%
) else (
    set TAG=%3
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