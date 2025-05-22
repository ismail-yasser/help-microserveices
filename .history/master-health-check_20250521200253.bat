@echo off
REM Master health check script that runs all checks in sequence

echo =========================================================
echo        MICROSERVICES HEALTH CHECK MASTER SCRIPT
echo =========================================================
echo This script will run all health checks in sequence to 
echo validate the entire system.
echo.

REM Check environment
set ENV_TYPE=unknown

REM Try to detect if this is a local Docker or Kubernetes environment
docker info >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    set ENV_DOCKER=available
) else (
    set ENV_DOCKER=unavailable
)

kubectl get nodes >nul 2>&1 
if %ERRORLEVEL% EQU 0 (
    set ENV_KUBE=available
) else (
    set ENV_KUBE=unavailable
)

if "%ENV_DOCKER%"=="available" (
    if "%ENV_KUBE%"=="available" (
        echo Detected both Docker and Kubernetes environments
        choice /C DKS /N /M "Run tests in [D]ocker, [K]ubernetes, or [S]kip auto-detection? "
        if errorlevel 3 (
            goto :choose_env
        ) else if errorlevel 2 (
            set ENV_TYPE=kubernetes
        ) else if errorlevel 1 (
            set ENV_TYPE=docker
        )
    ) else (
        echo Detected Docker environment
        set ENV_TYPE=docker
    )
) else (
    if "%ENV_KUBE%"=="available" (
        echo Detected Kubernetes environment
        set ENV_TYPE=kubernetes
    ) else (
        echo Could not detect environment
        goto :choose_env
    )
)

echo.
goto :run_checks

:choose_env
echo Please choose which environment to test:
echo.
echo 1. Local development environment (localhost)
echo 2. Docker containers
echo 3. Kubernetes cluster
echo 4. Exit
echo.
choice /C 1234 /N /M "Enter your choice: "

if errorlevel 4 goto :end
if errorlevel 3 set ENV_TYPE=kubernetes
if errorlevel 2 set ENV_TYPE=docker
if errorlevel 1 set ENV_TYPE=local

:run_checks
echo.
echo Running tests for %ENV_TYPE% environment...
echo =========================================================

if "%ENV_TYPE%"=="kubernetes" (
    echo KUBERNETES HEALTH CHECKS
    echo -----------------------
    call run-health-checks.bat --kubernetes
    
) else if "%ENV_TYPE%"=="docker" (
    echo DOCKER CONTAINER HEALTH CHECKS
    echo -----------------------------
    call check-docker-health.bat
    
) else if "%ENV_TYPE%"=="local" (
    echo LOCAL DEVELOPMENT HEALTH CHECKS
    echo -----------------------------
    call run-health-checks.bat --local
    
) else (
    echo Unknown environment type: %ENV_TYPE%
    goto :end
)

echo.
echo =========================================================
echo Health checks completed!
echo.

:end
pause
