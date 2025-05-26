@echo off
REM Uninstall User Service Helm Chart
REM Usage: uninstall-helm-chart.bat [environment] [release-name]

setlocal enabledelayedexpansion

set ENVIRONMENT=%1
set RELEASE_NAME=%2

if "%ENVIRONMENT%"=="" (
    set ENVIRONMENT=development
)

if "%RELEASE_NAME%"=="" (
    set RELEASE_NAME=user-service
)

echo Uninstalling User Service Helm Chart...
echo Environment: %ENVIRONMENT%
echo Release Name: %RELEASE_NAME%
echo.

REM Check if release exists
helm list -n %ENVIRONMENT% | findstr %RELEASE_NAME% >nul
if errorlevel 1 (
    echo WARNING: Release %RELEASE_NAME% not found in namespace %ENVIRONMENT%
    echo Available releases:
    helm list -n %ENVIRONMENT%
    set /p CONTINUE="Continue anyway? (y/N): "
    if /i not "!CONTINUE!"=="y" (
        exit /b 0
    )
)

REM Show what will be deleted
echo Resources that will be deleted:
kubectl get all -n %ENVIRONMENT% -l app.kubernetes.io/name=user-service
echo.
kubectl get configmap,secret -n %ENVIRONMENT% -l app.kubernetes.io/name=user-service
echo.

REM Ask for confirmation
set /p CONFIRM="Are you sure you want to uninstall %RELEASE_NAME%? This cannot be undone. (y/N): "
if /i not "%CONFIRM%"=="y" (
    echo Uninstall cancelled
    exit /b 0
)

REM Uninstall the release
echo.
echo Uninstalling...
helm uninstall %RELEASE_NAME% -n %ENVIRONMENT%

if errorlevel 1 (
    echo ERROR: Uninstall failed
    exit /b 1
)

echo.
echo SUCCESS: %RELEASE_NAME% uninstalled successfully!
echo.

REM Check if any resources remain
echo Checking for remaining resources...
set REMAINING_RESOURCES=0

kubectl get all -n %ENVIRONMENT% -l app.kubernetes.io/name=user-service --no-headers 2>nul | findstr . >nul
if not errorlevel 1 (
    echo WARNING: Some resources still exist:
    kubectl get all -n %ENVIRONMENT% -l app.kubernetes.io/name=user-service
    set REMAINING_RESOURCES=1
)

kubectl get configmap,secret -n %ENVIRONMENT% -l app.kubernetes.io/name=user-service --no-headers 2>nul | findstr . >nul
if not errorlevel 1 (
    echo WARNING: Some ConfigMaps/Secrets still exist:
    kubectl get configmap,secret -n %ENVIRONMENT% -l app.kubernetes.io/name=user-service
    set REMAINING_RESOURCES=1
)

if %REMAINING_RESOURCES%==1 (
    echo.
    set /p CLEANUP="Clean up remaining resources? (y/N): "
    if /i "!CLEANUP!"=="y" (
        echo Cleaning up remaining resources...
        kubectl delete all -n %ENVIRONMENT% -l app.kubernetes.io/name=user-service --ignore-not-found=true
        kubectl delete configmap,secret -n %ENVIRONMENT% -l app.kubernetes.io/name=user-service --ignore-not-found=true
        echo Cleanup completed.
    )
)

echo.
echo Uninstall completed.

endlocal
