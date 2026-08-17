# 🚀 Personal Learning Track DevOps Engineer
**Target:** Transition dari IT Network/System Administrator → Job-Ready Junior/Intermediate DevOps Engineer  
**Metode:** 30% Fundamental + 70% Hands-on Project (Mindset: Manual → Automated → Scalable → Observable → Secure)

---

## 📌 1. Skill Gap Analysis & Assessment Matrix

Berdasarkan background Anda sebagai Network/System Administrator (Linux, Windows Server, Cisco, Ansible, Python, AWS, Terraform, Docker, Kubernetes, Git, GitHub Actions), berikut adalah pemetaan posisi skill Anda saat ini menuju target **Production-Ready DevOps Engineer**.

### Categorization Skill
* **A. Kuasai & Cukup Di-review:** Networking (TCP/IP, Subnetting, DNS, Routing), Linux Basic/Systemd/SSH, Basic Git.
* **B. Pernah Belajar — Perlu Diperdalam (Ke Production Level):** Docker, Terraform, Ansible, Python Scripting, AWS Core.
* **C. Belum Cukup Kuat (Need Bridging):** Kubernetes (EKS/Helm/Ingress/Probes), GitHub Actions CI/CD (Pipeline hardening, Security scan, Rollback).
* **D. Belum Dikuasai / Harus Belajar dari Dasar:** Observability Stack (Prometheus, Grafana, Loki), DevSecOps Tools (Trivy, CodeQL, Gitleaks, tfsec).
* **E. Skill Baru Wajib (Industry Standard):** Infrastructure Automation Integration (Terraform + Ansible + CI/CD Glue), GitOps Concept (ArgoCD/Flux - optional/nice to have), Secret Management Best Practices.

### 🗺️ Skill Matrix

| Skill Domain | Estimasi Level Saat Ini | Target Level | Gap / Focus Area | Prioritas | Learning Phase |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Linux & SysAdmin** | Intermediate | Advanced / Prod-Ready | Kernel tuning, Systemd service hardening, bash automation | Medium | Phase 1 |
| **Networking & DNS** | Advanced (SysAdmin) | Prod-Ready DevOps | Container/K8s networking (CNI), AWS VPC Architecture, TLS/Ingress | Low (Bridging) | Phase 1 & 3 |
| **Git & GitHub Workflow** | Basic / Intermediate | Prod-Ready | Conventional Commits, Gitflow, Branch Protection, Rebase, Tags | High | Phase 1 |
| **Python & Bash Scripting**| Basic / Intermediate | Intermediate+ | REST API, Automation scripts, AWS SDK (Boto3), Error handling | High | Phase 1 |
| **Docker & Containerization**| Basic / Intermediate | Prod-Ready | Multi-stage build, Security scanning, Distroless images, Compose optimization | Critical | Phase 2 |
| **AWS Infrastructure** | Basic / Intermediate | Prod-Ready | VPC design, Multi-AZ, IAM Least Privilege, EKS, RDS, ALB, CloudWatch | Critical | Phase 3 |
| **Terraform (IaC)** | Basic / Intermediate | Prod-Ready | Modular IaC, Remote Backend (S3+DynamoDB), State Locking, Workspaces | Critical | Phase 3 |
| **Ansible (Config Mgmt)** | Basic / Intermediate | Prod-Ready | Ansible Roles, Vault, Dynamic Inventory (AWS), Idempotency | High | Phase 4 |
| **CI/CD (GitHub Actions)** | Basic | Prod-Ready | Multi-stage pipelines, Matrix build, Security scan, Automated rollback | Critical | Phase 5 |
| **Kubernetes (K8s)** | Basic | Intermediate+ | Pod Lifecycle, Deployment strategies, Helm, Ingress Controller, HPA | Critical | Phase 6 |
| **Observability & Logging** | Beginner | Intermediate | Prometheus, Grafana Dashboards, Loki, Alertmanager, Metric Exporters | High | Phase 7 |
| **DevSecOps & Security** | Beginner | Intermediate | Image scan (Trivy), SAST (CodeQL), IaC scan (tfsec), Secret Scanning | High | Cross-Phase |

---

## 🔄 Mindset Transformation Paradigm

Sebagai mantan Network/SysAdmin, transformasi terbesar Anda bukan hanya syntax, melainkan **Mindset**:

```text
[MANUAL MINDSET]                          [DEVOPS AUTOMATION MINDSET]
SSH to Server & Edit Config Direct   ──►  Configuration Management via Ansible Playbook
Clicking AWS Console UI              ──►  Infrastructure as Code (Terraform Code + State)
Manual Git Pull & Restart Service    ──►  CI/CD Automated Deployment via GitHub Actions
Checking Log Files via `tail -f`     ──►  Centralized Monitoring & Alerting (Prometheus + Grafana + Loki)
Single Standalone EC2 Server         ──►  Self-healing, Auto-scaling Kubernetes Cluster
Fixing Issues Directly on Server     ──►  Immutable Infrastructure (Destroy & Re-provision)
```

---

## 🗺️ Complete DevOps Learning Roadmap (8 Phases)

---

### 📍 Phase 1 — Git Automation, Advanced Linux & DevOps Networking Bridging

#### 1. Tujuan
Memindahkan mindset dari SysAdmin manual ke Git-driven Developer-ready Ops, menguasai scripting otomatisasi, serta menjembatani fondasi networking ke container & cloud.

#### 2. Skill
Git & GitHub Flow, Advanced Bash & Python Automation, Linux Hardening, Systemd Service Management, DevOps Networking (DNS, Reverse Proxy, TLS).

#### 3. Fundamental
* **Git Internals:** Commit tree, Branching strategies (Gitflow, Feature Branching), Merge vs Rebase, Resolving Merge Conflicts, Tagging & Semantic Versioning (`v1.0.0`).
* **Linux Automation:** Systemd custom unit files, cgroups, process isolation, Linux Signals (`SIGTERM`, `SIGKILL`), logrotate.
* **Networking for DevOps:** HTTP/HTTPS headers, SSL/TLS handshake, reverse proxy architecture (Nginx), CORS, DNS records (A, CNAME, TXT, ALIAS).

#### 4. Hands-on
* Membuat custom systemd service untuk Python script yang berjalan background dengan auto-restart on failure.
* Setting Nginx sebagai Reverse Proxy dengan SSL Let's Encrypt (Certbot) dan rate-limiting.
* Menulis Bash script untuk automated backup directory dengan log rotation dan status notification via Webhook (Discord/Telegram).

#### 5. Project 1: Automated Linux Web Infrastructure & Git Workflow
* **Goal:** Membangun Nginx web server teraman yang dikondisikan via Git flow standar industri.
* **Architecture:** GitHub Repo → Web Hook / Script Pull → Systemd Nginx Server with SSL & Rate Limiting.
* **Output:** Repository publik dengan Conventional Commits, clean documentation, dan Bash automated setup script.

