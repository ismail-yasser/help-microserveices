@echo off
:: Test load balancing for all services

echo Creating a test pod with curl...
kubectl run curl-test --image=curlimages/curl --restart=Never -- sleep 3600
echo Waiting for test pod to be ready...
kubectl wait --for=condition=Ready pod/curl-test --timeout=30s
echo Test pod is ready!

:: Test load balancing for help-service
echo Testing load balancing for help-service...
for /L %%i in (1,1,10) do (
    echo Request %%i:
    kubectl exec curl-test -- curl -v http://help-service:3002/
    echo.
)

:: Test load balancing for user-service
echo Testing load balancing for user-service...
for /L %%i in (1,1,10) do (
    echo Request %%i:
    kubectl exec curl-test -- curl -v http://user-service:3000/
    echo.
)

:: Test load balancing for frontend
echo Testing load balancing for frontend...
for /L %%i in (1,1,10) do (
    echo Request %%i:
    kubectl exec curl-test -- curl -v http://frontend:3001/
    echo.
)

echo Cleaning up test pod...
kubectl delete pod curl-test

echo Load balancing test completed for all services!
