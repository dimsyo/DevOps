# Project 01: Automated Linux Web Infrastructure & Git Workflow

![DevOps Linux Automation](https://img.shields.io/badge/DevOps-Phase%201-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)
![Status](https://img.shields.io/badge/Status-Completed-success.svg)

Proyek ini adalah implementasi dari **Phase 1 — Git Automation, Advanced Linux & DevOps Networking Bridging**. Tujuan utamanya adalah mentransisikan SysAdmin tradisional (manual SSH/nano) menuju **Git-driven Developer-ready Ops (Infrastructure-as-Code & Automated Ops)**.

---

## 📐 Architecture Flowchart

Berikut adalah diagram alur traffic dan interaksi komponen dari Client hingga ke Application Layer:

```mermaid
flowchart TD
    subgraph Client Layer
        User[🌐 Client / Browser]
    end

    subgraph Networking & DNS Layer
        DNS[📍 DNS Server - A/CNAME Record]
        Router[🛡️ Edge Firewall / Router]
    end

    subgraph Reverse Proxy Layer (Nginx)
        NginxSSL[🔒 Nginx SSL Termination - Port 443]
        RateLimit[⚡ Nginx Rate Limiter - 10 req/s]
        ProxyPass[🔄 Nginx Reverse Proxy]
    end

    subgraph Application & OS Layer (Linux)
        Systemd[⚙️ Systemd Service Manager]
        App[🐍 Python Web App - 127.0.0.1:8000]
        Logrotate[📜 Logrotate & Backup Daemon]
        Webhook[📢 Discord / Telegram Webhook]
    end

    User -->|HTTPS Request| DNS
    DNS -->|Resolves IP| Router
    Router -->|Port 443| NginxSSL
    NginxSSL --> RateLimit
    RateLimit --> ProxyPass
    ProxyPass -->|HTTP Pass-through| App
    Systemd -->|Manage Lifecycle & Auto-restart| App
    App -->|Write Logs| Logrotate
    Logrotate -->|Trigger Backup & Rotate| Webhook
```

---

## 📁 Repository Structure

```text
Semua/project-01-linux-automation-git/
├── README.md                              # Master Documentation & Guide
├── CARA-MENGERJAKAN.md                    # Panduan Praktis & Step-by-Step Cara Mengerjakan Project
├── docs/
│   ├── 01-git-internals-and-flow.md       # Git Internals, Branching, Rebase vs Merge, SemVer
│   ├── 02-linux-automation-and-systemd.md  # Systemd Units, cgroups, Signals, Logrotate
│   ├── 03-devops-networking-and-nginx.md  # HTTP/HTTPS, SSL Handshake, Reverse Proxy, CORS, DNS
│   └── 04-troubleshooting-playbook.md     # 5 Real-world Incident Playbooks & Diagnostics
├── scripts/
│   ├── setup_infrastructure.sh            # Automated Bash Infrastructure Provisioner
│   ├── backup_with_rotation.sh            # Automated Backup with Webhook Notification
│   ├── ssl_monitor.py                     # Challenge: Async/Multithread SSL & HTTP Health Checker
│   ├── dummy_app.py                       # Python App Service for Backend Simulation
│   └── targets.csv                        # Input target list for ssl_monitor.py
├── systemd/
│   └── my-python-app.service              # Hardened Systemd Custom Service File
├── nginx/
│   ├── nginx.conf                         # Hardened Main Nginx Config
│   └── conf.d/app.conf                    # SSL, Rate Limiting & Reverse Proxy Config
└── logrotate.d/
    └── my-python-app                      # Custom Log Rotation Specification
```

---

## 🛠️ Quick Start Guide

### 1. Prerequisite
* Sistem Operasi: Linux (Ubuntu 20.04/22.04 LTS atau Debian/RHEL disesuaikan)
* Software: Bash shell, Python 3.8+, Nginx, Git, UFW firewall

### 2. Infrastructure Setup (Automated)
Eksekusi script otomatisasi setup berikut untuk mengkonfigurasi lingkungan server:

```bash
chmod +x scripts/setup_infrastructure.sh
sudo ./scripts/setup_infrastructure.sh
```

### 3. Running Backend App via Systemd
Salin file unit Systemd dan aktifkan service:

```bash
sudo cp systemd/my-python-app.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now my-python-app.service
sudo systemctl status my-python-app.service
```

### 4. Configuring Nginx Reverse Proxy
Salin konfigurasi Nginx dan lakukan reload:

```bash
sudo cp nginx/nginx.conf /etc/nginx/nginx.conf
sudo cp nginx/conf.d/app.conf /etc/nginx/conf.d/
sudo nginx -t
sudo systemctl reload nginx
```

### 5. Running Automated Backup Script
Uji coba script backup otomatis dengan notifikasi webhook:

```bash
chmod +x scripts/backup_with_rotation.sh
./scripts/backup_with_rotation.sh /var/log/my-app /var/backups/my-app "https://discord.com/api/webhooks/YOUR_WEBHOOK_URL"
```

### 6. Running Challenge Script (SSL & Health Monitor)
Jalankan script monitoring SSL & HTTP health check paralel:

```bash
python3 scripts/ssl_monitor.py --file scripts/targets.csv --days 7
```

---

## 🏷️ Conventional Commits & Git Flow

Proyek ini menerapkan standar **Conventional Commits** dan **Gitflow**:

### Structure Format:
`<type>(<scope>): <short description>`

### Types:
* `feat`: Fitur baru (misal: `feat(nginx): add rate limiting zone`)
* `fix`: Perbaikan bug (misal: `fix(systemd): adjust WorkingDirectory path`)
* `docs`: Pembaruan dokumentasi (misal: `docs(readme): add architecture flowchart`)
* `chore`: Tugas rutin/maintenance (misal: `chore(deps): update python script parameters`)
* `ci`: Perubahan pada pipeline otomatisasi

### Tagging & Release:
```bash
git tag -a v1.0.0 -m "Release v1.0.0: Automated Linux Web Infrastructure & Git Workflow"
git push origin v1.0.0
```
