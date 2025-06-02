@echo off
echo ==========================================
echo 📊 RESOURCE MONITORING
echo ==========================================
echo.

REM Check if metrics server is available
kubectl top nodes >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠️ Metrics server not available or not ready
    echo Installing metrics server...
    echo.
    
    REM Try to apply metrics server
    if exist "%~dp0..\metrics-server.yaml" (
        kubectl apply -f "%~dp0..\metrics-server.yaml" >nul 2>&1
        echo ✅ Metrics server applied
        echo ⏳ Waiting for metrics server to be ready (30 seconds)...
        timeout /t 30 /nobreak >nul
    ) else (
        echo ❌ metrics-server.yaml not found, skipping metrics installation
    )
)

echo.
echo 🖥️ NODE RESOURCES:
echo ==========================================
kubectl top nodes 2>nul
if %errorlevel% neq 0 (
    echo ❌ Node metrics not available
    kubectl get nodes -o wide
)

echo.
echo 🐳 POD RESOURCES:
echo ==========================================
kubectl top pods 2>nul
if %errorlevel% neq 0 (
    echo ❌ Pod metrics not available
    echo Showing pod status instead:
    kubectl get pods -o wide
)

echo.
echo 📈 HORIZONTAL POD AUTOSCALERS:
echo ==========================================
kubectl get hpa -o wide 2>nul
if %errorlevel% neq 0 (
    echo No HPA resources found
)

echo.
echo 💾 PERSISTENT VOLUMES:
echo ==========================================
kubectl get pv,pvc 2>nul
if %errorlevel% neq 0 (
    echo No persistent volumes found
)

echo.
echo 🔄 DEPLOYMENT REPLICA STATUS:
echo ==========================================
kubectl get deployments -o custom-columns="NAME:.metadata.name,READY:.status.readyReplicas,UP-TO-DATE:.status.updatedReplicas,AVAILABLE:.status.availableReplicas,AGE:.metadata.creationTimestamp"

echo.
echo 📊 SERVICE ENDPOINTS:
echo ==========================================
kubectl get endpoints

echo.
echo 🎯 RESOURCE SUMMARY:
echo ==========================================

REM Count resources
set /a deployment_count=0
set /a service_count=0
set /a pod_count=0

for /f %%i in ('kubectl get deployments --no-headers 2^>nul ^| find /c /v ""') do set deployment_count=%%i
for /f %%i in ('kubectl get services --no-headers 2^>nul ^| find /c /v ""') do set service_count=%%i
for /f %%i in ('kubectl get pods --no-headers 2^>nul ^| find /c /v ""') do set pod_count=%%i

echo Deployments: %deployment_count%
echo Services: %service_count%
echo Pods: %pod_count%

echo.
echo 🔄 For continuous monitoring, run this script periodically
echo 📋 For logs: scripts\view-logs.bat
echo 📊 For status: scripts\check-status.bat

echo.
echo Press any key to exit or Ctrl+C to stop...
pause >nul
