@echo off
:: Check which pods are handling requests to verify load balancing

echo Creating a test pod with curl and appropriate tools...
kubectl run verify-pod --image=nicolaka/netshoot --restart=Never -- sleep 3600
echo Waiting for test pod to be ready...
kubectl wait --for=condition=Ready pod/verify-pod --timeout=30s
echo Test pod is ready!

echo.
echo ===== Testing help-service load balancing =====
echo.

for /L %%i in (1,1,10) do (
    echo Request %%i to help-service:
    kubectl exec verify-pod -- bash -c "curl -s http://help-service:3002/ | grep 'hostname\|podname' || echo 'No hostname in response'"
    echo.
)

echo.
echo ===== Testing user-service load balancing =====
echo.

for /L %%i in (1,1,10) do (
    echo Request %%i to user-service:
    kubectl exec verify-pod -- bash -c "curl -s http://user-service:3000/ | grep 'hostname\|podname' || echo 'No hostname in response'"
    echo.
)

echo.
echo ===== Testing frontend load balancing =====
echo.

for /L %%i in (1,1,10) do (
    echo Request %%i to frontend:
    kubectl exec verify-pod -- bash -c "curl -s http://frontend:3001/ | grep 'hostname\|podname' || echo 'No hostname in response'"
    echo.
)

echo Cleaning up test pod...
kubectl delete pod verify-pod

echo Load balancing verification completed!
