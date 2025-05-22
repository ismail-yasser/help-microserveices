@echo off

:: Validate DNS resolution for a service
kubectl run dns-validation-pod --image=busybox --restart=Never -- nslookup %1
kubectl delete pod dns-validation-pod
