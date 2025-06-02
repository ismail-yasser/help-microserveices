@echo off
setlocal enabledelayedexpansion

:: Troubleshooting and Diagnostics Script
:: This script helps diagnose and fix common issues

echo ================================================
echo    Microservices Project Troubleshooter
echo ================================================
echo.

set "NAMESPACE="
if not "%1"=="" set "NAMESPACE=-n %1"

echo Running comprehensive diagnostics...
echo.

echo ================================================
echo    SYSTEM DIAGNOSTICS
echo ================================================
echo.

:: Check Docker
echo [Docker Status]
docker version >nul 2>&1
if %errorLevel% equ 0 (
    echo ✓ Docker is running
    docker info | findstr "Server Version"
    docker info | findstr "Storage Driver"
    docker info | findstr "Memory"
) else (
    echo ❌ Docker is not running or not installed
    echo Solution: Install Docker Desktop and ensure it's running
)
echo.

:: Check Kubernetes
echo [Kubernetes Status]
kubectl version --client >nul 2>&1
if %errorLevel% equ 0 (
    echo ✓ kubectl is available
    kubectl version --short 2>nul
    
    kubectl cluster-info >nul 2>&1
    if %errorLevel% equ 0 (
        echo ✓ Kubernetes cluster is accessible
        kubectl cluster-info
    ) else (
        echo ❌ Cannot connect to Kubernetes cluster
        echo Solution: Start Minikube with 'minikube start' or configure cluster access
    )
) else (
    echo ❌ kubectl is not installed
    echo Solution: Install kubectl
)
echo.

:: Check Minikube (if available)
echo [Minikube Status]
minikube status >nul 2>&1
if %errorLevel% equ 0 (
    echo ✓ Minikube is available
    minikube status
    minikube profile list 2>nul
) else (
    echo ⚠ Minikube not available or not running
)
echo.

:: Check Helm
echo [Helm Status]
helm version >nul 2>&1
if %errorLevel% equ 0 (
    echo ✓ Helm is available
    helm version --short
) else (
    echo ⚠ Helm not available
)
echo.

echo ================================================
echo    APPLICATION DIAGNOSTICS
echo ================================================
echo.

:: Check namespaces
echo [Namespaces]
kubectl get namespaces | findstr -E "(development|production|default)"
echo.

:: Check deployments
echo [Deployments Status]
kubectl get deployments %NAMESPACE% 2>nul
if %errorLevel% neq 0 (
    echo ❌ No deployments found or namespace access issues
    echo.
    echo Available namespaces:
    kubectl get namespaces --no-headers -o custom-columns=":metadata.name"
    echo.
) else (
    echo.
    echo [Deployment Details]
    for /f "tokens=1" %%i in ('kubectl get deployments %NAMESPACE% --no-headers -o custom-columns=":metadata.name" 2^>nul') do (
        echo.
        echo Deployment: %%i
        kubectl describe deployment %%i %NAMESPACE% | findstr -E "(Replicas|Conditions|Events)"
    )
)
echo.

:: Check pods
echo [Pods Status]
kubectl get pods %NAMESPACE% 2>nul
if %errorLevel% equ 0 (
    echo.
    echo [Pod Issues Detection]
    
    :: Check for failed pods
    for /f "tokens=1,3" %%i in ('kubectl get pods %NAMESPACE% --no-headers 2^>nul') do (
        if not "%%j"=="Running" (
            if not "%%j"=="Completed" (
                echo.
                echo ❌ Pod %%i is in %%j state
                echo Logs for %%i:
                kubectl logs %%i %NAMESPACE% --tail=20 2>nul
                echo.
                echo Events for %%i:
                kubectl describe pod %%i %NAMESPACE% | findstr -A5 "Events:"
            )
        )
    )
) else (
    echo ❌ Cannot access pods in specified namespace
)
echo.

:: Check services
echo [Services Status]
kubectl get services %NAMESPACE% 2>nul
echo.

:: Check ConfigMaps
echo [ConfigMaps]
kubectl get configmaps %NAMESPACE% 2>nul
echo.

:: Check HPA
echo [Horizontal Pod Autoscaler]
kubectl get hpa %NAMESPACE% 2>nul
echo.

