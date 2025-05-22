@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo Kubernetes Microservices Deployment Utility
echo ===================================================
echo.

:menu
cls
echo Choose an operation:
echo.
echo  [1] Build and Push Docker Image
echo  [2] Generate Kubernetes Resource Files
echo  [3] Deploy Service to Kubernetes
echo  [4] Test Load Balancing
echo  [5] Validate Service DNS
echo  [6] Capture Pod Screenshot
echo  [7] Document API Endpoints
echo  [8] Push to GitHub
echo  [9] Exit
echo.
set /p CHOICE=Enter your choice (1-9): 

if "%CHOICE%"=="1" goto build_push
if "%CHOICE%"=="2" goto generate_resources
if "%CHOICE%"=="3" goto deploy_service
if "%CHOICE%"=="4" goto test_load_balancing
if "%CHOICE%"=="5" goto validate_dns
if "%CHOICE%"=="6" goto capture_screenshot
if "%CHOICE%"=="7" goto document_api
if "%CHOICE%"=="8" goto github_push
if "%CHOICE%"=="9" goto exit

echo Invalid choice. Please try again.
timeout /t 2 > nul
goto menu

:build_push
cls
echo ===================================================
echo Build and Push Docker Image
echo ===================================================
echo.
echo Choose a service:
echo  [1] Frontend
echo  [2] Help Service
echo  [3] User Service
echo  [4] Back to main menu
echo.
set /p SERVICE_CHOICE=Enter your choice (1-4): 

if "%SERVICE_CHOICE%"=="1" (
    set SERVICE_NAME=frontend
) else if "%SERVICE_CHOICE%"=="2" (
    set SERVICE_NAME=help-service
) else if "%SERVICE_CHOICE%"=="3" (
    set SERVICE_NAME=user-service
) else if "%SERVICE_CHOICE%"=="4" (
    goto menu
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 > nul
    goto build_push
)

set /p DOCKER_USERNAME=Enter your Docker Hub username: 

call build-and-push-docker.bat %SERVICE_NAME% %DOCKER_USERNAME%
echo.
pause
goto menu

:generate_resources
cls
echo ===================================================
echo Generate Kubernetes Resource Files
echo ===================================================
echo.
echo Choose a service:
echo  [1] Frontend
echo  [2] Help Service
echo  [3] User Service
echo  [4] Back to main menu
echo.
set /p SERVICE_CHOICE=Enter your choice (1-4): 

if "%SERVICE_CHOICE%"=="1" (
    set SERVICE_NAME=frontend
    set PORT=3000
) else if "%SERVICE_CHOICE%"=="2" (
    set SERVICE_NAME=help-service
    set PORT=3002
) else if "%SERVICE_CHOICE%"=="3" (
    set SERVICE_NAME=user-service
    set PORT=3003
) else if "%SERVICE_CHOICE%"=="4" (
    goto menu
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 > nul
    goto generate_resources
)

set /p DOCKER_USERNAME=Enter your Docker Hub username: 

call generate-k8s-resources.bat %SERVICE_NAME% %DOCKER_USERNAME% %PORT%
echo.
pause
goto menu

:deploy_service
cls
echo ===================================================
echo Deploy Service to Kubernetes
echo ===================================================
echo.
echo Choose a service:
echo  [1] Frontend
echo  [2] Help Service
echo  [3] User Service
echo  [4] Deploy All Services
echo  [5] Back to main menu
echo.
set /p SERVICE_CHOICE=Enter your choice (1-5): 

if "%SERVICE_CHOICE%"=="1" (
    set SERVICE_NAME=frontend
) else if "%SERVICE_CHOICE%"=="2" (
    set SERVICE_NAME=help-service
) else if "%SERVICE_CHOICE%"=="3" (
    set SERVICE_NAME=user-service
) else if "%SERVICE_CHOICE%"=="4" (
    echo Deploying all services...
    call deploy-k8s-service.bat frontend
    call deploy-k8s-service.bat help-service
    call deploy-k8s-service.bat user-service
    echo.
    pause
    goto menu
) else if "%SERVICE_CHOICE%"=="5" (
    goto menu
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 > nul
    goto deploy_service
)

call deploy-k8s-service.bat %SERVICE_NAME%
echo.
pause
goto menu

:test_load_balancing
cls
echo ===================================================
echo Test Load Balancing
echo ===================================================
echo.
echo Choose a service:
echo  [1] Help Service
echo  [2] User Service
echo  [3] Back to main menu
echo.
set /p SERVICE_CHOICE=Enter your choice (1-3): 