#### 6. Troubleshooting Scenarios
1. *Scenario 1:* Nginx return `502 Bad Gateway`.  
   *Investigation:* Check upstream app status (`systemctl status app`), check Nginx error log (`/var/log/nginx/error.log`), verify socket/port binding (`ss -tulpn`).
2. *Scenario 2:* Custom Systemd Service fail to start (`CrashLoop`).  
   *Investigation:* Inspect logs via `journalctl -u my-service.service -n 50 --no-pager`, check permissions and executable path.
3. *Scenario 3:* Git Merge Conflict pada configuration script.  
   *Investigation:* Use `git status`, `git diff`, edit conflict markers `<<<<<<<`, commit resolved state.
4. *Scenario 4:* Disk partition full due to unrotated logs.  
   *Investigation:* Identify large files via `du -sh /* | sort -h`, configure `/etc/logrotate.d/` properly.
5. *Scenario 5:* SSL Certificate Handshake failure.  
   *Investigation:* Verify certificate validity (`openssl x509 -in cert.pem -text -noout`), test port 443 with `curl -vI https://domain.com`.

#### 7. Challenge (Without Tutorial)
Tulis sebuah Python script yang membaca list IP/Domain dari CSV, mengecek SSL certificate expiration date & response code HTTP/HTTPS secara paralel (threading/asyncio), dan mengirimkan peringatan jika cert expired dalam < 7 hari.

#### 8. Production Practice
Di industri, SysAdmin tidak boleh lagi SSH langsung dan mengetik `nano /etc/nginx/nginx.conf`. Semua perubahan config harus tersimpan di Version Control System (VCS) dan dieksekusi secara terotomatisasi.

#### 9. Portfolio
* Repo: `project-01-linux-automation-git`
* Isi: Script Bash/Python, Config Nginx Hardened, Markdown documentation dengan flowchart.

#### 10. Exit Criteria
- [ ] Mampu mengatasi Git merge conflict dan merilis tag v1.0.0.
- [ ] Mampu membuat Systemd unit file & mengerti `journalctl`.
- [ ] Memahami aliran traffic dari Client → DNS → Router → Nginx Reverse Proxy → Application Port.

---

### 📍 Phase 2 — Containerization & Local Microservices (Docker & Docker Compose)

#### 1. Tujuan
Menguasai pemodelan aplikasi monolithic dan microservices ke dalam OCI (Open Container Initiative) compliant containers secara efisien, aman, dan berukuran kecil.

#### 2. Skill
Docker CLI, Dockerfile Best Practices, Multi-stage Builds, Docker Networking, Docker Volumes, Docker Compose, Image Security Scanning (Trivy).

#### 3. Fundamental
* **Docker Engine Architecture:** Daemon, Client, Images, Containers, Storage Drivers, Namespaces & cgroups.
* **Image Optimization:** Layer caching order, `.dockerignore`, Multi-stage builds (reducing node/python images from 1GB to < 100MB using Alpine/Distroless).
* **Networking & Volumes:** Bridge, Host, Overlay networks. Bind mounts vs Named Volumes.

#### 4. Hands-on
* Menulis Dockerfile multi-stage build untuk aplikasi Node.js/Python FastAPI.
* Membuat `docker-compose.yml` yang menghubungkan App + PostgreSQL + Redis dengan healthcheck dan volume persistence.
* Running security scan pada Docker image menggunakan `trivy image my-app:latest`.

#### 5. Project 2: Microservices Stack with Docker Compose & Hardened Security
* **Goal:** Melakukan containerization aplikasi 3-tier (Frontend React + Backend API + DB PostgreSQL) terintegrasi Docker Compose.
* **Architecture:**
  ```text
  [Client] ──► [Nginx Container (Port 80/443)]
                     │
                     ├──► [NodeJS API Container] ──► [PostgreSQL Volume]
                     └──► [React Frontend Container]
  ```
* **Output:** Stack yang berjalan hanya dengan 1 command `docker compose up -d` dengan healthcheck dan non-root container user.

#### 6. Troubleshooting Scenarios
1. *Scenario 1:* Backend container gagal connect ke Database container saat `docker compose up`.  
   *Investigation:* Cek `docker logs backend_container`, pastikan dependensi service `depends_on` menggunakan `condition: service_healthy`, cek DNS resolution nama service (`ping db` di dalam container network).
2. *Scenario 2:* Image size membengkak hingga 1.5 GB.  
   *Investigation:* Inspect layer dengan `docker history <image_id>`, tambahkan `.dockerignore` untuk node_modules/git, terapkan Multi-stage build dengan Distroless/Alpine base.
3. *Scenario 3:* Data database hilang saat container di-restart/recreate.  
   *Investigation:* Pastikan directory `/var/lib/postgresql/data` di-mount ke named volume persistent, bukan bind mount sementara.
4. *Scenario 4:* Container exit immediately dengan status `Exited (137)`.  
   *Investigation:* Exit code 137 menandakan OOM (Out of Memory) killed. Cek `docker inspect` dan naikkan memory resource limit/swap.
5. *Scenario 5:* Permission denied saat app menulis log di dalam container.  
   *Investigation:* Cek UID/GID `USER` di Dockerfile vs permission folder yang di-mount dari host.

#### 7. Challenge
Ubah container Nginx agar berjalan sebagai **non-root user** (`unprivileged nginx`) pada port 8080 dan sukses me-pass Trivy Security Scan tanpa vulnerability `HIGH` atau `CRITICAL`.

#### 8. Production Practice
Di production, container dilarang keras berjalan sebagai user `root`. Setiap image harus dikirim ke Container Registry (ECR/DockerHub) dengan tag versi spesifik, **bukan** `:latest`.

#### 9. Portfolio
* Repo: `project-02-docker-microservices`
* Isi: `Dockerfile` (Multi-stage), `docker-compose.yml`, `trivy-scan-report.txt`, Architecture diagram.

#### 10. Exit Criteria
- [ ] Ukuran image hasil multi-stage build < 150 MB.
- [ ] Mengerti perbedaan bind mount vs named volume.
- [ ] Mampu menghubungkan 3 container terisolasi dalam 1 docker network.

---

### 📍 Phase 3 — Infrastructure as Code (IaC) & Cloud Architecture (AWS + Terraform)

#### 1. Tujuan
Membangun infrastruktur cloud AWS yang handal, efisien, dan repeatable secara deklaratif menggunakan Terraform tanpa pernah mengklik AWS Management Console secara manual.

#### 2. Skill
AWS Core Services (VPC, EC2, ALB, RDS, S3, IAM, Security Groups), Terraform CLI, HCL (HashiCorp Configuration Language), Terraform Modules, Remote State & Locking (S3 + DynamoDB).

