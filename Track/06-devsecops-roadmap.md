# 🔐 Modul 06 — DevSecOps Shift-Left Integration Strategy

Integrasi keamanan harus dilakukan di **setiap tahap SDLC (Software Development Life Cycle)**, bukan hanya di akhir rilis.

---

## 🛡️ 1. DevSecOps Security Pipeline Architecture

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

## 🧰 2. DevSecOps Tooling Matrix & Implementation

| Layer SDLC | Tool Keamanan | Fungsi & Deskripsi | Cara Integrasi |
| :--- | :--- | :--- | :--- |
| **Code & Secrets** | **Gitleaks** | Mendeteksi kebocoran API key/secret di commit history | Pre-commit hook & CI Pipeline step |
| **Code Quality** | **GitHub CodeQL** | Static Application Security Testing (SAST) | GitHub Actions Security Tab |
| **Dependencies** | **Dependabot** | Scans vulnerable third-party libraries | Automatic GitHub PR alerts |
| **Containers** | **Trivy** | Vulnerability scanner untuk OS package & container layer | Step sebelum `docker push` ke Registry |
| **Infrastructure (IaC)**| **Checkov / tfsec** | Static code analysis untuk Terraform HCL (public buckets, open SGs) | CI step sebelum `terraform apply` |
| **K8s Runtime** | **Kube-bench** | Memeriksa kepatuhan cluster terhadap CIS Kubernetes Benchmark | Scheduled CronJob di K8s Cluster |

---

## 🔐 3. Best Practices Rules

1. **Zero Plaintext Secrets in Git:** Gunakan **Ansible Vault**, **AWS Secrets Manager**, atau **Sealed Secrets / External Secrets Operator** di Kubernetes.
2. **Non-Root Containers:** Setiap Dockerfile **wajib** mendeklarasikan unprivileged user (`USER appuser`).
3. **Short-Lived Cloud Credentials:** Gunakan **AWS IAM OIDC Federation** untuk CI/CD runner daripada menggunakan AWS Access Keys statis.
4. **Least Privilege IAM Policies:** Batasi hak akses IAM policy hanya ke resource spesifik, hindari penggunaan `Resource: "*"` dan `Action: "*"`.

---
*Kembali ke [README Index](file:///c:/Users/Premio/Documents/Belajar%20Devops/Track/README.md) atau lanjut ke [Modul 07 — Portfolio & Interview Prep](file:///c:/Users/Premio/Documents/Belajar%20Devops/Track/07-portfolio-and-interview-prep.md).*
