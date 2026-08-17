# 📝 Modul 08 — Weekly Assessments, Final Capstone & Readiness Checklist

---

## 📝 1. Weekly Self-Assessment & Scoring Template

Gunakan format ini setiap akhir minggu untuk mengevaluasi apakah Anda berhak lanjut ke minggu/phase berikutnya:

```text
=====================================================
WEEKLY ASSESSMENT REPORT - WEEK [ X ]
Domain Focus: [ Misal: Terraform AWS Infrastructure ]
=====================================================

1. THEORY CHECK (Skor Max: 30)
   - Pertanyaan 1: [...] (Skor: /10)
   - Pertanyaan 2: [...] (Skor: /10)
   - Pertanyaan 3: [...] (Skor: /10)

2. PRACTICAL HANDS-ON TASK (Skor Max: 40)
   - Task: Buat VPC Multi-AZ via Terraform tanpa melihat tutorial.
   - Hasil Execution: [ Pass / Fail ] (Skor: /40)

3. TROUBLESHOOTING DRILL (Skor Max: 30)
   - Scenario: Selesaikan masalah Terraform State Lock Stuck.
   - Diagnosa & Resolution Time: [ < 15 Menit ] (Skor: /30)

-----------------------------------------------------
TOTAL SCORE: [     / 100 ]
-----------------------------------------------------

EVALUATION SCALE:
 🏆 90 - 100 : EXCELLENT (Lanjut ke materi berikutnya dengan percaya diri)
 ✅ 80 - 89  : READY (Lanjut ke materi berikutnya)
 ⚠️ 70 - 79  : REVIEW (Ulangi mini-practice & project 1 hari lagi)
 ❌ < 70     : REPEAT (Dilarang lanjut! Pelajari ulang fundamental & ulangi test)
```

---

## 🧪 2. Final Technical Assessment (Take-Home Assignment Style)

> **Judul:** Junior DevOps Engineer Assignment — E-Commerce Infrastructure & CI/CD Deployment  
> **Durasi Pengerjaan:** 48 Jam (Tanpa Step-by-Step Tutorial)

### 📋 Assignment Requirements & Specification

1. **Infrastructure (AWS & Terraform):**
   * Provision AWS VPC dengan 2 Public Subnet & 2 Private Subnet di 2 AZ.
   * Provision AWS EKS Cluster atau 2 EC2 Instances dibelakang Application Load Balancer.
   * Remote State wajib tersimpan di AWS S3 dengan DynamoDB State Locking.

2. **Automation & Configuration (Ansible / Helm):**
   * Jika menggunakan EC2: Server harus di-configure 100% via Ansible Playbook (Install Docker, Fail2ban, UFW).
   * Jika menggunakan EKS: Deploy aplikasi menggunakan Helm Chart kustom.

3. **CI/CD Pipeline (GitHub Actions):**
   * Buat pipeline yang memicu otomatis saat PR di-merge ke `main`.
   * Pipeline wajib memiliki step: Code Linting → Gitleaks Secret Scan → Trivy Image Scan → Docker Build & Push ke AWS ECR → Deployment ke AWS.

4. **Security & Observability:**
   * Tidak ada hardcoded credentials/secrets di Git repository.
   * Setup Prometheus & Grafana dashboard untuk memantau HTTP Request Count & CPU Usage.

5. **Deliverables:**
   * Repository GitHub Publik berisi seluruh kode (`terraform/`, `ansible/`, `helm/`, `.github/workflows/`).
   * File `README.md` profesional berisi Architecture Diagram, Setup Guide, dan Evidence Screenshot.

---

## 🏆 3. Final Enterprise Capstone Project

### "End-to-End Cloud-Native Microservices Ecosystem on AWS"

```text
                                [DEVELOPER WORKSTATION]
                                           │
                                           ▼ (Git Push Feature Branch)
                                    [GITHUB REPOSITORY]
                                           │
                                           ▼ (Pull Request Trigger)
                       ┌─────────────────────────────────────────┐
                       │     GITHUB ACTIONS CI/CD PIPELINE       │
                       ├─────────────────────────────────────────┤
                       │ 1. Gitleaks & CodeQL Security Scan      │
                       │ 2. Automated Unit & Integration Tests   │
                       │ 3. Checkov Terraform Static Analysis    │
                       │ 4. Docker Multi-stage Build & Trivy Scan│
                       │ 5. Push Image to AWS ECR                │
                       └───────────────────┬─────────────────────┘
                                           │
                                           ▼ (Automated Helm Upgrade)
 ┌─────────────────────────────────────────────────────────────────────────────────────────┐
 │                                   AWS CLOUD REGION                                      │
 │                                                                                         │
 │  [AWS VPC]                                                                              │
 │   ├── [PUBLIC SUBNET AZ-A]                ├── [PUBLIC SUBNET AZ-B]                       │
 │   │    └── AWS ALB (Internet Facing) ───────┼─── NAT Gateway                              │
 │   │                                     │                                               │
 │   ├── [PRIVATE SUBNET AZ-A]               ├── [PRIVATE SUBNET AZ-B]                      │
 │   │    └── AWS EKS Node 1                 │    └── AWS EKS Node 2                        │
 │   │         ├── Frontend Pod (x3)       │         ├── Frontend Pod                      │
 │   │         ├── Backend API Pod (x3)    │         ├── Backend API Pod (HPA)             │
 │   │         ├── Prometheus Pod          │         ├── Grafana Pod                       │
 │   │         └── Loki Log Pod            │         └── Promtail Agent                    │
 │   │                                     │                                               │
 │   └── [DATABASE PRIVATE SUBNET]         └───────────────────────────────────────────────┤
 │        └── AWS RDS PostgreSQL Multi-AZ (Encrypted at Rest)                              │
 └─────────────────────────────────────────────────────────────────────────────────────────┘
                                           │
                                           ▼ (Alert Trigger)
                                 [SLACK / DISCORD CHANNEL]
```

