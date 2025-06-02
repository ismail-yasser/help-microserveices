@echo off
echo ==========================================
echo 📋 SERVICE LOGS VIEWER
echo ==========================================
echo.

echo Select service to view logs:
echo [1] User Service
echo [2] Help Service
echo [3] Frontend
echo [4] All Services (combined)
echo [5] Recent errors only
echo.
set /p choice="Enter your choice (1-5): "

echo.
echo Select time range:
echo [1] Last 10 minutes
echo [2] Last 1 hour
echo [3] Last 24 hours  
echo [4] All logs
echo.
set /p time_choice="Enter your choice (1-4): "

REM Set time parameters
set SINCE_TIME=""
if "%time_choice%"=="1" set SINCE_TIME="--since=10m"
if "%time_choice%"=="2" set SINCE_TIME="--since=1h"
if "%time_choice%"=="3" set SINCE_TIME="--since=24h"

echo.
echo Select log output:
echo [1] View in console
echo [2] Save to file
echo [3] Follow logs (real-time)
echo.
set /p output_choice="Enter your choice (1-3): "

echo.
echo ==========================================

if "%choice%"=="1" goto user_logs
if "%choice%"=="2" goto help_logs
if "%choice%"=="3" goto frontend_logs
if "%choice%"=="4" goto all_logs
if "%choice%"=="5" goto error_logs

echo Invalid choice.
exit /b 1

:user_logs
echo 📋 USER SERVICE LOGS:
echo ==========================================
if "%output_choice%"=="1" (
    kubectl logs -l app=user-service %SINCE_TIME%
) else if "%output_choice%"=="2" (
    set /p filename="Enter filename (e.g., user-service-logs.txt): "
    kubectl logs -l app=user-service %SINCE_TIME% > %filename%
    echo ✅ Logs saved to %filename%
) else if "%output_choice%"=="3" (
    echo Press Ctrl+C to stop following logs...
    kubectl logs -l app=user-service -f %SINCE_TIME%
)
goto end

:help_logs
echo 📋 HELP SERVICE LOGS:
echo ==========================================
if "%output_choice%"=="1" (
    kubectl logs -l app=help-service %SINCE_TIME%
) else if "%output_choice%"=="2" (
    set /p filename="Enter filename (e.g., help-service-logs.txt): "
    kubectl logs -l app=help-service %SINCE_TIME% > %filename%
    echo ✅ Logs saved to %filename%
) else if "%output_choice%"=="3" (
    echo Press Ctrl+C to stop following logs...
    kubectl logs -l app=help-service -f %SINCE_TIME%
)
goto end

:frontend_logs
echo 📋 FRONTEND LOGS:
echo ==========================================
if "%output_choice%"=="1" (
    kubectl logs -l app=frontend %SINCE_TIME%
) else if "%output_choice%"=="2" (
    set /p filename="Enter filename (e.g., frontend-logs.txt): "
    kubectl logs -l app=frontend %SINCE_TIME% > %filename%
    echo ✅ Logs saved to %filename%
) else if "%output_choice%"=="3" (
    echo Press Ctrl+C to stop following logs...
    kubectl logs -l app=frontend -f %SINCE_TIME%
)
goto end

:all_logs
echo 📋 ALL SERVICES LOGS:
echo ==========================================
if "%output_choice%"=="1" (
    echo --- USER SERVICE ---
    kubectl logs -l app=user-service %SINCE_TIME% --tail=20
    echo.
    echo --- HELP SERVICE ---
    kubectl logs -l app=help-service %SINCE_TIME% --tail=20
    echo.
    echo --- FRONTEND ---
    kubectl logs -l app=frontend %SINCE_TIME% --tail=20
) else if "%output_choice%"=="2" (
    set TIMESTAMP=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
    set TIMESTAMP=%TIMESTAMP: =0%
    kubectl logs -l app=user-service %SINCE_TIME% > all-logs-%TIMESTAMP%.txt
    kubectl logs -l app=help-service %SINCE_TIME% >> all-logs-%TIMESTAMP%.txt
    kubectl logs -l app=frontend %SINCE_TIME% >> all-logs-%TIMESTAMP%.txt
    echo ✅ All logs saved to all-logs-%TIMESTAMP%.txt
) else if "%output_choice%"=="3" (
    echo Press Ctrl+C to stop following logs...
    echo Following all services logs...
    kubectl logs -l app=user-service,app=help-service,app=frontend -f %SINCE_TIME%
)
goto end

:error_logs
echo 📋 ERROR LOGS ONLY:
echo ==========================================
echo Searching for errors in all services...
echo.
echo --- USER SERVICE ERRORS ---
kubectl logs -l app=user-service %SINCE_TIME% | findstr /i "error\|exception\|fail\|crash"
echo.
echo --- HELP SERVICE ERRORS ---
kubectl logs -l app=help-service %SINCE_TIME% | findstr /i "error\|exception\|fail\|crash"
echo.
echo --- FRONTEND ERRORS ---
kubectl logs -l app=frontend %SINCE_TIME% | findstr /i "error\|exception\|fail\|crash"
goto end

:end
echo.
echo ==========================================
echo 📋 Logs viewing completed!
echo.
echo For real-time monitoring: scripts\monitor-resources.bat
echo For service status: scripts\check-status.bat
