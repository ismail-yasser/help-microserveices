@echo off
echo ========================================
echo TASK 7: GITHUB REPOSITORY
echo ========================================
echo.

echo Checking Git repository status...
echo.

if exist "..\..\..git" (
    echo   ✅ Git repository initialized
) else (
    echo   ❌ Git repository not found
    goto :end
)

git status >nul 2>&1
if %errorlevel% equ 0 (
    echo   ✅ Git is working properly
) else (
    echo   ❌ Git status check failed
    goto :end
)

echo.
echo Checking remote repository...
git remote -v | findstr "github.com"
if %errorlevel% equ 0 (
    echo   ✅ GitHub remote repository configured
) else (
    echo   ❌ GitHub remote repository not found
)

echo.
echo Checking recent commits...
git log --oneline -5 2>nul
if %errorlevel% equ 0 (
    echo   ✅ Commit history exists
) else (
    echo   ❌ No commit history found
)

echo.
echo Checking if Kubernetes files are tracked...
git ls-files | findstr "k8s\|.yaml\|.yml" >nul
if %errorlevel% equ 0 (
    echo   ✅ Kubernetes files are tracked in Git
) else (
    echo   ⚠️  Kubernetes files might not be tracked
)

echo.
echo Checking current branch and status:
git branch --show-current 2>nul
git status --porcelain | findstr "." >nul
if %errorlevel% equ 0 (
    echo   ⚠️  Uncommitted changes found
    git status --short
) else (
    echo   ✅ Working directory clean
)

:end
echo.
echo ========================================
echo TASK 7 VALIDATION COMPLETE
echo ========================================
pause
