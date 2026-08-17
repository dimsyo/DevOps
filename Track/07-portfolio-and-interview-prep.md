# 📁 Modul 07 — GitHub Portfolio Architecture & Interview Preparation Kit

---

## 📁 1. Standardized GitHub Portfolio Repository Layout

Agar repository portfolio Anda terlihat profesional di mata Hiring Manager & Recruiter, susunlah master repository Anda dengan struktur berikut:

```text
devops-portfolio/
│
├── .github/
│   └── workflows/
│       └── main-ci-cd.yml
│
├── project-01-linux-nginx-automation/
│   ├── scripts/
│   ├── config/
│   └── README.md
│
├── project-02-docker-microservices/
│   ├── Dockerfile
│   ├── docker-compose.yml
│   └── README.md
│
├── project-03-aws-terraform-infrastructure/
│   ├── modules/
│   │   ├── vpc/
│   │   ├── alb/
│   │   └── ec2/
│   ├── main.tf
│   ├── variables.tf
│   └── README.md
│
├── project-04-ansible-server-provisioning/
│   ├── roles/
│   ├── site.yml
│   └── README.md
│
├── project-06-kubernetes-eks-helm/
│   ├── charts/
│   ├── manifests/
│   └── README.md
│
├── project-07-observability-prometheus-grafana/
│   ├── dashboards/
│   ├── alerts/
│   └── README.md
│
├── final-capstone-project/
│   ├── architecture-diagram.png
│   ├── terraform/
│   ├── ansible/
│   ├── helm/
│   ├── .github/workflows/
│   └── README.md
│
└── README.md (Master Portfolio Index)
```

---

## 🎤 2. Comprehensive DevOps Interview Preparation Kit

### 🐧 A. Linux & Systems
* **Basic:** Apa perbedaan antara `process` dan `thread`? Bagaimana cara melihat penggunaan memori di Linux (`free -h`, `/proc/meminfo`)?
* **Intermediate:** Jelaskan bagaimana Systemd mengelola service dependency (`Requires=`, `Wants=`, `After=`)!
* **Troubleshooting:** Sebuah server Linux tiba-tiba sangat lambat. Langkah diagnosa awal apa yang Anda lakukan (`top`, `iostat`, `vmstat`, `dmesg`)?
* **Architecture:** Jelaskan konsep Linux `cgroups` dan `namespaces` serta hubungannya dengan isolasi container Docker!

### 🌐 B. Networking & Cloud (AWS)
* **Basic:** Jelaskan perbedaan Public Subnet dan Private Subnet di AWS VPC!
* **Intermediate:** Bagaimana alur traffic dari internet menuju ke EC2 instance di Private Subnet melalui Application Load Balancer?
* **Troubleshooting:** EC2 Instance di Private Subnet tidak bisa mengunduh update package dari internet. Apa yang perlu diperiksa di VPC Route Table & NAT Gateway?
* **Architecture:** Bagaimana Anda merancang arsitektur AWS VPC yang High Available dan Fault Tolerant di 2 Availability Zone?

### 🐳 C. Docker & Containerization
* **Basic:** Perbedaan `CMD` vs `ENTRYPOINT` pada Dockerfile?
* **Intermediate:** Mengapa kita disarankan menggunakan Multi-Stage Build pada Dockerfile? Apa keuntungannya bagi keamanan dan performance?
* **Troubleshooting:** Container exit dengan code 137. Apa penyebabnya dan bagaimana solusi Anda?
* **Architecture:** Bagaimana cara mengamankan Docker Image agar lolos audit keamanan di industri?

### 🏗️ D. Infrastructure as Code (Terraform)
* **Basic:** Perbedaan `terraform plan`, `terraform apply`, dan `terraform refresh`?
* **Intermediate:** Mengapa `.tfstate` file sangat krusial dan mengapa dilarang keras di-commit ke Git? Solusi apa yang Anda pakai?
* **Troubleshooting:** Terjadi `State Locking Error` pada S3/DynamoDB backend saat pipeline terputus. Bagaimana cara penyelesaian yang aman?
* **Architecture:** Bagaimana strategi memisahkan Terraform code untuk lingkungan Development, Staging, dan Production?

### ☸️ E. Kubernetes & Orchestration
* **Basic:** Jelaskan komponen utama Kubernetes Control Plane (API Server, Etcd, Scheduler, Controller Manager)!
* **Intermediate:** Jelaskan perbedaan `Liveness Probe`, `Readiness Probe`, dan `Startup Probe`!
* **Troubleshooting:** Pod Anda berada dalam status `CrashLoopBackOff`. Tuliskan 3 command `kubectl` utama untuk mencari root cause!
* **Architecture:** Bagaimana strategi melakukan Zero-Downtime Deployment di Kubernetes (RollingUpdate vs Blue/Green)?

### 📊 F. Observability & Monitoring
* **Basic:** Sebutkan 4 Golden Signals dalam Monitoring!
* **Intermediate:** Jelaskan perbedaan pendekatan Pull-based (Prometheus) dan Push-based (Graphite/Datadog)!
* **Troubleshooting:** Grafana menunjukkan status `No Data` pada panel CPU usage server. Bagaimana alur pemeriksaan Anda?

---
*Kembali ke [README Index](file:///c:/Users/Premio/Documents/Belajar%20Devops/Track/README.md) atau lanjut ke [Modul 08 — Assessments & Checklist](file:///c:/Users/Premio/Documents/Belajar%20Devops/Track/08-assessments-and-readiness-checklist.md).*
