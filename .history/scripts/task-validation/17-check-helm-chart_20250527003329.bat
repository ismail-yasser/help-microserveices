@echo off
echo ========================================
echo TASK 17: HELM CHART
echo ========================================
echo.

echo Checking Helm chart directories...
echo.

if exist "..\..\helm-charts" (
    echo   ✅ Main helm-charts directory exists
) else (
    echo   ❌ Main helm-charts directory missing
    goto :end
)

echo.
echo Checking individual service Helm charts:
echo.

if exist "..\..\helm-charts\user-service" (
    echo   ✅ User Service Helm chart exists
    
    if exist "..\..\helm-charts\user-service\Chart.yaml" (
        echo     ✅ Chart.yaml found
    ) else (
        echo     ❌ Chart.yaml missing
    )
    
    if exist "..\..\helm-charts\user-service\values.yaml" (
        echo     ✅ values.yaml found
    ) else (
        echo     ❌ values.yaml missing
    )
    
    if exist "..\..\helm-charts\user-service\templates" (
        echo     ✅ templates directory found
        dir /b "..\..\helm-charts\user-service\templates\*.yaml" 2>nul | find /c ".yaml" > temp_count.txt
        set /p template_count=<temp_count.txt
        del temp_count.txt
        echo       Contains %template_count% template files
    ) else (
        echo     ❌ templates directory missing
    )
) else (
    echo   ❌ User Service Helm chart missing
)

echo.
if exist "..\..\helm-charts\help-service" (
    echo   ✅ Help Service Helm chart exists
    
    if exist "..\..\helm-charts\help-service\Chart.yaml" (
        echo     ✅ Chart.yaml found
    ) else (
        echo     ❌ Chart.yaml missing
    )
    
    if exist "..\..\helm-charts\help-service\values.yaml" (
        echo     ✅ values.yaml found
    ) else (
        echo     ❌ values.yaml missing
    )
    
    if exist "..\..\helm-charts\help-service\templates" (
        echo     ✅ templates directory found
        dir /b "..\..\helm-charts\help-service\templates\*.yaml" 2>nul | find /c ".yaml" > temp_count.txt
        set /p template_count=<temp_count.txt
        del temp_count.txt
        echo       Contains %template_count% template files
    ) else (
        echo     ❌ templates directory missing
    )
) else (
    echo   ❌ Help Service Helm chart missing
)

echo.
if exist "helm-charts\frontend" (
    echo   ✅ Frontend Helm chart exists
    
    if exist "helm-charts\frontend\Chart.yaml" (
        echo     ✅ Chart.yaml found
    ) else (
        echo     ❌ Chart.yaml missing
    )
    
    if exist "helm-charts\frontend\values.yaml" (
        echo     ✅ values.yaml found
    ) else (
        echo     ❌ values.yaml missing
    )
    
    if exist "helm-charts\frontend\templates" (
        echo     ✅ templates directory found
        dir /b "helm-charts\frontend\templates\*.yaml" 2>nul | find /c ".yaml" > temp_count.txt
        set /p template_count=<temp_count.txt
        del temp_count.txt
        echo       Contains %template_count% template files
    ) else (
        echo     ❌ templates directory missing
    )
) else (
    echo   ❌ Frontend Helm chart missing
)

echo.
echo Checking Helm installation scripts...
echo.

for %%d in (user-service help-service frontend) do (
    if exist "helm-charts\%%d\install-helm-chart.bat" (
        echo   ✅ %%d install script exists
    ) else (
        echo   ❌ %%d install script missing
    )
)

echo.
echo Checking if Helm is available...
echo.

helm version >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Helm is installed and available
    helm version --short 2>nul
) else (
    echo   ⚠️  Helm not available (this is okay if using kubectl)
)

echo.
echo Checking deployed Helm releases...
echo.

helm list >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Helm releases found:
    helm list
    
    helm list | findstr "user-service\|help-service\|frontend" >nul
    if %errorlevel% equ 0 (
        echo   ✅ Project services deployed via Helm
    ) else (
        echo   ⚠️  Project services not deployed via Helm
    )
) else (
    echo   ⚠️  No Helm releases found or Helm not available
)

echo.
echo Checking Helm documentation...
echo.

if exist "docs\helm-implementation-summary.md" (
    echo   ✅ Helm implementation documentation exists
) else if exist "helm-charts\README.md" (
    echo   ✅ Helm README documentation exists
) else (
    echo   ⚠️  Helm documentation might be missing
)

echo.
echo Helm chart validation summary:
echo   - Chart.yaml files define chart metadata
echo   - values.yaml files contain default configuration
echo   - templates/ directories contain Kubernetes manifests
echo   - Install scripts automate deployment process

:end
echo.
echo ========================================
echo TASK 17 VALIDATION COMPLETE
echo ========================================
pause
