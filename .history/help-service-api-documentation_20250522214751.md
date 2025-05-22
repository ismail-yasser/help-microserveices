# Help Service API Documentation

This document provides details about the Help Service API endpoints, request parameters, and response formats.

## Base URL

When running in Kubernetes:

- Within cluster: `http://help-service`
- Port forwarded: `http://localhost:3002` (if using default port forwarding)

## Authentication

Most endpoints require authentication using a JWT token in the Authorization header:

```
Authorization: Bearer [your-jwt-token]
```

## Endpoints

### 1. Create Help Request
- **URL**: `/api/help/requests`
- **Method**: POST
- **Headers**:
  - `Content-Type: application/json`
  - `Authorization: Bearer <token>`
- **Request Body**:
  ```json
  {
    "title": "Need groceries",
    "description": "I need someone to help me buy groceries.",
    "location": "123 Main St, City, Country"
  }
  ```
- **Response**:
  - **201 Created**:
    ```json
    {
      "id": "12345",
      "title": "Need groceries",
      "description": "I need someone to help me buy groceries.",
      "location": "123 Main St, City, Country",
      "status": "open"
    }
    ```
  - **400 Bad Request**: Invalid input.

- **Example (curl)**:
  ```bash
  curl -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer <token>" \
    -d '{"title":"Need groceries","description":"I need someone to help me buy groceries.","location":"123 Main St, City, Country"}' \
    http://<host>/api/help/requests
  ```

### 2. Get Help Requests
- **URL**: `/api/help/requests`
- **Method**: GET
- **Headers**:
  - `Authorization: Bearer <token>`
- **Response**:
  - **200 OK**:
    ```json
    [
      {
        "id": "12345",
        "title": "Need groceries",
        "description": "I need someone to help me buy groceries.",
        "location": "123 Main St, City, Country",
        "status": "open"
      }
    ]
    ```

- **Example (curl)**:
  ```bash
  curl -X GET \
    -H "Authorization: Bearer <token>" \
    http://<host>/api/help/requests
  ```

### 3. Get All Help Requests

**Endpoint:** `GET /api/help/requests`

**Authentication:** Required

**Query Parameters:**

- `status` (optional): Filter by status ("Open", "InProgress", "Completed")
- `category` (optional): Filter by category
- `page` (optional, default=1): Page number
- `limit` (optional, default=10): Number of results per page

**Response:**

```json
{
  "success": true,
  "data": {
    "requests": [
      {
        "_id": "60a1b2c3d4e5f6g7h8i9j0k1",
        "title": "Help with Math Homework",
        "description": "I need help with calculus problems",
        "category": "Academic",
        "location": "Library",
        "status": "Open",
        "dateTime": "2023-05-20T14:00:00Z",
        "userId": "60a1b2c3d4e5f6g7h8i9j0k2",
        "createdAt": "2023-05-15T10:30:00Z",
        "updatedAt": "2023-05-15T10:30:00Z"
      },
      // More requests...
    ],
    "pagination": {
      "total": 45,
      "limit": 10,
      "page": 1,
      "pages": 5
    }
  }
}
```

**CURL Example:**

```bash
curl http://localhost:3002/api/help/requests?status=Open
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 4. Get Help Request by ID

**Endpoint:** `GET /api/help/requests/:id`

**Authentication:** Required

**URL Parameters:**

- `id`: The ID of the help request

**Response:**

```json
{
  "success": true,
  "data": {
    "_id": "60a1b2c3d4e5f6g7h8i9j0k1",
    "title": "Help with Math Homework",
    "description": "I need help with calculus problems",
    "category": "Academic",
    "location": "Library",
    "status": "Open",
    "dateTime": "2023-05-20T14:00:00Z",
    "userId": {
      "_id": "60a1b2c3d4e5f6g7h8i9j0k2",
      "name": "Jane Doe",
      "email": "jane.doe@example.com"
    },
    "createdAt": "2023-05-15T10:30:00Z",
    "updatedAt": "2023-05-15T10:30:00Z"
  }
}
```

**CURL Example:**

```bash
curl http://localhost:3002/api/help/requests/60a1b2c3d4e5f6g7h8i9j0k1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Health Endpoint

### Health Check

**Endpoint:** `GET /health`

**Authentication:** Not Required

**Response:**

```json
{
  "status": "ok",
  "service": "help-service",
  "version": "1.0.0",
  "podName": "help-service-78b66d99df-2abcd",
  "hostname": "node1"
}
```

**CURL Example:**

```bash
curl http://localhost:3002/health
```

