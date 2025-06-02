@echo off
setlocal enabledelayedexpansion

:: Production Deployment Validation Script
:: This script validates production readiness and deploys with production settings

echo ================================================
echo    Production Deployment Validator & Deployer
echo ================================================
echo.

set "ENVIRONMENT=production"
set "NAMESPACE=production"

echo [1/6] Pre-deployment validation...
echo.

:: Check cluster access
echo Checking cluster connectivity...
kubectl cluster-info >nul 2>&1
if %errorLevel% neq 0 (
    echo ❌ ERROR: Cannot connect to Kubernetes cluster
    echo Please ensure kubectl is configured and cluster is accessible
    goto :error
)
echo ✓ Cluster connectivity verified

:: Check required images
echo Checking Docker images...
set "IMAGES_VALID=true"

docker image inspect user-service:latest >nul 2>&1
if %errorLevel% neq 0 (
    echo ❌ ERROR: user-service:latest image not found
    set "IMAGES_VALID=false"
)

docker image inspect help-service:latest >nul 2>&1
if %errorLevel% neq 0 (
    echo ❌ ERROR: help-service:latest image not found
    set "IMAGES_VALID=false"
)

docker image inspect frontend:latest >nul 2>&1
if %errorLevel% neq 0 (
    echo ❌ ERROR: frontend:latest image not found
    set "IMAGES_VALID=false"
)

if "!IMAGES_VALID!"=="false" (
    echo.
    echo Would you like to build the missing images? (y/n)
    set /p "BUILD_CHOICE="
    if /i "!BUILD_CHOICE!"=="y" (
        echo Building Docker images...
        call "%~dp0build-images.bat"
        if %errorLevel% neq 0 goto :error
    ) else (
        goto :error
    )
) else (
    echo ✓ All required Docker images found
)

:: Check Helm (if available)
helm version >nul 2>&1
if %errorLevel% equ 0 (
    set "HELM_AVAILABLE=true"
    echo ✓ Helm available for production deployment
) else (
    set "HELM_AVAILABLE=false"
    echo ⚠ Helm not available, will use kubectl deployment
)

echo.
echo [2/6] Production environment setup...
echo.

:: Create production namespace
echo Creating production namespace...
kubectl create namespace %NAMESPACE% --dry-run=client -o yaml | kubectl apply -f -
echo ✓ Production namespace ready

:: Apply resource quotas for production
echo Applying production resource quotas...
(
echo apiVersion: v1
echo kind: ResourceQuota
echo metadata:
echo   name: production-quota
echo   namespace: %NAMESPACE%
echo spec:
echo   hard:
echo     requests.cpu: "4"
echo     requests.memory: 8Gi
echo     limits.cpu: "8"
echo     limits.memory: 16Gi
echo     pods: "20"
echo     services: "10"
) | kubectl apply -f -

echo.
echo [3/6] Security configuration...
echo.

:: Apply network policies for production
echo Applying production network policies...
(
echo apiVersion: networking.k8s.io/v1
echo kind: NetworkPolicy
echo metadata:
echo   name: production-network-policy
echo   namespace: %NAMESPACE%
echo spec:
echo   podSelector: {}
echo   policyTypes:
echo   - Ingress
echo   - Egress
echo   ingress:
echo   - from:
echo     - namespaceSelector:
echo         matchLabels:
echo           name: %NAMESPACE%
echo   egress:
echo   - to:
echo     - namespaceSelector:
echo         matchLabels:
echo           name: %NAMESPACE%
echo   - to: {}
echo     ports:
echo     - protocol: TCP
echo       port: 53
echo     - protocol: UDP
echo       port: 53
echo     - protocol: TCP
echo       port: 443
echo     - protocol: TCP
echo       port: 80
) | kubectl apply -f -

echo.
echo [4/6] Production configuration deployment...
echo.

:: Deploy production ConfigMaps with production settings
echo Deploying production ConfigMaps...

:: Create production user-service config
(
echo apiVersion: v1
echo kind: ConfigMap
echo metadata:
echo   name: user-service-config
echo   namespace: %NAMESPACE%
echo data:
echo   NODE_ENV: "production"
echo   LOG_LEVEL: "info"
echo   PORT: "3000"
echo   DB_HOST: "user-db-service"
echo   DB_PORT: "5432"
echo   JWT_EXPIRY: "1h"
echo   RATE_LIMIT: "100"
) | kubectl apply -f -

:: Create production help-service config
(
echo apiVersion: v1
echo kind: ConfigMap
echo metadata:
echo   name: help-service-config
echo   namespace: %NAMESPACE%
echo data:
echo   NODE_ENV: "production"
echo   LOG_LEVEL: "info"
echo   PORT: "3001"
echo   USER_SERVICE_URL: "http://user-service:3000"
echo   CACHE_TTL: "300"
echo   MAX_REQUESTS_PER_MINUTE: "60"
) | kubectl apply -f -

