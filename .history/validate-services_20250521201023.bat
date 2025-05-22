@echo off
REM Service DNS validation script for Kubernetes
REM This script checks service connectivity and DNS resolution within the cluster

echo =====================================================
echo     KUBERNETES SERVICE DNS VALIDATION SCRIPT
echo =====================================================
echo.

REM Check if kubectl is available
kubectl version --client >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: kubectl not found. Please install kubectl and configure it.
    goto :end
)

REM Check if the test pod exists, otherwise create it
kubectl get pod service-test-pod >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Test pod not found. Creating test pod...
    kubectl apply -f test-pod.yaml
    
    REM Wait for pod to be ready
    echo Waiting for test pod to be ready...
    kubectl wait --for=condition=ready pod/service-test-pod --timeout=60s
) else (
    echo Found existing test pod: service-test-pod
)

echo.
echo Testing DNS resolution for services...
echo -----------------------------------------------------

REM Test DNS resolution for user-service
echo Checking DNS resolution for user-service:
kubectl exec -it service-test-pod -- nslookup user-service
echo.

REM Test DNS resolution for help-service
echo Checking DNS resolution for help-service:
kubectl exec -it service-test-pod -- nslookup help-service
echo.

REM Test DNS resolution for frontend-service
echo Checking DNS resolution for frontend-service:
kubectl exec -it service-test-pod -- nslookup frontend-service
echo.

echo Testing HTTP connectivity to services...
echo -----------------------------------------------------

REM Test HTTP connectivity to user-service
echo Checking HTTP connectivity to user-service:
echo GET /api/health
kubectl exec -it service-test-pod -- curl -s http://user-service:3000/api/health
echo.
echo.

REM Test HTTP connectivity to help-service
echo Checking HTTP connectivity to help-service:
echo GET /api/health
kubectl exec -it service-test-pod -- curl -s http://help-service:3002/api/health
echo.
echo.

REM Test HTTP connectivity to frontend-service
echo Checking HTTP connectivity to frontend-service:
echo GET /
kubectl exec -it service-test-pod -- curl -s -I http://frontend-service
echo.
echo.

echo =====================================================
echo Service validation complete!
echo =====================================================

:end
pause
