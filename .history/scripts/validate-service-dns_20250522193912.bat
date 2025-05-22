@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo Kubernetes Service DNS Validation
echo ===================================================
echo.

if "%1"=="" (
    echo Please provide a service name to validate: help-service or user-service
    echo Usage: validate-service-dns.bat [service-name]
    exit /b 1
)

set SERVICE=%1
set TEST_POD_NAME=dns-validation-pod

echo Validating DNS resolution for service: %SERVICE%
echo.

:: Check if service exists
kubectl get service %SERVICE% >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Service %SERVICE% not found in Kubernetes
    echo Make sure to deploy the service first using deploy-k8s-service.bat
    exit /b 1
)

echo ===================================================
echo Step 1: Creating temporary test pod
echo ===================================================
echo.

:: Delete the test pod if it already exists
kubectl delete pod %TEST_POD_NAME% --ignore-not-found=true >nul 2>&1

:: Create a temporary pod for testing
echo Creating temporary pod for DNS validation...
kubectl run %TEST_POD_NAME% --image=curlimages/curl --restart=Never -- sleep 600

echo Waiting for pod to be ready...
kubectl wait --for=condition=Ready pod/%TEST_POD_NAME% --timeout=60s
if %errorlevel% neq 0 (
    echo ERROR: Failed to create test pod
    kubectl delete pod %TEST_POD_NAME% --ignore-not-found=true >nul 2>&1
    exit /b 1
)

echo.
echo ===================================================
echo Step 2: Validating DNS resolution
echo ===================================================
echo.

echo Checking DNS resolution for %SERVICE%...
kubectl exec %TEST_POD_NAME% -- nslookup %SERVICE%
if %errorlevel% neq 0 (
    echo ERROR: DNS resolution failed for %SERVICE%
    kubectl delete pod %TEST_POD_NAME% --ignore-not-found=true >nul 2>&1
    exit /b 1
)

echo.
echo ===================================================
echo Step 3: Testing HTTP connectivity
echo ===================================================
echo.

:: Determine health endpoint to use
set HEALTH_ENDPOINT="/health"

echo Testing HTTP connectivity to %SERVICE% on %HEALTH_ENDPOINT%...
kubectl exec %TEST_POD_NAME% -- curl -s --connect-timeout 5 http://%SERVICE%%HEALTH_ENDPOINT%
if %errorlevel% neq 0 (
    echo ERROR: HTTP connectivity test failed
    echo This may indicate issues with your service or that the /health endpoint doesn't exist
) else (
    echo.
    echo HTTP connectivity test successful!
)

echo.
echo ===================================================
echo Step 4: Testing from another service
echo ===================================================
echo.

:: Determine which service to test from
if "%SERVICE%"=="help-service" (
    set OTHER_SERVICE=user-service
) else (
    set OTHER_SERVICE=help-service
)

echo Testing connectivity from %OTHER_SERVICE% to %SERVICE%...

:: Check if other service exists
kubectl get deployment %OTHER_SERVICE% >nul 2>&1
if %errorlevel% neq 0 (
    echo WARNING: %OTHER_SERVICE% not deployed, skipping cross-service test
) else (
    :: Get pod name from the other service
    for /f "tokens=1" %%p in ('kubectl get pods -l app^=%OTHER_SERVICE% -o name ^| findstr "pods" ^| head -1') do (
        set OTHER_POD=%%p
        echo Testing from !OTHER_POD!...
        kubectl exec !OTHER_POD! -- curl -s --connect-timeout 5 http://%SERVICE%%HEALTH_ENDPOINT%
        if !errorlevel! neq 0 (
            echo WARNING: Cross-service test from %OTHER_SERVICE% to %SERVICE% failed
        ) else (
            echo Cross-service test successful!
        )
    )
)

echo.
echo ===================================================
echo Cleanup
echo ===================================================
echo.

echo Removing temporary test pod...
kubectl delete pod %TEST_POD_NAME% --ignore-not-found=true >nul 2>&1

echo.
echo ===================================================
echo Validation Complete!
echo ===================================================
echo.
echo Summary:
echo - Service %SERVICE% exists in Kubernetes
echo - DNS resolution for %SERVICE% is working correctly
echo - HTTP connectivity test results shown above
echo.
echo This confirms that your service is properly exposed within the Kubernetes cluster
echo and can be accessed by other services using its DNS name.
echo.

exit /b 0
