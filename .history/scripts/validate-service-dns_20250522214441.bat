@echo off
:: Validate DNS resolution for all services

:: Validate help-service DNS
echo Validating DNS for help-service...
kubectl run dns-validation-pod --image=busybox --restart=Never -- nslookup help-service
kubectl delete pod dns-validation-pod --force --grace-period=0

:: Validate user-service DNS
echo Validating DNS for user-service...
kubectl run dns-validation-pod --image=busybox --restart=Never -- nslookup user-service
kubectl delete pod dns-validation-pod --force --grace-period=0

:: Validate frontend DNS
echo Validating DNS for frontend...
kubectl run dns-validation-pod --image=busybox --restart=Never -- nslookup frontend
kubectl delete pod dns-validation-pod --force --grace-period=0

echo DNS validation completed for all services!