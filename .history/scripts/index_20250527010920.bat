@echo off
setlocal enabledelayedexpansion

:: Microservices Project Scripts - Main Index
:: This script provides easy access to all organized scripts

echo ================================================
echo    Microservices Project Scripts
echo ================================================
echo.

echo 📁 ORGANIZED SCRIPT STRUCTURE
echo ==============================
echo.

echo 🚀 quick-start/          - Fast setup and getting started
echo 🔧 deployment/           - Build and deployment scripts  
echo 🎛️ management/           - Service lifecycle management
echo 📊 monitoring/           - Status, logs, and diagnostics
echo 🔄 maintenance/          - Updates, backups, and cleanup
echo 🧪 validation/           - Testing and validation scripts
echo 🌐 utilities/            - Helper and utility scripts
echo.

echo ================================================
echo    QUICK ACCESS MENU
echo ================================================
echo.

echo What would you like to do?
echo.
echo 1.  🚀 Quick Start (get project running fast)
echo 2.  🔧 Deploy Project (deployment options)
echo 3.  🎛️ Manage Services (start/stop/scale/restart)
echo 4.  📊 Monitor System (status/logs/health checks)
echo 5.  🔄 Maintenance (backup/update/cleanup)
echo 6.  🧪 Run Validations (test deployments)
echo 7.  🌐 Get Service URLs (access applications)
echo 8.  📖 Browse Scripts by Category
echo 9.  ❓ Help and Documentation
echo 0.  ❌ Exit
echo.

set /p "MENU_CHOICE=Enter your choice (0-9): "

