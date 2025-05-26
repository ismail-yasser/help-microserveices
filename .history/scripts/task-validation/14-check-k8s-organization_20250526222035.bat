@echo off
echo ========================================
echo TASK 14: ORGANIZE K8S MANIFESTS
echo ========================================
echo.

echo Checking k8s directory structure...
echo.

if exist "..\..\k8s" (
    echo   ✅ Main k8s directory exists
) else (
    echo   ❌ Main k8s directory missing
    goto :end
)

echo.
echo Checking service-specific directories:
echo.

if exist "..\..\k8s\user-service" (
    echo   ✅ User Service manifests directory exists
    dir /b "..\..\k8s\user-service\*.yaml" 2>nul | find /c ".yaml" > temp_count.txt
    set /p yaml_count=<temp_count.txt
    del temp_count.txt
    echo      Contains %yaml_count% YAML files
) else (
    echo   ❌ User Service manifests directory missing
)

if exist "..\..\k8s\help-service" (
    echo   ✅ Help Service manifests directory exists
    dir /b "..\..\k8s\help-service\*.yaml" 2>nul | find /c ".yaml" > temp_count.txt
    set /p yaml_count=<temp_count.txt
    del temp_count.txt
    echo      Contains %yaml_count% YAML files
) else (
    echo   ❌ Help Service manifests directory missing
)

if exist "..\..\k8s\frontend" (
    echo   ✅ Frontend manifests directory exists
    dir /b "..\..\k8s\frontend\*.yaml" 2>nul | find /c ".yaml" > temp_count.txt
    set /p yaml_count=<temp_count.txt
    del temp_count.txt
    echo      Contains %yaml_count% YAML files
) else (
    echo   ❌ Frontend manifests directory missing
)

echo.
echo Checking for essential manifest files:
echo.

echo User Service:
if exist "k8s\user-service\user-service-deployment.yaml" (echo     ✅ Deployment) else (echo     ❌ Deployment missing)
if exist "k8s\user-service\user-service-service.yaml" (echo     ✅ Service) else (echo     ❌ Service missing)
if exist "k8s\user-service\user-service-config.yaml" (echo     ✅ ConfigMap) else (echo     ❌ ConfigMap missing)
if exist "k8s\user-service\user-service-secret.yaml" (echo     ✅ Secret) else (echo     ❌ Secret missing)
if exist "k8s\user-service\user-service-hpa.yaml" (echo     ✅ HPA) else (echo     ❌ HPA missing)

echo.
echo Help Service:
if exist "k8s\help-service\help-service-deployment.yaml" (echo     ✅ Deployment) else (echo     ❌ Deployment missing)
if exist "k8s\help-service\help-service-service.yaml" (echo     ✅ Service) else (echo     ❌ Service missing)
if exist "k8s\help-service\help-service-config.yaml" (echo     ✅ ConfigMap) else (echo     ❌ ConfigMap missing)
if exist "k8s\help-service\help-service-secret.yaml" (echo     ✅ Secret) else (echo     ❌ Secret missing)
if exist "k8s\help-service\help-service-hpa.yaml" (echo     ✅ HPA) else (echo     ❌ HPA missing)

echo.
echo Frontend:
if exist "k8s\frontend\frontend-deployment.yaml" (echo     ✅ Deployment) else (echo     ❌ Deployment missing)
if exist "k8s\frontend\frontend-service.yaml" (echo     ✅ Service) else (echo     ❌ Service missing)
if exist "k8s\frontend\frontend-hpa.yaml" (echo     ✅ HPA) else (echo     ❌ HPA missing)

echo.
echo Checking shared manifests:
echo.

dir /b "k8s\*.yaml" 2>nul | findstr "ingress\|namespace" >nul
if %errorlevel% equ 0 (
    echo   ✅ Shared manifests found (Ingress/Namespace)
    dir /b "k8s\*.yaml" | findstr "ingress\|namespace"
) else (
    echo   ⚠️  No shared manifests found
)

echo.
echo Complete k8s directory structure:
tree /f k8s 2>nul || dir /s k8s

:end
echo.
echo ========================================
echo TASK 14 VALIDATION COMPLETE
echo ========================================
pause
