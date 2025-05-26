@echo off
echo ========================================
echo TASK 2: KUBERNETES DEPLOYMENTS
echo ========================================
echo.

echo Checking deployment files...
echo.

if exist "..\..\k8s\user-service\user-service-deployment.yaml" (
    echo   ✅ User Service deployment file exists
) else (
    echo   ❌ User Service deployment file missing
)

if exist "..\..\k8s\help-service\help-service-deployment.yaml" (
    echo   ✅ Help Service deployment file exists
) else (
    echo   ❌ Help Service deployment file missing
)

if exist "..\..\k8s\frontend\frontend-deployment.yaml" (
    echo   ✅ Frontend deployment file exists
) else (
    echo   ❌ Frontend deployment file missing
)

echo.
echo Checking running deployments...
echo.

kubectl get deployments >nul 2>&1
if %errorlevel% neq 0 (
    echo   ❌ kubectl not available or cluster not running
    goto :end
)

kubectl get deployment user-service-deployment >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ User Service deployment is running
    kubectl get deployment user-service-deployment | findstr "2/2"
) else (
    echo   ❌ User Service deployment not found
)

kubectl get deployment help-service-deployment >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Help Service deployment is running
    kubectl get deployment help-service-deployment | findstr "2/2"
) else (
    echo   ❌ Help Service deployment not found
)

kubectl get deployment frontend-deployment >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Frontend deployment is running
    kubectl get deployment frontend-deployment | findstr "2/2"
) else (
    echo   ❌ Frontend deployment not found
)

echo.
echo Checking pod replicas...
echo.
kubectl get pods | findstr -i "user-service help-service frontend"

:end
echo.
echo ========================================
echo TASK 2 VALIDATION COMPLETE
echo ========================================
pause
