@echo off
echo ===================================================
echo Microservices Health Check and Diagnostics
echo ===================================================
echo.

echo This script will help verify the health of your microservices
echo after Docker Desktop and Kubernetes are fixed.
echo.

echo Checking Kubernetes connection...
kubectl version --short
if %errorlevel% neq 0 (
    echo ERROR: Cannot connect to Kubernetes.
    echo Make sure Docker Desktop is running with Kubernetes enabled.
    goto end
)

echo.
echo Kubernetes connection successful!
echo.

echo ===================================================
echo Step 1: Check all resources
echo ===================================================
echo.

echo Checking node status...
kubectl get nodes -o wide

echo.
echo Checking pod status...
kubectl get pods -o wide

echo.
echo Checking service status...
kubectl get services -o wide

echo.
echo Checking deployments...
kubectl get deployments -o wide

echo.
echo ===================================================
echo Step 2: Detailed pod diagnostics
echo ===================================================
echo.

echo Looking for problematic pods...
kubectl get pods | findstr -v "Running"

echo.
echo If any pods are not in Running state, checking pod events:
for /f "tokens=1" %%i in ('kubectl get pods -o=name') do (
    echo.
    echo Events for %%i:
    kubectl describe %%i | findstr -i "Events:"
    kubectl describe %%i | findstr -i "Warning"
)

echo.
echo ===================================================
echo Step 3: Service connectivity tests
echo ===================================================
echo.

echo Testing service connectivity...
echo.

echo Frontend Service (port 3001):
kubectl port-forward service/frontend 3001:3001 --address 0.0.0.0 &
ping -n 2 localhost > nul
powershell -Command "try { Invoke-RestMethod -Uri http://localhost:3001 -Method Get -TimeoutSec 5; Write-Host 'Frontend is accessible' -ForegroundColor Green } catch { Write-Host 'Frontend is not responding: ' -NoNewline -ForegroundColor Red; Write-Host $_.Exception.Message }"
taskkill /f /im "kubectl.exe" > nul 2>&1

echo.
echo Help Service (port 3002):
kubectl port-forward service/help-service 3002:3002 --address 0.0.0.0 &
ping -n 2 localhost > nul
powershell -Command "try { Invoke-RestMethod -Uri http://localhost:3002 -Method Get -TimeoutSec 5; Write-Host 'Help service is accessible' -ForegroundColor Green } catch { Write-Host 'Help service is not responding: ' -NoNewline -ForegroundColor Red; Write-Host $_.Exception.Message }"
taskkill /f /im "kubectl.exe" > nul 2>&1

echo.
echo User Service (port 3003):
kubectl port-forward service/user-service 3003:3003 --address 0.0.0.0 &
ping -n 2 localhost > nul
powershell -Command "try { Invoke-RestMethod -Uri http://localhost:3003 -Method Get -TimeoutSec 5; Write-Host 'User service is accessible' -ForegroundColor Green } catch { Write-Host 'User service is not responding: ' -NoNewline -ForegroundColor Red; Write-Host $_.Exception.Message }"
taskkill /f /im "kubectl.exe" > nul 2>&1

echo.
echo ===================================================
echo Step 4: Check logs for each service
echo ===================================================
echo.

echo Recent logs from frontend:
for /f "tokens=1" %%i in ('kubectl get pods -l app=frontend -o name') do (
    kubectl logs --tail=20 %%i
)

echo.
echo Recent logs from help-service:
for /f "tokens=1" %%i in ('kubectl get pods -l app=help-service -o name') do (
    kubectl logs --tail=20 %%i
)

echo.
echo Recent logs from user-service:
for /f "tokens=1" %%i in ('kubectl get pods -l app=user-service -o name') do (
    kubectl logs --tail=20 %%i
)

echo.
echo ===================================================
echo Step 5: Check NodePort access
echo ===================================================
echo.

echo Testing NodePort access...
echo.

echo Frontend via NodePort (30080):
powershell -Command "try { Invoke-RestMethod -Uri http://localhost:30080 -Method Get -TimeoutSec 5; Write-Host 'Frontend NodePort is accessible' -ForegroundColor Green } catch { Write-Host 'Frontend NodePort is not responding: ' -NoNewline -ForegroundColor Red; Write-Host $_.Exception.Message }"

echo.
echo Help Service via NodePort (30081):
powershell -Command "try { Invoke-RestMethod -Uri http://localhost:30081 -Method Get -TimeoutSec 5; Write-Host 'Help service NodePort is accessible' -ForegroundColor Green } catch { Write-Host 'Help service NodePort is not responding: ' -NoNewline -ForegroundColor Red; Write-Host $_.Exception.Message }"

echo.
echo User Service via NodePort (30082):
powershell -Command "try { Invoke-RestMethod -Uri http://localhost:30082 -Method Get -TimeoutSec 5; Write-Host 'User service NodePort is accessible' -ForegroundColor Green } catch { Write-Host 'User service NodePort is not responding: ' -NoNewline -ForegroundColor Red; Write-Host $_.Exception.Message }"

echo.
echo ===================================================
echo Diagnostics Complete
echo ===================================================
echo.
echo Health check and diagnostics completed.
echo Review the output for any issues with your microservices.
echo.
echo Microservices should be accessible at:
echo - Frontend: http://localhost:30080 (NodePort) or http://localhost:3001 (port-forward)
echo - Help Service: http://localhost:30081 (NodePort) or http://localhost:3002 (port-forward)
echo - User Service: http://localhost:30082 (NodePort) or http://localhost:3003 (port-forward)
echo.
echo Press any key to exit...

:end
pause > nul
