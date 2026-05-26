<div align="center">

# ⚡ Distributed Real-Time API Rate Limiter ⚡

### High-Performance Distributed Backend System Built with C++, Redis & Crow

<p align="center">
  <img src="https://img.shields.io/badge/C%2B%2B-17-blue?style=for-the-badge&logo=c%2B%2B">
  <img src="https://img.shields.io/badge/Redis-InMemory-red?style=for-the-badge&logo=redis">
  <img src="https://img.shields.io/badge/Crow-Web_Framework-green?style=for-the-badge">
  <img src="https://img.shields.io/badge/System-Design-orange?style=for-the-badge">
  <img src="https://img.shields.io/badge/Distributed-Systems-purple?style=for-the-badge">
</p>

<p align="center">
  <b>Production-Inspired Backend Engineering Project</b>
</p>

---

### 🚀 Built to Simulate Real-World API Infrastructure Used in Modern Distributed Systems

</div>

---

# 🔥 Overview

This project is a **Real-Time Distributed API Rate Limiter** designed to simulate how modern backend systems protect APIs from abuse, spam traffic, and overload.

The system:

✅ Tracks incoming API requests in real-time  
✅ Stores counters inside Redis  
✅ Allows only **5 requests per minute per user**  
✅ Returns **429 Too Many Requests** after limit exceeds  
✅ Uses low-latency Redis operations for ultra-fast performance  
✅ Follows modular backend engineering architecture  
✅ Demonstrates core distributed systems concepts  

---

# ⚡ Why This Project Exists

Modern systems like:

- Netflix
- Cloudflare
- Discord
- Stripe
- Uber
- AWS API Gateway

all use some form of:

- Rate Limiting
- Distributed Counters
- Traffic Protection
- API Throttling

Without rate limiting:

❌ APIs get spammed  
❌ Servers crash under heavy traffic  
❌ Bots abuse infrastructure  
❌ DDoS attacks become easier  

This project demonstrates the foundational architecture behind those systems.

---

# 🏗️ System Architecture

<div align="center">

```text
                         ┌────────────────────┐
                         │      POSTMAN       │
                         │  API Client/User   │
                         └─────────┬──────────┘
                                   │
                                   ▼
                    ┌──────────────────────────┐
                    │      CROW API SERVER     │
                    │  HTTP Request Handling   │
                    └──────────┬───────────────┘
                               │
                               ▼
                    ┌──────────────────────────┐
                    │    RATE LIMITER ENGINE   │
                    │       (C++ Logic)        │
                    └──────────┬───────────────┘
                               │
                               ▼
                    ┌──────────────────────────┐
                    │          REDIS           │
                    │ Distributed Request Store│
                    └──────────────────────────┘
```

</div>

---

# 🧠 Core Engineering Concepts

This project demonstrates:

| Concept | Description |
|---|---|
| REST APIs | HTTP communication between client and server |
| Backend Engineering | Building scalable server-side systems |
| Redis | In-memory distributed datastore |
| Distributed Systems | Shared counters across multiple servers |
| Rate Limiting | Controlling API traffic |
| Low Latency | Fast response architecture |
| Scalability | Handling large traffic efficiently |
| Modular Design | Clean maintainable architecture |
| Object-Oriented Programming | Encapsulated backend components |

---

# 🚀 Features

## ✅ Real-Time Request Tracking

Tracks users using unique IDs.

---

## ✅ Redis-Based Distributed Counters

All request counts are stored in Redis for:

- Speed
- Scalability
- Shared state across servers

---

## ✅ Fixed Window Rate Limiting

Allows:

```text
5 Requests / 60 Seconds
```

---

## ✅ Automatic Counter Reset

Redis automatically expires counters using:

```redis
EXPIRE
```

---

## ✅ Production-Style HTTP Responses

### Allowed

```json
{
  "status": "allowed"
}
```

### Blocked

```json
{
  "status": "blocked"
}
```

HTTP Status:

```http
429 Too Many Requests
```

---

# ⚙️ Tech Stack

<div align="center">

| Technology | Role |
|---|---|
| **C++17** | Core Backend Logic |
| **Crow** | HTTP API Framework |
| **Redis** | Distributed In-Memory Store |
| **hiredis** | Redis Client |
| **CMake** | Build System |
| **Postman** | API Testing |
| **Git/GitHub** | Version Control |

</div>

---

# 📂 Project Structure

```text
distributed-rate-limiter/
│
├── include/
│   ├── rate_limiter.h
│   └── redis_client.h
│
├── src/
│   ├── main.cpp
│   ├── rate_limiter.cpp
│   └── redis_client.cpp
│
├── external/
│   └── crow_all.h
│
├── build/
│
├── CMakeLists.txt
├── README.md
└── .gitignore
```

---

# ⚡ Request Flow

```text
Client Request
      ↓
Crow HTTP Server
      ↓
Rate Limiter Logic
      ↓
Redis Counter Increment
      ↓
Check Request Count
      ↓
Allow / Block User
      ↓
JSON Response Returned
```

---

# 🧮 Redis Internals

The project uses two extremely important Redis commands:

---

## Increment Request Counter

```redis
INCR user123
```

Example:

```text
0 → 1
1 → 2
2 → 3
```

---

## Auto Expire Counter

