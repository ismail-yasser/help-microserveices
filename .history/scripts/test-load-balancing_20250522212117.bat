@echo off

:: Test load balancing for a service
kubectl get service %1
for /L %%i in (1,1,%3) do curl http://%1%2
