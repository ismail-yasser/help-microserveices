@echo off
echo ========================================
echo TASK 3: KUBERNETES SERVICES
echo ========================================
echo.

echo Checking service files...
echo.

if exist "..\..\k8s\user-service\user-service-service.yaml" (
    echo   ✅ User Service service file exists
) else (
    echo   ❌ User Service service file missing
)

if exist "..\..\k8s\help-service\help-service-service.yaml" (
    echo   ✅ Help Service service file exists
) else (
    echo   ❌ Help Service service file missing
)

if exist "..\..\k8s\frontend\frontend-service.yaml" (
    echo   ✅ Frontend service file exists
) else (
    echo   ❌ Frontend service file missing
)

echo.
echo Checking running services...
echo.

kubectl get services >nul 2>&1
if %errorlevel% neq 0 (
    echo   ❌ kubectl not available or cluster not running
    goto :end
)

kubectl get service user-service >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ User Service is exposed
    kubectl get service user-service | findstr "ClusterIP\|NodePort"
) else (
    echo   ❌ User Service not found
)

kubectl get service help-service >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Help Service is exposed
    kubectl get service help-service | findstr "ClusterIP\|NodePort"
) else (
    echo   ❌ Help Service not found
)

kubectl get service frontend >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Frontend service is exposed
    kubectl get service frontend | findstr "ClusterIP\|NodePort"
) else (
    echo   ❌ Frontend service not found
)

echo.
echo All services overview:
kubectl get services

:end
echo.
echo ========================================
echo TASK 3 VALIDATION COMPLETE
echo ========================================
pause
