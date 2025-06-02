@echo off
echo ==========================================
echo ⏪ DEPLOYMENT ROLLBACK
echo ==========================================
echo.

echo Select rollback method:
echo [1] Rollback specific deployment
echo [2] Rollback all deployments
echo [3] Rollback Helm release
echo [4] View rollback history
echo.
set /p method="Enter your choice (1-4): "

if "%method%"=="1" goto specific_rollback
if "%method%"=="2" goto all_rollback
if "%method%"=="3" goto helm_rollback
if "%method%"=="4" goto view_history

echo Invalid choice.
exit /b 1

:specific_rollback
echo.
echo 📦 Select deployment to rollback:
echo [1] User Service
echo [2] Help Service
echo [3] Frontend
echo.
set /p deploy_choice="Enter your choice (1-3): "

echo.
if "%deploy_choice%"=="1" (
    set DEPLOYMENT=user-service-deployment
    set SERVICE_NAME=User Service
) else if "%deploy_choice%"=="2" (
    set DEPLOYMENT=help-service-deployment
    set SERVICE_NAME=Help Service
) else if "%deploy_choice%"=="3" (
    set DEPLOYMENT=frontend-deployment
    set SERVICE_NAME=Frontend
) else (
    echo Invalid choice.
    exit /b 1
)

echo 📋 Rollout History for %SERVICE_NAME%:
echo ==========================================
kubectl rollout history deployment/%DEPLOYMENT%

echo.
echo Select rollback option:
echo [1] Rollback to previous version
echo [2] Rollback to specific revision
echo.
set /p rollback_choice="Enter your choice (1-2): "

if "%rollback_choice%"=="1" (
    echo.
    echo Rolling back %SERVICE_NAME% to previous version...
    kubectl rollout undo deployment/%DEPLOYMENT%
    if %errorlevel% equ 0 (
        echo ✅ %SERVICE_NAME% rollback initiated
        kubectl rollout status deployment/%DEPLOYMENT%
    ) else (
        echo ❌ Failed to rollback %SERVICE_NAME%
    )
) else if "%rollback_choice%"=="2" (
    echo.
    set /p revision="Enter revision number: "
    echo Rolling back %SERVICE_NAME% to revision %revision%...
    kubectl rollout undo deployment/%DEPLOYMENT% --to-revision=%revision%
    if %errorlevel% equ 0 (
        echo ✅ %SERVICE_NAME% rollback to revision %revision% initiated
        kubectl rollout status deployment/%DEPLOYMENT%
    ) else (
        echo ❌ Failed to rollback %SERVICE_NAME%
    )
) else (
    echo Invalid choice.
)
goto end

:all_rollback
echo.
echo ⚠️ WARNING: This will rollback ALL deployments to their previous versions
echo.
set /p confirm="Continue? (y/n): "
if /i not "%confirm%"=="y" goto end

echo.
echo Rolling back all deployments...
echo ==========================================

echo Rolling back User Service...
kubectl rollout undo deployment/user-service-deployment
if %errorlevel% equ 0 echo ✅ User Service rollback initiated

echo Rolling back Help Service...
kubectl rollout undo deployment/help-service-deployment
if %errorlevel% equ 0 echo ✅ Help Service rollback initiated

echo Rolling back Frontend...
kubectl rollout undo deployment/frontend-deployment
if %errorlevel% equ 0 echo ✅ Frontend rollback initiated

echo.
echo ⏳ Waiting for rollbacks to complete...
kubectl rollout status deployment/user-service-deployment
kubectl rollout status deployment/help-service-deployment
kubectl rollout status deployment/frontend-deployment
goto end

:helm_rollback
echo.
echo 📋 Helm Releases:
echo ==========================================
helm list
echo.

set /p release="Enter release name to rollback: "
if "%release%"=="" (
    echo No release specified.
    goto end
)

echo.
echo 📋 Release History for %release%:
echo ==========================================
helm history %release%

echo.
echo Select rollback option:
echo [1] Rollback to previous version
echo [2] Rollback to specific revision
echo.
set /p helm_choice="Enter your choice (1-2): "

if "%helm_choice%"=="1" (
    echo.
    echo Rolling back %release% to previous version...
    helm rollback %release%
    if %errorlevel% equ 0 (
        echo ✅ %release% rollback completed
    ) else (
        echo ❌ Failed to rollback %release%
    )
) else if "%helm_choice%"=="2" (
    echo.
    set /p helm_revision="Enter revision number: "
    echo Rolling back %release% to revision %helm_revision%...
    helm rollback %release% %helm_revision%
    if %errorlevel% equ 0 (
        echo ✅ %release% rollback to revision %helm_revision% completed
    ) else (
        echo ❌ Failed to rollback %release%
    )
) else (
    echo Invalid choice.
)
goto end

:view_history
echo.
echo 📋 DEPLOYMENT HISTORIES:
echo ==========================================

echo User Service History:
echo ----------------------
kubectl rollout history deployment/user-service-deployment

echo.
echo Help Service History:
echo ---------------------
kubectl rollout history deployment/help-service-deployment

echo.
echo Frontend History:
echo -----------------
kubectl rollout history deployment/frontend-deployment

echo.
echo 📋 HELM RELEASE HISTORIES:
echo ==========================================
helm list >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=1" %%i in ('helm list --short') do (
        echo.
        echo %%i History:
        echo ------------------
        helm history %%i
    )
) else (
    echo No Helm releases found
)
goto end

:end
echo.
echo 📊 Current Status:
echo ==========================================
kubectl get deployments
echo.
kubectl get pods

echo.
echo ✅ Rollback operation completed!
echo.
echo Check health: scripts\health-checks.bat
echo Check status: scripts\check-status.bat
