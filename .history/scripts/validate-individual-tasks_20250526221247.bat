@echo off
echo ========================================
echo    INDIVIDUAL TASKS VALIDATION
echo ========================================
echo.

set "TASK_COUNT=0"
set "COMPLETED_COUNT=0"

echo [TASK 1] Build and Push Docker Image
echo ----------------------------------------
set /a TASK_COUNT+=1
echo Checking DockerHub images...
docker images | findstr "ismaill370" >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ PASS: Docker images found locally
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: No Docker images found with ismaill370 repository
)
echo.

echo [TASK 2] Create Kubernetes Deployment
echo ----------------------------------------
set /a TASK_COUNT+=1
kubectl get deployments >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ PASS: Kubernetes deployments found
    kubectl get deployments
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: No Kubernetes deployments found
)
echo.

echo [TASK 3] Create Kubernetes Service
echo ----------------------------------------
set /a TASK_COUNT+=1
kubectl get services | findstr -v "kubernetes" >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ PASS: Kubernetes services found
    kubectl get services
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: No custom Kubernetes services found
)
echo.

echo [TASK 4] ConfigMap or Secret
echo ----------------------------------------
set /a TASK_COUNT+=1
kubectl get configmaps >nul 2>&1
kubectl get secrets | findstr -v "default-token" >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ PASS: ConfigMaps and Secrets found
    echo ConfigMaps:
    kubectl get configmaps
    echo Secrets:
    kubectl get secrets | findstr -v "default-token"
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: No ConfigMaps or custom Secrets found
)
echo.

echo [TASK 5] Document API Endpoints
echo ----------------------------------------
set /a TASK_COUNT+=1
if exist "%~dp0..\Document API Endpoints.md" (
    echo ✅ PASS: API documentation found
    echo File: Document API Endpoints.md
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: API documentation not found
)
echo.

echo [TASK 6] Test Load Balancing
echo ----------------------------------------
set /a TASK_COUNT+=1
kubectl get pods | findstr "Running" | find /c "Running" >temp_count.txt
set /p POD_COUNT=<temp_count.txt
del temp_count.txt
if %POD_COUNT% geq 2 (
    echo ✅ PASS: Multiple pods running for load balancing
    echo Running pods: %POD_COUNT%
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: Insufficient pods for load balancing test
)
echo.

echo [TASK 7] Push to GitHub
echo ----------------------------------------
set /a TASK_COUNT+=1
if exist "%~dp0..\.git" (
    echo ✅ PASS: Git repository found
    echo Checking recent commits...
    git log --oneline -5
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: No Git repository found
)
echo.

echo [TASK 8] Liveness and Readiness Probes
echo ----------------------------------------
set /a TASK_COUNT+=1
kubectl get deployments -o yaml | findstr "livenessProbe\|readinessProbe" >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ PASS: Health probes configured
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: No health probes found in deployments
)
echo.

echo [TASK 9] Horizontal Pod Autoscaler
echo ----------------------------------------
set /a TASK_COUNT+=1
kubectl get hpa >nul 2>&1
if %errorlevel% == 0 (
    echo ✅ PASS: HPA configured
    kubectl get hpa
    set /a COMPLETED_COUNT+=1
) else (
    echo ❌ FAIL: No HPA found
)
echo.

echo ========================================
echo    INDIVIDUAL TASKS SUMMARY
echo ========================================
echo Completed: %COMPLETED_COUNT%/%TASK_COUNT%
if %COMPLETED_COUNT% == %TASK_COUNT% (
    echo ✅ ALL INDIVIDUAL TASKS COMPLETED!
) else (
    set /a REMAINING=%TASK_COUNT%-%COMPLETED_COUNT%
    echo ⚠️  %REMAINING% tasks remaining
)
echo ========================================
pause
