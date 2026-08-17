# 📍 Modul 02 — Complete DevOps Learning Phases (Phases 1 – 8)

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
*(Detail rincian terdapat di [04-project-roadmap.md](file:///c:/Users/Premio/Documents/Belajar%20Devops/Track/04-project-roadmap.md))*

#### 6. Portfolio & Career Preparation
* Membangun Master Repository Portfolio di GitHub.
* Menyusun README profesional bergaya industri.
* Latihan simulasi technical interview & system design breakdown.

#### 7. Exit Criteria
- [ ] Seluruh infrastruktur dan pipeline capstone project sukses 100% tanpa error.
- [ ] GitHub Portfolio terstruktur rapi dan siap dikirim ke Recruiter / Hiring Manager.

---
*Kembali ke [README Index](file:///c:/Users/Premio/Documents/Belajar%20Devops/Track/README.md) atau lanjut ke [Modul 03 — Roadmaps & Schedules](file:///c:/Users/Premio/Documents/Belajar%20Devops/Track/03-roadmaps-and-schedules.md).*