if "%SERVICE_CHOICE%"=="1" (
    set SERVICE_NAME=help-service
    set ENDPOINT=/api/help
) else if "%SERVICE_CHOICE%"=="2" (
    set SERVICE_NAME=user-service
    set ENDPOINT=/api/users/profile
) else if "%SERVICE_CHOICE%"=="3" (
    goto menu
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 > nul
    goto test_load_balancing
)

set /p ITERATIONS=Enter number of test iterations (default: 10): 
if "%ITERATIONS%"=="" set ITERATIONS=10

call test-load-balancing.bat %SERVICE_NAME% %ENDPOINT% %ITERATIONS%
echo.
pause
goto menu

:validate_dns
cls
echo ===================================================
echo Validate Service DNS
echo ===================================================
echo.
echo Choose a service:
echo  [1] Frontend
echo  [2] Help Service
echo  [3] User Service
echo  [4] Back to main menu
echo.
set /p SERVICE_CHOICE=Enter your choice (1-4): 

if "%SERVICE_CHOICE%"=="1" (
    set SERVICE_NAME=frontend
) else if "%SERVICE_CHOICE%"=="2" (
    set SERVICE_NAME=help-service
) else if "%SERVICE_CHOICE%"=="3" (
    set SERVICE_NAME=user-service
) else if "%SERVICE_CHOICE%"=="4" (
    goto menu
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 > nul
    goto validate_dns
)

call validate-service-dns.bat %SERVICE_NAME%
echo.
pause
goto menu

:capture_screenshot
cls
echo ===================================================
echo Capture Pod Screenshot
echo ===================================================
echo.
echo Choose a service:
echo  [1] Frontend
echo  [2] Help Service
echo  [3] User Service
echo  [4] All Services
echo  [5] Back to main menu
echo.
set /p SERVICE_CHOICE=Enter your choice (1-5): 

if "%SERVICE_CHOICE%"=="1" (
    set SERVICE_NAME=frontend
) else if "%SERVICE_CHOICE%"=="2" (
    set SERVICE_NAME=help-service
) else if "%SERVICE_CHOICE%"=="3" (
    set SERVICE_NAME=user-service
) else if "%SERVICE_CHOICE%"=="4" (
    echo Capturing screenshots for all services...
    call capture-pod-screenshot.bat frontend
    call capture-pod-screenshot.bat help-service
    call capture-pod-screenshot.bat user-service
    echo.
    pause
    goto menu
) else if "%SERVICE_CHOICE%"=="5" (
    goto menu
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 > nul
    goto capture_screenshot
)

call capture-pod-screenshot.bat %SERVICE_NAME%
echo.
pause
goto menu

:document_api
cls
echo ===================================================
echo Document API Endpoints
echo ===================================================
echo.
echo Choose a service:
echo  [1] Help Service
echo  [2] User Service
echo  [3] Both Services
echo  [4] Back to main menu
echo.
set /p SERVICE_CHOICE=Enter your choice (1-4): 

if "%SERVICE_CHOICE%"=="1" (
    set SERVICE_NAME=help-service
) else if "%SERVICE_CHOICE%"=="2" (
    set SERVICE_NAME=user-service
) else if "%SERVICE_CHOICE%"=="3" (
    echo Generating API documentation for both services...
    call document-api-endpoints.bat help-service
    call document-api-endpoints.bat user-service
    echo.
    pause
    goto menu
) else if "%SERVICE_CHOICE%"=="4" (
    goto menu
) else (
    echo Invalid choice. Please try again.
    timeout /t 2 > nul
    goto document_api
)

call document-api-endpoints.bat %SERVICE_NAME%
echo.
pause
goto menu

:github_push
cls
echo ===================================================
echo Push to GitHub
echo ===================================================
echo.
set /p TEAM_NAME=Enter your team name (e.g., teamX): 
set /p MEMBER_NAME=Enter your name (e.g., memberY): 
set /p COMMIT_MESSAGE=Enter commit message: 

call push-to-github.bat %TEAM_NAME% %MEMBER_NAME% "%COMMIT_MESSAGE%"
echo.
pause
goto menu

:exit
echo.
echo Thank you for using the Kubernetes Microservices Deployment Utility.
echo.
echo Goodbye!
echo.
exit /b 0