### Multi-Stage Capstone Implementation Flow
1. **Stage 1 (IaC):** `terraform apply` merilis VPC, Subnets, EKS, RDS, S3, ECR, DynamoDB.
2. **Stage 2 (App & Docker):** Build Microservices (Frontend + Backend) ter-containerize.
3. **Stage 3 (CI/CD):** Konfigurasi GitHub Actions OIDC ke AWS ECR & EKS.
4. **Stage 4 (K8s & Helm):** Deploy Nginx Ingress, Cert-manager (SSL), HPA, dan App Helm Chart.
5. **Stage 5 (Observability):** Deploy Prometheus, Grafana, Loki, Alertmanager dengan Slack Alerting.
6. **Stage 6 (Incident Drill & Verification):** Simulasikan Node failure & Traffic spike, pastikan HPA & Auto-recovery berjalan 100%.

---

## 🎯 4. Final DevOps Engineer Readiness Checklist

Gunakan checklist ini sebelum mulai melamar pekerjaan **DevOps Engineer**:

### 🐧 Linux & Systems Administration
- [ ] Mampu menulis Bash script untuk otomatisasi sistem (loops, conditionals, functions, error handling).
- [ ] Memahami Systemd unit files, process management (`top`, `htop`, `ps`, `kill`), dan log inspection (`journalctl`).
- [ ] Memahami Linux file permissions (`chmod`, `chown`), SSH Hardening, dan UFW/Iptables firewall.

### 🌐 Networking & Web Infrastructure
- [ ] Memahami TCP/IP, Subnetting, CIDR Notation, DNS Records (A, CNAME, TXT), dan HTTP/HTTPS Status Codes.
- [ ] Mampu mengkonfigurasi Nginx sebagai Reverse Proxy, Load Balancer, SSL Termination (Certbot), dan Rate Limiter.

### 🐙 Git & GitHub Workflow
- [ ] Terbiasa dengan Conventional Commits, Feature Branching, Pull Requests, dan Resolving Merge Conflicts.
- [ ] Memahami Git Rebase vs Git Merge, Git Tagging, dan Semantic Versioning.

### 🐳 Docker & Containerization
- [ ] Mampu menulis Dockerfile multi-stage build untuk mengoptimasi ukuran image dan keamanan (non-root user).
- [ ] Memahami Docker Compose untuk menghubungkan multi-container local microservices stack.
- [ ] Mampu melakukan vulnerability scanning pada Docker image menggunakan Trivy.

### ☁️ AWS Cloud Infrastructure
- [ ] Mampu mendesain AWS VPC Custom Multi-AZ (Public/Private Subnets, Route Tables, IGW, NAT Gateway).
- [ ] Memahami EC2, Auto Scaling Groups, Application Load Balancers (ALB), S3, dan RDS PostgreSQL.
- [ ] Memahami AWS IAM (Roles, Policies, OIDC, Least Privilege Principle).

### 🏗️ Infrastructure as Code (Terraform)
- [ ] Mampu menulis kode HCL Terraform yang modular dan DRY.
- [ ] Mampu mengatur S3 Remote Backend dengan DynamoDB State Locking.
- [ ] Memahami cara menangani State Drift (`terraform plan`) dan State Lock conflicts.

### ⚙️ Configuration Management (Ansible)
- [ ] Mampu membuat Ansible Roles yang terstruktur dan 100% Idempotent.
- [ ] Memahami Ansible Vault untuk mengamankan data sensitif/secrets.
- [ ] Memahami AWS Dynamic Inventory (`aws_ec2`).

### ☸️ Kubernetes & Orchestration
- [ ] Memahami arsitektur Kubernetes (Control Plane vs Worker Nodes) dan objek dasarnya (Pod, Service, Deployment).
- [ ] Mampu mendiagnosa masalah Pod (`CrashLoopBackOff`, `Pending`, `OOMKilled`) via `kubectl`.
- [ ] Mampu membuat dan me-manage Helm Charts serta me-route traffic via Ingress Controller.

### 🔄 CI/CD (GitHub Actions) & DevSecOps
- [ ] Mampu membangun pipeline CI/CD multi-stage yang mencakup Test, Scan, Build, Push ECR, dan Deploy.
- [ ] Memahami integrasi DevSecOps tools (Gitleaks, CodeQL, Checkov, Trivy).
- [ ] Memahami OIDC Authentication antara GitHub Actions dan Cloud Provider.

### 📊 Observability & Incident Response
- [ ] Mampu me-deploy dan mengkonfigurasi Prometheus, Grafana, dan Loki.
- [ ] Mampu menulis PromQL query dasar dan membuat Grafana Dashboard custom.
- [ ] Memahami alur penanganan insiden produksi (Detect → Investigate → Root Cause → Fix → Verify → Prevent).

---

### 🏆 Readiness Status Evaluation
* **< 15 Checklist Tercentang:** 🔴 *Not Ready* (Fokus pada Phase 1 - 4).
* **15 - 22 Checklist Tercentang:** 🟡 *Beginner DevOps / Junior Ready* (Siap melamar Junior DevOps / SysAdmin Automation).
* **23 - 28 Checklist Tercentang:** 🟢 *Strong Junior / Intermediate DevOps Ready* (Siap bersaing sebagai DevOps Engineer profesional di industri!).

---
*Kembali ke [README Index](file:///c:/Users/Premio/Documents/Belajar%20Devops/Track/README.md).*
