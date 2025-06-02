@echo off
echo ==========================================
echo 🏥 HEALTH CHECKS
echo ==========================================
echo.

echo Running comprehensive health checks...
echo.

echo 🔍 1. CLUSTER CONNECTIVITY:
echo ==========================================
kubectl cluster-info >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Kubernetes cluster is accessible
    kubectl config current-context
) else (
    echo ❌ Cannot connect to Kubernetes cluster
    exit /b 1
)

echo.
echo 🏗️ 2. DEPLOYMENT HEALTH:
echo ==========================================
set /a healthy_deployments=0
set /a total_deployments=0

for /f "tokens=1,2,3" %%a in ('kubectl get deployments --no-headers 2^>nul') do (
    set /a total_deployments+=1
    echo Checking deployment: %%a
    echo   Ready: %%b
    if "%%b"=="2/2" (
        echo   ✅ Healthy
        set /a healthy_deployments+=1
    ) else (
        echo   ❌ Not ready
    )
)

echo.
echo Deployment Summary: %healthy_deployments%/%total_deployments% healthy

echo.
echo 🔗 3. SERVICE HEALTH:
echo ==========================================
kubectl get services --no-headers | findstr -v "kubernetes"
echo.

echo 🧪 4. ENDPOINT HEALTH CHECKS:
echo ==========================================

echo Testing User Service health endpoint...
kubectl run health-test-user --image=curlimages/curl --rm -i --restart=Never -- curl -s -w "%%{http_code}" http://user-service:3000/health -o /dev/null 2>nul
if %errorlevel% equ 0 (
    echo ✅ User Service health endpoint responding
) else (
    echo ❌ User Service health endpoint not accessible
)

echo.
echo Testing Help Service health endpoint...
kubectl run health-test-help --image=curlimages/curl --rm -i --restart=Never -- curl -s -w "%%{http_code}" http://help-service:3002/health -o /dev/null 2>nul
if %errorlevel% equ 0 (
    echo ✅ Help Service health endpoint responding
) else (
    echo ❌ Help Service health endpoint not accessible
)

echo.
echo 🐳 5. POD HEALTH STATUS:
echo ==========================================
kubectl get pods -o custom-columns="NAME:.metadata.name,STATUS:.status.phase,READY:.status.containerStatuses[*].ready,RESTARTS:.status.containerStatuses[*].restartCount"

echo.
echo 📊 6. RESOURCE USAGE CHECK:
echo ==========================================
kubectl top pods >nul 2>&1
if %errorlevel% equ 0 (
    echo Resource usage:
    kubectl top pods
) else (
    echo ⚠️ Metrics not available
    echo Checking resource requests/limits:
    kubectl describe pods | findstr -i "requests\|limits"
)

echo.
echo 🎛️ 7. CONFIGURATION HEALTH:
echo ==========================================
echo ConfigMaps:
kubectl get configmaps --no-headers | findstr -v "kube-"
echo.
echo Secrets:
kubectl get secrets --no-headers | findstr -v "default-token"

echo.
echo 📈 8. AUTOSCALING STATUS:
echo ==========================================
kubectl get hpa >nul 2>&1
if %errorlevel% equ 0 (
    kubectl get hpa
) else (
    echo No HPA configured
)

echo.
echo 🔄 9. ROLLOUT STATUS:
echo ==========================================
echo User Service:
kubectl rollout status deployment/user-service-deployment --timeout=10s >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ User Service rollout complete
) else (
    echo ⚠️ User Service rollout in progress or failed
)

echo Help Service:
kubectl rollout status deployment/help-service-deployment --timeout=10s >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Help Service rollout complete
) else (
    echo ⚠️ Help Service rollout in progress or failed
)

echo Frontend:
kubectl rollout status deployment/frontend-deployment --timeout=10s >nul 2>&1
if %errorlevel% equ 0 (
    echo ✅ Frontend rollout complete
) else (
    echo ⚠️ Frontend rollout in progress or failed
)

echo.
echo 🎯 HEALTH CHECK SUMMARY:
echo ==========================================
if %healthy_deployments%==%total_deployments% (
    echo ✅ Overall Status: HEALTHY
    echo All deployments are running with expected replicas
) else (
    echo ⚠️ Overall Status: ISSUES DETECTED
    echo Some deployments need attention
)

echo.
echo 💡 RECOMMENDED ACTIONS:
echo ==========================================
if %healthy_deployments% lss %total_deployments% (
    echo - Check deployment logs: scripts\view-logs.bat
    echo - Restart unhealthy services: scripts\restart-services.bat
    echo - Check resource usage: scripts\monitor-resources.bat
) else (
    echo - Monitor performance: scripts\monitor-resources.bat
    echo - Check service URLs: scripts\get-service-urls.bat
    echo - View application logs: scripts\view-logs.bat
)

echo.
echo Health check completed!
