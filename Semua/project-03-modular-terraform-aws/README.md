# 📦 Project 3: Production Cloud Infrastructure on AWS using Modular Terraform

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
![TFLint](https://img.shields.io/badge/TFLint-000000?style=for-the-badge&logo=terraform&logoColor=white)

Project 3 mengimplementasikan infrastruktur cloud tingkat produksi di **Amazon Web Services (AWS)** secara otomatis, terstandarisasi, dan teruji menggunakan **Modular Terraform (HCL)**. Proyek ini memecahkan masalah konfigurasi manual via AWS Web Console yang memakan waktu, rawan *human error*, serta sulit direplikasi di lingkungan staging maupun production.

---

## 🏗️ Arsitektur Infrastruktur System

```text
                                [ Internet Client ]
                                         │
                                         ▼ (Port 80 / 443)
                   [ AWS Application Load Balancer (Public Subnets) ]
                                         │
                  ┌──────────────────────┴──────────────────────┐
                  ▼                                             ▼
       [ Public Subnet AZ-a ]                         [ Public Subnet AZ-b ]
      ├── [ NAT Gateway ]                            ├── [ Internet Gateway ]
                  │                                             │
      ┌───────────┴─────────────────────────────────────────────┴───────────┐
      │ (Traffic Routed to Private Subnets via Target Group)                │
      └───────────┬─────────────────────────────────────────────┬───────────┘
                  ▼                                             ▼
      [ Private Subnet AZ-a ]                         [ Private Subnet AZ-b ]
     ├── [ EC2 Instance 1 ]                          ├── [ EC2 Instance 2 ]
     └── (Auto Scaling Group)                        └── (Auto Scaling Group)
                  │                                             │
                  └──────────────────────┬──────────────────────┘
                                         ▼ (PostgreSQL Port 5432)
                                 [ RDS PostgreSQL ]
                             (Multi-AZ Isolated Subnet)
```

---

## 🚀 Fitur Utama & Keunggulan

1. **VPC Multi-AZ Layered Architecture (`modules/vpc`):**
   * Pembagian subnet bertingkat: **Public Subnets** (ALB & NAT GW), **Private Subnets** (EC2 ASG), dan **Isolated Database Subnets** (RDS Multi-AZ).
   * Internet Gateway untuk akses masuk publik & NAT Gateway untuk outbound internet instance private secara aman.
2. **Strict Least-Privilege Security Groups (`modules/security_group`):**
   * `alb_sg`: Hanya membuka port HTTP (80) & HTTPS (443) dari `0.0.0.0/0`.
   * `ec2_sg`: Hanya mengizinkan trafik HTTP port 80 **hanya dari ALB Security Group**.
   * `rds_sg`: Hanya mengizinkan koneksi PostgreSQL port 5432 **hanya dari EC2 Security Group**.
3. **High Availability & High Scalability (`modules/alb` & `modules/asg`):**
   * Application Load Balancer melakukan distribute trafik ke seluruh instance di multiple AZ.
   * Auto Scaling Group secara otomatis menambah node baru jika beban CPU melebihi 70% (`TargetTrackingScaling`).
   * Bootstrapping otomatis via `scripts/user_data.sh` yang mengunduh dan menyalakan web server Nginx.
4. **Resilient Managed Database (`modules/rds`):**
   * Multi-AZ deployment (`multi_az = true`) dengan automatic failover jika terjadi outage pada satu AZ.
   * Storage encryption aktif (`storage_encrypted = true`) dan subnet terisolasi tanpa akses publik.
5. **Remote State Management & Lock Table (`backend.tf` & `scripts/init_backend`):**
   * Terraform State disimpan di **Amazon S3** dengan server-side encryption (AES256) dan versioning aktif.
   * State Locking dikelola oleh **DynamoDB Table** untuk mencegah race condition / concurrent execution saat team collaboration.
6. **Multi-Environment Ready (`environments/dev` & `environments/prod`):**
   * Struktur modular terpisah yang memungkinkan deployment instan ke lingkungan Development (`dev`) maupun Production (`prod`).

---

## 📂 Struktur Berkas Project

```text
project-03-modular-terraform-aws/
├── main.tf                    # Root Terraform configuration orchestrating modules
├── variables.tf               # Root input variable definitions & validations
├── outputs.tf                 # Exposed outputs (ALB DNS, VPC ID, RDS Endpoint)
├── providers.tf               # AWS Provider config & global default tags
├── backend.tf                 # Remote S3 state backend & DynamoDB state locking
├── terraform.tfvars.example   # Sample input values template
├── .env.example               # Environment variables template for AWS CLI & state
├── .gitignore                 # Exclusion rules for state files, credentials, & cache
├── modules/
│   ├── vpc/                   # VPC, Subnets, IGW, NAT GW, Route Tables
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── security_group/        # ALB, EC2, and RDS Security Groups
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── alb/                   # Application Load Balancer & Target Group
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── asg/                   # Launch Template, Auto Scaling Group, CPU Scaling Policy
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── rds/                   # Multi-AZ RDS PostgreSQL Instance & DB Subnet Group
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/
│   ├── dev/                   # Development environment configuration
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   └── backend.tfvars.example
│   └── prod/                  # Production environment configuration
│       ├── main.tf
│       ├── terraform.tfvars
│       └── backend.tfvars.example
├── scripts/
│   ├── user_data.sh           # EC2 User Data bootstrap script (Nginx & Metadata)
│   ├── init_backend.sh        # AWS CLI Bash script for S3 & DynamoDB backend setup
│   ├── init_backend.ps1       # AWS CLI PowerShell script for S3 & DynamoDB backend setup
│   ├── validate.sh            # Bash script for terraform fmt, validate & tflint
│   └── validate.ps1           # PowerShell script for terraform fmt, validate & tflint
├── .github/
│   └── workflows/
│       └── terraform-ci.yml   # GitHub Actions CI for formatting, validation & tflint
├── README.md                  # Main documentation
└── CARA-MENGERJAKAN.md        # Hands-on step-by-step execution guide
```

---

## ⚡ Ringkasan Cara Menjalankan

### 1. Inisialisasi Backend S3 & DynamoDB (Opsional jika belum ada)
```bash
./scripts/init_backend.sh my-custom-tfstate-bucket my-tfstate-locks ap-southeast-1
```

### 2. Validasi Kode & Formatting
```bash
./scripts/validate.sh
```

### 3. Inisialisasi & Deployment via Terraform
```bash
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

### 4. Menghapus Seluruh Resource AWS (Penting untuk hemat biaya)
```bash
terraform destroy -auto-approve
```

Untuk petunjuk lengkap langkah demi langkah, silakan baca [CARA-MENGERJAKAN.md](file:///c:/Users/Premio/Documents/Belajar%20Devops/Semua/project-03-modular-terraform-aws/CARA-MENGERJAKAN.md).
