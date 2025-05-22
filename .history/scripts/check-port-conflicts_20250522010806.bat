@echo off
echo ===================================================
echo Docker and Kubernetes Port Conflict Checker
echo ===================================================
echo.

echo Checking for processes using Docker and Kubernetes ports...
echo.

echo Docker Engine (default ports: 2375, 2376)
netstat -ano | find "2375"
netstat -ano | find "2376"

echo.
echo Docker Swarm (default ports: 2377, 7946, 4789)
netstat -ano | find "2377"
netstat -ano | find "7946" 
netstat -ano | find "4789"

echo.
echo Kubernetes API Server (default port: 6443, 8080)
netstat -ano | find "6443"
netstat -ano | find "8080"

echo. 
echo Kubernetes etcd (default ports: 2379-2380)
netstat -ano | find "2379"
netstat -ano | find "2380"

echo.
echo Kubernetes kubelet (default port: 10250)
netstat -ano | find "10250"

echo.
echo Kubernetes scheduler (default port: 10251)
netstat -ano | find "10251"

echo.
echo Kubernetes controller manager (default port: 10252)
netstat -ano | find "10252"

echo.
echo Docker Desktop WSL2 ports
netstat -ano | find "53"

echo.
echo ===================================================
echo Custom Service Ports Check 
echo ===================================================
echo.

echo Frontend service (port 3001, targetPort 3000, nodePort 30080)
netstat -ano | find "3000"
netstat -ano | find "3001"
netstat -ano | find "30080"

echo.
echo Help service ports
netstat -ano | find "3002"
netstat -ano | find "30081"

echo.
echo User service ports
netstat -ano | find "3003"
netstat -ano | find "30082"

echo.
echo ===================================================
echo Docker and Kubernetes Status Check
echo ===================================================
echo.

echo Docker service status:
sc query docker

echo.
echo Docker Desktop Backend status:
tasklist | find "com.docker.backend.exe"

echo.
echo WSL status:
wsl --status

echo.
echo ===================================================
echo Port Conflict Resolution
echo ===================================================
echo.
echo If you find conflicting ports, you can kill the process with:
echo taskkill /F /PID [process_id]
echo.
echo Example: taskkill /F /PID 1234
echo.
pause
