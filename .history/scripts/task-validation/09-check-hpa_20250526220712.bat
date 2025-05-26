@echo off
echo ========================================
echo TASK 9: HORIZONTAL POD AUTOSCALER (HPA)
echo ========================================
echo.

echo Checking HPA files...
echo.

if exist "k8s\user-service\user-service-hpa.yaml" (
    echo   ✅ User Service HPA file exists
) else (
    echo   ❌ User Service HPA file missing
)

if exist "k8s\help-service\help-service-hpa.yaml" (
    echo   ✅ Help Service HPA file exists
) else (
    echo   ❌ Help Service HPA file missing
)

if exist "k8s\frontend\frontend-hpa.yaml" (
    echo   ✅ Frontend HPA file exists
) else (
    echo   ❌ Frontend HPA file missing
)

echo.
echo Checking deployed HPAs...
echo.

kubectl get hpa >nul 2>&1
if %errorlevel% neq 0 (
    echo   ❌ kubectl not available or cluster not running
    goto :end
)

kubectl get hpa user-service-hpa >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ User Service HPA is deployed
    kubectl get hpa user-service-hpa
) else (
    echo   ❌ User Service HPA not found
)

echo.
kubectl get hpa help-service-hpa >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Help Service HPA is deployed
    kubectl get hpa help-service-hpa
) else (
    echo   ❌ Help Service HPA not found
)

echo.
kubectl get hpa frontend-hpa >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Frontend HPA is deployed
    kubectl get hpa frontend-hpa
) else (
    echo   ❌ Frontend HPA not found
)

echo.
echo Checking metrics server...
kubectl get pods -n kube-system | findstr "metrics-server"
if %errorlevel% equ 0 (
    echo   ✅ Metrics server is running
) else (
    echo   ⚠️  Metrics server might not be running
)

echo.
echo All HPAs overview:
kubectl get hpa

:end
echo.
echo ========================================
echo TASK 9 VALIDATION COMPLETE
echo ========================================
pause
