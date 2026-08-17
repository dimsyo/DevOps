# 🛠️ Modul 04 — Complete Project Roadmap (Projects 1 – 10 + Capstone)

Setiap project dirancang semakin lama semakin realistis untuk merepresentasikan kondisi arsitektur di industri modern.

---

### 📦 Project 1: Automated Secure Nginx Infrastructure with Git Automation
* **Problem Solved:** Konfigurasi web server manual sering tidak terstandarisasi, rawan kebobolan SSL expired, dan tidak terpantau oleh version control.
* **Architecture:**
  ```text
  [Git Repository] ──(Webhook / Cron Pull)──► [Linux Server (Debian/Ubuntu)]
                                                    │
                                                    ▼
                                     [Systemd Managed Nginx Service]
                                     ├── TLS 1.3 / SSL Certbot
                                     ├── Security Headers Hardening
                                     └── Custom Logrotate Script
  ```
* **Technologies:** Linux, Systemd, Nginx, Bash Scripting, Certbot, Git.
* **Dependencies:** Fundamental Linux & Networking.
* **Step-by-step Implementation:**
  1. Buat GitHub Repository `project-01-linux-nginx`.
  2. Tulis Bash script `setup.sh` yang mengunduh Nginx, mengkonfigurasi systemd service unit file kustom.
  3. Konfigurasi `nginx.conf` dengan HTTPS hardening (HSTS, X-Frame-Options, CSP) dan rate limiting `limit_req_zone`.
  4. Tulis cron job / Bash script untuk auto-renew certbot dan auto-reload Nginx.
* **Expected Output:** Web server Nginx yang mendapatkan rating A+ di SSL Labs dan ter-deploy secara otomatis via script.
* **Security Consideration:** Menutup semua port kecuali 80 dan 443 via UFW firewall. Disable server token (`server_tokens off;`).

---

### 📦 Project 2: Microservices Containerization with Docker Compose & Security Scan
* **Problem Solved:** Aplikasi monolithic susah di-scale dan lingkungan development tidak sesuai dengan lingkungan production ("Works on my machine syndrome").
* **Architecture:**
  ```text
  [Nginx Reverse Proxy Container (Port 8080)]
             │
             ├──► [Python FastAPI App Container (Multi-stage Build)]
             │            │
             │            ▼
             │   [PostgreSQL Database Container] ──► [Named Volume: db_data]
             │
             └──► [Redis Cache Container]
  ```
* **Technologies:** Docker, Docker Compose, Python FastAPI, PostgreSQL, Redis, Trivy.
* **Dependencies:** Project 1.
* **Step-by-step Implementation:**
  1. Buat `Dockerfile` multi-stage untuk FastAPI menggunakan base `python:3.11-slim` dan non-root user `appuser`.
  2. Buat file `docker-compose.yml` yang menghubungkan App, DB, Redis, dan Nginx dalam 1 custom bridge network.
  3. Sertakan `healthcheck` di setiap service untuk memastikan urutan startup yang benar.
  4. Jalankan `trivy image` dan pastikan 0 vulnerability High/Critical.
* **Expected Output:** Aplikasi 3-tier berjalan mulus dengan 1 command `docker compose up -d`.

---

### 📦 Project 3: Production Cloud Infrastructure on AWS using Modular Terraform
* **Problem Solved:** Membuat infrastruktur AWS manual via Web Console memakan waktu lama, rawan human error, dan susah di-replicate ke lingkungan staging/prod.
* **Architecture:**
  ```text
  [AWS VPC (10.0.0.0/16)]
   ├── Public Subnet AZ-a  ──► [Application Load Balancer]
   ├── Public Subnet AZ-b  ──► [NAT Gateway]
   ├── Private Subnet AZ-a ──► [EC2 Instance 1 (Auto Scaling Group)]
   ├── Private Subnet AZ-b ──► [EC2 Instance 2 (Auto Scaling Group)]
   └── Database Subnet     ──► [AWS RDS PostgreSQL Multi-AZ]
  ```
* **Technologies:** AWS, Terraform HCL, S3, DynamoDB.
* **Dependencies:** Project 2.
* **Step-by-step Implementation:**
  1. Strukturasi folder Terraform: `modules/vpc`, `modules/alb`, `modules/ec2`, `modules/rds`.
  2. Konfigurasi S3 bucket backend dengan server-side encryption dan DynamoDB state lock table.
  3. Parameterisasi variabel (CIDR block, instance type, environment tags).
  4. Eksekusi `terraform apply` dan verifikasi seluruh resource di AWS.
* **Expected Output:** Infrastructure AWS ter-provisioning penuh dalam waktu < 5 menit via Terraform.

---

