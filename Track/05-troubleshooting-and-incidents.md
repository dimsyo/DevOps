# 🧯 Modul 05 — Troubleshooting Roadmap & Industry Simulations

Sebagai DevOps Engineer, **70% nilai tambah Anda terletak pada kemampuan mendiagnosa dan memulihkan insiden produksi secepat mungkin.**

---

## 🔍 1. Diagnostic Framework Flowchart

Setiap terjadi error / insiden, ikuti alur berpikir terstandarisasi industri berikut:

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

## 🚨 2. Real-World Incident Simulation Scenarios

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

#### 🛠️ Incident 4: AWS ECR Image Push Denied / Rate Limit
* **Context:** Pipeline CI/CD gagal pada step `docker push` ke AWS ECR.
* **Diagnostic Command Flow:**
  ```bash
  # 1. Check AWS Credentials login status
  aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.us-east-1.amazonaws.com

  # 2. Inspect ECR repository policy & IAM permissions
  aws ecr describe-repositories --repository-names my-app
  ```
* **Root Cause:** IAM Role OIDC kehabisan permission `ecr:GetAuthorizationToken` atau token auth expired (> 12 jam).
* **Fix & Prevention:** Perbarui policy IAM role OIDC di Terraform dan tambahkan login step eksplisit di GitHub Actions workflow.

#### 🛠️ Incident 5: Disk Space Full On Kubernetes Node / Container Engine
* **Context:** Node Kubernetes berubah status menjadi `MemoryPressure` / `DiskPressure`, Pod baru gagal ter-schedule.
* **Diagnostic Command Flow:**
  ```bash
  # 1. Inspect disk usage on node
  df -h
  du -sh /var/lib/docker/* | sort -h

  # 2. Cleanup dangling containers & unreferenced images
  docker system prune -a --volumes -f
  crictl rmi --prune
  ```
* **Root Cause:** Unused container images dan unrotated container stdout logs menumpuk di node filesystem.
* **Fix & Prevention:** Konfigurasi log rotation pada daemon container manager (`max-size: 50m`, `max-file: 3`) dan pasang Kubelet garbage collection thresholds.

---
*Kembali ke [README Index](file:///c:/Users/Premio/Documents/Belajar%20Devops/Track/README.md) atau lanjut ke [Modul 06 — DevSecOps Roadmap](file:///c:/Users/Premio/Documents/Belajar%20Devops/Track/06-devsecops-roadmap.md).*
