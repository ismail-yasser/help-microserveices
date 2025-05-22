@echo off
REM Consolidated health check test script for Windows environments

echo Health Endpoint Checker for Kubernetes and Local Development
echo ==========================================================

REM Parse command line arguments
set ENVIRONMENT=auto
set USE_DIRECT=false

:parse_args
if "%~1"=="" goto :done_parsing
if /i "%~1"=="--local" (
    set ENVIRONMENT=local
    shift
    goto :parse_args
)
if /i "%~1"=="--kubernetes" (
    set ENVIRONMENT=kubernetes
    shift
    goto :parse_args
)
if /i "%~1"=="--direct" (
    set USE_DIRECT=true
    shift
    goto :parse_args
)
if /i "%~1"=="--help" (
    goto :show_help
)
if /i "%~1"=="-h" (
    goto :show_help
)

echo Unknown option: %~1
goto :show_help

:show_help
echo Usage: %0 [--local^|--kubernetes] [--direct]
echo   --local       Test health endpoints in local environment
echo   --kubernetes  Test health endpoints in Kubernetes environment
echo   --direct      Test directly using curl instead of using Node.js script
echo.
exit /b 1

:done_parsing

REM Auto-detect environment if set to auto
if "%ENVIRONMENT%"=="auto" (
    where kubectl >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        kubectl get nodes >nul 2>&1
        if %ERRORLEVEL% EQU 0 (
            echo Detected Kubernetes environment
            set ENVIRONMENT=kubernetes
        ) else (
            echo Kubernetes not accessible, defaulting to local environment
            set ENVIRONMENT=local
        )
    ) else (
        echo kubectl not found, defaulting to local environment
        set ENVIRONMENT=local
    )
)

echo Running health checks in %ENVIRONMENT% environment...

REM Choose between direct curl testing or Node.js script
if "%USE_DIRECT%"=="true" (
    echo Using direct curl testing...
    
    if "%ENVIRONMENT%"=="kubernetes" (
        echo Testing health endpoints in Kubernetes cluster...
        echo -------------------------------------------------
        
        REM Check if test pod exists
        kubectl get pod service-test-pod >nul 2>&1
        if %ERRORLEVEL% EQU 0 (
            REM Test user-service health endpoint
            echo Checking user-service health:
            kubectl exec -it service-test-pod -- curl -s http://user-service:3000/api/health
            
            echo.
            echo -------------------------------------------------
            
            REM Test help-service health endpoint
            echo Checking help-service health:
            kubectl exec -it service-test-pod -- curl -s http://help-service:3002/api/health
        ) else (
            echo Error: service-test-pod not found. Please create the pod first.
            echo Example: kubectl apply -f test-pod.yaml
            goto :end
        )
    ) else (
        echo Testing health endpoints in local environment...
        echo -------------------------------------------------
        
        where curl >nul 2>&1
        if %ERRORLEVEL% EQU 0 (
            REM Test user-service health endpoint
            echo Checking user-service health:
            curl -s http://localhost:3000/api/health
            
            echo.
            echo -------------------------------------------------
            
            REM Test help-service health endpoint
            echo Checking help-service health:
            curl -s http://localhost:3002/api/health
        ) else (
            echo Error: curl command not found. Please install curl or use the Node.js option.
            goto :end
        )
    )
    
    echo.
    echo -------------------------------------------------
    echo Health check completed!
) else (
    REM Run the JavaScript test script with the appropriate environment variable
    if "%ENVIRONMENT%"=="kubernetes" (
        set KUBERNETES_ENV=true
        node test-health-endpoints.js
    ) else (
        set KUBERNETES_ENV=false
        node test-health-endpoints.js
    )
)

:end
echo Test completed.
pause
