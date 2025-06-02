@echo off
setlocal enabledelayedexpansion

:: Script Index and Helper
:: This script provides an overview of all available scripts

echo ================================================
echo    Microservices Project Script Index
echo ================================================
echo.

echo 🚀 QUICK START SCRIPTS
echo ========================
echo.
echo quick-start.bat             - Fastest way to get project running (2 minutes)
echo setup-development.bat       - Complete development environment setup
echo deploy-project.bat          - Main deployment script with multiple options
echo.

echo 🔧 DEPLOYMENT SCRIPTS
echo =======================
echo.
echo deploy-k8s-manifests.bat    - Deploy using Kubernetes manifests
echo deploy-helm-charts.bat      - Deploy using Helm charts (production-ready)
echo deploy-production.bat       - Production deployment with full validation
echo build-images.bat            - Build Docker images with versioning support
echo.

echo 🎛️ MANAGEMENT SCRIPTS
echo =======================
echo.
echo manage-project.bat          - Interactive management console (14 operations)
echo check-status.bat            - Comprehensive status checking
echo start-services.bat          - Start all services (scale to 2 replicas)
echo stop-services.bat           - Stop all services (scale to 0 replicas)
echo restart-services.bat        - Rolling restart of all services
echo scale-services.bat          - Interactive scaling (1-10 replicas)
echo.

echo 📊 MONITORING ^& DIAGNOSTICS
echo =============================
echo.
echo view-logs.bat               - Advanced log viewer with filtering options
echo monitor-resources.bat       - Resource monitoring (CPU, memory, HPA)
echo health-checks.bat           - 9-point comprehensive health assessment
echo troubleshoot.bat            - Diagnostics and automated fixes
echo.

echo 🔄 MAINTENANCE SCRIPTS
echo ========================
echo.
echo update-images.bat           - Docker image management and updates
echo backup-config.bat           - Configuration backup with restore instructions
echo rollback-deployment.bat     - Rollback deployments and Helm releases
echo cleanup-project.bat         - Complete project cleanup and removal
echo.

echo 🌐 UTILITY SCRIPTS
echo ====================
echo.
echo get-service-urls.bat        - Smart URL discovery (Minikube + cloud support)
echo.

echo ================================================
echo    USAGE RECOMMENDATIONS
echo ================================================
echo.

echo 🆕 First Time Users:
echo   1. scripts\quick-start.bat              (Fastest start)
echo   2. scripts\setup-development.bat        (Full setup)
echo.

echo 👨‍💻 Daily Development:
echo   1. scripts\manage-project.bat           (Interactive console)
echo   2. scripts\check-status.bat             (Quick status check)
echo   3. scripts\view-logs.bat                (Log analysis)
echo.

echo 🏭 Production Deployment:
echo   1. scripts\deploy-production.bat        (Validated deployment)
echo   2. scripts\deploy-helm-charts.bat       (Helm-based deployment)
echo.

echo 🔍 Troubleshooting:
echo   1. scripts\troubleshoot.bat             (Comprehensive diagnostics)
echo   2. scripts\health-checks.bat            (Health assessment)
echo   3. scripts\monitor-resources.bat        (Resource monitoring)
echo.

echo ================================================
echo    SCRIPT FEATURES
echo ================================================
echo.

echo ✅ Features Available:
echo   • Interactive menus and prompts
echo   • Comprehensive error handling
echo   • Multi-environment support (dev/prod)
echo   • Automatic dependency checking
echo   • Real-time status updates
echo   • Minikube and cloud cluster support
echo   • Backup and rollback capabilities
echo   • Resource monitoring and scaling
echo   • Advanced logging and diagnostics
echo   • Production-ready configurations
echo.

echo ================================================
echo    QUICK ACTIONS
echo ================================================
echo.

echo What would you like to do?
echo.
echo 1.  🚀 Quick Start (get running fast)
echo 2.  🔧 Setup Development Environment
echo 3.  🎛️ Open Management Console
echo 4.  📊 Check System Status
echo 5.  🔍 Run Troubleshooting
echo 6.  🌐 Get Service URLs
echo 7.  📖 View Documentation
echo 8.  ❌ Exit
echo.

set /p "ACTION_CHOICE=Enter your choice (1-8): "

echo.
if "%ACTION_CHOICE%"=="1" (
    echo Launching Quick Start...
    call "%~dp0quick-start.bat"
) else if "%ACTION_CHOICE%"=="2" (
    echo Launching Development Setup...
    call "%~dp0setup-development.bat"
) else if "%ACTION_CHOICE%"=="3" (
    echo Opening Management Console...
    call "%~dp0manage-project.bat"
) else if "%ACTION_CHOICE%"=="4" (
    echo Checking System Status...
    call "%~dp0check-status.bat"
) else if "%ACTION_CHOICE%"=="5" (
    echo Running Troubleshooting...
    call "%~dp0troubleshoot.bat"
) else if "%ACTION_CHOICE%"=="6" (
    echo Getting Service URLs...
    call "%~dp0get-service-urls.bat"
) else if "%ACTION_CHOICE%"=="7" (
    echo Opening Documentation...
    if exist "%~dp0README.md" (
        start notepad "%~dp0README.md"
    ) else (
        echo Documentation not found at: %~dp0README.md
    )
) else if "%ACTION_CHOICE%"=="8" (
    echo Goodbye! 👋
    goto :end
) else (
    echo Invalid choice. Please run the script again.
)

:end
echo.
echo ================================================
echo.
echo 💡 TIP: For comprehensive project management, use:
echo    scripts\manage-project.bat
echo.
echo 📚 For detailed documentation, see:
echo    scripts\README.md
echo.
echo 🆘 For help and troubleshooting, use:
echo    scripts\troubleshoot.bat
echo.
pause
endlocal
