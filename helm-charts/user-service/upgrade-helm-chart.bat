@echo off
REM Upgrade User Service Helm Chart
REM Usage: upgrade-helm-chart.bat [environment] [release-name] [new-image-tag]

setlocal enabledelayedexpansion

set ENVIRONMENT=%1
set RELEASE_NAME=%2
set NEW_TAG=%3

if "%ENVIRONMENT%"=="" (
    set ENVIRONMENT=development
)

if "%RELEASE_NAME%"=="" (
    set RELEASE_NAME=user-service
)

echo Upgrading User Service Helm Chart...
echo Environment: %ENVIRONMENT%
echo Release Name: %RELEASE_NAME%
if not "%NEW_TAG%"=="" (
    echo New Image Tag: %NEW_TAG%
)
echo.

REM Check if release exists
helm list -n %ENVIRONMENT% | findstr %RELEASE_NAME% >nul
if errorlevel 1 (
    echo ERROR: Release %RELEASE_NAME% not found in namespace %ENVIRONMENT%
    echo Available releases:
    helm list -n %ENVIRONMENT%
    exit /b 1
)

REM Set values file based on environment
set VALUES_FILE=""
if "%ENVIRONMENT%"=="production" (
    set VALUES_FILE=-f "./helm-charts/user-service/values-production.yaml"
)
if "%ENVIRONMENT%"=="development" (
    set VALUES_FILE=-f "./helm-charts/user-service/values-development.yaml"
)

REM Get current values
echo Current configuration:
helm get values %RELEASE_NAME% -n %ENVIRONMENT%
echo.

REM Build upgrade command
set UPGRADE_CMD=helm upgrade %RELEASE_NAME% "./helm-charts/user-service" %VALUES_FILE% --namespace %ENVIRONMENT% --wait --timeout=300s

REM Add image tag if provided
if not "%NEW_TAG%"=="" (
    set UPGRADE_CMD=!UPGRADE_CMD! --set image.tag="%NEW_TAG%"
)

REM Ask for confirmation
echo About to run:
echo !UPGRADE_CMD!
echo.
set /p CONFIRM="Continue with upgrade? (y/N): "
if /i not "%CONFIRM%"=="y" (
    echo Upgrade cancelled
    exit /b 0
)

REM Perform upgrade
echo.
echo Upgrading...
!UPGRADE_CMD!

if errorlevel 1 (
    echo ERROR: Upgrade failed
    echo.
    echo Rolling back...
    helm rollback %RELEASE_NAME% -n %ENVIRONMENT%
    exit /b 1
)

echo.
echo SUCCESS: Upgrade completed successfully!
echo.
echo Checking rollout status...
kubectl rollout status deployment/%RELEASE_NAME% -n %ENVIRONMENT%

echo.
echo Current pods:
kubectl get pods -n %ENVIRONMENT% -l app.kubernetes.io/name=user-service

echo.
echo To view upgrade history:
echo   helm history %RELEASE_NAME% -n %ENVIRONMENT%

endlocal
