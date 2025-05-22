@echo off

:: Start User Service
start cmd /k "cd services\user-service && node index.js"

:: Start Resource Service
start cmd /k "cd services\resource-service && node index.js"

:: Start Help Service
start cmd /k "cd services\help-service && node index.js"

:: Start Gamification Service
start cmd /k "cd services\gamification-service && node index.js"

:: Start Notification Service
start cmd /k "cd services\notification-service && node index.js"

:: Start Study Group Service
start cmd /k "cd services\study-group-service && node index.js"