### 📦 Project 4: Immutable Server Provisioning & OS Hardening using Ansible Roles
* **Problem Solved:** EC2 instance mentah di AWS belum memiliki konfigurasi keamanan, dependency software, atau user management yang terstandarisasi.
* **Architecture:**
  ```text
  [Ansible Controller] ──(Dynamic Inventory aws_ec2)──► [AWS EC2 Instances]
                                                              │
                                                              ├── Role: os_hardening
                                                              ├── Role: install_docker
                                                              └── Role: deploy_app
  ```
* **Technologies:** Ansible, Ansible Vault, AWS EC2 Dynamic Inventory, Python Boto3.
* **Dependencies:** Project 3.
* **Step-by-step Implementation:**
  1. Konfigurasi file plugin `aws_ec2.yml` untuk fetch IP EC2 otomatis berdasarkan AWS Tag.
  2. Buat Ansible Roles: `common`, `security` (Fail2ban + UFW), `docker`, `app`.
  3. Enkripsi kredensial sensitif DB dengan `ansible-vault`.
  4. Jalankan playbook `site.yml` dan pastikan idempotency (`changed=0` pada run kedua).
* **Expected Output:** EC2 instance yang ter-provisioning dan ter-hardening secara otomatis tanpa sentuhan manual.

---

### 📦 Project 5: Enterprise Zero-Downtime CI/CD Pipeline with GitHub Actions
* **Problem Solved:** Proses release software manual sering menyebabkan downtime, tidak melalui uji kualitas/security, dan rawan kesalahan manusia.
* **Architecture:**
  ```text
  [Git Push Feature Branch] ──► [Pull Request] ──► [Lint + Test + Trivy Scan]
                                                          │
  [Prod Server (EC2)] ◄── [Deploy via SSH] ◄── [Push AWS ECR] ◄── [Merge to Main]
  ```
* **Technologies:** GitHub Actions, AWS ECR, OIDC IAM, Docker, SSH, Trivy.
* **Dependencies:** Project 2, 3, 4.
* **Step-by-step Implementation:**
  1. Setup AWS OIDC IAM Role agar GitHub Actions dapat berkomunikasi dengan AWS tanpa Access Key statis.
  2. Tulis workflow multi-job di `.github/workflows/deploy.yml`.
  3. Tambahkan automated security scanner step (Gitleaks + Trivy).
  4. Implementasikan zero-downtime deployment strategy (Blue/Green atau Rolling Update via Docker Compose / Systemd).
* **Expected Output:** Setiap `git push` ke `main` merilis versi aplikasi terbaru ke AWS secara terotomatisasi dalam waktu < 3 menit.

---

### 📦 Project 6: Cloud-Native Kubernetes Microservices Deployment on AWS EKS
* **Problem Solved:** Mengelola puluhan container Docker secara manual di instance EC2 terpisah sangat sulit saat terjadi lonjakan traffic (traffic spike) atau node failure.
* **Architecture:**
  ```text
  [AWS EKS Cluster]
   ├── [AWS Load Balancer Controller] ──► [Nginx Ingress]
   ├── [Frontend Deployment] ──► [Pod x3]
   ├── [Backend API Deployment] ──► [Pod x3] (HPA: CPU > 70%)
   └── [ConfigMaps & AWS Secrets Manager CSI Driver]
  ```
* **Technologies:** AWS EKS, Kubernetes, Helm, kubectl, AWS ALB Ingress.
* **Dependencies:** Project 3, 5.
* **Step-by-step Implementation:**
  1. Provision AWS EKS Cluster menggunakan Terraform EKS Module.
  2. Buat Helm Chart kustom untuk aplikasi (Deployment, Service, Ingress, HPA).
  3. Konfigurasi Horizontal Pod Autoscaler (HPA) dengan target CPU Utilization 70%.
  4. Deploy aplikasi menggunakan `helm upgrade --install`.
* **Expected Output:** Cluster EKS yang auto-heal (jika Pod di-kill, Pod baru otomatis menyala) dan auto-scale saat diberi beban traffic.

---

### 📦 Project 7: Centralized Observability & Automated Alerting (Prometheus, Grafana & Loki)
* **Problem Solved:** Tim Ops tidak mengetahui jika server crash atau kehabisan memori sebelum user/klien komplain.
* **Architecture:**
  ```text
  [EC2 / EKS Cluster] ──► [Prometheus Exporter] ──► [Prometheus Server]
                                                            │
  [Log Files] ─────────► [Promtail Aggregator] ──► [Grafana Loki]
                                                            │
                                                            ▼
                                                [Grafana Visual Dashboard]
                                                            │
                                                            ▼
                                               [Alertmanager] ──► [Slack Alert]
  ```
