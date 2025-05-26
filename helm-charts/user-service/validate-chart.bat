@echo off
REM Manual Helm Chart Validation Script
REM This script validates the Helm chart structure and templates without requiring Helm to be installed

setlocal enabledelayedexpansion

echo ========================================
echo   Helm Chart Manual Validation
echo ========================================
echo.

set CHART_DIR=c:\Users\IsmailYasserIsmailAb\Desktop\project\helm-charts\user-service
set VALIDATION_PASSED=true

echo Chart Directory: %CHART_DIR%
echo.

REM Check required files exist
echo Checking required files...
echo --------------------------

set REQUIRED_FILES=Chart.yaml values.yaml README.md

for %%f in (%REQUIRED_FILES%) do (
    if exist "%CHART_DIR%\%%f" (
        echo [PASS] %%f found
    ) else (
        echo [FAIL] %%f missing
        set VALIDATION_PASSED=false
    )
)

REM Check templates directory
if exist "%CHART_DIR%\templates" (
    echo [PASS] templates directory found
    
    REM Check key template files
    set TEMPLATE_FILES=deployment.yaml service.yaml configmap.yaml secret.yaml hpa.yaml ingress.yaml
    
    for %%t in (%TEMPLATE_FILES%) do (
        if exist "%CHART_DIR%\templates\%%t" (
            echo [PASS] templates/%%t found
        ) else (
            echo [WARN] templates/%%t missing (optional)
        )
    )
) else (
    echo [FAIL] templates directory missing
    set VALIDATION_PASSED=false
)

echo.

REM Check Chart.yaml content
echo Checking Chart.yaml content...
echo -----------------------------
if exist "%CHART_DIR%\Chart.yaml" (
    findstr /C:"apiVersion" "%CHART_DIR%\Chart.yaml" >nul && echo [PASS] apiVersion found || echo [FAIL] apiVersion missing
    findstr /C:"name" "%CHART_DIR%\Chart.yaml" >nul && echo [PASS] name found || echo [FAIL] name missing
    findstr /C:"version" "%CHART_DIR%\Chart.yaml" >nul && echo [PASS] version found || echo [FAIL] version missing
    findstr /C:"appVersion" "%CHART_DIR%\Chart.yaml" >nul && echo [PASS] appVersion found || echo [FAIL] appVersion missing
)

echo.

REM Check values files
echo Checking values files...
echo -----------------------
for %%v in (values.yaml values-development.yaml values-production.yaml) do (
    if exist "%CHART_DIR%\%%v" (
        echo [PASS] %%v found
        REM Check for key configuration sections
        findstr /C:"image:" "%CHART_DIR%\%%v" >nul && echo [PASS] %%v contains image config || echo [WARN] %%v missing image config
        findstr /C:"service:" "%CHART_DIR%\%%v" >nul && echo [PASS] %%v contains service config || echo [WARN] %%v missing service config
    ) else (
        echo [INFO] %%v not found (optional)
    )
)

echo.

REM Check template syntax (basic YAML validation)
echo Checking template syntax...
echo --------------------------
set YAML_VALID=true

for /r "%CHART_DIR%\templates" %%f in (*.yaml *.yml) do (
    echo Checking %%~nxf...
    REM Basic YAML syntax check - look for common issues
    findstr /R /C:"{{.*}}" "%%f" >nul && echo [PASS] %%~nxf contains Helm templates || echo [INFO] %%~nxf no Helm templates
    
    REM Check for basic YAML structure
    findstr /R /C:"^[a-zA-Z].*:" "%%f" >nul && echo [PASS] %%~nxf has YAML structure || echo [WARN] %%~nxf may have YAML issues
)

echo.

REM Check helper templates
if exist "%CHART_DIR%\templates\_helpers.tpl" (
    echo [PASS] _helpers.tpl found
    findstr /C:"{{- define" "%CHART_DIR%\templates\_helpers.tpl" >nul && echo [PASS] _helpers.tpl contains template definitions || echo [WARN] _helpers.tpl may be empty
) else (
    echo [WARN] _helpers.tpl not found (recommended)
)

echo.

REM Final validation result
echo ========================================
if "%VALIDATION_PASSED%"=="true" (
    echo   VALIDATION RESULT: PASSED
    echo   Chart structure looks good!
) else (
    echo   VALIDATION RESULT: FAILED
    echo   Please fix the issues above
)
echo ========================================

echo.
echo Manual validation complete.
echo Note: This is a basic structural validation.
echo For full validation, install Helm and run: helm lint .
echo.

endlocal
exit /b 0