#### 3. Fundamental
* **AWS Networking Architecture:** Custom VPC, Public/Private Subnets across Multi-AZ, Route Tables, Internet Gateway (IGW), NAT Gateway, Security Groups vs NACLs.
* **Terraform Concepts:** Providers, Resources, Data Sources, Variables, Outputs, State File (`terraform.tfstate`), Drift Detection (`terraform plan`), Remote State Locking.
* **IaC Best Practices:** Reusable Modules, Environment Separation (Dev/Staging/Prod via workspaces/directories), DRY (Don't Repeat Yourself) principle.

#### 4. Hands-on
* Menulis modul Terraform kustom untuk merilis Custom VPC dengan 2 Public Subnet & 2 Private Subnet di 2 Availability Zone.
* Memasang Remote State Backend S3 dengan State Locking via DynamoDB table.
* Provisioning EC2 Auto Scaling Group dibelakang Application Load Balancer (ALB).

#### 5. Project 3: Automated Highly Available AWS Infrastructure via Terraform
* **Goal:** Menjalankan 1-click infrastructure deployment di AWS.
* **Architecture:**
  ```text
  [Internet] ──► [Application Load Balancer (Public Subnet)]
                        │
             ┌──────────┴──────────┐
             ▼                     ▼
     [EC2 Instance 1]      [EC2 Instance 2]  (Private Subnet AZ-a & AZ-b)
             │                     │
             └──────────┬──────────┘
                        ▼
            [AWS RDS PostgreSQL Multi-AZ] (Database Private Subnet)
  ```
* **Output:** Folder Terraform modular yang dapat di-`apply` dan di-`destroy` secara bersih tanpa sisa sisa dangling resource.

#### 6. Troubleshooting Scenarios
1. *Scenario 1:* `terraform apply` error `Error acquiring the state lock` (DynamoDB lock stuck).  
   *Investigation:* Verify jika ada process terraform lain running. Jika crash, gunakan `terraform force-unlock <LOCK-ID>` setelah verifikasi manual.
2. *Scenario 2:* EC2 Instance di Private Subnet tidak bisa mendownload package / update `apt-get`.  
   *Investigation:* Cek Route Table Private Subnet, pastikan 0.0.0.0/0 diarahkan ke NAT Gateway yang berada di Public Subnet.
3. *Scenario 3:* ALB Target Group menunjukkan status `Unhealthy` pada EC2 targets.  
   *Investigation:* Cek Health Check path di ALB, Security Group EC2 (apakah mengizinkan inbound traffic dari SG ALB pada port app), dan Web Server process di EC2.
4. *Scenario 4:* Resource Terraform terhapus atau diubah manual via AWS Console (State Drift).  
   *Investigation:* Jalankan `terraform plan` untuk mendeteksi drift. Gunakan `terraform apply` untuk mengembalikan ke desired state atau `terraform import` jika ingin mengadopsi resource manual.
5. *Scenario 5:* AWS IAM `AccessDenied` saat Terraform mencoba membuat Security Group.  
   *Investigation:* Inspect IAM Policy yang digunakan oleh AWS credentials (`aws sts get-caller-identity`), tambahkan least-privilege policy yang dibutuhkan.

#### 7. Challenge
Buat modul Terraform RDS PostgreSQL yang password-nya di-generate secara random via resource `random_password` dan disimpan otomatis ke **AWS Secrets Manager**, bukan plaintext di file `.tfstate` lokal.

#### 8. Production Practice
Di dunia kerja, `.tfstate` file pantang disimpan di Git repository karena berisi plaintext secret (database password, TLS key). Selalu gunakan S3 dengan Encryption Enabled + DynamoDB Locking.

#### 9. Portfolio
* Repo: `project-03-aws-terraform-infrastructure`
* Isi: `main.tf`, `variables.tf`, `outputs.tf`, folder `modules/vpc`, `modules/ec2`, `architecture-diagram.png`.

#### 10. Exit Criteria
- [ ] Mampu mendesain AWS VPC Multi-AZ dari nol via Terraform.
- [ ] Memahami alur `terraform init` → `plan` → `apply` → `destroy`.
- [ ] Berhasil mengimplementasikan S3 Remote State Backend + DynamoDB Lock.

---

### 📍 Phase 4 — Configuration Management & Automated Server Provisioning (Ansible)

#### 1. Tujuan
Mengotomatiskan konfigurasi Operating System, installasi software, hardening security, dan deployment aplikasi ke instance server bare-metal/EC2 yang di-provision oleh Terraform.

#### 2. Skill
Ansible Inventory, Playbooks, Modules, Variables & Facts, Handlers, Roles, Jinja2 Templates, Ansible Vault, AWS Dynamic Inventory (`aws_ec2`).

#### 3. Fundamental
* **Push-based Architecture:** Agentless setup via SSH, Idempotency (menjalankan playbook berulang kali tanpa mengubah state jika sudah sesuai).
* **Ansible Structuring:** Roles pattern (`tasks/`, `handlers/`, `templates/`, `vars/`, `defaults/`).
* **Dynamic Inventory:** Mengambil list IP EC2 secara dinamis berdasarkan AWS Tag (`Environment=Production`) menggunakan plugin `aws_ec2`.

#### 4. Hands-on
* Menulis Playbook untuk meng-install Nginx, Python, Docker, dan meng-copy file konfigurasi ter-template Jinja2 (`nginx.conf.j2`).
* Mengamankan database credentials menggunakan **Ansible Vault** (`ansible-vault encrypt vars/secrets.yml`).
* Menggabungkan Terraform output (IP address) langsung dengan ansible-playbook execution.

#### 5. Project 4: Fully Automated Immutable Server Configuration
* **Goal:** Setelah Terraform selesai membuat EC2, Ansible secara otomatis melakukan OS hardening, install Docker runtime, setup UFW firewall, dan deploy Web App.
* **Architecture:**
  ```text
  [Terraform] ──(Output EC2 IPs)──► [Ansible Controller]
                                            │ (SSH / Dynamic Inventory)
                                            ▼
                              [EC2 Production Instances]
                              ├── OS Security Hardening & SSH Config
                              ├── Install Docker Engine & Dependencies
                              └── Deploy Microservices Stack via Ansible Docker Module
  ```
* **Output:** Tercipta Ansible Role yang reusable dan teruji 100% idempotent (run 2x return `changed=0`).

#### 6. Troubleshooting Scenarios
1. *Scenario 1:* `Fatal: Host key verification failed` saat Ansible mencoba SSH ke EC2 baru.  
   *Investigation:* Configure `ansible.cfg` dengan `host_key_checking = False` untuk temporary CI environment atau pass proper SSH identity file `-i key.pem`.
2. *Scenario 2:* Playbook gagal di tengah jalan saat menginstal package (`apt-get lock`).  
   *Investigation:* Tambahkan task check/wait for apt lock file atau gunakan `retries` dan `delay` di Ansible task.
3. *Scenario 3:* Task Ansible selalu bernilai `changed` meskipun tidak ada pembaruan (Idempotency broken).  
   *Investigation:* Evaluasi task `command` atau `shell`. Gunakan modul bawaan Ansible (misal `apt`, `copy`, `systemd`) atau tambahkan parameter `creates:` / `changed_when:`.
4. *Scenario 4:* Ansible Vault decrypt error saat CI/CD pipeline berjalan.  
   *Investigation:* Pastikan `--vault-password-file` atau environment variable `ANSIBLE_VAULT_PASSWORD` disuplai dengan benar pada runner CI.
5. *Scenario 5:* Dynamic inventory `aws_ec2` tidak menemukan instance AWS.  
   *Investigation:* Verify AWS credentials/region di runner environment dan pastikan tag EC2 sesuai dengan filter di `aws_ec2.yml`.

#### 7. Challenge
Buat Ansible Role `ssh_hardening` yang mengubah default SSH port ke 2222, disable root login (`PermitRootLogin no`), disable password authentication (`PasswordAuthentication no`), dan mengkonfigurasi `fail2ban`.

#### 8. Production Practice
Di infrastruktur produksi modern menghindari konfigurasi manual server. Jika ada perubahan konfigurasi (misal update Nginx config), ubah di Ansible Role, lakukan commit ke Git, dan jalankan Ansible Playbook via CI/CD pipeline.

#### 9. Portfolio
* Repo: `project-04-ansible-server-provisioning`
* Isi: `site.yml`, `ansible.cfg`, `roles/common`, `roles/docker`, `roles/security`, `README.md`.

#### 10. Exit Criteria
- [ ] Memahami konsep Idempotency dan mampu membuktikannya.
- [ ] Mampu membuat dan strukturasi Ansible Roles secara profesional.
- [ ] Mampu mengamankan data sensitif dengan Ansible Vault.

---

### 📍 Phase 5 — Continuous Integration & Continuous Delivery (CI/CD) with GitHub Actions

#### 1. Tujuan
Membangun automated software delivery pipeline yang mencakup linting, automated testing, security scanning, container building, pushing ke registry, dan zero-downtime deployment.

#### 2. Skill
GitHub Actions Workflows, Jobs, Steps, Matrix Builds, Self-hosted/GitHub Runners, Secrets & Environment Variables, Image Registry (AWS ECR / Docker Hub), Security Scanning (Trivy, Gitleaks, Dependabot), Deployment Strategies (Recreate, Rolling Update).

#### 3. Fundamental
* **CI/CD Lifecycle:**
  ```text
  [Developer Git Push] ──► [Pull Request Trigger] ──► [Lint & Unit Test] ──► [Security Scan]
                                                                                  │
  [Prod Deployment] ◄── [Deploy to Staging] ◄── [Push ECR] ◄── [Docker Build] ◄───┘
  ```
* **Git Security:** Mencegah kebocoran secret (API Keys/Passwords) di commit history menggunakan pre-commit hooks & Gitleaks.
* **Pipeline Efficiency:** Caching dependency (`actions/cache`), Docker layer caching (`cache-from/cache-to` dengan ECR/GitHub Cache).

#### 4. Hands-on
* Menulis file workflow `.github/workflows/ci-cd.yml` dengan job paralel (Linting, Testing, Security).
* Menerapkan OIDC (OpenID Connect) authentication antara GitHub Actions dan AWS IAM (tanpa menyimpan long-lived AWS Access Key/Secret Key di GitHub Secrets).
* Membuat Slack/Discord notification step yang memberitahukan status pipeline (Success / Failed).

#### 5. Project 5: Enterprise-Grade Production CI/CD Pipeline
* **Goal:** Otomatisasi total dari commit code hingga aplikasi ter-deploy di AWS EC2/ECS secara aman.
* **Pipeline Specs:**
  1. **Stage 1 (Quality & Security):** Run Linter, Execute Unit Tests, Gitleaks Secret Scan, Trivy File System Scan.
  2. **Stage 2 (Build & Package):** Multi-stage Docker Build, Tagging dengan Short Commit SHA (`v1.0.0-a1b2c3d`), Push ke AWS ECR.
  3. **Stage 3 (Infrastructure & Provisioning):** Terraform Plan/Apply check.
  4. **Stage 4 (Deploy & Smoke Test):** SSH/Ansible/AWS ECS update service → HTTP Health Check verification → Rollback otomatis jika HTTP 5xx.

#### 6. Troubleshooting Scenarios
1. *Scenario 1:* Pipeline gagal di step `docker push` ke AWS ECR (`Denied: User is not authorized`).  
   *Investigation:* Check step AWS Credentials login (`aws-actions/configure-aws-credentials`), pastikan IAM Role memiliki policy `ecr:GetAuthorizationToken` dan `ecr:BatchCheckLayerAvailability`.
2. *Scenario 2:* Build time Docker image sangat lambat (memakan waktu 15+ menit setiap run).  
   *Investigation:* Implementasikan GitHub Actions caching `type=gha` pada Docker Buildx action dan perbaiki urutan command Dockerfile.
3. *Scenario 3:* Secrets ter-push secara tidak sengaja ke Git Commit.  
   *Investigation:* Revoke credential secepatnya di AWS/Provider, gunakan `git-filter-repo` atau BFG Repo-Cleaner untuk menghapus dari commit history, aktifkan GitHub Secret Scanning.
4. *Scenario 4:* Automated Deployment berhasil tetapi aplikasi crashing di server (Smoke test fail).  
   *Investigation:* Jalankan step rollback otomatis di pipeline (`if: failure()`), inspect container logs di remote server via SSH command.
5. *Scenario 5:* Matrix build kehabisan runner quota atau concurrency limit.  
   *Investigation:* Batasi concurrency group di `.github/workflows` (`concurrency: group: ${{ github.workflow }}-${{ github.ref }}`).

#### 7. Challenge
Tambahkan **Branch Protection Rules** di GitHub repository yang mewajibkan:
* Minimal 1 Pull Request Code Review approval.
* Seluruh check CI/CD pipeline (Lint, Test, Trivy Scan) bernilai **PASSED** sebelum PR bisa di-merge ke branch `main`.

#### 8. Production Practice
Jangan pernah menyimpan `AWS_ACCESS_KEY_ID` dan `AWS_SECRET_ACCESS_KEY` statis di repository secrets jika menggunakan AWS. Gunakan **AWS IAM OIDC Role Federation** yang memberikan temporary short-lived token per job execution.

#### 9. Portfolio
* Repo: `project-05-enterprise-cicd-pipeline`
* Isi: `.github/workflows/pipeline.yml`, `src/`, `Dockerfile`, README dengan CI/CD badge status hijau.

#### 10. Exit Criteria
- [ ] Memahami perbedaan Continuous Integration, Delivery, dan Deployment.
- [ ] Mampu membuat pipeline multi-stage dengan conditional job (`needs:`).
- [ ] Berhasil menghubungkan GitHub Actions ke AWS ECR menggunakan OIDC.

---

### 📍 Phase 6 — Container Orchestration at Scale (Kubernetes & Helm)

#### 1. Tujuan
Menguasai orchestrasi container skala besar untuk menangani High Availability, Auto-scaling, Self-healing, Zero-downtime Rolling Updates, dan Service Mesh/Ingress di Kubernetes (EKS / Minikube).

#### 2. Skill
Kubernetes Architecture (Control Plane vs Worker Nodes), kubectl CLI, Pods, Deployments, ReplicaSets, Services (ClusterIP, NodePort, LoadBalancer), ConfigMaps & Secrets, Ingress Controllers (Nginx Ingress), Persistent Volumes (PV/PVC), Helm Package Manager, Horizontal Pod Autoscaler (HPA).

#### 3. Fundamental
* **Architecture:** API Server, Etcd, Scheduler, Controller Manager, Kubelet, Kube-proxy, CNI Network Plugins.
* **Declarative Manifests:** YAML Schema, `apiVersion`, `kind`, `metadata`, `spec`.
* **Application Reliability:** Liveness Probes, Readiness Probes, Startup Probes, Resource Requests & Limits (CPU/Memory) untuk mencegah OOMKilled nodes.
* **Helm:** Templating Kubernetes YAML, `values.yaml`, Chart release management.

#### 4. Hands-on
* Menulis Kubernetes manifest lengkap (Deployment, Service, ConfigMap, Secret, PVC, Ingress) untuk 2-tier application.
* Meng-install Nginx Ingress Controller dan Cert-Manager via Helm untuk HTTPS otomatis.
* Menguji HPA (Horizontal Pod Autoscaler) dengan melakukan Load Test (`hey` / `locust`) hingga Pod meng-scale dari 2 ke 10 instance.

#### 5. Project 6: Cloud-Native Microservices Deployment on AWS EKS with Helm
* **Goal:** Launching Production Kubernetes Cluster di AWS EKS (via Terraform) dan deploy aplikasi microservices ter-orchestrasi.
* **Architecture:**
  ```text
  [User Traffic] ──► [AWS ALB Ingress Controller]
                             │
            ┌────────────────┴────────────────┐
            ▼ (Host Routing)                  ▼
  [Frontend Service (ClusterIP)]    [Backend API Service (ClusterIP)]
            │                                 │
            ▼                                 ▼
   [Frontend Pods x3]                [Backend Pods x3 (HPA Enabled)]
                                              │
                                              ▼
                                    [External AWS RDS DB]
  ```
* **Output:** Helm Chart kustom yang bisa di-deploy dengan command `helm upgrade --install my-app ./my-helm-chart`.

#### 6. Troubleshooting Scenarios
1. *Scenario 1:* Pod menunjukkan status `CrashLoopBackOff`.  
   *Investigation:* Inspect pod logs (`kubectl logs <pod-name> --previous`), inspect events (`kubectl describe pod <pod-name>`), periksa misconfiguration environment variable / DB connection.
2. *Scenario 2:* Pod bertengger di status `Pending`.  
   *Investigation:* Run `kubectl describe pod <pod-name>`. Cek apakah node kehabisan resource CPU/Memory (insufficient CPU/memory) atau PVC gagal di-bind oleh StorageClass.
3. *Scenario 3:* Ingress me-return HTTP `503 Service Temporarily Unavailable`.  
   *Investigation:* Periksa apakah Service endpoint memiliki Pod aktif (`kubectl get endpoints <service-name>`). Cek label selector pada Service vs Pod match.
4. *Scenario 4:* Pod terus-menerus di-restart oleh Kubernetes (Liveness probe failed).  
   *Investigation:* Inspect `kubectl describe pod`, sesuaikan `initialDelaySeconds`, `timeoutSeconds`, dan endpoint `/health` pada Liveness probe spec.
5. *Scenario 5:* Helm release stuck dalam status `pending-install` atau `pending-upgrade`.  
   *Investigation:* Jalankan `helm rollback <release-name> <revision>` atau `helm history`, selesaikan conflict resource sebelum re-applying.

#### 7. Challenge
Konfigurasikan **Zero-Downtime Deployment Strategy** menggunakan `maxSurge: 25%` dan `maxUnavailable: 0%` pada Deployment spec, lalu buktikan saat rolling update dilakukan dengan script test HTTP continuous request (`curl` loop) tidak ada 1 pun request yang return HTTP 5xx.

#### 8. Production Practice
Jangan pernah meletakkan resource limit Kubernetes tanpa perhitungan. Jika `memory limit` terlampaui, Pod akan terkena `OOMKilled`. Jika `CPU limit` terlampaui, Pod akan mengalami `CPU Throttling` (kinerja melambat).

#### 9. Portfolio
* Repo: `project-06-kubernetes-eks-helm`
* Isi: Terraform code untuk EKS cluster, Helm Chart directory `charts/my-microservice`, Manifest files YAML, Proof of Auto-scaling screenshot.

#### 10. Exit Criteria
- [ ] Mampu mendiagnosa Pod issue menggunakan `kubectl logs`, `describe`, `exec`.
- [ ] Memahami perbedaan Service type: ClusterIP, NodePort, LoadBalancer, Ingress.
- [ ] Mampu membuat dan meng-custom Helm Chart.

---

### 📍 Phase 7 — Production Observability, Centralized Logging & Alerting

#### 1. Tujuan
Membangun visibilitas penuh (End-to-End Observability) terhadap kondisi infrastructure dan aplikasi menggunakan Metrics, Centralized Logs, Dashboards, dan Automated Alerts.

#### 2. Skill
Prometheus (Metrics Collection & PromQL), Grafana (Dashboard Visualization), Grafana Loki / ELK Stack (Log Aggregation), Alertmanager (Notification routing to Slack/PagerDuty), Node Exporter, Kube-State-Metrics.

#### 3. Fundamental
* **The 4 Golden Signals of Monitoring:** Latency, Traffic, Errors, and Saturation.
* **SLI / SLO / SLA Concepts:**
  * **SLI (Service Level Indicator):** Metric terukur (misal: HTTP Success Rate = 99.9%).
  * **SLO (Service Level Objective):** Target internal tim (misal: Success rate > 99.5% per bulan).
  * **SLA (Service Level Agreement):** Kontrak bisnis dengan klien akhir.
* **Pull vs Push Metrics:** Prometheus scrape architecture via `/metrics` endpoint.

#### 4. Hands-on
* Deploy **kube-prometheus-stack** pada Kubernetes cluster menggunakan Helm.
* Membuat Custom Grafana Dashboard yang menampilkan CPU/Memory usage, HTTP Request Rate (RPS), dan Error Rate (HTTP 5xx).
* Mengkonfigurasi Alertmanager rule untuk mengirim notifikasi ke Discord/Slack Webhook jika CPU usage > 85% selama 5 menit.

#### 5. Project 7: Enterprise Observability Stack with Prometheus, Grafana & Loki
* **Goal:** Menghubungkan seluruh server AWS EC2 dan Kubernetes Pods ke satu pusat Monitoring & Logging yang real-time.
* **Architecture:**
  ```text
  [EKS Cluster Nodes] ──(Node Exporter)──┐
                                         ▼
  [K8s App Pods] ────────(/metrics)───► [Prometheus Server] ──► [Grafana Visual Dashboard]
                                         ▲                            │
  [K8s App Logs] ────────(Promtail)───► [Loki Server]                ▼
                                                              [Alertmanager] ──► [Slack/Discord Webhook]
  ```
* **Output:** Dashboard Grafana live dan Alertmanager rule teruji (dites menggunakan stress tool `stress-ng`).

#### 6. Troubleshooting Scenarios
1. *Scenario 1:* Prometheus Target menunjukkan status `DOWN` (Error: `connection refused`).  
   *Investigation:* Inspect target IP/Port di Prometheus UI (`/targets`), periksa Network Policy/Security Group, dan pastikan `/metrics` endpoint app aktif.
2. *Scenario 2:* Grafana Dashboard menunjukkan panel `No Data`.  
   *Investigation:* Test query PromQL langsung di Prometheus Expression Browser, verify data source connection di Grafana settings.
3. *Scenario 3:* Alertmanager tidak mengiringkan pesan ke Slack saat incident terjadi.  
   *Investigation:* Check Alertmanager logs (`kubectl logs -l app=prometheus-alertmanager`), test webhook URL secara manual dengan `curl -X POST`.
4. *Scenario 4:* Loki kehabisan disk space karena menampung log aplikasi berukuran sangat besar.  
   *Investigation:* Konfigurasikan retention policy di Loki config (`retention_period: 7d`), perbaiki log verbosity aplikasi dari `DEBUG` ke `INFO/WARN` di production.
5. *Scenario 5:* High CPU consumption pada Prometheus pod itu sendiri.  
   *Investigation:* Evaluasi cardinality PromQL query (terlalu banyak label unik), sesuaikan scrape interval dari `5s` ke `15s` atau `30s`.

#### 7. Challenge
Tulis alert rule PromQL custom untuk mendeteksi **High HTTP 5xx Error Rate** (jika persentase response code 5xx > 5% dari total traffic selama 2 menit terakhir) dan **Kubernetes Pod Frequent Restarts** (`increase(kube_pod_container_status_restarts_total[5m]) > 3`).

#### 8. Production Practice
Monitoring bukan sekadar membuat grafik warna-warni yang indah. Monitoring adalah sistem peringatan dini (early warning system). Setiap Alert harus memicu **Actionable Runbook** (langkah penyelesaian masalah), bukan sekadar noise spamming di channel Slack.

#### 9. Portfolio
* Repo: `project-07-observability-prometheus-grafana`
* Isi: Prometheus alert rules YAML, Custom Grafana JSON Dashboards, Screenshots dashboard under load test, Alert notification evidence.

#### 10. Exit Criteria
- [ ] Memahami 4 Golden Signals.
- [ ] Mampu menulis query dasar PromQL (`rate`, `sum`, `by`).
- [ ] Berhasil mensimulasikan incident dan menerima alert otomatis di Slack/Discord.

---

### 📍 Phase 8 — DevSecOps Integration, Final Capstone Project & Career Readiness

#### 1. Tujuan
Mengintegrasikan keamanan di setiap layer (Shift-Left Security), menggabungkan seluruh pengetahuan dari Phase 1–7 ke dalam **Final Enterprise Capstone Project**, serta mempersiapkan portfolio dan interview technical discussion.

#### 2. Skill
DevSecOps Tools Integration (Trivy, Gitleaks, Checkov/tfsec, Kube-bench), IAM Least Privilege Audit, Production Hardening, System Design & Architecture Presentation, Technical Resume/GitHub Optimization.

#### 3. Fundamental
* **DevSecOps Shift-Left Philosophy:** Menemukan kerentanan (vulnerabilities) sedini mungkin di tahap coding/building, bukan setelah rilis di production.
* **Security Layers:**
  1. *Code:* Secret scanning (Gitleaks), SAST (CodeQL).
  2. *Dependency:* Software Supply Chain Security (Dependabot).
  3. *Container:* Container Image Vulnerability Scanning (Trivy).
  4. *Infrastructure (IaC):* Static Analysis Terraform (Checkov/tfsec).
  5. *Runtime K8s:* CIS Kubernetes Benchmark (Kube-bench).

#### 4. Hands-on
* Menjalankan `checkov -d ./terraform` untuk mendeteksi salah konfigurasi AWS Security Group dan S3 Bucket public access.
* Menjalankan `kube-bench` untuk mengevaluasi kepatuhan Kubernetes cluster terhadap standar CIS Security Benchmark.

#### 5. Project 8: Final Enterprise DevOps Capstone Project
*(Detail lengkap dijelaskan di Section 16 & 29)*

#### 6. Portfolio & Career Preparation
* Membangun Master Repository Portfolio di GitHub.
* Menyusun README profesional bergaya industri.
* Latihan simulasi technical interview & system design breakdown.

#### 7. Exit Criteria
- [ ] Seluruh infrastruktur dan pipeline capstone project sukses 100% tanpa error.
- [ ] GitHub Portfolio terstruktur rapi dan siap dikirim ke Recruiter / Hiring Manager.

---

## 🗓️ 3-Month Intensive Roadmap (12 Weeks Schedule)

> **Komitmen Waktu:** ~20–25 jam per minggu (Cocok untuk Full-Time Bootcamp / Intensive Focus).

```text
[WEEK 1-2] Phase 1: Advanced Linux, Git Flow & DevOps Networking
 ├── W1: Conventional Commits, Rebase, Systemd, Bash Automation Scripting.
 └── W2: Nginx Reverse Proxy Hardening, Certbot SSL, Networking Deep Dive. -> Project 1

[WEEK 3-4] Phase 2: Containerization & Local Microservices (Docker)
 ├── W3: Docker Architecture, Dockerfile Multi-stage Build, Image Optimization.
 └── W4: Docker Compose, Container Networking, Trivy Scan. -> Project 2

[WEEK 5-6] Phase 3: Infrastructure as Code (AWS + Terraform)
 ├── W5: AWS Core (VPC Multi-AZ, Subnets, IAM, Security Groups), HCL Basics.
 └── W6: Modular Terraform, S3 Remote State, DynamoDB Lock, ALB + EC2. -> Project 3

[WEEK 7] Phase 4: Configuration Management (Ansible)
 └── W7: Ansible Roles, Vault, Dynamic Inventory AWS, OS Hardening. -> Project 4

[WEEK 8-9] Phase 5: Production CI/CD (GitHub Actions) & DevSecOps
 ├── W8: GitHub Actions Workflow, Multi-stage, OIDC AWS Integration.
 └── W9: Automated Security Scanning (Trivy, Gitleaks), Auto-Rollback Pipeline. -> Project 5

[WEEK 10-11] Phase 6: Cloud-Native Kubernetes (AWS EKS & Helm)
 ├── W10: K8s Architecture, Pods, Deployments, Services, Ingress, Probes.
 └── W11: AWS EKS Provisioning via Terraform, Helm Charts, HPA. -> Project 6

[WEEK 12] Phase 7 & 8: Observability Stack & Final Capstone Project
 ├── Days 1-3: Prometheus, Grafana, Loki Deployment & Alerting Rules. -> Project 7
 └── Days 4-7: Final Capstone Integration, Documentation & Resume Polish. -> Capstone
```

---

## 🗓️ 6-Month Sustainable Roadmap (24 Weeks Schedule)

> **Komitmen Waktu:** ~10–12 jam per minggu (Cocok untuk Belajar Sambil Bekerja / Side-Learning).

| Month | Target Utama | Focus Weekly | Output & Milestone |
| :--- | :--- | :--- | :--- |
| **Bulan 1** | **Git, Advanced Linux & Networking** | W1: Advanced Git Workflow<br>W2: Linux Systemd & Bash Scripting<br>W3: Networking, DNS, Nginx SSL<br>W4: **Project 1 Execution & Review** | **Project 1 Live** (Automated Linux Infrastructure) |
| **Bulan 2** | **Docker & Microservices** | W5: Dockerfile Multi-stage<br>W6: Docker Networking & Volumes<br>W7: Docker Compose Microservices<br>W8: **Project 2 Execution & Trivy Scanning** | **Project 2 Live** (Microservices Docker Compose) |
| **Bulan 3** | **AWS Cloud & Terraform IaC** | W9: AWS VPC Multi-AZ Networking<br>W10: Terraform HCL & Modules<br>W11: S3 Remote Backend & DynamoDB Lock<br>W12: **Project 3 Execution (AWS ALB+EC2+RDS)** | **Project 3 Live** (Terraform AWS Infrastructure) |
| **Bulan 4** | **Ansible & CI/CD Pipeline** | W13: Ansible Roles & Idempotency<br>W14: Ansible Vault & AWS Dynamic Inventory<br>W15: GitHub Actions Fundamentals & OIDC<br>W16: **Project 4 & 5 Execution (CI/CD Pipeline)** | **Project 4 & 5 Live** (Ansible & Automated Pipeline) |
| **Bulan 5** | **Kubernetes Orchestration** | W17: K8s Fundamentals (Pod/Svc/Deploy)<br>W18: Ingress, ConfigMaps, PVC, Probes<br>W19: AWS EKS & Helm Package Manager<br>W20: **Project 6 Execution (EKS + HPA)** | **Project 6 Live** (Production EKS Microservices) |
| **Bulan 6** | **Observability & Final Capstone** | W21: Prometheus Metrics & PromQL<br>W22: Grafana Dashboards & Loki Logging<br>W23: **Final Capstone Integration Phase**<br>W24: **Portfolio Polish & Interview Prep** | **Final Capstone Project & Portfolio Complete** |

### Perbandingan 3 Bulan vs 6 Bulan

| Parameter | 3-Month Intensive | 6-Month Sustainable |
| :--- | :--- | :--- |
| **Beban Belajar** | 20–25 Jam / Minggu | 10–12 Jam / Minggu |
| **Tempo Pembelajaran** | Sangat Cepat, Fokus Penuh | Stabil, Menyesuaikan Jam Kerja |
| **Retensi Memori** | Butuh Review Berulang | Memasang Rutinitas Harian Lebih Kuat |
| **Rekomendasi Untuk** | Full-time Job Seeker / Career Switcher | Working Professional (SysAdmin Aktif) |

---

## ⏰ Daily & Weekly Learning System

### 1. Pola Belajar Hari Kerja (Weekday: 2 Jam / Hari)

```text
⏱️ 00:00 - 00:30 (30 Mins)  ──► 📘 Fundamental & Conceptual Understanding
                                   Read Official Documentation / Architecture Diagrams.
⏱️ 00:30 - 01:45 (75 Mins)  ──► 💻 Hands-on Practice / Code Execution
                                   Build Terraform code, Dockerfile, or Playbook.
⏱️ 01:45 - 02:00 (15 Mins)  ──► 📝 Documentation & Git Push
                                   Commit code with Conventional Commits, update README.
```

### 2. Pola Belajar Akhir Pekan (Weekend: 4–5 Jam / Hari)

```text
⏱️ Session 1 (2 Jam)  ──► 🏗️ Project Development & Architecture Assembly
                           Menggabungkan komponen yang dipelajari di Weekday.
⏱️ Session 2 (2 Jam)  ──► 🧯 Controlled "Break Something" & Troubleshooting Drill
                           Sengaja merusak konfigurasi (misal: salah port, hapus secret),
                           lalu latih proses diagnosa hingga resolved.
⏱️ Session 3 (1 Jam)  ──► 🔍 Weekly Review & Assessment Self-Grading
```

---

## 🛠️ Complete Project Roadmap (Projects 1 – 10 + Capstone)

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

## 🧯 Troubleshooting Roadmap & Industry Simulations

Sebagai DevOps Engineer, **70% nilai tambah Anda terletak pada kemampuan mendiagnosa dan memulihkan insiden produksi secepat mungkin.**

### Diagnostic Framework Flowchart

```text
[DETECT]      ──► PagerDuty / Slack Alert triggers (e.g. HTTP 500 Spike)
   │
[INVESTIGATE] ──► Inspect Grafana Dashboards ──► Check Prometheus Metrics ──► Read Loki/Journalctl Logs
   │
[IDENTIFY]    ──► Pinpoint Root Cause (e.g., Database Connection Pool Exhausted)
   │
[FIX]         ──► Apply Temporary Mitigation (Scale Up Pods) + Permanent Fix (Increase DB Max Connections)
   │
[VERIFY]      ──► Check Metrics back to Normal + Smoke Test API Endpoint
   │
[PREVENT]     ──► Post-Mortem Document + Add Alerting Rule + Terraform/Ansible Code Update
```

---

### 🚨 Real-World Incident Simulation Scenarios

#### 🛠️ Incident 1: Production Server Unreachable (HTTP 504 Gateway Timeout)
* **Context:** Aplikasi e-commerce mendadak tidak bisa diakses pelanggan saat lonjakan promo.
* **Diagnostic Command Flow:**
  ```bash
  # 1. Check server uptime & load average
  uptime
  top -b -n 1 | head -n 20

  # 2. Check network socket states & active connections
  ss -tulpn
  netstat -an | grep SYN_RECV | wc -l

  # 3. Inspect Nginx error logs
  tail -f -n 100 /var/log/nginx/error.log | grep -E "upstream timed out|connect() failed"

  # 4. Check backend service status & system logs
  systemctl status backend-app.service
  journalctl -u backend-app.service -n 100 --no-pager
  ```
* **Root Cause:** Backend Application thread pool hang karena database query mengalami deadlock.
* **Fix & Prevention:** Kill hung process (`kill -9`), restart service, tambahkan database query timeout, dan pasang connection pool limit di backend config.

#### 🛠️ Incident 2: Kubernetes Pod Stuck in `CrashLoopBackOff`
* **Context:** Setelah rilis CI/CD versi baru, Pod backend di Kubernetes mengalami restart terus menerus.
* **Diagnostic Command Flow:**
  ```bash
  # 1. Check pod status & restart count
  kubectl get pods -n production -o wide

  # 2. Inspect recent logs of the crashed container
  kubectl logs -n production <pod-name> --previous

  # 3. Inspect Kubernetes events for the pod
  kubectl describe pod -n production <pod-name>
  ```
* **Root Cause:** Application gagal membaca environment variable `DATABASE_URL` karena typo di ConfigMap/Secret YAML.
* **Fix & Prevention:** Perbaiki typo di Git repository ConfigMap, jalankan `helm upgrade`, dan tambahkan validation test di CI/CD pipeline.

#### 🛠️ Incident 3: Terraform State File Lock Conflict & Drift
* **Context:** Pipeline CI/CD Terraform gagal berjalan dengan pesan `Error acquiring the state lock`.
* **Diagnostic Command Flow:**
  ```bash
  # 1. Inspect DynamoDB Lock Table via AWS CLI
  aws dynamodb scan --table-name terraform-state-lock-table

  # 2. Check active running Terraform jobs
  # 3. Force unlock state (if verified no active apply is running)
  terraform force-unlock <LOCK-ID>

  # 4. Detect configuration drift
  terraform plan -detailed-exitcode
  ```
* **Root Cause:** Job CI/CD sebelumnya terputus secara tidak wajar (cancelled by user) saat `terraform apply` sedang berlangsung, meninggalkan lock ID di DynamoDB.
* **Fix & Prevention:** Hapus lock dengan `terraform force-unlock`, pastikan CI/CD job memiliki timeout handler.

---

## 🔐 DevSecOps Integration Roadmap

Integrasi keamanan harus dilakukan di **setiap tahap SDLC (Software Development Life Cycle)**:

```text
┌───────────────────────────────────────────────────────────────────────────┐
│                           DEVSECOPS PIPELINE                              │
├───────────────┬───────────────────┬───────────────────┬───────────────────┤
│    PLAN &     │      BUILD &      │      TEST &       │     DEPLOY &      │
│     CODE      │      PACKAGE      │       IAC         │      RUNTIME      │
├───────────────┼───────────────────┼───────────────────┼───────────────────┤
│ • Gitleaks    │ • Trivy Container │ • Checkov IaC     │ • AWS GuardDuty   │
│   (Secret     │   Image Scan      │   Scan            │ • CIS Kube-bench  │
│   Scan)       │ • Docker Multi-   │ • CodeQL SAST     │ • IAM Least       │
│ • Pre-commit  │   stage Non-root  │   (Supply-chain)  │   Privilege Audit │
│   Hooks       │   Distroless      │   (Supply-chain)  │ • AWS WAF         │
└───────────────┴───────────────────┴───────────────────┴───────────────────┘
```

---

## 📁 Standardized GitHub Portfolio Structure

Agar terlihat sangat profesional di mata Hiring Manager/Recruiter, susunlah GitHub Repository Anda dengan struktur master berikut:

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

## 🎤 Comprehensive DevOps Interview Preparation Kit

---

### 1. Linux & Systems
* **Basic:** Apa perbedaan antara `process` dan `thread`? Bagaimana cara melihat penggunaan memori di Linux (`free -h`, `/proc/meminfo`)?
* **Intermediate:** Jelaskan bagaimana Systemd mengelola service dependency (`Requires=`, `Wants=`, `After=`)!
* **Troubleshooting:** Sebuah server Linux tiba-tiba sangat lambat. Langkah diagnosa awal apa yang Anda lakukan (`top`, `iostat`, `vmstat`, `dmesg`)?
* **Architecture:** Jelaskan konsep Linux `cgroups` dan `namespaces` serta hubungannya dengan isolasi container Docker!

---

### 2. Networking & Cloud (AWS)
* **Basic:** Jelaskan perbedaan Public Subnet dan Private Subnet di AWS VPC!
* **Intermediate:** Bagaimana alur traffic dari internet menuju ke EC2 instance di Private Subnet melalui Application Load Balancer?
* **Troubleshooting:** EC2 Instance di Private Subnet tidak bisa mengunduh update package dari internet. Apa yang perlu diperiksa di VPC Route Table & NAT Gateway?
* **Architecture:** Bagaimana Anda merancang arsitektur AWS VPC yang High Available dan Fault Tolerant di 2 Availability Zone?

---

### 3. Docker & Containerization
* **Basic:** Perbedaan `CMD` vs `ENTRYPOINT` pada Dockerfile?
* **Intermediate:** Mengapa kita disarankan menggunakan Multi-Stage Build pada Dockerfile? Apa keuntungannya bagi keamanan dan performance?
* **Troubleshooting:** Container exit dengan code 137. Apa penyebabnya dan bagaimana solusi Anda?
* **Architecture:** Bagaimana cara mengamankan Docker Image agar lolos audit keamanan di industri?

---

### 4. Infrastructure as Code (Terraform)
* **Basic:** Perbedaan `terraform plan`, `terraform apply`, dan `terraform refresh`?
* **Intermediate:** Mengapa `.tfstate` file sangat krusial dan mengapa dilarang keras di-commit ke Git? Solusi apa yang Anda pakai?
* **Troubleshooting:** Terjadi `State Locking Error` pada S3/DynamoDB backend saat pipeline terputus. Bagaimana cara penyelesaian yang aman?
* **Architecture:** Bagaimana strategi memisahkan Terraform code untuk lingkungan Development, Staging, dan Production?

---

### 5. Kubernetes & Orchestration
* **Basic:** Jelaskan komponen utama Kubernetes Control Plane (API Server, Etcd, Scheduler, Controller Manager)!
* **Intermediate:** Jelaskan perbedaan `Liveness Probe`, `Readiness Probe`, dan `Startup Probe`!
* **Troubleshooting:** Pod Anda berada dalam status `CrashLoopBackOff`. Tuliskan 3 command `kubectl` utama untuk mencari root cause!
* **Architecture:** Bagaimana strategi melakukan Zero-Downtime Deployment di Kubernetes (RollingUpdate vs Blue/Green)?

---

### 6. Observability & Monitoring
* **Basic:** Sebutkan 4 Golden Signals dalam Monitoring!
* **Intermediate:** Jelaskan perbedaan pendekatan Pull-based (Prometheus) dan Push-based (Graphite/Datadog)!
* **Troubleshooting:** Grafana menunjukkan status `No Data` pada panel CPU usage server. Bagaimana alur pemeriksaan Anda?

---

## 📝 Weekly Self-Assessment & Scoring Template

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

## 🧪 Final Technical Assessment (Take-Home Assignment Style)

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

## 🏆 Final Enterprise Capstone Project

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

## 🎯 Final DevOps Engineer Readiness Checklist

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
