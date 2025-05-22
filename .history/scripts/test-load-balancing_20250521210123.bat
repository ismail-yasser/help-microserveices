@echo off
echo Testing load balancing for Help Service...
for /L %%i in (1,1,10) do curl http://help-service

echo Testing load balancing for User Service...
for /L %%i in (1,1,10) do curl http://user-service

pause