echo.
if "%MENU_CHOICE%"=="1" (
    echo 🚀 Quick Start Options:
    echo ========================
    echo 1. Ultra-Quick Start (2 minutes)
    echo 2. Development Environment Setup
    echo 3. Interactive Help
    echo.
    set /p "QUICK_CHOICE=Choose option (1-3): "
    if "!QUICK_CHOICE!"=="1" call "%~dp0quick-start\quick-start.bat" --quick
    if "!QUICK_CHOICE!"=="2" call "%~dp0quick-start\setup-development.bat"
    if "!QUICK_CHOICE!"=="3" call "%~dp0quick-start\help.bat"
    
) else if "%MENU_CHOICE%"=="2" (
    echo 🔧 Deployment Options:
    echo =======================
    echo 1. Main Deployment Script (multiple options)
    echo 2. Kubernetes Manifests Deployment
    echo 3. Helm Charts Deployment
    echo 4. Production Deployment
    echo 5. Build Docker Images
    echo.
    set /p "DEPLOY_CHOICE=Choose option (1-5): "
    if "!DEPLOY_CHOICE!"=="1" call "%~dp0deployment\deploy-project.bat"
    if "!DEPLOY_CHOICE!"=="2" call "%~dp0deployment\deploy-k8s-manifests.bat"
    if "!DEPLOY_CHOICE!"=="3" call "%~dp0deployment\deploy-helm-charts.bat"
    if "!DEPLOY_CHOICE!"=="4" call "%~dp0deployment\deploy-production.bat"
    if "!DEPLOY_CHOICE!"=="5" call "%~dp0deployment\build-images.bat"
    
) else if "%MENU_CHOICE%"=="3" (
    echo 🎛️ Service Management:
    echo =======================
    echo 1. Management Console (interactive)
    echo 2. Start All Services
    echo 3. Stop All Services
    echo 4. Restart All Services
    echo 5. Scale Services
    echo.
    set /p "MGMT_CHOICE=Choose option (1-5): "
    if "!MGMT_CHOICE!"=="1" call "%~dp0management\manage-project.bat"
    if "!MGMT_CHOICE!"=="2" call "%~dp0management\start-services.bat"
    if "!MGMT_CHOICE!"=="3" call "%~dp0management\stop-services.bat"
    if "!MGMT_CHOICE!"=="4" call "%~dp0management\restart-services.bat"
    if "!MGMT_CHOICE!"=="5" call "%~dp0management\scale-services.bat"
    
) else if "%MENU_CHOICE%"=="4" (
    echo 📊 Monitoring Options:
    echo =======================
    echo 1. Check System Status
    echo 2. View Logs
    echo 3. Monitor Resources
    echo 4. Health Checks
    echo 5. Troubleshoot Issues
    echo.
    set /p "MONITOR_CHOICE=Choose option (1-5): "
    if "!MONITOR_CHOICE!"=="1" call "%~dp0monitoring\check-status.bat"
    if "!MONITOR_CHOICE!"=="2" call "%~dp0monitoring\view-logs.bat"
    if "!MONITOR_CHOICE!"=="3" call "%~dp0monitoring\monitor-resources.bat"
    if "!MONITOR_CHOICE!"=="4" call "%~dp0monitoring\health-checks.bat"
    if "!MONITOR_CHOICE!"=="5" call "%~dp0monitoring\troubleshoot.bat"
    
) else if "%MENU_CHOICE%"=="5" (
    echo 🔄 Maintenance Options:
    echo ========================
    echo 1. Update Docker Images
    echo 2. Backup Configuration
    echo 3. Rollback Deployment
    echo 4. Cleanup Project
    echo.
    set /p "MAINT_CHOICE=Choose option (1-4): "
    if "!MAINT_CHOICE!"=="1" call "%~dp0maintenance\update-images.bat"
    if "!MAINT_CHOICE!"=="2" call "%~dp0maintenance\backup-config.bat"
    if "!MAINT_CHOICE!"=="3" call "%~dp0maintenance\rollback-deployment.bat"
    if "!MAINT_CHOICE!"=="4" call "%~dp0maintenance\cleanup-project.bat"
    
) else if "%MENU_CHOICE%"=="6" (
    echo 🧪 Validation Options:
    echo =======================
    echo 1. Validate All Tasks
    echo 2. Validate Individual Tasks
    echo 3. Validate Team Tasks
    echo 4. Validate Helm Deployment
    echo.
    set /p "VALID_CHOICE=Choose option (1-4): "
    if "!VALID_CHOICE!"=="1" call "%~dp0validation\validate-all-tasks.bat"
    if "!VALID_CHOICE!"=="2" call "%~dp0validation\validate-individual-tasks.bat"
    if "!VALID_CHOICE!"=="3" call "%~dp0validation\validate-team-tasks.bat"
    if "!VALID_CHOICE!"=="4" call "%~dp0validation\validate-helm-deployment.sh"
    
) else if "%MENU_CHOICE%"=="7" (
    echo 🌐 Getting Service URLs...
    call "%~dp0utilities\get-service-urls.bat"
    
) else if "%MENU_CHOICE%"=="8" (
    echo 📖 Script Categories:
    echo ======================
    echo.
    echo Choose a category to explore:
    echo 1. Quick Start Scripts
    echo 2. Deployment Scripts
    echo 3. Management Scripts
    echo 4. Monitoring Scripts
    echo 5. Maintenance Scripts
    echo 6. Validation Scripts
    echo 7. Utility Scripts
    echo.
    set /p "CAT_CHOICE=Choose category (1-7): "
    
    if "!CAT_CHOICE!"=="1" (
        echo.
        echo 🚀 Quick Start Scripts:
        echo ========================
        dir /b "%~dp0quick-start\*.bat"
        echo.
        echo Location: scripts\quick-start\
    )
    if "!CAT_CHOICE!"=="2" (
        echo.
        echo 🔧 Deployment Scripts:
        echo =======================
        dir /b "%~dp0deployment\*.bat"
        echo.
        echo Location: scripts\deployment\
    )
    if "!CAT_CHOICE!"=="3" (
        echo.
        echo 🎛️ Management Scripts:
        echo =======================
        dir /b "%~dp0management\*.bat"
        echo.
        echo Location: scripts\management\
    )
    if "!CAT_CHOICE!"=="4" (
        echo.
        echo 📊 Monitoring Scripts:
        echo =======================
        dir /b "%~dp0monitoring\*.bat"
        echo.
        echo Location: scripts\monitoring\
    )
    if "!CAT_CHOICE!"=="5" (
        echo.
        echo 🔄 Maintenance Scripts:
        echo ========================
        dir /b "%~dp0maintenance\*.bat"
        echo.
        echo Location: scripts\maintenance\
    )
    if "!CAT_CHOICE!"=="6" (
        echo.
        echo 🧪 Validation Scripts:
        echo =======================
        dir /b "%~dp0validation\*.bat"
        echo.
        echo Location: scripts\validation\
    )
    if "!CAT_CHOICE!"=="7" (
        echo.
        echo 🌐 Utility Scripts:
        echo ====================
        dir /b "%~dp0utilities\*.bat"
        echo.
        echo Location: scripts\utilities\
    )
    echo.
    pause
    
) else if "%MENU_CHOICE%"=="9" (
    echo 📖 Documentation and Help:
    echo ============================
    echo 1. View README Documentation
    echo 2. Interactive Help Guide
    echo 3. Script Structure Overview
    echo.
    set /p "HELP_CHOICE=Choose option (1-3): "
    if "!HELP_CHOICE!"=="1" (
        if exist "%~dp0README.md" (
            start notepad "%~dp0README.md"
        ) else (
            echo README.md not found
        )
    )
    if "!HELP_CHOICE!"=="2" call "%~dp0quick-start\help.bat"
    if "!HELP_CHOICE!"=="3" (
        echo.
        echo 📁 Script Organization:
        echo ========================
        echo scripts/
        echo ├── 🚀 quick-start/     - Fast setup and getting started
        echo ├── 🔧 deployment/      - Build and deployment scripts
        echo ├── 🎛️ management/      - Service lifecycle management
        echo ├── 📊 monitoring/      - Status, logs, and diagnostics
        echo ├── 🔄 maintenance/     - Updates, backups, and cleanup
        echo ├── 🧪 validation/      - Testing and validation scripts
        echo └── 🌐 utilities/       - Helper and utility scripts
        echo.
        echo Each folder contains related scripts for specific tasks.
        echo Use this index script to easily access any functionality.
        pause
    )
    
) else if "%MENU_CHOICE%"=="0" (
    echo Goodbye! 👋
    goto :end
) else (
    echo Invalid choice. Please try again.
    pause
    cls
    goto :start
)

:end
echo.
echo ================================================
echo.
echo 💡 TIP: You can run this script anytime to access all functionality:
echo    scripts\index.bat
echo.
echo 📁 Direct folder access:
echo    scripts\quick-start\     - Fast setup scripts
echo    scripts\deployment\      - Deployment scripts
echo    scripts\management\      - Management scripts
echo    scripts\monitoring\      - Monitoring scripts
echo    scripts\maintenance\     - Maintenance scripts
echo    scripts\validation\      - Validation scripts
echo    scripts\utilities\       - Utility scripts
echo.
pause
endlocal