:: Check resource usage
echo [Resource Usage]
kubectl top nodes 2>nul
if %errorLevel% neq 0 (
    echo ⚠ Metrics server not available or not ready
) else (
    echo.
    kubectl top pods %NAMESPACE% 2>nul
)
echo.

echo ================================================
echo    NETWORK DIAGNOSTICS
echo ================================================
echo.

:: Check Ingress
echo [Ingress Status]
kubectl get ingress %NAMESPACE% 2>nul
echo.

:: Test internal connectivity
echo [Internal Connectivity Test]
kubectl run test-pod --image=busybox --rm -it --restart=Never %NAMESPACE% -- nslookup kubernetes.default 2>nul
echo.

echo ================================================
echo    COMMON SOLUTIONS
echo ================================================
echo.

echo If you're experiencing issues, try these solutions:
echo.
echo 1. Pods not starting:
echo    - Check Docker images exist: docker images
echo    - Rebuild images: scripts\build-images.bat
echo    - Check resource limits: kubectl describe pod [POD_NAME] %NAMESPACE%
echo.
echo 2. Services not accessible:
echo    - Check service endpoints: kubectl get endpoints %NAMESPACE%
echo    - Verify port configurations in manifests
echo    - For Minikube: minikube service list
echo.
echo 3. Minikube issues:
echo    - Restart: minikube stop ^&^& minikube start
echo    - Reset: minikube delete ^&^& minikube start
echo    - Check status: minikube status
echo.
echo 4. Resource issues:
echo    - Scale down: scripts\scale-services.bat
echo    - Clean up: scripts\cleanup-project.bat
echo    - Check available resources: kubectl describe nodes
echo.
echo 5. Image pull issues:
echo    - Use Minikube Docker daemon: minikube docker-env
echo    - Rebuild images in Minikube context
echo    - Check image tags match manifest specifications
echo.

echo ================================================
echo    AUTOMATED FIXES
echo ================================================
echo.

echo Available automated fixes:
echo 1. Restart all services
echo 2. Rebuild and redeploy images
echo 3. Reset development environment
echo 4. Clean and redeploy
echo 5. Fix common configuration issues
echo 0. Skip automated fixes
echo.

set /p "FIX_CHOICE=Select fix to apply (0-5): "

if "%FIX_CHOICE%"=="1" (
    echo Restarting all services...
    call "%~dp0..\management\restart-services.bat"
) else if "%FIX_CHOICE%"=="2" (
    echo Rebuilding and redeploying...    call "%~dp0..\deployment\build-images.bat"
    call "%~dp0..\deployment\deploy-k8s-manifests.bat"
) else if "%FIX_CHOICE%"=="3" (
    echo Resetting development environment...
    call "%~dp0..\maintenance\cleanup-project.bat"
    call "%~dp0..\quick-start\setup-development.bat"
) else if "%FIX_CHOICE%"=="4" (
    echo Cleaning and redeploying...
    call "%~dp0..\maintenance\cleanup-project.bat"
    call "%~dp0..\deployment\deploy-project.bat"
) else if "%FIX_CHOICE%"=="5" (
    echo Applying configuration fixes...
    
    :: Ensure metrics server is enabled
    minikube addons enable metrics-server 2>nul
    
    :: Apply common fixes
    kubectl apply -f k8s/ %NAMESPACE% 2>nul
    
    :: Restart any failed deployments
    for /f "tokens=1" %%i in ('kubectl get deployments %NAMESPACE% --no-headers -o custom-columns=":metadata.name" 2^>nul') do (
        kubectl rollout restart deployment %%i %NAMESPACE% 2>nul
    )
    
    echo Configuration fixes applied
)

echo.
echo ================================================
echo    Troubleshooting Complete
echo ================================================
echo.

if "%FIX_CHOICE%" neq "0" (
    echo Automated fix applied. Check system status:
    call "%~dp0check-status.bat"
)

echo.
echo For additional help:
echo - Project management: scripts\manage-project.bat
echo - Health checks: scripts\health-checks.bat
echo - Resource monitoring: scripts\monitor-resources.bat
echo.
pause
endlocal
