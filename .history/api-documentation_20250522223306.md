# API Documentation

## Help Service API

### Base URL
`http://help-service:3002` (Internal to Kubernetes cluster)

### Health Endpoints

#### Check Service Health
- **URL**: `/health`
- **Method**: `GET`
- **Response**:
  ```json
  {
    "status": "UP",
    "message": "Help Service is healthy"
  }
  ```

### Help Request Endpoints

#### Get All Help Requests
- **URL**: `/api/help/requests`
- **Method**: `GET`
- **Authentication**: Not required
- **Response**:
  ```json
  [
    {
      "_id": "string",
      "title": "string",
      "description": "string",
      "category": "string",
      "status": "string",
      "location": "string",
      "requesterId": "string",
      "createdAt": "string",
      "updatedAt": "string"
    }
  ]
  ```
- **Example**:
  ```bash
  curl http://help-service:3002/api/help/requests
  ```

#### Get Help Request by ID
- **URL**: `/api/help/requests/:id`
- **Method**: `GET`
- **Authentication**: Not required
- **Parameters**:
  - `id`: Help request ID
- **Response**:
  ```json
  {
    "_id": "string",
    "title": "string",
    "description": "string",
    "category": "string",
    "status": "string",
    "location": "string",
    "requesterId": "string",
    "createdAt": "string",
    "updatedAt": "string"
  }
  ```
- **Example**:
  ```bash
  curl http://help-service:3002/api/help/requests/60d21b4667d0d8992e610c85
  ```

#### Create Help Request
- **URL**: `/api/help/requests`
- **Method**: `POST`
- **Authentication**: Required (JWT token)
- **Request Body**:
  ```json
  {
    "title": "string",
    "description": "string",
    "category": "string",
    "location": "string"
  }
  ```
- **Response**:
  ```json
  {
    "_id": "string",
    "title": "string",
    "description": "string",
    "category": "string",
    "status": "pending",
    "location": "string",
    "requesterId": "string",
    "createdAt": "string",
    "updatedAt": "string"
  }
  ```
- **Example**:
  ```bash
  curl -X POST http://help-service:3002/api/help/requests \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer <token>" \
    -d '{"title": "Need help with groceries", "description": "Cannot go to the store due to illness", "category": "Errands", "location": "New York"}'
  ```

#### Update Help Request
- **URL**: `/api/help/requests/:id`
- **Method**: `PUT`
- **Authentication**: Required (JWT token)
- **Parameters**:
  - `id`: Help request ID
- **Request Body**:
  ```json
  {
    "title": "string",
    "description": "string",
    "category": "string",
    "status": "string",
    "location": "string"
  }
  ```
- **Response**:
  ```json
  {
    "_id": "string",
    "title": "string",
    "description": "string",
    "category": "string",
    "status": "string",
    "location": "string",
    "requesterId": "string",
    "createdAt": "string",
    "updatedAt": "string"
  }
  ```
- **Example**:
  ```bash
  curl -X PUT http://help-service:3002/api/help/requests/60d21b4667d0d8992e610c85 \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer <token>" \
    -d '{"status": "completed"}'
  ```

#### Delete Help Request
- **URL**: `/api/help/requests/:id`
- **Method**: `DELETE`
- **Authentication**: Required (JWT token)
- **Parameters**:
  - `id`: Help request ID
- **Response**:
  ```json
  {
    "message": "Help request deleted successfully"
  }
  ```
- **Example**:
  ```bash
  curl -X DELETE http://help-service:3002/api/help/requests/60d21b4667d0d8992e610c85 \
    -H "Authorization: Bearer <token>"
  ```

## User Service API

### Base URL
`http://user-service:3000` (Internal to Kubernetes cluster)

### Health Endpoints

#### Check Service Health
- **URL**: `/health`
- **Method**: `GET`
- **Response**:
  ```json
  {
    "status": "UP",
    "message": "User Service is healthy"
  }
  ```

### User Endpoints

#### Register User
- **URL**: `/api/users/register`
- **Method**: `POST`
- **Authentication**: Not required
- **Request Body**:
  ```json
  {
    "username": "string",
    "email": "string",
    "password": "string",
    "name": "string"
  }
  ```
- **Response**:
  ```json
  {
    "id": "string",
    "username": "string",
    "email": "string",
    "name": "string",
    "token": "string"
  }
  ```
- **Example**:
  ```bash
  curl -X POST http://user-service:3000/api/users/register \
    -H "Content-Type: application/json" \
    -d '{"username": "john_doe", "email": "john@example.com", "password": "securepassword", "name": "John Doe"}'
  ```

#### Login User
- **URL**: `/api/users/login`
- **Method**: `POST`
- **Authentication**: Not required
- **Request Body**:
  ```json
  {
    "email": "string",
    "password": "string"
  }
  ```
- **Response**:
  ```json
  {
    "id": "string",
    "username": "string",
    "email": "string",
    "name": "string",
    "token": "string"
  }
  ```
- **Example**:
  ```bash
  curl -X POST http://user-service:3000/api/users/login \
    -H "Content-Type: application/json" \
    -d '{"email": "john@example.com", "password": "securepassword"}'
  ```

#### Get User Profile
- **URL**: `/api/users/profile`
- **Method**: `GET`
- **Authentication**: Required (JWT token)
- **Response**:
  ```json
  {
    "id": "string",
    "username": "string",
    "email": "string",
    "name": "string"
  }
  ```
- **Example**:
  ```bash
  curl http://user-service:3000/api/users/profile \
    -H "Authorization: Bearer <token>"
  ```

#### Update User Profile
- **URL**: `/api/users/profile`
- **Method**: `PUT`
- **Authentication**: Required (JWT token)
- **Request Body**:
  ```json
  {
    "username": "string",
    "email": "string",
    "name": "string",
    "password": "string"
  }
  ```
- **Response**:
  ```json
  {
    "id": "string",
    "username": "string",
    "email": "string",
    "name": "string"
  }
  ```
- **Example**:
  ```bash
  curl -X PUT http://user-service:3000/api/users/profile \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer <token>" \
    -d '{"name": "John Smith"}'
  ```

## Frontend Service

### Base URL
`http://frontend:3001` (Internal to Kubernetes cluster)
`http://<node-ip>:30080` (External access via NodePort)

The frontend serves a React application that interacts with the help-service and user-service APIs.

### Pages

1. **Login Page** - `/login`
2. **Signup Page** - `/signup`
3. **Help Request List** - `/`
4. **Help Request Detail** - `/request/:id`
5. **Create Help Request** - `/create-request`
6. **Create Help Offer** - `/create-offer`

### Example Access
```bash
curl http://frontend:3001/
```

## Load Balancing

All services are deployed with multiple replicas and Kubernetes handles load balancing automatically through service objects. Requests to any service name (e.g., `help-service`) are distributed across all available pods for that service.

### Testing Load Balancing
```bash
for i in {1..10}; do curl http://help-service:3002/health; done
```

This will distribute requests across all help-service pods in a round-robin fashion.
