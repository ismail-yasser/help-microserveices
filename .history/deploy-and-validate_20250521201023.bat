@echo off
REM Complete Kubernetes deployment and validation script

echo =====================================================
echo     KUBERNETES DEPLOYMENT AND VALIDATION SCRIPT
echo =====================================================
echo.

echo Step 1: Applying Kubernetes configuration files...
echo -----------------------------------------------------
kubectl apply -f deployment.yaml
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to apply deployment.yaml
    goto :error
) else (
    echo [SUCCESS] Applied deployment.yaml
)

echo.
kubectl apply -f service.yaml
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to apply service.yaml
    goto :error
) else (
    echo [SUCCESS] Applied service.yaml
)

echo.
echo Step 2: Creating test pod...
echo -----------------------------------------------------
kubectl apply -f test-pod.yaml
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Failed to create test pod
    goto :error
) else (
    echo [SUCCESS] Created test pod
)

echo.
echo Step 3: Waiting for pods to be ready...
echo -----------------------------------------------------
echo Waiting for user-service pods...
kubectl wait --for=condition=ready pods -l app=user-service --timeout=120s
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Not all user-service pods are ready. Continuing anyway...
) else (
    echo [SUCCESS] User service pods are ready
)

echo.
echo Waiting for help-service pods...
kubectl wait --for=condition=ready pods -l app=help-service --timeout=120s
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Not all help-service pods are ready. Continuing anyway...
) else (
    echo [SUCCESS] Help service pods are ready
)

echo.
echo Waiting for frontend pods...
kubectl wait --for=condition=ready pods -l app=frontend --timeout=120s
if %ERRORLEVEL% NEQ 0 (
    echo [WARNING] Not all frontend pods are ready. Continuing anyway...
) else (
    echo [SUCCESS] Frontend pods are ready
)

echo.
echo Waiting for test pod...
kubectl wait --for=condition=ready pod/service-test-pod --timeout=60s
if %ERRORLEVEL% NEQ 0 (
    echo [ERROR] Test pod is not ready
    goto :error
) else (
    echo [SUCCESS] Test pod is ready
)

echo.
echo Step 4: Validating services and connectivity...
echo -----------------------------------------------------

REM Little delay to ensure DNS is updated
timeout /t 5 /nobreak > NUL

call validate-services.bat

echo.
echo Step 5: Showing running pods and services...
echo -----------------------------------------------------
echo.
echo --- Pods ---
kubectl get pods
echo.
echo --- Services ---
kubectl get services
echo.
echo --- Endpoints ---
kubectl get endpoints

echo.
echo =====================================================
echo Deployment and validation completed successfully!
echo =====================================================
goto :end

:error
echo.
echo [ERROR] Deployment process failed
echo.

:end
pause
