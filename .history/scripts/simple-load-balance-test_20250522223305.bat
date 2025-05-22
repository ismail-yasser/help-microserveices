@echo off
:: Simple load balancing test

echo Creating a simple test pod...
kubectl run curl-test --image=curlimages/curl --restart=Never -- sleep 600
echo Waiting for pod to be ready...
kubectl wait --for=condition=Ready pod/curl-test --timeout=60s
echo.

echo Testing help-service endpoints...
echo -------------------------------
echo Testing /health endpoint:
kubectl exec curl-test -- curl -v http://help-service:3002/health
echo.
echo Testing root endpoint:
kubectl exec curl-test -- curl -v http://help-service:3002/
echo.

echo Testing user-service endpoints...
echo -------------------------------
echo Testing /health endpoint:
kubectl exec curl-test -- curl -v http://user-service:3000/health
echo.
echo Testing root endpoint:
kubectl exec curl-test -- curl -v http://user-service:3000/
echo.

echo Testing frontend...
echo -------------------------------
kubectl exec curl-test -- curl -v http://frontend:3001/
echo.

echo Testing IP resolution for load balancing verification...
echo ------------------------------------------------------
echo Running nslookup for help-service:
kubectl exec curl-test -- sh -c "nslookup help-service || echo nslookup not available"
echo.

echo Running multiple requests to help-service to check for load balancing...
FOR /L %%i IN (1,1,3) DO (
    echo Request %%i:
    kubectl exec curl-test -- curl -s http://help-service:3002/ || echo Failed to reach service
    echo.
)

echo Cleaning up test pod...
kubectl delete pod curl-test

echo Load balancing test completed!
