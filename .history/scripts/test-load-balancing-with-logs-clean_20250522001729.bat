@echo off
echo Testing pod load balancing with cleaner port forwarding...

:: Navigate to the project root
cd ..

:: Kill existing kubectl port-forward processes
echo Cleaning up existing port forwards...
FOR /F "tokens=5" %%P IN ('netstat -ano ^| findstr "3000 3001 3002 30080"') DO (
    echo Killing process: %%P
    taskkill /F /PID %%P 2>NUL
)
timeout /t 2 >nul

:: Set up port forwarding for services in separate terminals
echo Setting up fresh port forwarding...
start cmd /c "kubectl port-forward svc/help-service 3002:3002"
start cmd /c "kubectl port-forward svc/user-service 3000:3000"
start cmd /c "kubectl port-forward svc/frontend 3001:3001"

:: Allow time for port forwarding to establish
timeout /t 3 > nul

:: Get pod names dynamically instead of hardcoding them
echo Identifying current pod names...
for /f "tokens=*" %%a in ('kubectl get pods -l app^=help-service -o name ^| findstr "help-service"') do (
    set "HELP_POD_1=%%a"
    set "HELP_POD_1=!HELP_POD_1:pod/=!"
    goto :foundhelp1
)
:foundhelp1

for /f "tokens=*" %%a in ('kubectl get pods -l app^=user-service -o name ^| findstr "user-service"') do (
    set "USER_POD_1=%%a"
    set "USER_POD_1=!USER_POD_1:pod/=!"
    goto :founduser1
)
:founduser1

:: Create a new script to look at logs during testing
echo @echo off > watch-pod-logs.bat
echo setlocal enabledelayedexpansion >> watch-pod-logs.bat
echo echo Watching help-service and user-service pod logs during load test... >> watch-pod-logs.bat
echo start cmd /c "kubectl logs -f deployment/help-service-deployment --all-containers" >> watch-pod-logs.bat
echo start cmd /c "kubectl logs -f deployment/user-service-deployment --all-containers" >> watch-pod-logs.bat

:: Start watching the pod logs
call watch-pod-logs.bat

:: Give time for log windows to open
timeout /t 2 > nul

echo.
echo Sending 20 requests to help-service to test load balancing...
echo =======================================================

for /L %%i in (1,1,20) do (
    echo Request %%i to help-service:
    curl -s http://localhost:3002/
    echo.
    timeout /t 1 > nul
)

echo.
echo Sending 20 requests to user-service to test load balancing...
echo =======================================================

for /L %%i in (1,1,20) do (
    echo Request %%i to user-service:
    curl -s http://localhost:3000/
    echo.
    timeout /t 1 > nul
)

echo.
echo Testing Frontend Service Load Balancing (10 requests)
echo =======================================================
echo Note: Frontend service returns HTML content that may not display well in console

:: Open the frontend in the default browser
echo Opening frontend in browser...
start http://localhost:3001

:: Test responses with headers to verify connectivity
for /L %%i in (1,1,10) do (
    echo Request %%i to frontend:
    curl -s -I http://localhost:3001 | findstr "HTTP"
    echo.
    timeout /t 1 > nul
)

echo.
echo Load balancing test complete!
echo Check the log windows to see how the requests were distributed between pods.
echo Close all terminal windows manually when done.

pause
