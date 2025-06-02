@echo off
echo ========================================
echo TASK 16: GITHUB ACTIONS CI/CD
echo ========================================
echo.

echo Checking GitHub Actions workflow files...
echo.

if exist "..\..\\.github\\workflows" (
    echo   ✅ GitHub Actions workflows directory exists
    
    dir /b "..\..\\.github\\workflows\\*.yml" "..\..\\.github\\workflows\\*.yaml" 2>nul | find /c "." > temp_count.txt
    set /p workflow_count=<temp_count.txt
    del temp_count.txt
      if %workflow_count% gtr 0 (
        echo   ✅ Found %workflow_count% workflow files:
        dir /b "..\..\\.github\\workflows\\*.yml" "..\..\\.github\\workflows\\*.yaml" 2>nul
    ) else (
        echo   ❌ No workflow files found
    )
) else (
    echo   ❌ GitHub Actions workflows directory missing
)

echo.
echo Checking workflow content...
echo.

for %%f in (..\..\\.github\\workflows\\*.yml ..\..\\.github\\workflows\\*.yaml) do (
    if exist "%%f" (
        echo   Checking %%f:
        
        findstr /i "kubectl\|minikube" "%%f" >nul
        if %errorlevel% equ 0 (
            echo     ✅ Contains kubectl/minikube commands
        ) else (
            echo     ⚠️  No kubectl/minikube commands found
        )
        
        findstr /i "docker.*build\|docker.*push" "%%f" >nul
        if %errorlevel% equ 0 (
            echo     ✅ Contains Docker build/push commands
        ) else (
            echo     ⚠️  No Docker build/push commands found
        )
        
        findstr /i "deploy\|apply" "%%f" >nul
        if %errorlevel% equ 0 (
            echo     ✅ Contains deployment commands
        ) else (
            echo     ⚠️  No deployment commands found
        )
        
        findstr /i "on:.*push\|on:.*pull_request" "%%f" >nul
        if %errorlevel% equ 0 (
            echo     ✅ Triggered on push/PR events
        ) else (
            echo     ⚠️  Trigger events not found
        )
        
        echo.
    )
)

echo.
echo Checking for CI/CD configuration files...
echo.

if exist "Dockerfile" (
    echo   ✅ Root Dockerfile exists
) else (
    echo   ⚠️  Root Dockerfile not found
)

if exist "docker-compose.yml" (
    echo   ✅ Docker Compose file exists
) else (
    echo   ⚠️  Docker Compose file not found
)

echo.
echo Checking recent workflow runs (if applicable)...
echo.

git log --oneline --grep="workflow\|ci\|cd\|deploy" -5 2>nul
if %errorlevel% equ 0 (
    echo   ✅ Found CI/CD related commits
) else (
    echo   ⚠️  No CI/CD related commits found recently
)

echo.
echo GitHub Actions setup verification:
echo.

if exist ".github\workflows" (
    echo   Required components for Task 16:
    echo   ✓ Workflow files in .github/workflows/
    echo   ✓ kubectl commands for deployment
    echo   ✓ Automatic trigger on push
    echo   ✓ Docker build and push steps
    echo.
    echo   Current workflow files:
    for %%f in (.github\workflows\*.yml .github\workflows\*.yaml) do (
        if exist "%%f" echo     - %%f
    )
)

echo.
echo ========================================
echo TASK 16 VALIDATION COMPLETE
echo ========================================
pause
