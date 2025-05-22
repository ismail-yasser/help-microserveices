@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo Kubernetes Pod Screenshot Utility
echo ===================================================
echo.

if "%1"=="" (
    echo Please provide a service name
    echo Usage: capture-pod-screenshot.bat [service-name]
    exit /b 1
)

set SERVICE=%1
set SCREENSHOT_DIR=..\screenshots
set TIMESTAMP=%date:~-4,4%%date:~-10,2%%date:~-7,2%_%time:~0,2%%time:~3,2%%time:~6,2%
set TIMESTAMP=%TIMESTAMP: =0%
set OUTPUT_FILE=%SCREENSHOT_DIR%\%SERVICE%_pods_%TIMESTAMP%.txt

:: Create screenshots directory if it doesn't exist
if not exist %SCREENSHOT_DIR% mkdir %SCREENSHOT_DIR%

echo Capturing screenshot of %SERVICE% pods...
echo.

:: Check if service exists
kubectl get deployment %SERVICE% >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Deployment %SERVICE% not found in Kubernetes
    echo Make sure to deploy the service first using deploy-k8s-service.bat
    exit /b 1
)

:: Capture pod info with rich output
echo Kubernetes Pod Status: %SERVICE% > %OUTPUT_FILE%
echo Timestamp: %date% %time% >> %OUTPUT_FILE%
echo. >> %OUTPUT_FILE%

echo Getting pod details... 
kubectl get pods -l app=%SERVICE% -o wide >> %OUTPUT_FILE%
echo. >> %OUTPUT_FILE%

echo Getting deployment details...
kubectl get deployment %SERVICE% -o wide >> %OUTPUT_FILE%
echo. >> %OUTPUT_FILE%

echo Getting service details...
kubectl get service %SERVICE% -o wide >> %OUTPUT_FILE%
echo. >> %OUTPUT_FILE%

:: Get HPA info if available
kubectl get hpa %SERVICE%-hpa >nul 2>&1
if %errorlevel% equ 0 (
    echo Getting HPA details...
    kubectl get hpa %SERVICE%-hpa -o wide >> %OUTPUT_FILE%
    echo. >> %OUTPUT_FILE%
)

:: Get detailed pod info
echo Detailed pod information: >> %OUTPUT_FILE%
echo. >> %OUTPUT_FILE%

for /f "tokens=1" %%p in ('kubectl get pods -l app^=%SERVICE% -o name') do (
    echo Details for %%p: >> %OUTPUT_FILE%
    kubectl describe %%p >> %OUTPUT_FILE%
    echo. >> %OUTPUT_FILE%
    echo Logs for %%p: >> %OUTPUT_FILE%
    kubectl logs --tail=20 %%p >> %OUTPUT_FILE%
    echo =============================================== >> %OUTPUT_FILE%
    echo. >> %OUTPUT_FILE%
)

echo.
echo ===================================================
echo Screenshot captured successfully!
echo ===================================================
echo.
echo Screenshot saved to:
echo - %OUTPUT_FILE%
echo.
echo Next steps:
echo 1. Review the captured information
echo 2. Include this file in your documentation
echo 3. Submit as part of your assignment
echo.

:: Open the file for viewing
type %OUTPUT_FILE%

echo.
echo The full output has been saved to %OUTPUT_FILE%
echo.

exit /b 0
