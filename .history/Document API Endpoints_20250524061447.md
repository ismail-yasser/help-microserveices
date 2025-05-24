# API Endpoints Documentation

## User Service API

**Base URL (within cluster):**  
`http://user-service:3000`

### Endpoints

#### 1. `/`
- **Method:** GET  
- **Description:** Returns a simple status message and the pod hostname (useful for debugging/load balancing).
- **Response Example:**
  ```json
  {
    "message": "User Service is running",
    "hostname": "user-service-deployment-xxxx"
  }
  ```

#### 2. `/health`
- **Method:** GET  
- **Description:** Health check endpoint. Returns service health and pod hostname.
- **Response Example:**
  ```json
  {
    "status": "UP",
    "message": "User Service is healthy",
    "hostname": "user-service-deployment-xxxx"
  }
  ```

#### 3. `/ready`
- **Method:** GET  
- **Description:** Readiness check. Returns 200 if DB is connected, 503 otherwise, with pod hostname.
- **Success Response:**
  ```json
  {
    "status": "READY",
    "message": "User Service is ready",
    "hostname": "user-service-deployment-xxxx"
  }
  ```
- **Error Response:**
  ```json
  {
    "status": "NOT READY",
    "message": "Database connection not ready",
    "hostname": "user-service-deployment-xxxx"
  }
  ```

#### 4. `/api/users` (and subroutes)
- **Method:** Varies (GET, POST, PUT, DELETE)
- **Description:** User management endpoints (register, login, get user info, etc.)
- **Authentication:** Most endpoints require `Authorization: Bearer <JWT_TOKEN>` header.
- **Example:**
  - **POST** `/api/users/register`
    - **Request Body:**
      ```json
      {
        "username": "alice",
        "email": "alice@example.com",
        "password": "password123"
      }
      ```
    - **Success Response:**
      ```json
      {
        "message": "User registered successfully",
        "userId": "abc123"
      }
      ```
    - **Error Response:**
      ```json
      {
        "error": "Email already exists"
      }
      ```

  - **POST** `/api/users/login`
    - **Request Body:**
      ```json
      {
        "email": "alice@example.com",
        "password": "password123"
      }
      ```
    - **Success Response:**
      ```json
      {
        "token": "<JWT_TOKEN>",
        "user": { "id": "abc123", "username": "alice", "email": "alice@example.com" }
      }
      ```
    - **Error Response:**
      ```json
      {
        "error": "Invalid credentials"
      }
      ```

---

## Help Service API

**Base URL (within cluster):**  
`http://help-service:3002`

### Endpoints

#### 1. `/`
- **Method:** GET  
- **Description:** Returns a status message, DB connection status, and pod hostname.
- **Response Example:**
  ```json
  {
    "message": "Help Service is running. Database status: Connected to MongoDB",
    "hostname": "help-service-deployment-xxxx"
  }
  ```

#### 2. `/health`
- **Method:** GET  
- **Description:** Health check endpoint. Returns service health and pod hostname.
- **Response Example:**
  ```json
  {
    "status": "UP",
    "message": "Help Service is healthy",
    "hostname": "help-service-deployment-xxxx"
  }
  ```

#### 3. `/ready`
- **Method:** GET  
- **Description:** Readiness check. Returns 200 if DB is connected, 503 otherwise, with pod hostname.
- **Success Response:**
  ```json
  {
    "status": "READY",
    "message": "Help Service is ready",
    "hostname": "help-service-deployment-xxxx"
  }
  ```
- **Error Response:**
  ```json
  {
    "status": "NOT READY",
    "message": "Database connection not ready",
    "hostname": "help-service-deployment-xxxx"
  }
  ```

#### 4. `/api/help` (and subroutes)
- **Method:** Varies (GET, POST, PUT, DELETE)
- **Description:** Help ticket management endpoints (create ticket, get tickets, update, etc.)
- **Authentication:** Most endpoints require `Authorization: Bearer <JWT_TOKEN>` header.
- **Example:**
  - **POST** `/api/help/tickets`
    - **Request Body:**
      ```json
      {
        "title": "Cannot log in",
        "description": "I forgot my password"
      }
      ```
    - **Success Response:**
      ```json
      {
        "message": "Ticket created successfully",
        "ticketId": "xyz789"
      }
      ```
    - **Error Response:**
      ```json
      {
        "error": "Missing required fields"
      }
      ```

---

**Note:**
- All endpoints returning sensitive or user-specific data require a valid JWT in the `Authorization` header.
- Replace example hostnames with actual pod names as returned by the service.