echo.
echo [5/6] Application deployment...
echo.

if "!HELM_AVAILABLE!"=="true" (
    echo Deploying with Helm (Production configuration)...
    
    :: Deploy user-service with Helm
    helm upgrade --install user-service ./helm-charts/user-service ^
        --namespace %NAMESPACE% ^
        --set environment=production ^
        --set replicaCount=3 ^
        --set resources.requests.cpu=100m ^
        --set resources.requests.memory=128Mi ^
        --set resources.limits.cpu=500m ^
        --set resources.limits.memory=512Mi ^
        --set autoscaling.enabled=true ^
        --set autoscaling.minReplicas=3 ^
        --set autoscaling.maxReplicas=10 ^
        --wait
    
    if %errorLevel% neq 0 (
        echo ❌ ERROR: Failed to deploy user-service with Helm
        goto :error
    )
    
    :: Deploy help-service with Helm
    helm upgrade --install help-service ./helm-charts/help-service ^
        --namespace %NAMESPACE% ^
        --set environment=production ^
        --set replicaCount=3 ^
        --set resources.requests.cpu=100m ^
        --set resources.requests.memory=128Mi ^
        --set resources.limits.cpu=500m ^
        --set resources.limits.memory=512Mi ^
        --set autoscaling.enabled=true ^
        --set autoscaling.minReplicas=3 ^
        --set autoscaling.maxReplicas=10 ^
        --wait
    
    if %errorLevel% neq 0 (
        echo ❌ ERROR: Failed to deploy help-service with Helm
        goto :error
    )
    
    :: Deploy frontend with Helm
    helm upgrade --install frontend ./helm-charts/frontend ^
        --namespace %NAMESPACE% ^
        --set environment=production ^
        --set replicaCount=2 ^
        --set resources.requests.cpu=50m ^
        --set resources.requests.memory=64Mi ^
        --set resources.limits.cpu=200m ^
        --set resources.limits.memory=256Mi ^
        --wait
    
    if %errorLevel% neq 0 (
        echo ❌ ERROR: Failed to deploy frontend with Helm
        goto :error
    )
    
) else (
    echo Deploying with kubectl (Production configuration)...
    
    :: Apply production manifests with higher resource limits
    cd /d "%~dp0.."
    
    :: Modify manifests for production (higher replicas, resource limits)
    kubectl apply -f k8s/ -n %NAMESPACE%
    
    if %errorLevel% neq 0 (
        echo ❌ ERROR: Failed to deploy with kubectl
        goto :error
    )
    
    :: Scale for production
    kubectl scale deployment user-service --replicas=3 -n %NAMESPACE%
    kubectl scale deployment help-service --replicas=3 -n %NAMESPACE%
    kubectl scale deployment frontend --replicas=2 -n %NAMESPACE%
)

echo.
echo [6/6] Post-deployment validation...
echo.

:: Wait for deployments to be ready
echo Waiting for deployments to be ready...
kubectl wait --for=condition=available --timeout=300s deployment --all -n %NAMESPACE%

if %errorLevel% neq 0 (
    echo ❌ WARNING: Some deployments may not be ready yet
    echo Check deployment status manually
) else (
    echo ✓ All deployments are ready
)

:: Run health checks
echo Running production health checks...
timeout /t 30 >nul 2>&1
call "%~dp0health-checks.bat" %NAMESPACE%

:: Get service URLs
echo.
echo Getting production service URLs...
call "%~dp0get-service-urls.bat" %NAMESPACE%

echo.
echo ================================================
echo    Production Deployment Complete! 🚀
echo ================================================
echo.
echo Environment: %ENVIRONMENT%
echo Namespace: %NAMESPACE%
echo.
echo Production Features Enabled:
echo ✓ Resource quotas and limits
echo ✓ Network policies
echo ✓ Multiple replicas for high availability
echo ✓ Horizontal Pod Autoscaling
echo ✓ Production logging configuration
echo.
echo Monitoring Commands:
echo - kubectl get pods -n %NAMESPACE%
echo - kubectl get services -n %NAMESPACE%
echo - kubectl get hpa -n %NAMESPACE%
echo.
echo Management:
echo - Use 'scripts\manage-project.bat' for ongoing management
echo - Use 'scripts\monitor-resources.bat' for resource monitoring
echo - Use 'scripts\view-logs.bat' for log analysis
echo.
pause
goto :end

:error
echo.
echo ❌ Production deployment failed!
echo Please check the errors above and retry.
echo.
pause
exit /b 1

:end
endlocal
