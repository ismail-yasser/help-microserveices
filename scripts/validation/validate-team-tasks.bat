@echo off
echo ========================================
echo      TEAM TASKS VALIDATION
echo ========================================
echo.

set "TASK_COUNT=0"
set "COMPLETED_COUNT=0"

echo [TASK 10] Deploy Frontend
echo ----------------------------------------
set /a TASK_COUNT+=1
kubectl get deployments | findstr "frontend" >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ PASS: Frontend deployment found
    kubectl get deployments | findstr "frontend"
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: No frontend deployment found
)
echo.

echo [TASK 11] Expose Frontend
echo ----------------------------------------
set /a TASK_COUNT+=1
kubectl get services | findstr "frontend" >nul 2>&1
kubectl get ingress >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ PASS: Frontend service/ingress found
    echo Services:
    kubectl get services | findstr "frontend"
    echo Ingress:
    kubectl get ingress
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: No frontend service or ingress found
)
echo.

echo [TASK 12] System Integration Testing
echo ----------------------------------------
set /a TASK_COUNT+=1
if exist "%~dp0..\docs\*test*.md" (
    echo ✅ PASS: Integration testing documentation found
    dir "%~dp0..\docs\*test*.md" /b
    set /a COMPLETED_COUNT+=1
) else (
    echo ⚠️  PARTIAL: No specific test documentation found
    echo Checking if services are communicating...
    kubectl get pods | findstr "Running" >nul 2>&1
    if %errorlevel% == 0 (
        echo ✅ Services are running for integration
        set /a COMPLETED_COUNT+=1
    )
)
echo.

echo [TASK 13] Create Architecture Diagram
echo ----------------------------------------
set /a TASK_COUNT+=1
if exist "%~dp0..\docs\architecture-diagram.md" (
    echo ✅ PASS: Architecture diagram documentation found
    echo File: docs\architecture-diagram.md
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: Architecture diagram not found
)
echo.

echo [TASK 14] Organize k8s Manifests
echo ----------------------------------------
set /a TASK_COUNT+=1
if exist "%~dp0..\k8s\" (
    echo ✅ PASS: k8s folder structure found
    echo Checking organization...
    dir "%~dp0..\k8s" /b
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: k8s folder not found
)
echo.

echo [TASK 15] Configure Ingress Controller
echo ----------------------------------------
set /a TASK_COUNT+=1
kubectl get ingress >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ PASS: Ingress resources found
    kubectl get ingress
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: No ingress resources found
)
echo.

echo [TASK 16] GitHub Actions CI/CD
echo ----------------------------------------
set /a TASK_COUNT+=1
if exist "%~dp0..\.github\workflows\" (
    echo ✅ PASS: GitHub Actions workflows found
    dir "%~dp0..\.github\workflows" /b
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: No GitHub Actions workflows found
)
echo.

echo [TASK 17] Create Helm Chart
echo ----------------------------------------
set /a TASK_COUNT+=1
if exist "%~dp0..\helm-charts\" (
    echo ✅ PASS: Helm charts directory found
    echo Checking for Chart.yaml files...
    dir "%~dp0..\helm-charts\*\Chart.yaml" /b /s
    if %errorlevel% == 0 (
        echo ✅ Helm charts properly structured
    )
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: No Helm charts found
)
echo.

echo ========================================
echo       TEAM TASKS SUMMARY
echo ========================================
echo Completed: %COMPLETED_COUNT%/%TASK_COUNT%
if %COMPLETED_COUNT% == %TASK_COUNT% (
    echo ✅ ALL TEAM TASKS COMPLETED!
) else (
    set /a REMAINING=%TASK_COUNT%-%COMPLETED_COUNT%
    echo ⚠️  %REMAINING% tasks remaining
)
echo ========================================
pause
