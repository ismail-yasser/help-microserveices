@echo off
echo Testing load balancing...

:: Navigate to the project root
cd ..

:: Test Help Service
for /L %%i in (1,1,10) do curl http://help-service

:: Test User Service
for /L %%i in (1,1,10) do curl http://user-service

:: Test Frontend Service
for /L %%i in (1,1,10) do curl http://frontend:3001

pause
