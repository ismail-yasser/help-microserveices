@echo off
echo Checking health of Help Service...
curl http://help-service/health

echo Checking health of User Service...
curl http://user-service/health

echo Checking health of Frontend...
curl http://frontend/health

pause
