@echo off
echo Testing load balancing with cleaner port forwarding...

:: Navigate to the project root
cd ..

:: Kill existing kubectl port-forward processes
echo Cleaning up existing port forwards...
FOR /F "tokens=5" %%P IN ('netstat -ano ^| findstr "3000 3001 3002 30080"') DO (
    echo Killing process: %%P
    taskkill /F /PID %%P 2>NUL
)
timeout /t 2 >nul

echo Setting up port forwarding for services...
start cmd /k kubectl port-forward svc/help-service 3002:3002
start cmd /k kubectl port-forward svc/user-service 3000:3000
start cmd /k kubectl port-forward svc/frontend 3001:3001

timeout /t 5
echo Port forwarding established. Testing services...

echo.
echo Testing Help Service Load Balancing (10 requests)
echo ==============================================
for /L %%i in (1,1,10) do (
    echo Request %%i:
    curl -s http://localhost:3002
    echo.
    timeout /t 1 >nul
)

echo.
echo Testing User Service Load Balancing (10 requests)
echo ==============================================
for /L %%i in (1,1,10) do (
    echo Request %%i:
    curl -s http://localhost:3000
    echo.
    timeout /t 1 >nul
)

echo.
echo Testing Frontend Service Load Balancing (10 requests)
echo ==============================================
echo Note: Frontend service returns HTML content that may not display well in console

:: Open the frontend in the default browser
echo Opening frontend in browser...
start http://localhost:3001

:: Test responses with headers to verify connectivity
for /L %%i in (1,1,10) do (
    echo Request %%i:
    curl -s -I http://localhost:3001 | findstr "HTTP"
    echo.
    timeout /t 1 >nul
)

echo.
echo Testing complete! You may need to manually close the port-forward windows.
echo To view pod distribution, run: kubectl describe endpoints help-service
echo Or: kubectl describe endpoints user-service

pause
