@echo off
echo ========================================
echo TASK 8: HEALTH PROBES
echo ========================================
echo.

echo Checking deployment files for health probes...
echo.

echo User Service deployment:
if exist "..\..\k8s\user-service\user-service-deployment.yaml" (
    findstr /i "livenessProbe" "..\..\k8s\user-service\user-service-deployment.yaml" >nul
    if %errorlevel% equ 0 (
        echo   ✅ Liveness probe configured
    ) else (
        echo   ❌ Liveness probe missing
    )
    
    findstr /i "readinessProbe" "..\..\k8s\user-service\user-service-deployment.yaml" >nul
    if %errorlevel% equ 0 (
        echo   ✅ Readiness probe configured
    ) else (
        echo   ❌ Readiness probe missing
    )
) else (
    echo   ❌ User Service deployment file not found
)

echo.
echo Help Service deployment:
if exist "k8s\help-service\help-service-deployment.yaml" (
    findstr /i "livenessProbe" "k8s\help-service\help-service-deployment.yaml" >nul
    if %errorlevel% equ 0 (
        echo   ✅ Liveness probe configured
    ) else (
        echo   ❌ Liveness probe missing
    )
    
    findstr /i "readinessProbe" "k8s\help-service\help-service-deployment.yaml" >nul
    if %errorlevel% equ 0 (
        echo   ✅ Readiness probe configured
    ) else (
        echo   ❌ Readiness probe missing
    )
) else (
    echo   ❌ Help Service deployment file not found
)

echo.
echo Frontend deployment:
if exist "k8s\frontend\frontend-deployment.yaml" (
    findstr /i "livenessProbe" "k8s\frontend\frontend-deployment.yaml" >nul
    if %errorlevel% equ 0 (
        echo   ✅ Liveness probe configured
    ) else (
        echo   ❌ Liveness probe missing
    )
    
    findstr /i "readinessProbe" "k8s\frontend\frontend-deployment.yaml" >nul
    if %errorlevel% equ 0 (
        echo   ✅ Readiness probe configured
    ) else (
        echo   ❌ Readiness probe missing
    )
) else (
    echo   ❌ Frontend deployment file not found
)

echo.
echo Testing health endpoints...
echo.

kubectl get pods >nul 2>&1
if %errorlevel% neq 0 (
    echo   ❌ kubectl not available or cluster not running
    goto :end
)

echo Testing User Service health endpoint:
kubectl exec -it deployment/user-service -- curl -s http://localhost:3000/health 2>nul | findstr -i "healthy\|ok\|success" >nul
if %errorlevel% equ 0 (
    echo   ✅ User Service health endpoint responding
) else (
    echo   ❌ User Service health endpoint not responding
)

echo Testing Help Service health endpoint:
kubectl exec -it deployment/help-service -- curl -s http://localhost:3002/health 2>nul | findstr -i "healthy\|ok\|success" >nul
if %errorlevel% equ 0 (
    echo   ✅ Help Service health endpoint responding
) else (
    echo   ❌ Help Service health endpoint not responding
)

:end
echo.
echo ========================================
echo TASK 8 VALIDATION COMPLETE
echo ========================================
pause
