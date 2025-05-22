@echo off
setlocal enabledelayedexpansion

echo ===================================================
echo API Documentation Generator
echo ===================================================
echo.

if "%1"=="" (
    echo Please provide a service name: help-service or user-service
    echo Usage: document-api-endpoints.bat [service-name]
    exit /b 1
)

set SERVICE=%1
set OUTPUT_FILE=..\%SERVICE%-api-documentation.md

echo Generating API documentation for %SERVICE%...
echo.

:: Create documentation template based on service
if "%SERVICE%"=="help-service" (
    (
        echo # Help Service API Documentation
        echo.
        echo This document provides details about the Help Service API endpoints, request parameters, and response formats.
        echo.
        echo ## Base URL
        echo.
        echo When running in Kubernetes:
        echo.
        echo - Within cluster: `http://help-service`
        echo - Port forwarded: `http://localhost:3002` ^(if using default port forwarding^)
        echo.
        echo ## Authentication
        echo.
        echo Most endpoints require authentication using a JWT token in the Authorization header:
        echo.
        echo ```
        echo Authorization: Bearer [your-jwt-token]
        echo ```
        echo.
        echo ## Endpoints
        echo.
        echo ### 1. Create Help Request
        echo.
        echo **Endpoint:** `POST /api/help/requests`
        echo.
        echo **Authentication:** Required
        echo.
        echo **Request Body:**
        echo.
        echo ```json
        echo {
        echo   "title": "Help with Math Homework",
        echo   "description": "I need help with calculus problems",
        echo   "category": "Academic",
        echo   "location": "Library",
        echo   "dateTime": "2023-05-20T14:00:00Z"
        echo }
        echo ```
        echo.
        echo **Response:**
        echo.
        echo ```json
        echo {
        echo   "success": true,
        echo   "message": "Help request created successfully",
        echo   "data": {
        echo     "_id": "60a1b2c3d4e5f6g7h8i9j0k1",
        echo     "title": "Help with Math Homework",
        echo     "description": "I need help with calculus problems",
        echo     "category": "Academic",
        echo     "location": "Library",
        echo     "status": "Open",
        echo     "dateTime": "2023-05-20T14:00:00Z",
        echo     "userId": "60a1b2c3d4e5f6g7h8i9j0k2",
        echo     "createdAt": "2023-05-15T10:30:00Z",
        echo     "updatedAt": "2023-05-15T10:30:00Z"
        echo   }
        echo }
        echo ```
        echo.
        echo **CURL Example:**
        echo.
        echo ```bash
        echo curl -X POST http://localhost:3002/api/help/requests \
        echo   -H "Content-Type: application/json" \
        echo   -H "Authorization: Bearer YOUR_JWT_TOKEN" \
        echo   -d '{
        echo     "title": "Help with Math Homework",
        echo     "description": "I need help with calculus problems",
        echo     "category": "Academic",
        echo     "location": "Library",
        echo     "dateTime": "2023-05-20T14:00:00Z"
        echo   }'
        echo ```
        echo.
        echo ### 2. Get All Help Requests
        echo.
        echo **Endpoint:** `GET /api/help/requests`
        echo.
        echo **Authentication:** Required
        echo.
        echo **Query Parameters:**
        echo.
        echo - `status` ^(optional^): Filter by status ^("Open", "InProgress", "Completed"^)
        echo - `category` ^(optional^): Filter by category
        echo - `page` ^(optional, default=1^): Page number
        echo - `limit` ^(optional, default=10^): Number of results per page
        echo.
        echo **Response:**
        echo.
        echo ```json
        echo {
        echo   "success": true,
        echo   "data": {
        echo     "requests": [
        echo       {
        echo         "_id": "60a1b2c3d4e5f6g7h8i9j0k1",
        echo         "title": "Help with Math Homework",
        echo         "description": "I need help with calculus problems",
        echo         "category": "Academic",
        echo         "location": "Library",
        echo         "status": "Open",
        echo         "dateTime": "2023-05-20T14:00:00Z",
        echo         "userId": "60a1b2c3d4e5f6g7h8i9j0k2",
        echo         "createdAt": "2023-05-15T10:30:00Z",
        echo         "updatedAt": "2023-05-15T10:30:00Z"
        echo       },
        echo       // More requests...
        echo     ],
        echo     "pagination": {
        echo       "total": 45,
        echo       "limit": 10,
        echo       "page": 1,
        echo       "pages": 5
        echo     }
        echo   }
        echo }
        echo ```
        echo.
        echo **CURL Example:**
        echo.
        echo ```bash
        echo curl http://localhost:3002/api/help/requests?status=Open&category=Academic&page=1&limit=10 \
        echo   -H "Authorization: Bearer YOUR_JWT_TOKEN"
        echo ```
        echo.
        echo ### 3. Get Help Request by ID
        echo.
        echo **Endpoint:** `GET /api/help/requests/:id`
        echo.
        echo **Authentication:** Required
        echo.
        echo **URL Parameters:**
        echo.
        echo - `id`: The ID of the help request
        echo.
        echo **Response:**
        echo.
        echo ```json
        echo {
        echo   "success": true,
        echo   "data": {
        echo     "_id": "60a1b2c3d4e5f6g7h8i9j0k1",
        echo     "title": "Help with Math Homework",
        echo     "description": "I need help with calculus problems",
        echo     "category": "Academic",
        echo     "location": "Library",
        echo     "status": "Open",
        echo     "dateTime": "2023-05-20T14:00:00Z",
        echo     "userId": {
        echo       "_id": "60a1b2c3d4e5f6g7h8i9j0k2",
        echo       "name": "Jane Doe",
        echo       "email": "jane.doe@example.com"
        echo     },
        echo     "createdAt": "2023-05-15T10:30:00Z",
        echo     "updatedAt": "2023-05-15T10:30:00Z"
        echo   }
        echo }
        echo ```
        echo.
        echo **CURL Example:**
        echo.
        echo ```bash
        echo curl http://localhost:3002/api/help/requests/60a1b2c3d4e5f6g7h8i9j0k1 \
        echo   -H "Authorization: Bearer YOUR_JWT_TOKEN"
        echo ```
        echo.
        echo ## Health Endpoint
        echo.
        echo ### Health Check
        echo.
        echo **Endpoint:** `GET /health`
        echo.
        echo **Authentication:** Not Required
        echo.
        echo **Response:**
        echo.
        echo ```json
        echo {
        echo   "status": "ok",
        echo   "service": "help-service",
        echo   "version": "1.0.0",
        echo   "podName": "help-service-78b66d99df-2abcd",
        echo   "hostname": "node1"
        echo }
        echo ```
        echo.
        echo **CURL Example:**
        echo.
        echo ```bash
        echo curl http://localhost:3002/health
        echo ```
        echo.
    ) > %OUTPUT_FILE%
) else if "%SERVICE%"=="user-service" (
    (
        echo # User Service API Documentation
        echo.
        echo This document provides details about the User Service API endpoints, request parameters, and response formats.
        echo.
        echo ## Base URL
        echo.
        echo When running in Kubernetes:
        echo.
        echo - Within cluster: `http://user-service`
        echo - Port forwarded: `http://localhost:3003` ^(if using default port forwarding^)
        echo.
        echo ## Authentication
        echo.
        echo Some endpoints require authentication using a JWT token in the Authorization header:
        echo.
        echo ```
        echo Authorization: Bearer [your-jwt-token]
        echo ```
        echo.
        echo ## Endpoints
        echo.
        echo ### 1. User Registration
        echo.
        echo **Endpoint:** `POST /api/users/register`
        echo.
        echo **Authentication:** Not required
        echo.
        echo **Request Body:**
        echo.
        echo ```json
        echo {
        echo   "name": "John Doe",
        echo   "email": "john.doe@example.com",
        echo   "password": "securePassword123",
        echo   "confirmPassword": "securePassword123"
        echo }
        echo ```
        echo.
        echo **Response:**
        echo.
        echo ```json
        echo {
        echo   "success": true,
        echo   "message": "User registered successfully",
        echo   "data": {
        echo     "_id": "60a1b2c3d4e5f6g7h8i9j0k1",
        echo     "name": "John Doe",
        echo     "email": "john.doe@example.com",
        echo     "createdAt": "2023-05-15T10:30:00Z",
        echo     "updatedAt": "2023-05-15T10:30:00Z"
        echo   }
        echo }
        echo ```
        echo.
        echo **CURL Example:**
        echo.
        echo ```bash
        echo curl -X POST http://localhost:3003/api/users/register \
        echo   -H "Content-Type: application/json" \
        echo   -d '{
        echo     "name": "John Doe",
        echo     "email": "john.doe@example.com",
        echo     "password": "securePassword123",
        echo     "confirmPassword": "securePassword123"
        echo   }'
        echo ```
        echo.
        echo ### 2. User Login
        echo.
        echo **Endpoint:** `POST /api/users/login`
        echo.
        echo **Authentication:** Not required
        echo.
        echo **Request Body:**
        echo.
        echo ```json
        echo {
        echo   "email": "john.doe@example.com",
        echo   "password": "securePassword123"
        echo }
        echo ```
        echo.
        echo **Response:**
        echo.
        echo ```json
        echo {
        echo   "success": true,
        echo   "message": "Login successful",
        echo   "data": {
        echo     "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
        echo     "user": {
        echo       "_id": "60a1b2c3d4e5f6g7h8i9j0k1",
        echo       "name": "John Doe",
        echo       "email": "john.doe@example.com"
        echo     }
        echo   }
        echo }
        echo ```
        echo.
        echo **CURL Example:**
        echo.
        echo ```bash
        echo curl -X POST http://localhost:3003/api/users/login \
        echo   -H "Content-Type: application/json" \
        echo   -d '{
        echo     "email": "john.doe@example.com",
        echo     "password": "securePassword123"
        echo   }'
        echo ```
        echo.
        echo ### 3. Get User Profile
        echo.
        echo **Endpoint:** `GET /api/users/profile`
        echo.
        echo **Authentication:** Required
        echo.
        echo **Response:**
        echo.
        echo ```json
        echo {
        echo   "success": true,
        echo   "data": {
        echo     "_id": "60a1b2c3d4e5f6g7h8i9j0k1",
        echo     "name": "John Doe",
        echo     "email": "john.doe@example.com",
        echo     "createdAt": "2023-05-15T10:30:00Z",
        echo     "updatedAt": "2023-05-15T10:30:00Z"
        echo   }
        echo }
        echo ```
        echo.
        echo **CURL Example:**
        echo.
        echo ```bash
        echo curl http://localhost:3003/api/users/profile \
        echo   -H "Authorization: Bearer YOUR_JWT_TOKEN"
        echo ```
        echo.
        echo ## Health Endpoint
        echo.
        echo ### Health Check
        echo.
        echo **Endpoint:** `GET /health`
        echo.
        echo **Authentication:** Not Required
        echo.
        echo **Response:**
        echo.
        echo ```json
        echo {
        echo   "status": "ok",
        echo   "service": "user-service",
        echo   "version": "1.0.0",
        echo   "podName": "user-service-78b66d99df-2abcd",
        echo   "hostname": "node1"
        echo }
        echo ```
        echo.
        echo **CURL Example:**
        echo.
        echo ```bash
        echo curl http://localhost:3003/health
        echo ```
        echo.
    ) > %OUTPUT_FILE%
) else (
    echo ERROR: Invalid service name. Choose from: help-service or user-service
    exit /b 1
)

echo.
echo ===================================================
echo API Documentation generated successfully!
echo ===================================================
echo.
echo Documentation file created:
echo - %OUTPUT_FILE%
echo.
echo Next steps:
echo 1. Review and customize the generated documentation
echo 2. Ensure your service implements all documented endpoints
echo 3. Add this documentation to your GitHub repository
echo.

exit /b 0
