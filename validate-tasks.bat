@echo off
echo ==========================================
echo KUBERNETES MICROSERVICES PROJECT
echo TASK VALIDATION LAUNCHER
echo ==========================================
echo.

if not exist "scripts\validate-all-tasks.bat" (
    echo ❌ Validation scripts not found!
    echo Make sure you're running this from the project root directory.
    echo.
    pause
    exit /b 1
)

echo ✅ Starting task validation system...
echo.

cd scripts
call validate-all-tasks.bat

echo.
echo Returning to project root...
cd ..

echo.
echo ==========================================
echo VALIDATION LAUNCHER COMPLETE
echo ==========================================
pause
