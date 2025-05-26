@echo off
echo ========================================
echo TASK 4: CONFIGMAPS AND SECRETS
echo ========================================
echo.

echo Checking ConfigMap files...
echo.

if exist "k8s\user-service\user-service-config.yaml" (
    echo   ✅ User Service ConfigMap file exists
) else (
    echo   ❌ User Service ConfigMap file missing
)

if exist "k8s\help-service\help-service-config.yaml" (
    echo   ✅ Help Service ConfigMap file exists
) else (
    echo   ❌ Help Service ConfigMap file missing
)

echo.
echo Checking Secret files...
echo.

if exist "k8s\user-service\user-service-secret.yaml" (
    echo   ✅ User Service Secret file exists
) else (
    echo   ❌ User Service Secret file missing
)

if exist "k8s\help-service\help-service-secret.yaml" (
    echo   ✅ Help Service Secret file exists
) else (
    echo   ❌ Help Service Secret file missing
)

echo.
echo Checking deployed ConfigMaps...
echo.

kubectl get configmaps >nul 2>&1
if %errorlevel% neq 0 (
    echo   ❌ kubectl not available or cluster not running
    goto :end
)

kubectl get configmap user-service-config >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ User Service ConfigMap is deployed
) else (
    echo   ❌ User Service ConfigMap not found
)

kubectl get configmap help-service-config >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Help Service ConfigMap is deployed
) else (
    echo   ❌ Help Service ConfigMap not found
)

echo.
echo Checking deployed Secrets...
echo.

kubectl get secret user-service-secret >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ User Service Secret is deployed
) else (
    echo   ❌ User Service Secret not found
)

kubectl get secret help-service-secret >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Help Service Secret is deployed
) else (
    echo   ❌ Help Service Secret not found
)

echo.
echo All ConfigMaps and Secrets:
kubectl get configmaps,secrets | findstr -v "default-token\|kube-"

:end
echo.
echo ========================================
echo TASK 4 VALIDATION COMPLETE
echo ========================================
pause
