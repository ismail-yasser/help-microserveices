@echo off
echo ========================================
echo QUICK VALIDATION TEST
echo ========================================
echo.

echo Testing file path corrections...
echo.

if exist "..\..\k8s\user-service\user-service-deployment.yaml" (
    echo ✅ User Service deployment found
) else (
    echo ❌ User Service deployment missing
)

if exist "..\..\k8s\help-service\help-service-deployment.yaml" (
    echo ✅ Help Service deployment found
) else (
    echo ❌ Help Service deployment missing
)

if exist "..\..\k8s\frontend\frontend-deployment.yaml" (
    echo ✅ Frontend deployment found
) else (
    echo ❌ Frontend deployment missing
)

if exist "..\..\services\user-service\Dockerfile" (
    echo ✅ User Service Dockerfile found
) else (
    echo ❌ User Service Dockerfile missing
)

if exist "..\..\helm-charts\user-service\Chart.yaml" (
    echo ✅ User Service Helm chart found
) else (
    echo ❌ User Service Helm chart missing
)

echo.
echo Kubernetes cluster status:
kubectl get pods --no-headers 2>nul | find /c "Running" > temp_running.txt
set /p running_pods=<temp_running.txt
del temp_running.txt

echo   Running pods: %running_pods%

echo.
echo ========================================
echo QUICK TEST COMPLETE
echo ========================================
pause
