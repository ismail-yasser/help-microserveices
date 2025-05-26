@echo off
echo ========================================
echo TASK 6: LOAD BALANCING TEST
echo ========================================
echo.

echo Testing load balancing across pods...
echo.

kubectl get services >nul 2>&1
if %errorlevel% neq 0 (
    echo   ❌ kubectl not available or cluster not running
    goto :end
)

echo Testing User Service load balancing:
echo.
kubectl get pods -l app=user-service | findstr "Running"
if %errorlevel% equ 0 (
    echo   ✅ User Service pods are running
    
    echo.
    echo   Testing 5 requests to user service...
    for /l %%i in (1,1,5) do (
        kubectl exec deployment/frontend-deployment -- curl -s http://user-service:3000/health >nul 2>&1
        if !errorlevel! equ 0 (
            echo     Request %%i: ✅ SUCCESS
        ) else (
            echo     Request %%i: ❌ FAILED
        )
    )
) else (
    echo   ❌ User Service pods not found or not running
)

echo.
echo Testing Help Service load balancing:
echo.
kubectl get pods -l app=help-service | findstr "Running"
if %errorlevel% equ 0 (
    echo   ✅ Help Service pods are running
    
    echo.    echo   Testing 5 requests to help service...
    for /l %%i in (1,1,5) do (
        kubectl exec deployment/frontend-deployment -- curl -s http://help-service:3002/health >nul 2>&1
        if !errorlevel! equ 0 (
            echo     Request %%i: ✅ SUCCESS
        ) else (
            echo     Request %%i: ❌ FAILED
        )
    )
) else (
    echo   ❌ Help Service pods not found or not running
)

echo.
echo Checking service endpoints:
kubectl get endpoints user-service help-service 2>nul

:end
echo.
echo ========================================
echo TASK 6 VALIDATION COMPLETE
echo ========================================
pause
