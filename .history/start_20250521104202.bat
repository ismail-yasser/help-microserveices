@echo off

:: Start User Service
start cmd /k "cd services\user-service && node index.js"

:: Start Help Service
start cmd /k "cd services\help-service && node index.js"




