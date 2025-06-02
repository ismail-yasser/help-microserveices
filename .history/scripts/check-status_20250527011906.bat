@echo off
echo ==========================================
echo 📊 SERVICE STATUS CHECK
echo ==========================================
echo.

REM Check if kubectl is available
kubectl version --client >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ kubectl is not available
    exit /b 1
)

REM Check cluster connectivity
kubectl cluster-info >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Cannot connect to Kubernetes cluster
    exit /b 1
)

echo ✅ Connected to cluster: 
kubectl config current-context
echo.

echo 🏗️ DEPLOYMENTS STATUS:
echo ==========================================
kubectl get deployments -o wide
echo.

echo 🔗 SERVICES STATUS:
echo ==========================================
kubectl get services -o wide
echo.

echo 🐳 PODS STATUS:
echo ==========================================
kubectl get pods -o wide
echo.

echo 📈 HORIZONTAL POD AUTOSCALERS:
echo ==========================================
kubectl get hpa 2>nul
if %errorlevel% neq 0 (
    echo No HPA resources found
)
echo.

echo 🎛️ CONFIGMAPS AND SECRETS:
echo ==========================================
echo ConfigMaps:
kubectl get configmaps | findstr -v "kube-"
echo.
echo Secrets:
kubectl get secrets | findstr -v "default-token"
echo.

echo 🏥 SERVICE HEALTH CHECK:
echo ==========================================
echo Checking User Service health...
kubectl run health-check-user --image=curlimages/curl --rm -i --restart=Never -- curl -s http://user-service:3000/health 2>nul
if %errorlevel% equ 0 (
    echo ✅ User Service is healthy
) else (
    echo ❌ User Service health check failed
)

echo.
echo Checking Help Service health...
kubectl run health-check-help --image=curlimages/curl --rm -i --restart=Never -- curl -s http://help-service:3002/health 2>nul
if %errorlevel% equ 0 (
    echo ✅ Help Service is healthy
) else (
    echo ❌ Help Service health check failed
)

echo.
echo 🎯 QUICK SUMMARY:
echo ==========================================
set /a total_pods=0
set /a running_pods=0

for /f "tokens=*" %%i in ('kubectl get pods --no-headers 2^>nul') do (
    set /a total_pods+=1
    echo %%i | findstr "Running" >nul && set /a running_pods+=1
)

echo Total Pods: %total_pods%
echo Running Pods: %running_pods%
if %running_pods%==%total_pods% (
    echo ✅ All pods are running!
) else (
    echo ⚠️ Some pods are not running
)

echo.
echo 📱 For service URLs, run: scripts\get-service-urls.bat
echo 📋 For detailed logs, run: scripts\view-logs.bat
