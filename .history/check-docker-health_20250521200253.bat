@echo off
REM Quick check for health endpoints in locally running Docker containers

echo Quick Health Check for Docker Containers
echo =======================================

REM Define container names and health endpoints
set USER_SERVICE_CONTAINER=user-service
set HELP_SERVICE_CONTAINER=help-service
set USER_HEALTH_ENDPOINT=http://localhost:3000/api/health
set HELP_HEALTH_ENDPOINT=http://localhost:3002/api/health

REM Check if Docker is running
docker info >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Docker is not running! Please start Docker Desktop first.
    goto :end
)

echo Checking for running microservice containers...
echo.

REM Check user-service
echo Checking user-service container:
docker ps --filter "name=%USER_SERVICE_CONTAINER%" --format "{{.Names}}" | findstr "%USER_SERVICE_CONTAINER%" >nul
if %ERRORLEVEL% EQU 0 (
    echo [✓] User service container is running
) else (
    echo [✗] User service container is NOT running
    echo     Try: docker-compose up -d user-service
)

REM Check help-service
echo Checking help-service container:
docker ps --filter "name=%HELP_SERVICE_CONTAINER%" --format "{{.Names}}" | findstr "%HELP_SERVICE_CONTAINER%" >nul
if %ERRORLEVEL% EQU 0 (
    echo [✓] Help service container is running
) else (
    echo [✗] Help service container is NOT running
    echo     Try: docker-compose up -d help-service
)

echo.
echo Testing health endpoints...
echo.

REM Test user-service health endpoint with curl
echo User Service Health:
where curl >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    curl -s %USER_HEALTH_ENDPOINT%
    echo.
) else (
    echo Curl not found. Cannot test user-service health endpoint.
)

echo.
echo Help Service Health:
where curl >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    curl -s %HELP_HEALTH_ENDPOINT%
    echo.
) else (
    echo Curl not found. Cannot test help-service health endpoint.
)

echo.
echo Testing complete!

:end
pause
