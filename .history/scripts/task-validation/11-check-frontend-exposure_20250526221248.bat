@echo off
echo ========================================
echo TASK 11: FRONTEND EXPOSURE
echo ========================================
echo.

echo Checking frontend service file...
echo.

if exist "k8s\frontend\frontend-service.yaml" (
    echo   ✅ Frontend service file exists
    
    findstr /i "NodePort\|LoadBalancer" "k8s\frontend\frontend-service.yaml" >nul
    if %errorlevel% equ 0 (
        echo   ✅ Frontend service configured for external access
    ) else (
        echo   ⚠️  Frontend service might be ClusterIP only
    )
) else (
    echo   ❌ Frontend service file missing
)

echo.
echo Checking Ingress configuration...
echo.

if exist "k8s\ingress.yaml" (
    echo   ✅ Ingress file exists (k8s\ingress.yaml)
) else if exist "k8s\frontend\*ingress*.yaml" (
    echo   ✅ Frontend Ingress files exist
    dir /b "k8s\frontend\*ingress*.yaml"
) else (
    echo   ❌ No Ingress configuration found
)

echo.
echo Checking running frontend service...
echo.

kubectl get service frontend >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Frontend service is running
    kubectl get service frontend
    
    echo.
    echo   Service details:
    kubectl describe service frontend | findstr "Type:\|Port:\|NodePort:\|Endpoints:"
    
) else (
    echo   ❌ Frontend service not found
)

echo.
echo Checking Ingress resources...
echo.

kubectl get ingress >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Ingress resources found:
    kubectl get ingress
) else (
    echo   ⚠️  No Ingress resources found
)

echo.
echo Checking external access...
echo.

kubectl get service frontend -o jsonpath="{.spec.type}" 2>nul | findstr "NodePort\|LoadBalancer" >nul
if %errorlevel% equ 0 (
    echo   ✅ Frontend is exposed externally
    
    for /f "tokens=2 delims=:" %%i in ('kubectl get service frontend -o jsonpath^="{.spec.ports[0].nodePort}" 2^>nul') do (
        echo   Access URL: http://localhost:%%i
    )
) else (
    echo   ⚠️  Frontend might only be accessible internally
)

echo.
echo ========================================
echo TASK 11 VALIDATION COMPLETE
echo ========================================
pause
