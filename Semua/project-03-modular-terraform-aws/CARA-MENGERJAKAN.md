# 📘 CARA MENGERJAKAN: Project 3 (Production Cloud Infrastructure on AWS using Modular Terraform)

Panduan praktis hands-on ini membimbing Anda mengeksekusi **Project 3** dari awal hingga selesai, mulai dari konfigurasi backend S3 & DynamoDB state lock, validasi modul Terraform, deployment infrastruktur AWS Multi-AZ, pengujian Load Balancer & Auto Scaling, hingga proses *cleanup/destroy* untuk mencegah pembengkakan biaya cloud.

---

## 📋 Prasyarat Sistem

1. **AWS CLI** (v2) telah terinstall dan terkonfigurasi:
   ```bash
   aws configure
   ```
   Pastikan Anda memasukkan `AWS Access Key ID`, `AWS Secret Access Key`, dan `Default region` (contoh: `ap-southeast-1`).
2. **Terraform CLI** versi `>= 1.5.0` telah terinstall.
3. **TFLint** (Opsional, direkomendasikan untuk static analysis).
4. **Curl / Browser** untuk pengujian ALB Endpoint.

---

## 🛠️ Langkah-Langkah Pengerjaan

### Langkah 1: Persiapan Environment & Inisialisasi Remote State Backend

Masuk ke direktori proyek:
```bash
cd Semua/project-03-modular-terraform-aws
```

Sebelum Terraform dapat menyimpan status infrastruktur di cloud (remote backend), kita perlu membuat S3 Bucket dan DynamoDB Lock Table. Gunakan script otomatisasi yang telah disediakan:

**Di Linux / macOS / WSL:**
```bash
chmod +x scripts/init_backend.sh scripts/validate.sh scripts/user_data.sh
./scripts/init_backend.sh my-devops-tfstate-unique-id devops-tfstate-locks ap-southeast-1
```

**Di Windows (PowerShell):**
```powershell
.\scripts\init_backend.ps1 -BucketName "my-devops-tfstate-unique-id" -TableName "devops-tfstate-locks" -Region "ap-southeast-1"
```

*Script di atas akan secara otomatis:*
* Membuat S3 Bucket dengan enkripsi **AES256** dan **Versioning** aktif.
* Mengaktifkan **Public Access Block** demi keamanan.
* Membuat tabel DynamoDB dengan Primary Key `LockID` untuk mencegah *concurrent apply*.

---

### Langkah 2: Menyiapkan Parameter Variabel Local

Salin berkas `terraform.tfvars.example` menjadi `terraform.tfvars`:
```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit file `terraform.tfvars` dan sesuaikan kata sandi database `db_password`:
```hcl
db_password = "SuperSecretSecureP@ssw0rd2026!"
```

---

### Langkah 3: Inisialisasi & Validasi Kode Terraform

Jalankan skrip validasi lokal untuk memastikan format dan sintaksis HCL valid:

**Linux / WSL:**
```bash
./scripts/validate.sh
```

**Windows (PowerShell):**
```powershell
.\scripts\validate.ps1
```

Atau jalankan perintah manual:
```bash
# 1. Format check
terraform fmt -check -recursive

# 2. Inisialisasi provider & modul
terraform init

# 3. Validasi sintaksis HCL
terraform validate
```

*Output yang diharapkan:*
```text
Success! The configuration is valid.
```

---

### Langkah 4: Meninjau Plan Infrastruktur (`terraform plan`)

Eksekusi perintah `terraform plan` untuk melihat daftar resource AWS yang akan dibuat:
```bash
terraform plan -out=tfplan
```

*Resource utama yang akan dibuat meliputi:*
* `module.vpc.aws_vpc.main` (VPC 10.0.0.0/16)
* `module.vpc.aws_subnet.public[*]` (2 Public Subnets)
* `module.vpc.aws_subnet.private[*]` (2 Private Subnets)
* `module.vpc.aws_subnet.database[*]` (2 DB Subnets)
* `module.vpc.aws_nat_gateway.main` & `aws_internet_gateway.main`
* `module.security_group.aws_security_group.alb`
* `module.security_group.aws_security_group.ec2`
* `module.security_group.aws_security_group.rds`
* `module.alb.aws_lb.main` & Target Group
* `module.asg.aws_autoscaling_group.app` & Launch Template
* `module.rds.aws_db_instance.main` (Multi-AZ PostgreSQL)

---

### Langkah 5: Eksekusi Deployment Cloud (`terraform apply`)

Jalankan deployment ke akun AWS Anda:
```bash
terraform apply tfplan
```

Proses provisioning membutuhkan waktu sekitar **3 - 5 menit** (terutama untuk alokasi Multi-AZ RDS PostgreSQL Instance).

Setelah selesai, Terraform akan menampilkan output penting:
```text
Apply complete! Resources: 24 added, 0 changed, 0 destroyed.

Outputs:

alb_dns_name = "dev-alb-1234567890.ap-southeast-1.elb.amazonaws.com"
rds_endpoint = "dev-postgres-db.c1234567890.ap-southeast-1.rds.amazonaws.com:5432"
vpc_id = "vpc-0a1b2c3d4e5f6g7h8"
```

---

### Langkah 6: Pengujian Integrasi Infrastruktur

#### 1. Uji Trafik Application Load Balancer
Buka browser atau gunakan `curl` untuk mengakses `alb_dns_name`:
```bash
curl -i http://<alb_dns_name>
```

*Hasil yang diharapkan:*
Halaman HTML interaktif yang menampilkan **Instance ID**, **Availability Zone** (contoh: `ap-southeast-1a`), dan status node `ONLINE (Healthy)`.

#### 2. Uji Load Balancing & Auto Scaling
Jalankan beberapa request beruntun untuk melihat pergeseran trafik antar AZ:
```bash
for i in {1..5}; do curl -s http://<alb_dns_name> | grep "Availability Zone"; done
```
Anda akan melihat balasan bergantian dari Availability Zone `ap-southeast-1a` dan `ap-southeast-1b`.

---

### Langkah 7: Pengujian Deployment Lingkungan Dev / Prod (Opsional)

Jika ingin melakukan testing terpisah untuk environment `dev` atau `prod`:

```bash
cd environments/dev
terraform init
terraform apply -var-file="terraform.tfvars"
```

---

### ⚠️ Langkah 8: Clean Up & Destruksi Resource (PENTING)

Untuk menghindari tagihan tagihan AWS yang tidak diinginkan setelah selesai belajar, hapus seluruh resource yang telah dibuat:

```bash
terraform destroy -auto-approve
```

Pastikan terminal mengembalikan status:
```text
Destroy complete! Resources: 24 destroyed.
```

---

## 🔍 Troubleshooting Populer

1. **Error `AccessDenied` pada AWS CLI:**
   * Solusi: Pastikan IAM User yang digunakan memiliki izin `AdministratorAccess` atau izin penuh untuk EC2, VPC, ALB, RDS, S3, dan DynamoDB.
2. **Error `BucketAlreadyExists` saat init backend:**
   * Solusi: Nama S3 bucket di AWS bersifat universal. Gunakan nama unik dengan menambahkan tanggal/random id.
3. **EC2 Instance status `unhealthy` di Target Group:**
   * Solusi: Tunggu 1-2 menit hingga `user_data.sh` selesai menginstall Nginx pada startup instance.
