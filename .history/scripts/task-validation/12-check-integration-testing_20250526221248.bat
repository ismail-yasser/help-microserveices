@echo off
echo ========================================
echo TASK 12: SYSTEM INTEGRATION TESTING
echo ========================================
echo.

echo Testing end-to-end system integration...
echo.

kubectl get pods >nul 2>&1
if %errorlevel% neq 0 (
    echo   ❌ kubectl not available or cluster not running
    goto :end
)

echo 1. Testing frontend to user-service communication:
kubectl exec -it deployment/frontend -- curl -s http://user-service:3000/health 2>nul | findstr -i "healthy\|ok\|success" >nul
if %errorlevel% equ 0 (
    echo   ✅ Frontend → User Service: SUCCESS
) else (
    echo   ❌ Frontend → User Service: FAILED
)

echo.
echo 2. Testing frontend to help-service communication:
kubectl exec -it deployment/frontend -- curl -s http://help-service:3002/health 2>nul | findstr -i "healthy\|ok\|success" >nul
if %errorlevel% equ 0 (
    echo   ✅ Frontend → Help Service: SUCCESS
) else (
    echo   ❌ Frontend → Help Service: FAILED
)

echo.
echo 3. Testing user-service endpoints:
kubectl exec -it deployment/frontend -- curl -s http://user-service:3000/api/users 2>nul | findstr -i "\[\]\|users\|data" >nul
if %errorlevel% equ 0 (
    echo   ✅ User Service API: SUCCESS
) else (
    echo   ❌ User Service API: FAILED
)

echo.
echo 4. Testing help-service endpoints:
kubectl exec -it deployment/frontend -- curl -s http://help-service:3002/api/help 2>nul | findstr -i "\[\]\|help\|data" >nul
if %errorlevel% equ 0 (
    echo   ✅ Help Service API: SUCCESS
) else (
    echo   ❌ Help Service API: FAILED
)

echo.
echo 5. Testing all services are responding:
echo.
kubectl get pods | findstr "Running" | findstr -c "user-service help-service frontend"
set /a running_count=0
for /f %%i in ('kubectl get pods ^| findstr "Running" ^| findstr -c "user-service help-service frontend"') do set /a running_count=%%i

if %running_count% geq 3 (
    echo   ✅ All critical services are running
) else (
    echo   ❌ Not all services are running properly
)

echo.
echo 6. Testing service discovery:
kubectl exec -it deployment/frontend -- nslookup user-service >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Service discovery working for user-service
) else (
    echo   ❌ Service discovery failed for user-service
)

kubectl exec -it deployment/frontend -- nslookup help-service >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Service discovery working for help-service
) else (
    echo   ❌ Service discovery failed for help-service
)

echo.
echo 7. Testing external access (if configured):
kubectl get service frontend -o jsonpath="{.spec.type}" 2>nul | findstr "NodePort\|LoadBalancer" >nul
if %errorlevel% equ 0 (
    echo   ✅ Frontend is externally accessible
    kubectl get service frontend | findstr "frontend"
) else (
    echo   ⚠️  Frontend external access not configured
)

echo.
echo Integration test summary completed.

:end
echo.
echo ========================================
echo TASK 12 VALIDATION COMPLETE
echo ========================================
pause
