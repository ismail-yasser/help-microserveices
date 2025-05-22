@echo off
setlocal EnableDelayedExpansion

echo ===================================================
echo Docker Desktop Troubleshooting Wizard
echo ===================================================
echo.

echo This wizard will guide you through the process of fixing your
echo Docker Desktop and Kubernetes issues.
echo.
echo Press any key to begin...
pause > nul

:menu
cls
echo ===================================================
echo Docker Desktop Troubleshooting Wizard
echo ===================================================
echo.
echo Choose an option:
echo.
echo [1] Run complete troubleshooting sequence (recommended)
echo [2] Check for port conflicts
echo [3] Fix Docker Desktop issues
echo [4] Optimize Docker Desktop settings
echo [5] Restart Docker with Kubernetes
echo [6] Collect diagnostic logs
echo [7] Reinstall Docker Desktop (last resort)
echo [8] Deploy applications to Kubernetes
echo [9] Verify microservices health
echo [0] Exit
echo.
set /p choice=Enter your choice (0-9): 

if "%choice%"=="1" goto complete_sequence
if "%choice%"=="2" goto check_ports
if "%choice%"=="3" goto fix_docker
if "%choice%"=="4" goto optimize_docker
if "%choice%"=="5" goto restart_docker
if "%choice%"=="6" goto collect_logs
if "%choice%"=="7" goto reinstall_docker
if "%choice%"=="8" goto deploy_apps
if "%choice%"=="9" goto verify_health
if "%choice%"=="0" goto end

echo Invalid choice. Please try again.
timeout /t 2 > nul
goto menu

:complete_sequence
cls
echo ===================================================
echo Complete Troubleshooting Sequence
echo ===================================================
echo.
echo This will run all troubleshooting steps in sequence:
echo 1. Check for port conflicts
echo 2. Fix Docker Desktop issues
echo 3. Optimize Docker Desktop settings
echo 4. Restart Docker with Kubernetes
echo.
echo Press any key to begin or Ctrl+C to cancel...
pause > nul

call :check_ports
echo.
echo Press any key to continue to the next step...
pause > nul

call :fix_docker
echo.
echo Press any key to continue to the next step...
pause > nul

call :optimize_docker
echo.
echo Press any key to continue to the next step...
pause > nul

call :restart_docker
echo.
echo Complete troubleshooting sequence finished.
echo.
echo Once Docker is running correctly, you can:
echo - Deploy applications with option 8
echo - Verify service health with option 9
echo.
echo Press any key to return to menu...
pause > nul
goto menu

:check_ports
cls
echo ===================================================
echo Step 1: Check for Port Conflicts
echo ===================================================
echo.
echo Running port conflict checker...
echo.
call check-port-conflicts.bat
goto :eof

:fix_docker
cls
echo ===================================================
echo Step 2: Fix Docker Desktop Issues
echo ===================================================
echo.
echo Running Docker Desktop fixer...
echo.
call fix-docker-desktop.bat
goto :eof

:optimize_docker
cls
echo ===================================================
echo Step 3: Optimize Docker Desktop Settings
echo ===================================================
echo.
echo Running Docker Desktop settings optimizer...
echo.
call optimize-docker-settings.bat
goto :eof

:restart_docker
cls
echo ===================================================
echo Step 4: Restart Docker with Kubernetes
echo ===================================================
echo.
echo Restarting Docker Desktop with Kubernetes...
echo.
call restart-docker-kubernetes.bat
goto :eof

:collect_logs
cls
echo ===================================================
echo Collect Diagnostic Logs
echo ===================================================
echo.
echo Collecting Docker Desktop logs and diagnostics...
echo.
call collect-docker-logs.bat
echo.
echo Press any key to return to menu...
pause > nul
goto menu

:reinstall_docker
cls
echo ===================================================
echo Reinstall Docker Desktop
echo ===================================================
echo.
echo WARNING: This will completely remove Docker Desktop.
echo.
echo Are you sure you want to proceed? (Y/N)
choice /c YN /m "Proceed with Docker Desktop reinstallation"
if errorlevel 2 goto menu
if errorlevel 1 (
    call reinstall-docker-desktop.bat
)
echo.
echo Press any key to return to menu...
pause > nul
goto menu

:deploy_apps
cls
echo ===================================================
echo Deploy Applications to Kubernetes
echo ===================================================
echo.
echo This will deploy your applications to Kubernetes.
echo Make sure Docker Desktop and Kubernetes are running first.
echo.
echo Do you want to proceed? (Y/N)
choice /c YN /m "Deploy applications"
if errorlevel 2 goto menu
if errorlevel 1 (
    call deploy-kubernetes-apps.bat
)
echo.
echo Press any key to return to menu...
pause > nul
goto menu

:verify_health
cls
echo ===================================================
echo Verify Microservices Health
echo ===================================================
echo.
echo This will verify the health of your microservices.
echo Make sure applications are deployed first.
echo.
echo Do you want to proceed? (Y/N)
choice /c YN /m "Verify health"
if errorlevel 2 goto menu
if errorlevel 1 (
    call verify-microservices-health.bat
)
echo.
echo Press any key to return to menu...
pause > nul
goto menu

:end
cls
echo ===================================================
echo Docker Desktop Troubleshooting Wizard
echo ===================================================
echo.
echo Thank you for using the troubleshooting wizard.
echo.
echo If you've resolved your Docker issues, remember to:
echo 1. Deploy your applications (option 8)
echo 2. Verify service health (option 9)
echo.
echo For detailed instructions, refer to:
echo Docker-Kubernetes-Troubleshooting-Guide.md
echo.
echo Press any key to exit...
pause > nul
exit /b
