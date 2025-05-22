@echo off
echo Starting Help Service...
start cmd /k "cd services\help-service && npm start"

echo Starting User Service...
start cmd /k "cd services\user-service && npm start"

echo Starting Frontend...
start cmd /k "cd frontend && npm start"

pause