* **Technologies:** Prometheus, Grafana, Loki, Promtail, Alertmanager, Helm.
* **Dependencies:** Project 6.
* **Step-by-step Implementation:**
  1. Deploy `kube-prometheus-stack` dan `loki-stack` via Helm di K8s cluster.
  2. Import Grafana Dashboard resmi (Node Exporter Full & Kubernetes Cluster).
  3. Buat Alertmanager Rules untuk High CPU (>85%), High Memory, dan Pod Restarts.
  4. Hubungkan Alertmanager ke Slack / Discord Webhook.
* **Expected Output:** Dashboard monitoring real-time dan notifikasi alert yang masuk otomatis ke Slack saat ada insiden simulasi.

---

### 📦 Project 8: DevSecOps Shift-Left Security Automated Pipeline
* **Problem Solved:** Keamanan infrastruktur dan aplikasi baru dicek sebelum rilis di production, menyebabkan banyak keterlambatan dan vulnerability lolos.
* **Architecture:**
  ```text
  [Dev Code] ──► [Gitleaks (Secrets)] ──► [CodeQL (SAST)]
                                               │
  [Prod] ◄── [Kube-bench (Runtime)] ◄── [Checkov (IaC)] ◄── [Trivy (Containers)]
  ```
* **Technologies:** Gitleaks, CodeQL, Trivy, Checkov, Kube-bench, GitHub Actions.
* **Dependencies:** Project 5, 6.
* **Step-by-step Implementation:**
  1. Integrasikan Gitleaks pada pre-commit hook dan GitHub Actions.
  2. Terapkan Checkov untuk menscan Terraform manifest sebelum `terraform apply`.
  3. Konfigurasikan Trivy agar memblokir Docker image build jika ditemukan vulnerability status `CRITICAL`.
* **Expected Output:** Pipeline CI/CD yang menolak secara otomatis (Fail Fast) setiap code yang mengandung vulnerability atau secret bocor.

---

### 📦 Project 9: Disaster Recovery & Automated Backup Architecture
* **Problem Solved:** Risiko kehilangan data akibat ransomware, kesalahan manusia, atau hilangnya AWS Region/Availability Zone.
* **Architecture:**
  ```text
  [AWS RDS PostgreSQL (Primary AZ-a)] ──(Auto Replication)──► [RDS Standby AZ-b]
                                                                     │
  [AWS S3 Backup Bucket] ◄──(Encrypted Nightly Snapshot)─────────────┘
  ```
* **Technologies:** AWS RDS Snapshots, AWS Backup Service, S3 Cross-Region Replication, Bash/Python Automation.
* **Dependencies:** Project 3, 4.
* **Step-by-step Implementation:**
  1. Konfigurasi AWS Backup Vault dengan S3 lifecycle policy (Glacier Transition).
  2. Buat Python Boto3 script untuk menguji ketersediaan snapshot restore secara otomatis seminggu sekali.
  3. Tulis Incident Recovery Runbook (SOP pemulihan data saat bencana).
* **Expected Output:** Sistem backup terenkripsi otomatis yang teruji mampu me-restore data dalam RTO (Recovery Time Objective) < 30 menit.

---

### 📦 Project 10: Multi-Environment GitOps Architecture with ArgoCD
* **Problem Solved:** Perubahan konfigurasi Kubernetes cluster yang dilakukan secara manual via `kubectl apply` menyebabkan hilangnya audit trail dan konfigurasi drift.
* **Architecture:**
  ```text
  [Git Infrastructure Repo] ──► [Branch: staging / prod]
                                       │
                                       ▼ (Pull-based Sync)
                                [ArgoCD Controller]
                                       │
                                       ▼
                           [Kubernetes Staging / Prod Namespaces]
  ```
* **Technologies:** ArgoCD, Kubernetes, GitOps, Kustomize/Helm, GitHub.
* **Dependencies:** Project 6, 7.
* **Step-by-step Implementation:**
  1. Install ArgoCD di EKS cluster via Helm.
  2. Hubungkan ArgoCD ke Git repository infrastruktur.
  3. Aktifkan **Automated Sync & Self-Healing** (jika ada yang mengubah k8s manual, ArgoCD otomatis me-revert ke state di Git).
* **Expected Output:** Pengelolaan cluster Kubernetes 100% berbasis Git (GitOps Engine).

---
*Kembali ke [README Index](file:///c:/Users/Premio/Documents/Belajar%20Devops/Track/README.md) atau lanjut ke [Modul 05 — Troubleshooting & Incidents](file:///c:/Users/Premio/Documents/Belajar%20Devops/Track/05-troubleshooting-and-incidents.md).*
