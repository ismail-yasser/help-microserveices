### API Endpoints for Help Service

- **GET /api/help**
  - **Description**: Fetch all help requests.
  - **Response**: JSON array of help requests.
  - **Example**:
    ```bash
    curl -X GET http://<service-dns>/api/help
    ```

- **GET /health**
  - **Description**: Health check endpoint for Kubernetes liveness probe.
  - **Response**: `{"status":"UP","message":"Help Service is healthy"}`
  - **Example**:
    ```bash
    curl -X GET http://<service-dns>/health
    ```

- **GET /ready**
  - **Description**: Readiness check endpoint for Kubernetes readiness probe.
  - **Response**: `{"status":"READY","message":"Help Service is ready"}` if database is connected, otherwise returns 503 status code.
  - **Example**:
    ```bash
    curl -X GET http://<service-dns>/ready
    ```

- **POST /api/help**
  - **Description**: Create a new help request.
  - **Request Body**: `{ "title": "Need help", "description": "Details" }`
  - **Response**: Created help request.
  - **Example**:
    ```bash
    curl -X POST -H "Content-Type: application/json" -d '{"title":"Need help","description":"Details"}' http://<service-dns>/api/help
    ```

### API Endpoints for User Service

- **GET /api/users**
  - **Description**: Fetch all users.
  - **Response**: JSON array of users.
  - **Example**:
    ```bash
    curl -X GET http://<service-dns>/api/users
    ```

- **POST /api/users**
  - **Description**: Create a new user.
  - **Request Body**: `{ "name": "John Doe", "email": "john@example.com" }`
  - **Response**: Created user.
  - **Example**:
    ```bash
    curl -X POST -H "Content-Type: application/json" -d '{"name":"John Doe","email":"john@example.com"}' http://<service-dns>/api/users
    ```

### API Endpoints for Frontend

- **GET /**
  - **Description**: Fetch the main frontend page.
  - **Response**: HTML content of the frontend.
  - **Example**:
    ```bash
    curl -X GET http://<frontend-dns>/
    ```