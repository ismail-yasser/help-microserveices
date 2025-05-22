@echo off
echo Starting services locally...

:: Navigate to the project root
cd ..

:: Start Help Service
start cmd /k "cd services\help-service && npm start"

:: Start User Service
start cmd /k "cd services\user-service && npm start"

:: Start Frontend
start cmd /k "cd frontend && npm start"

pause
