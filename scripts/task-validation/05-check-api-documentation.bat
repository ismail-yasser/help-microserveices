@echo off
echo ========================================
echo TASK 5: API DOCUMENTATION
echo ========================================
echo.

echo Checking API documentation files...
echo.

if exist "..\..\Document API Endpoints.md" (
    echo   ✅ Main API documentation exists
    echo      File: Document API Endpoints.md
) else (
    echo   ❌ Main API documentation missing
)

if exist "..\..\services\user-service\README.md" (
    echo   ✅ User Service documentation exists
) else (
    echo   ❌ User Service documentation missing
)

if exist "..\..\services\help-service\README.md" (
    echo   ✅ Help Service documentation exists
) else (
    echo   ❌ Help Service documentation missing
)

if exist "full-services.postman_collection.json" (
    echo   ✅ Postman collection exists
    echo      File: full-services.postman_collection.json
) else (
    echo   ❌ Postman collection missing
)

echo.
echo Checking documentation content...
echo.

if exist "Document API Endpoints.md" (
    findstr /i "curl\|GET\|POST\|PUT\|DELETE" "Document API Endpoints.md" >nul
    if %errorlevel% equ 0 (
        echo   ✅ API documentation contains HTTP methods and curl examples
    ) else (
        echo   ⚠️  API documentation might be incomplete
    )
)

echo.
echo Documentation files found:
dir /b *.md 2>nul
dir /b docs\*.md 2>nul
dir /b *.json | findstr -i "postman\|api"

echo.
echo ========================================
echo TASK 5 VALIDATION COMPLETE
echo ========================================
pause
