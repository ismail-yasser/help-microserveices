@echo off
echo Testing health endpoints for all services...

:: Get the NodePort for frontend service
for /f "tokens=*" %%a in ('kubectl get svc frontend -o=jsonpath="{.spec.ports[0].nodePort}"') do set FRONTEND_PORT=%%a
echo Frontend NodePort: %FRONTEND_PORT%

:: Get the ClusterIPs for internal services
for /f "tokens=*" %%a in ('kubectl get svc help-service -o=jsonpath="{.spec.clusterIP}"') do set HELP_SERVICE_IP=%%a
echo Help Service ClusterIP: %HELP_SERVICE_IP%

for /f "tokens=*" %%a in ('kubectl get svc user-service -o=jsonpath="{.spec.clusterIP}"') do set USER_SERVICE_IP=%%a
echo User Service ClusterIP: %USER_SERVICE_IP%

:: Test frontend using port-forward
echo.
echo Testing Frontend service (use Ctrl+C when finished)...
start cmd /k kubectl port-forward svc/frontend 3001:3001
timeout /t 5
echo Frontend URL: http://localhost:3001
echo.

:: Test user-service health and readiness endpoints using kubectl exec
echo.
echo Testing User Service health endpoint...
kubectl exec -it deployment/user-service-deployment -- curl -s http://localhost:3000/health
echo.

echo Testing User Service readiness endpoint...
kubectl exec -it deployment/user-service-deployment -- curl -s http://localhost:3000/ready
echo.

:: Test help-service health and readiness endpoints using kubectl exec
echo.
echo Testing Help Service health endpoint...
kubectl exec -it deployment/help-service-deployment -- curl -s http://localhost:3002/health
echo.

echo Testing Help Service readiness endpoint...
kubectl exec -it deployment/help-service-deployment -- curl -s http://localhost:3002/ready
echo.

pause
