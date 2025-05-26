@echo off
echo ========================================
echo TASK 10: FRONTEND DEPLOYMENT
echo ========================================
echo.

echo Checking frontend deployment file...
echo.

if exist "..\..\k8s\frontend\frontend-deployment.yaml" (
    echo   ✅ Frontend deployment file exists
    
    findstr /i "replicas.*2" "..\..\k8s\frontend\frontend-deployment.yaml" >nul
    if %errorlevel% equ 0 (
        echo   ✅ Frontend configured with 2+ replicas
    ) else (
        echo   ⚠️  Frontend might not have 2+ replicas configured
    )
) else (
    echo   ❌ Frontend deployment file missing
)

echo.
echo Checking frontend source files...
echo.

if exist "..\..\frontend\Dockerfile" (
    echo   ✅ Frontend Dockerfile exists
) else (
    echo   ❌ Frontend Dockerfile missing
)

if exist "..\..\frontend\package.json" (
    echo   ✅ Frontend package.json exists
) else (
    echo   ❌ Frontend package.json missing
)

if exist "..\..\frontend\build" (
    echo   ✅ Frontend build directory exists
) else (
    echo   ⚠️  Frontend build directory missing - may need to build
)

echo.
echo Checking running frontend deployment...
echo.

kubectl get deployment frontend-deployment >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Frontend deployment is running
    kubectl get deployment frontend-deployment
    
    echo.
    echo   Frontend pods:
    kubectl get pods -l app=frontend
    
) else (
    echo   ❌ Frontend deployment not found
)

echo.
echo Checking if frontend can reach backend services...
echo.

kubectl exec -it deployment/frontend-deployment -- nslookup user-service 2>nul | findstr "Address" >nul
if %errorlevel% equ 0 (
    echo   ✅ Frontend can resolve user-service DNS
) else (
    echo   ❌ Frontend cannot resolve user-service DNS
)

kubectl exec -it deployment/frontend-deployment -- nslookup help-service 2>nul | findstr "Address" >nul
if %errorlevel% equ 0 (
    echo   ✅ Frontend can resolve help-service DNS
) else (
    echo   ❌ Frontend cannot resolve help-service DNS
)

echo.
echo ========================================
echo TASK 10 VALIDATION COMPLETE
echo ========================================
pause
