@echo off
REM Health check test script for Windows environment

echo Testing health endpoints...

REM Check if kubectl is available
where kubectl >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    REM Try to get Kubernetes nodes
    kubectl get nodes >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo Detected Kubernetes environment
        set KUBERNETES_ENV=true
    ) else (
        echo Kubernetes not accessible, defaulting to local environment
        set KUBERNETES_ENV=false
    )
) else (
    echo kubectl not found, defaulting to local environment
    set KUBERNETES_ENV=false
)

REM Run the Node.js test script
node test-health-endpoints.js

echo Test completed.
pause