```redis
EXPIRE user123 60
```

Redis automatically deletes the counter after:

```text
60 seconds
```

This resets the rate limit window.

---

# 📡 API Documentation

# POST `/request`

---

## Request Headers

```http
Content-Type: application/json
```

---

## Request Body

```json
{
  "user": "user123"
}
```

---

# ✅ Success Response

```json
{
  "status": "allowed"
}
```

HTTP Status:

```http
200 OK
```

---

# ❌ Rate Limited Response

```json
{
  "status": "blocked"
}
```

HTTP Status:

```http
429 Too Many Requests
```

---

# 🧪 Postman Testing

### Endpoint

```text
http://localhost:18080/request
```

---

### Method

```text
POST
```

---

### Example Body

```json
{
  "user": "backend_engineer"
}
```

---

# ⚡ Expected Output

| Request Number | Result |
|---|---|
| 1 | ✅ Allowed |
| 2 | ✅ Allowed |
| 3 | ✅ Allowed |
| 4 | ✅ Allowed |
| 5 | ✅ Allowed |
| 6 | ❌ Blocked |

After 60 seconds:

```text
Counter resets automatically
```

---

# 🛠️ Installation & Setup

# 1️⃣ Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/distributed-rate-limiter.git
```

---

# 2️⃣ Enter Project

```bash
cd distributed-rate-limiter
```

---

# 3️⃣ Install Redis

## Ubuntu/Linux

```bash
sudo apt update
sudo apt install redis-server
```

---

# 4️⃣ Start Redis

```bash
redis-server
```

Verify:

```bash
redis-cli ping
```

Expected:

```text
PONG
```

---

# 5️⃣ Install hiredis

```bash
sudo apt install libhiredis-dev
```

---

# 5.1️⃣ Install Crow (single-header)

Crow is a header-only C++ microframework. Copy the single header `crow_all.h` into the `external/` folder.

Linux/macOS (quick):

```bash
mkdir -p external
curl -sSL https://raw.githubusercontent.com/CrowCpp/Crow/master/include/crow_all.h -o external/crow_all.h
```

Windows (quick): download `crow_all.h` from the Crow repo and place it into the `external\` folder.

If you prefer package managers, install via `vcpkg` or your distro packages and update include paths accordingly.

---

# 6️⃣ Build Project

```bash
mkdir build
cd build

cmake ..
make
```

---

# 7️⃣ Run Server

```bash
./rate_limiter
```

Expected:

```text
Connected to Redis!
Crow server is running on port 18080
```

---

# 📈 Scalability

This project is designed around distributed systems principles.

Multiple backend servers can share the same Redis instance:

```text
              ┌──────────────┐
              │ API Server 1 │
              └──────┬───────┘
                     │
                     ▼
              ┌──────────────┐
              │    Redis     │
              └──────▲───────┘
                     │
              ┌──────┴───────┐
              │ API Server 2 │
              └──────────────┘
```

This enables:

✅ Shared request counters  
✅ Horizontal scalability  
✅ Distributed traffic management  

---

# ⚡ Why Redis?

Redis is perfect for rate limiting because it provides:

| Feature | Benefit |
|---|---|
| In-Memory Storage | Ultra-fast operations |
| Low Latency | Millisecond responses |
| Atomic Operations | Safe concurrent counting |
| Expiry Support | Automatic counter resets |
| Distributed Access | Shared state across servers |

---

# 🧠 System Design Insights

This project introduces real backend engineering concepts:

- Distributed Counters
- Shared State Management
- Traffic Throttling
- API Protection
- Horizontal Scaling
- Low-Latency Infrastructure
- High Throughput Systems

---

# 🚀 Future Improvements

Potential production-level upgrades:

- Sliding Window Algorithm
- Token Bucket Algorithm
- JWT Authentication
- Docker Deployment
- Redis Cluster
- Prometheus Metrics
- Grafana Dashboard
- Kubernetes
- NGINX Reverse Proxy
- Async Redis Operations
- Logging & Monitoring

---

# 🐳 Future Docker Support

```bash
docker-compose up
```

Containerization support can be added for production-ready deployment.

---

# 🌍 Real-World Applications

This architecture is commonly used in:

- API Gateways
- Payment Systems
- Authentication Services
- CDN Infrastructure
- SaaS Platforms
- Cloud Systems
- Microservices
- Distributed Applications

---

# 📚 Learning Outcomes

By building this project, you gain practical understanding of:

✅ Backend Engineering  
✅ REST API Development  
✅ Redis Fundamentals  
✅ Distributed Systems  
✅ Rate Limiting Algorithms  
✅ System Design Principles  
✅ C++ Server Development  
✅ Real-Time Architecture  
✅ API Security Concepts  

---

# 🤝 Contributing

Contributions are welcome.

Feel free to:

- Fork the repository
- Improve performance
- Add new algorithms
- Enhance scalability
- Add monitoring support

---

# 📜 License

MIT License

---

# 👨‍💻 Author

### Built with C++, Redis & Distributed Systems Concepts

If you found this project useful:

⭐ Star the repository  
🍴 Fork the project  
🚀 Build something awesome  

---

<div align="center">

# ⭐ STAR THIS REPOSITORY IF YOU LIKE DISTRIBUTED SYSTEMS ⭐

</div>