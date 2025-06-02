@echo off
setlocal enabledelayedexpansion

:: Build Docker Images Script
:: This script builds all Docker images for the microservices project

echo ================================================
echo    Docker Images Builder
echo ================================================
echo.

set "BUILD_LATEST=true"
set "BUILD_VERSION="
set "PUSH_TO_REGISTRY=false"
set "REGISTRY_URL="

:: Parse command line arguments
:parse_args
if "%1"=="" goto :args_done
if "%1"=="--version" (
    set "BUILD_VERSION=%2"
    shift
    shift
    goto :parse_args
)
if "%1"=="--push" (
    set "PUSH_TO_REGISTRY=true"
    shift
    goto :parse_args
)
if "%1"=="--registry" (
    set "REGISTRY_URL=%2"
    shift
    shift
    goto :parse_args
)
shift
goto :parse_args
:args_done

:: Set image tags
if not "!BUILD_VERSION!"=="" (
    set "USER_SERVICE_TAG=user-service:!BUILD_VERSION!"
    set "HELP_SERVICE_TAG=help-service:!BUILD_VERSION!"
    set "FRONTEND_TAG=frontend:!BUILD_VERSION!"
) else (
    set "USER_SERVICE_TAG=user-service:latest"
    set "HELP_SERVICE_TAG=help-service:latest"
    set "FRONTEND_TAG=frontend:latest"
)

:: Add registry prefix if specified
if not "!REGISTRY_URL!"=="" (
    set "USER_SERVICE_TAG=!REGISTRY_URL!/!USER_SERVICE_TAG!"
    set "HELP_SERVICE_TAG=!REGISTRY_URL!/!HELP_SERVICE_TAG!"
    set "FRONTEND_TAG=!REGISTRY_URL!/!FRONTEND_TAG!"
)

echo Build Configuration:
echo - User Service Tag: !USER_SERVICE_TAG!
echo - Help Service Tag: !HELP_SERVICE_TAG!
echo - Frontend Tag: !FRONTEND_TAG!
if "!PUSH_TO_REGISTRY!"=="true" (
    echo - Push to Registry: Yes (!REGISTRY_URL!)
) else (
    echo - Push to Registry: No
)
echo.

:: Check Docker availability
docker version >nul 2>&1
if %errorLevel% neq 0 (
    echo ❌ ERROR: Docker is not installed or not running
    echo Please install Docker and ensure it's running
    goto :error
)
echo ✓ Docker is available
echo.

:: Navigate to project root
cd /d "%~dp0.."

echo [1/4] Building user-service...
echo.

:: Check if Dockerfile exists
if not exist "user-service\Dockerfile" (
    echo ❌ ERROR: user-service\Dockerfile not found
    goto :error
)

:: Build user-service
echo Building !USER_SERVICE_TAG!...
docker build -t !USER_SERVICE_TAG! ./user-service
if %errorLevel% neq 0 (
    echo ❌ ERROR: Failed to build user-service
    goto :error
)
echo ✓ user-service built successfully
echo.

echo [2/4] Building help-service...
echo.

:: Check if Dockerfile exists
if not exist "help-service\Dockerfile" (
    echo ❌ ERROR: help-service\Dockerfile not found
    goto :error
)

:: Build help-service
echo Building !HELP_SERVICE_TAG!...
docker build -t !HELP_SERVICE_TAG! ./help-service
if %errorLevel% neq 0 (
    echo ❌ ERROR: Failed to build help-service
    goto :error
)
echo ✓ help-service built successfully
echo.

echo [3/4] Building frontend...
echo.

:: Check if Dockerfile exists
if not exist "frontend\Dockerfile" (
    echo ❌ ERROR: frontend\Dockerfile not found
    goto :error
)

:: Build frontend
echo Building !FRONTEND_TAG!...
docker build -t !FRONTEND_TAG! ./frontend
if %errorLevel% neq 0 (
    echo ❌ ERROR: Failed to build frontend
    goto :error
)
echo ✓ frontend built successfully
echo.

:: Push to registry if requested
if "!PUSH_TO_REGISTRY!"=="true" (
    echo [4/4] Pushing images to registry...
    echo.
    
    if "!REGISTRY_URL!"=="" (
        echo ❌ ERROR: Registry URL not specified for push operation
        goto :error
    )
    
    echo Pushing !USER_SERVICE_TAG!...
    docker push !USER_SERVICE_TAG!
    if %errorLevel% neq 0 (
        echo ❌ ERROR: Failed to push user-service
        goto :error
    )
    
    echo Pushing !HELP_SERVICE_TAG!...
    docker push !HELP_SERVICE_TAG!
    if %errorLevel% neq 0 (
        echo ❌ ERROR: Failed to push help-service
        goto :error
    )
    
    echo Pushing !FRONTEND_TAG!...
    docker push !FRONTEND_TAG!
    if %errorLevel% neq 0 (
        echo ❌ ERROR: Failed to push frontend
        goto :error
    )
    
    echo ✓ All images pushed successfully
) else (
    echo [4/4] Skipping registry push (use --push to enable)
)

echo.
echo ================================================
echo    Build Complete! 🚀
echo ================================================
echo.
echo Built Images:
echo - !USER_SERVICE_TAG!
echo - !HELP_SERVICE_TAG!
echo - !FRONTEND_TAG!
echo.

:: Show image sizes
echo Image Sizes:
docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}" | findstr /C:"user-service" /C:"help-service" /C:"frontend"
echo.

if "!PUSH_TO_REGISTRY!"=="true" (
    echo ✓ Images available in registry: !REGISTRY_URL!
    echo.
    echo To use in Kubernetes:
    echo   kubectl set image deployment/user-service user-service=!USER_SERVICE_TAG!
    echo   kubectl set image deployment/help-service help-service=!HELP_SERVICE_TAG!
    echo   kubectl set image deployment/frontend frontend=!FRONTEND_TAG!
) else (
    echo Next steps:
    echo 1. Deploy to Kubernetes: scripts\deploy-k8s-manifests.bat
    echo 2. Or use Helm: scripts\deploy-helm-charts.bat
    echo 3. Push to registry: %~nx0 --push --registry your-registry-url
)

echo.
echo Usage examples:
echo   %~nx0                                    ^(build latest tags^)
echo   %~nx0 --version v1.2.3                  ^(build with version tag^)
echo   %~nx0 --push --registry docker.io/user  ^(build and push to registry^)
echo.
pause
goto :end

:error
echo.
echo ❌ Build failed! Please check the errors above.
echo.
pause
exit /b 1

:end
endlocal
