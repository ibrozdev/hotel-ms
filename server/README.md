# Hotel Management System Backend

## Overview

This backend is a REST API built with Node.js (Express) and MongoDB, designed for a hotel management system. It consists of modules for Authentication, Service Management, Bookings, and Administrative Analytics. Below is the documentation of the endpoints and how to use them.

--- 
## Table of Contents

- [Authentication](#authentication)
- [Service Management](#Service-Management)
- [Booking Endpoints](#Booking-Endpoints)
- [Admin Analytics](#Admin-Analytics)
- [Environment Configuration](#Environment-Configuration )
---

## Authentication


### 1. User/Admin Login

**Endpoint:** `POST /api/auth/login`

**Body:**

```json
{
    "email": "admin@gmail.com",
    "password": "Password123"
}
```

**Response:**

- 200: `{ message: "Login successful", user: { ... } }`
- 401: `{ message: "Invalid email or password" }`

**Example (fetch):**

```js
fetch("http://localhost:5000/api/auth/login", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    email: "admin@gmail.com",
    password: "Password123",
  }),
})
  .then((res) => res.json())
  .then(console.log);
```



### 2. User Registration

**Endpoint:** `POST /api/users/register`

**Body:**
```json
{
    "name": "Admin Ibra",
    "email": "admin@gmail.com",
    "password": "Password123",
    "role": "admin"
}
```

**Example (fetch):**
```js
fetch("http://localhost:5000/api/users/register", {
  method: "POST",
  headers: { "Content-Type": "application/json" },
  body: JSON.stringify({
    name: "John Doe",
    email: "john@example.com",
    password: "securepassword123",
  }),
})
  .then((res) => res.json())
  .then(console.log);
```

## Service Management

**Note: Creating, updating, or deleting services requires admin authentication.**

## 1. Create Service

**Endpoint:** ` POST /api/services/create`
### Service  CRUD

- **Create Service:**
    - `POST /api/services/create`
    **Data** 
    ```js
    Data (FormData):
    const data = new FormData();
    data.append("serviceName", "Luxury VIP Suite");
    data.append("image", fileInput.files[0]); // Supports images up to 30MB
    data.append("price", "250");
    data.append("category", "Room");
    data.append("type","King Size")
    data.append("description","A beautiful luxury room")
    ```

- **Example (fetch):**
    ```js
    fetch("http://localhost:5000/api/services/create", {
        method: "POST",
        headers: { "Authorization": "Bearer YOUR_JWT_TOKEN_HERE" },
        body: data,
    })
        .then((res) => res.json())
        .then(console.log)
        .catch(console.error);
    ```
``` 
```
### 2. update service 

- **Update Service:**

  - `PUT /api/services/update/:id`
  - **Body:**

    ```js
    const data = new FormData();
    data.append("serviceName", "Luxury VIP Suite");
    data.append("image", fileInput.files[0]); // Supports images up to 30MB
    data.append("price", "250");
    data.append("category", "Room");
    data.append("type","King Size")
    data.append("description","A beautiful luxury room")
    ```

  - **Example (fetch):**
    ```js
    fetch("http://localhost:5000/api/services/update/1", {
      method: "PUT",
      body: data,
    })
      .then((res) => res.json())
      .then(console.log);
    ```

### 3. Get All Services (With Search & Filter)

**Endpoint:** `GET /api/services/getservice`
**Description: Search by name or filter by category and price.**
// Search for "Luxury" rooms under $300
- **Get All Candidates:**
  - `GET /services/getservice`
  - **Example (fetch):**
    ```js
    fetch("http://localhost:5000/api/services/getservice?search=Luxury&price")
      .then((res) => res.json())
      .then(console.log);
    ```

### 4. get service by id 
- **Get One service:**
  - `GET /api/services/update/:id`
  - **Example (fetch):**
    ```js
    fetch("http://localhost:5000/api/services/update/1")
      .then((res) => res.json())
      .then(console.log);
    ```

### 5. delete serivce
- **Delete service:**
  - `DELETE /api/services/update/:id`
  - **Example (fetch):**
    ```js
    fetch("http://localhost:5000/api/services/delete/1", {
      method: "DELETE",
    })
      .then((res) => res.json())
      .then(console.log);
    ```


### Booking Endpoints

### 1. Create Booking

**Endpoint:** `POST /api/booking/create`

- **Body:**
```json
{
    "user": "{{userId}}",
    "service": "{{serviceId}}",
    "checkInDate": "2026-02-01",
    "checkOutDate": "2026-02-05",
}
```


- **Example (fetch):**
```js
fetch("http://localhost:5000/api/booking/create", {
  method: "POST",
  headers: { 
    "Content-Type": "application/json",
    "Authorization": "Bearer YOUR_JWT_TOKEN_HERE" 
  },
  body: JSON.stringify({
    user: "76ndbsafhsd...."
    service: "65badc...",
    checkInDate: "2026-02-10",
    checkOutDate: "2026-02-15",
  }),
})
  .then((res) => res.json())
  .then(console.log);
```

### 2. Get My Bookings

**Endpoint:**` GET /api/booking/mybooking`

- **Example (fetch):**
```js
fetch("http://localhost:5000/api/booking/mybooking/", {
  method: "GET",
  headers: { 
    "Authorization": "Bearer YOUR_JWT_TOKEN_HERE" 
  },
})
  .then((res) => res.json())
  .then(console.log);
```
### 3. GET A bookings 

**Endpoint:**` GET /api/booking/getbooking`

- **Example (fetch):**
```js
fetch("http://localhost:5000/api/booking/getbooking", {
  method: "GET",
  headers: { 
    "Authorization": "Bearer YOUR_JWT_TOKEN_HERE" 
  },
})
  .then((res) => res.json())
  .then(console.log);
```

### 4. delete or  cancel booking 
- **Delete Booking or cancel :**
  - `DELETE /api/booking/delete/:id`
  - **Example (fetch):**
    ```js
    fetch("http://localhost:5000/api/booking/delete/1", {
      method: "DELETE",
    })
      .then((res) => res.json())
      .then(console.log);
    ```
### Admin Analytics

### 1. Revenue Statistics

**Endpoint:**` GET /api/booking/stats`

**Description: Get total revenue, total booking counts, and average prices.**
**Example (fetch):**
```js
fetch("http://localhost:5000/api/booking/stats", {
  method: "GET",
  headers: { 
    "Authorization": "Bearer ADMIN_JWT_TOKEN_HERE" 
  },
})
  .then((res) => res.json())
  .then(console.log);
```

### Environment Configuration

**Ensure your .env file is set up correctly:**

MONGO_URI=your_mongodb_connection_string
JWT_SECRET=your_jwt_secret_key
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
PORT=5000
