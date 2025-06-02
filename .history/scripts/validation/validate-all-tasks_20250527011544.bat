@echo off
setlocal enabledelayedexpansion
echo ==========================================
echo KUBERNETES MICROSERVICES PROJECT
echo COMPLETE VALIDATION SUITE
echo ==========================================
echo.
echo This script will validate all 17 tasks:
echo.
echo INDIVIDUAL TASKS (1-9):
echo  1. Build and Push Docker Images
echo  2. Kubernetes Deployments  
echo  3. Kubernetes Services
echo  4. ConfigMaps and Secrets
echo  5. API Documentation
echo  6. Load Balancing Tests
echo  7. GitHub Repository
echo  8. Health Probes
echo  9. Horizontal Pod Autoscaler
echo.
echo SYSTEM TASKS (10-17):
echo  10. Frontend Deployment
echo  11. Frontend Exposure
echo  12. System Integration Testing
echo  13. Architecture Diagram
echo  14. K8s Manifests Organization
echo  15. Ingress Controller
echo  16. GitHub Actions CI/CD
echo  17. Helm Chart
echo.
echo ==========================================

set /p choice="Run all validations? (y/n): "
if /i "%choice%" neq "y" goto :menu

echo.
echo Starting complete validation...
echo.

:: Initialize counters
set passed=0
set failed=0
set warnings=0

:: Run all validation scripts
for /l %%i in (1,1,17) do (
    echo.
    echo ==========================================
    echo RUNNING TASK %%i VALIDATION
    echo ==========================================
      if %%i lss 10 (
        call "%~dp0..\task-validation\0%%i-check-*.bat" >nul 2>&1
    ) else (
        call "%~dp0..\task-validation\%%i-check-*.bat" >nul 2>&1
    )
    
    if !errorlevel! equ 0 (
        echo ✅ TASK %%i: PASSED
        set /a passed+=1
    ) else (
        echo ❌ TASK %%i: ISSUES FOUND
        set /a failed+=1
    )
)

goto :summary

:menu
echo.
echo ==========================================
echo INDIVIDUAL TASK VALIDATION MENU
echo ==========================================
echo.
echo Select a task to validate (1-17) or 0 for all:
echo.
echo  1. Docker Images         10. Frontend Deployment
echo  2. Deployments          11. Frontend Exposure  
echo  3. Services             12. Integration Testing
echo  4. ConfigMaps/Secrets   13. Architecture Diagram
echo  5. API Documentation    14. K8s Organization
echo  6. Load Balancing       15. Ingress Controller
echo  7. GitHub Repository    16. GitHub Actions
echo  8. Health Probes        17. Helm Chart
echo  9. Auto Scaling         
echo.
echo  0. Run All Tasks
echo  99. Exit
echo.

set /p task_choice="Enter task number: "

if "%task_choice%"=="0" goto :run_all
if "%task_choice%"=="99" goto :exit

if %task_choice% geq 1 if %task_choice% leq 17 (
    echo.
    echo Running Task %task_choice% validation...
      if %task_choice% lss 10 (
        call "%~dp0..\task-validation\0%task_choice%-check-*.bat"
    ) else (
        call "%~dp0..\task-validation\%task_choice%-check-*.bat"
    )
    
    echo.
    echo Task %task_choice% validation completed.
    echo.
    pause
    goto :menu
) else (
    echo Invalid choice. Please select 1-17, 0 for all, or 99 to exit.
    pause
    goto :menu
)

:run_all
echo.
echo Running all task validations...
echo.

for /l %%i in (1,1,17) do (
    echo ==========================================
    echo TASK %%i VALIDATION
    echo ==========================================
      if %%i lss 10 (
        call "%~dp0..\task-validation\0%%i-check-*.bat"
    ) else (
        call "%~dp0..\task-validation\%%i-check-*.bat"
    )
    
    echo.
    echo Press any key to continue to next task...
    pause >nul
    echo.
)

:summary
echo.
echo ==========================================
echo VALIDATION SUMMARY
echo ==========================================
echo.
echo Total Tasks: 17
echo ✅ Passed: %passed%
echo ❌ Issues: %failed%
echo.

if %failed% equ 0 (
    echo 🎉 CONGRATULATIONS! 
    echo All tasks appear to be completed successfully!
    echo Your Kubernetes microservices project is ready!
) else (
    echo ⚠️  Some tasks need attention.
    echo Review the individual task outputs above.
)

echo.
echo ==========================================
echo QUICK STATUS CHECK
echo ==========================================
echo.

echo Checking overall system status...
kubectl get all 2>nul | findstr "pod\|service\|deployment" >nul
if %errorlevel% equ 0 (
    echo ✅ Kubernetes cluster is responsive
    echo.
    kubectl get pods | findstr "Running"
    echo.
    kubectl get services | findstr -v "kubernetes"
) else (
    echo ❌ Kubernetes cluster not accessible
)

echo.
echo ==========================================

:exit
echo.
echo Validation complete. Check individual task scripts in:
echo scripts\task-validation\
echo.
echo For detailed information, see:
echo docs\final-project-completion.md
echo.
pause
exit /b
