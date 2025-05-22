@echo off
echo Testing load balancing...

:: Navigate to the project root
cd ..

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
for /L %%i in (1,1,10) do (
    echo Request %%i:
    curl -s http://localhost:3001
    echo.
    timeout /t 1 >nul
)

echo.
echo Testing complete! You may need to manually close the port-forward windows.
echo To view pod distribution, run: kubectl describe endpoints help-service
echo Or: kubectl describe endpoints user-service

pause
