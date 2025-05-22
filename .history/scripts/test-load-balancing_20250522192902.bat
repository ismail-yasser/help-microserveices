@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo Kubernetes Load Balancing Test
echo ===================================================
echo.

if "%1"=="" (
    echo Please provide a service name: help-service or user-service
    echo Usage: test-load-balancing.bat [service-name] [endpoint] [iterations]
    echo Example: test-load-balancing.bat help-service /api/help/requests 10
    exit /b 1
)

set SERVICE=%1
set ENDPOINT=%2
set ITERATIONS=10

if not "%3"=="" (
    set ITERATIONS=%3
)

if "%ENDPOINT%"=="" (
    if "%SERVICE%"=="help-service" (
        set ENDPOINT=/api/help
    ) else if "%SERVICE%"=="user-service" (
        set ENDPOINT=/api/users/profile
    ) else (
        echo Please provide an endpoint path to test
        exit /b 1
    )
)

echo Testing load balancing for %SERVICE% (%ENDPOINT%) with %ITERATIONS% requests...
echo.

:: Check if the service is deployed
kubectl get service %SERVICE% >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Service %SERVICE% not found in Kubernetes
    echo Make sure to deploy the service first using deploy-k8s-service.bat
    exit /b 1
)

:: Check if the deployment has multiple replicas
for /f %%i in ('kubectl get deployment %SERVICE% -o jsonpath^="{.spec.replicas}"') do (
    set REPLICAS=%%i
)

if %REPLICAS% LSS 2 (
    echo WARNING: Service %SERVICE% has only %REPLICAS% replica^(s^)
    echo For proper load balancing testing, scale the deployment to at least 2 replicas:
    echo kubectl scale deployment/%SERVICE% --replicas=2
    
    set /p CONTINUE=Do you want to proceed anyway? (y/n): 
    if /i "!CONTINUE!"=="n" (
        exit /b 0
    )
)

echo Setting up port-forwarding to service %SERVICE%...
start /b cmd /c kubectl port-forward service/%SERVICE% 3000:80 >nul 2>&1
timeout /t 2 > nul

echo.
echo Starting load balancing test - making %ITERATIONS% requests...
echo This will show which pod serves each request
echo.

echo "Pod Name","Hostname","Request ID"

for /l %%i in (1, 1, %ITERATIONS%) do (
    for /f "tokens=*" %%a in ('curl -s http://localhost:3000%ENDPOINT% -H "Accept: application/json" ^| findstr "podName\|hostname"') do (
        set OUTPUT=%%a
        echo !OUTPUT! | findstr "podName" >nul
        if !errorlevel!==0 (
            set POD_INFO=!OUTPUT!
        )
        echo !OUTPUT! | findstr "hostname" >nul
        if !errorlevel!==0 (
            set HOSTNAME_INFO=!OUTPUT!
            echo %%i,!POD_INFO!,!HOSTNAME_INFO!
        )
    )
    timeout /t 1 > nul
)

echo.
echo ===================================================
echo Test Complete!
echo ===================================================
echo.

echo Stopping port-forwarding...
taskkill /f /im kubectl.exe >nul 2>&1

echo.
echo If you're seeing different pod names/hostnames in the output,
echo the load balancing is working correctly! Each request is being
echo distributed across the available pods.
echo.

exit /b 0
