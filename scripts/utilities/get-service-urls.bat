@echo off
echo ==========================================
echo 🌐 SERVICE ACCESS URLS
echo ==========================================
echo.

REM Check if running in Minikube
minikube status >nul 2>&1
if %errorlevel% equ 0 (
    echo 🚀 Detected Minikube environment
    echo.
    
    echo Getting Minikube IP...
    for /f "tokens=*" %%i in ('minikube ip') do set MINIKUBE_IP=%%i
    echo Minikube IP: %MINIKUBE_IP%
    echo.
    
    echo 🌐 SERVICE URLS:
    echo ==========================================
    
    REM Get NodePort for frontend
    for /f "tokens=5 delims=: " %%i in ('kubectl get service frontend -o custom-columns=PORT:.spec.ports[0].nodePort --no-headers 2^>nul') do set FRONTEND_PORT=%%i
    if not "%FRONTEND_PORT%"=="" (
        echo Frontend Application:
        echo   http://%MINIKUBE_IP%:%FRONTEND_PORT%
        echo.
    ) else (
        echo Frontend: Service not exposed via NodePort
        echo.
    )
    
    REM Get NodePort for user-service if exposed
    for /f "tokens=5 delims=: " %%i in ('kubectl get service user-service -o custom-columns=PORT:.spec.ports[0].nodePort --no-headers 2^>nul') do set USER_PORT=%%i
    if not "%USER_PORT%"=="" (
        echo User Service API:
        echo   http://%MINIKUBE_IP%:%USER_PORT%
        echo   Health: http://%MINIKUBE_IP%:%USER_PORT%/health
        echo.
    ) else (
        echo User Service: ClusterIP only (internal)
        echo.
    )
    
    REM Get NodePort for help-service if exposed
    for /f "tokens=5 delims=: " %%i in ('kubectl get service help-service -o custom-columns=PORT:.spec.ports[0].nodePort --no-headers 2^>nul') do set HELP_PORT=%%i
    if not "%HELP_PORT%"=="" (
        echo Help Service API:
        echo   http://%MINIKUBE_IP%:%HELP_PORT%
        echo   Health: http://%MINIKUBE_IP%:%HELP_PORT%/health
        echo.
    ) else (
        echo Help Service: ClusterIP only (internal)
        echo.
    )
    
    echo 💡 Quick Access Commands:
    echo ==========================================
    if not "%FRONTEND_PORT%"=="" (
        echo Open Frontend:  start http://%MINIKUBE_IP%:%FRONTEND_PORT%
    )
    echo Minikube Dashboard: minikube dashboard
    echo.
    
) else (
    echo 🏢 Non-Minikube environment detected
    echo.
    
    echo 🌐 SERVICE INFORMATION:
    echo ==========================================
    
    echo Services:
    kubectl get services -o wide
    echo.
    
    echo Ingress (if configured):
    kubectl get ingress -o wide 2>nul
    echo.
    
    REM Check for LoadBalancer services
    echo LoadBalancer Services:
    kubectl get services --field-selector spec.type=LoadBalancer -o wide
    echo.
    
    REM Check for NodePort services
    echo NodePort Services:
    kubectl get services --field-selector spec.type=NodePort -o wide
    echo.
    
    echo 💡 Access Methods:
    echo ==========================================
    echo 1. Port Forwarding (for testing):
    echo    kubectl port-forward service/frontend 8080:3000
    echo    kubectl port-forward service/user-service 8081:3000
    echo    kubectl port-forward service/help-service 8082:3002
    echo.
    echo 2. If using cloud provider:
    echo    Wait for LoadBalancer external IP
    echo    Check ingress controller configuration
    echo.
)

echo 🔧 ADVANCED ACCESS:
echo ==========================================
echo Internal service communication:
echo   User Service: http://user-service:3000
echo   Help Service: http://help-service:3002
echo   Frontend: http://frontend:3000
echo.

echo Pod direct access (kubectl exec):
echo   kubectl exec -it [POD_NAME] -- /bin/sh
echo.

echo 📊 For service status: scripts\check-status.bat
echo 📋 For logs: scripts\view-logs.bat
