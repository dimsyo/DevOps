# 📦 Project 2: Microservices Containerization with Docker Compose & Security Scan

![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=for-the-badge&logo=fastapi)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-DC382D?style=for-the-badge&logo=redis&logoColor=white)
![Nginx](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![Trivy](https://img.shields.io/badge/Trivy-1904DA?style=for-the-badge&logo=aquasec&logoColor=white)

Project 2 mengimplementasikan kontainerisasi arsitektur **3-Tier Microservices** yang aman, scalable, dan ter-orchestrate secara otomatis menggunakan **Docker Compose**, multi-stage build `Dockerfile` dengan non-root user `appuser`, serta dipindai dari kerentanan keamanan menggunakan **Trivy Vulnerability Scanner**.

---

## 🏗️ Arsitektur Sistem

```text
                                [ Client Request ]
                                        │
                                        ▼ (Port 8080)
                         [ Nginx Reverse Proxy Container ]
                                        │
                                        ▼ (Internal Network: microservices-net)
                       [ Python FastAPI App Container ]
                       (Multi-stage Build, UID: 10001)
                                │               │
                                ▼               ▼
                    [PostgreSQL Container]   [Redis Container]
                    (Volume: db_data)        (Volume: redis_data)
```

---

## 🚀 Fitur Utama & Hardening Keamanan

1. **Multi-Stage Build Dockerfile (`app/Dockerfile`):**
   * Menggunakan base image `python:3.11-slim` yang ringan.
   * Menjaga ukuran image tetap minimal dengan memisahkan stage dependency builder.
   * Memastikan aplikasi berjalan sebagai non-root user `appuser` (UID: `10001`) untuk mencegah privilege escalation.
2. **Reverse Proxy & Load Balancer (`nginx/`):**
   * Nginx berjalan pada port `8080` dan melakukan forwarding trafik secara terisolasi ke container `fastapi-app:8000`.
   * Dilengkapi security headers: `X-Frame-Options`, `X-Content-Type-Options`, `X-XSS-Protection`, dan Rate Limiting.
   * Dikonfigurasi berjalan sebagai unprivileged non-root process.
3. **Container Orchestration (`docker-compose.yml`):**
   * Menghubungkan seluruh service dalam 1 custom bridge network `microservices-net`.
   * Dilengkapi `healthcheck` native pada setiap service (`pg_isready`, `redis-cli ping`, `curl/wget healthcheck`).
   * Menjamin urutan dependensi startup menggunakan `depends_on: condition: service_healthy`.
4. **Automated Security Scan (Trivy & GitHub Actions):**
   * Script pemindaian `security_scan.sh` dan `security_scan.ps1` untuk mendeteksi kerentanan **HIGH / CRITICAL** pada image dan miskonfigurasi IaC.
   * GitHub Actions workflow `.github/workflows/docker-security.yml` untuk pengujian otomatis pada CI/CD.

---

## 📂 Struktur Berkas Project

```text
project-02-microservices-docker-security/
├── app/
│   ├── main.py              # FastAPI Application entrypoint & health endpoints
│   ├── database.py          # PostgreSQL SQLAlchemy connection & retry initialization
│   ├── redis_client.py      # Redis client & caching helper functions
│   ├── config.py            # Environment configuration with Pydantic
│   ├── schemas.py           # API request & response schemas
│   ├── requirements.txt     # Python production dependencies
│   └── Dockerfile           # Multi-stage build Dockerfile (non-root appuser)
├── nginx/
│   ├── nginx.conf           # Reverse proxy configuration & security headers
│   └── Dockerfile           # Unprivileged Nginx proxy Dockerfile
├── scripts/
│   ├── security_scan.sh     # Bash script untuk pemindaian Trivy (Linux/WSL)
│   ├── security_scan.ps1    # PowerShell script untuk pemindaian Trivy (Windows)
│   └── test_stack.sh        # Integration test script untuk seluruh endpoint
├── .github/
│   └── workflows/
│       └── docker-security.yml # CI pipeline untuk security scan
├── docker-compose.yml       # Docker Compose multi-container orchestration
├── .dockerignore            # Docker build context exclusion rules
├── .env.example             # Template environment variables
├── README.md                # Dokumentasi utama proyek
└── CARA-MENGERJAKAN.md      # Panduan hands-on eksekusi proyek
```

---

## ⚡ Panduan Menjalankan Project

### 1. Salin Environment File
```bash
cp .env.example .env
```

### 2. Jalankan Stack Microservices
```bash
docker compose up -d --build
```

### 3. Cek Status Containers & Healthcheck
```bash
docker compose ps
```
Pastikan seluruh status container menunjukkan status `healthy`.

### 4. Pengujian Endpoints
* **Nginx Health:** `curl http://localhost:8080/nginx-health`
* **App Health:** `curl http://localhost:8080/health`
* **Swagger API Docs:** Buka `http://localhost:8080/docs` pada browser.

### 5. Eksekusi Security Scan (Trivy)
```bash
# Untuk Linux / macOS / WSL:
chmod +x scripts/security_scan.sh
./scripts/security_scan.sh

# Untuk Windows (PowerShell):
.\scripts\security_scan.ps1
```

---

## 🧼 Menghentikan & Membersihkan Resources

```bash
# Menghentikan container
docker compose down

# Menghentikan container + menghapus persistent volumes
docker compose down -v
```
