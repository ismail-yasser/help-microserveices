@echo off
echo ========================================
echo TASK 15: INGRESS CONTROLLER
echo ========================================
echo.

echo Checking Ingress files...
echo.

if exist "..\..\k8s\ingress.yaml" (
    echo   ✅ Main Ingress file exists (k8s\ingress.yaml)
    
    findstr /i "path.*users\|path.*help" "..\..\k8s\ingress.yaml" >nul
    if %errorlevel% equ 0 (
        echo   ✅ Ingress contains path-based routing
    ) else (
        echo   ⚠️  Ingress might not have path-based routing
    )
) else (
    echo   ⚠️  Main Ingress file not found
)

echo.
echo Checking service-specific Ingress files...
echo.

dir /s /b "..\..\k8s\*ingress*.yaml" 2>nul | find /c "ingress" > temp_count.txt
set /p ingress_count=<temp_count.txt
del temp_count.txt

if %ingress_count% gtr 0 (
    echo   ✅ Found %ingress_count% Ingress files:
    dir /s /b "..\..\k8s\*ingress*.yaml"
) else (
    echo   ❌ No Ingress files found
)

echo.
echo Checking deployed Ingress resources...
echo.

kubectl get ingress >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Ingress resources are deployed:
    kubectl get ingress
    
    echo.
    echo   Ingress details:
    kubectl describe ingress | findstr "Host:\|Path:\|Backend:"
    
) else (
    echo   ❌ No Ingress resources found or kubectl unavailable
)

echo.
echo Checking Ingress Controller...
echo.

kubectl get pods -A | findstr "ingress" >nul
if %errorlevel% equ 0 (
    echo   ✅ Ingress Controller pods found:
    kubectl get pods -A | findstr "ingress"
) else (
    echo   ⚠️  Ingress Controller might not be running
)

echo.
echo Checking Ingress routing configuration...
echo.

if exist "k8s\ingress.yaml" (
    echo   Routes configured in main Ingress:
    findstr /i "path:\|service:\|port:" "k8s\ingress.yaml" | findstr /v "^[[:space:]]*#"
) else if exist "k8s\frontend\*ingress*.yaml" (
    echo   Routes configured in frontend Ingress:
    for %%f in (k8s\frontend\*ingress*.yaml) do (
        echo     File: %%f
        findstr /i "path:\|service:\|port:" "%%f" | findstr /v "^[[:space:]]*#"
    )
)

echo.
echo Verifying expected routing paths:
echo   Expected paths: /users, /help, /api/users, /api/help
echo   Check if these are configured in your Ingress files above

echo.
echo ========================================
echo TASK 15 VALIDATION COMPLETE
echo ========================================
pause
