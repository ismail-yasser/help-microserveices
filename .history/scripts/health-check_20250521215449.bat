@echo off
echo Checking health of services...

:: Navigate to the project root
cd ..

:: Check Help Service
curl http://help-service/health

:: Check User Service
curl http://user-service/health

:: Check Frontend
curl http://frontend/health

pause
