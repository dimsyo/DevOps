# 📘 CARA MENGERJAKAN: Project 2 (Microservices Containerization & Security Scan)

Panduan ini berisi langkah-langkah praktis eksekusi **Project 2** dari awal hingga selesai, termasuk pengujian aplikasi dan pemindaian keamanan menggunakan Trivy.

---

## 📋 Prasyarat Sistem

1. **Docker Desktop / Docker Engine** (versi 24+ direkomendasikan) dengan modul `docker compose` (v2).
2. **Trivy CLI** (Opsional jika ingin menjalankan pemindaian langsung di host, atau gunakan image `aquasec/trivy` via Docker).
3. **Curl / Postman** untuk pengujian API.

---

## 🛠️ Langkah-Langkah Pengerjaan

### Langkah 1: Persiapan Folder & Environment
Masuk ke direktori proyek `project-02-microservices-docker-security`:
```bash
cd Semua/project-02-microservices-docker-security
```

Buat file `.env` berdasarkan contoh `.env.example`:
```bash
cp .env.example .env
```

---

### Langkah 2: Memahami Struktur Dockerfile Multi-Stage (`app/Dockerfile`)
Buka file `app/Dockerfile`. Perhatikan dua tahap utama:
1. **Stage 1 (Builder):** Mengunduh dan mengompilasi library Python (`gcc`, `libpq-dev`).
2. **Stage 2 (Runner):**
   * Menggunakan base `python:3.11-slim`.
   * Memasang user non-root `appuser` (UID 10001).
   * Menjalankan perintah `USER appuser`.
   * Menambahkan perintah `HEALTHCHECK` otomatis.

---

### Langkah 3: Menjalankan Container Orchestration
Jalankan perintah berikut untuk mengompilasi image dan menyalakan seluruh service secara background (`-d`):
```bash
docker compose up -d --build
```

Amati proses build:
* Container `postgres-db` akan menyala lebih dahulu dan menunggu status `healthy`.
* Container `redis-cache` akan menyala dan menunggu status `healthy`.
* Container `fastapi-app` akan menginisialisasi tabel database PostgreSQL dan terhubung ke Redis.
* Container `nginx-proxy` menyala sebagai pintu masuk (Reverse Proxy) pada port `8080`.

---

### Langkah 4: Memeriksa Status Container & Logs
Gunakan perintah `docker compose ps` untuk melihat status kesehatan container:
```bash
docker compose ps
```

*Status yang diharapkan:*
```text
NAME                   IMAGE                                COMMAND                  SERVICE        CREATED         STATUS
devops-fastapi-app     project-02...-fastapi-app            "uvicorn app.main:ap…"   fastapi-app    1 minute ago    Up 1 minute (healthy)
devops-nginx-proxy     project-02...-nginx-proxy            "/docker-entrypoint.…"   nginx-proxy    1 minute ago    Up 1 minute (healthy)
devops-postgres-db     postgres:15-alpine                   "docker-entrypoint.s…"   postgres-db    1 minute ago    Up 1 minute (healthy)
devops-redis-cache     redis:7-alpine                       "docker-entrypoint.s…"   redis-cache    1 minute ago    Up 1 minute (healthy)
```

Untuk melihat log aplikasi jika diperlukan:
```bash
docker compose logs -f fastapi-app
```

---

### Langkah 5: Menguji Integrasi Microservices API

#### 1. Uji Endpoint Healthcheck Aplikasi & Database/Redis
```bash
curl -i http://localhost:8080/health
```
*Hasil:*
```json
{
  "status": "healthy",
  "database": "healthy",
  "redis": "healthy",
  "timestamp": "2026-08-18T02:00:00.000000"
}
```

#### 2. Uji Penambahan Data Baru (POST /items)
```bash
curl -X POST http://localhost:8080/items \
  -H "Content-Type: application/json" \
  -d '{"title": "DevOps Project 2", "description": "Microservices with Docker Compose"}'
```

#### 3. Uji Caching Redis (GET /items)
Jalankan request GET pertama (membaca dari PostgreSQL dan menyimpan ke Redis Cache):
```bash
curl -i http://localhost:8080/items
```

---

### Langkah 6: Pemindaian Keamanan dengan Trivy Security Scan

Jalankan script pemindaian otomatis yang telah disediakan:

**Untuk Linux / macOS / WSL:**
```bash
chmod +x scripts/security_scan.sh
./scripts/security_scan.sh
```

**Untuk Windows (PowerShell):**
```powershell
.\scripts\security_scan.ps1
```

*Verifikasi Pemindaian:*
* Pastikan **0 Vulnerability** dengan tingkat **HIGH / CRITICAL** pada image `fastapi-app`.
* Pastikan tidak ada miskonfigurasi IaC berbahaya pada Dockerfile (seperti menjalankan container sebagai `root`).

---

### Langkah 7: Pengujian Otomatis via Script Integration Test
Jalankan script `test_stack.sh` untuk melakukan verifikasi otomatis seluruh fungsi API:
```bash
chmod +x scripts/test_stack.sh
./scripts/test_stack.sh
```

---

## 🎯 Kriteria Kelulusan Project 2

- [ ] Multi-stage build `Dockerfile` untuk FastAPI dengan base `python:3.11-slim` dan non-root user `appuser`.
- [ ] Orchestration 4-tier service (Nginx Proxy, FastAPI, PostgreSQL, Redis) dalam 1 `docker-compose.yml`.
- [ ] Penggunaan custom bridge network `microservices-net` & persistent volume.
- [ ] Healthcheck terpasang di semua service dengan urutan dependensi `depends_on: condition: service_healthy`.
- [ ] Pemindaian kerentanan menggunakan Trivy dengan hasil 0 High/Critical vulnerability.
- [ ] Dokumentasi lengkap `README.md` dan `CARA-MENGERJAKAN.md`.
