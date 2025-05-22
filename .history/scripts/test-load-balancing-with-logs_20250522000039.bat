@echo off
echo Testing pod load balancing...

:: Set up port forwarding for services in separate terminals
start cmd /c "kubectl port-forward svc/help-service 3002:3002"
start cmd /c "kubectl port-forward svc/user-service 3000:3000"
start cmd /c "kubectl port-forward svc/frontend 30080:3001"

:: Allow time for port forwarding to establish
timeout /t 3 > nul

:: Create a new script to look at logs during testing
echo @echo off > watch-pod-logs.bat
echo echo Watching help-service pod logs during load test... >> watch-pod-logs.bat
echo start cmd /c "kubectl logs -f help-service-deployment-95ffd7c76-9lg7l" >> watch-pod-logs.bat
echo start cmd /c "kubectl logs -f help-service-deployment-95ffd7c76-wjn54" >> watch-pod-logs.bat
echo echo Watching user-service pod logs during load test... >> watch-pod-logs.bat
echo start cmd /c "kubectl logs -f user-service-deployment-df6f6f45f-j566r" >> watch-pod-logs.bat
echo start cmd /c "kubectl logs -f user-service-deployment-df6f6f45f-vjlgp" >> watch-pod-logs.bat

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
start http://localhost:30080

:: Test responses with headers to verify connectivity
for /L %%i in (1,1,10) do (
    echo Request %%i to frontend:
    curl -s -I http://localhost:30080 | findstr "HTTP"
    echo.
    timeout /t 1 > nul
)

echo.
echo Load balancing test complete!
echo Check the log windows to see how the requests were distributed between pods.
echo Close all terminal windows manually when done.

pause
