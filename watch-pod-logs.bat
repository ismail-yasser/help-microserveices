@echo off 
setlocal enabledelayedexpansion 
echo Watching help-service and user-service pod logs during load test... 
start cmd /c "kubectl logs -f deployment/help-service-deployment --all-containers" 
start cmd /c "kubectl logs -f deployment/user-service-deployment --all-containers" 
