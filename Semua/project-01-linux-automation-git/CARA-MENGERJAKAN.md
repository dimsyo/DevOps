# 📖 Panduan Praktis & Cara Mengerjakan Project 01: Automated Linux Web Infrastructure & Git Workflow

Dokumen ini adalah **Panduan Step-by-Step (Hands-on Guide)** untuk mengeksekusi, menguji, dan memahami seluruh komponen pada **Project 01**.

---

## 🎯 Ringkasan Tujuan Project

Di proyek ini, kamu akan membangun infrastruktur web Linux yang aman dan otomatis berbasis Git Ops & DevOps Best Practices:
1. **Automated Infrastructure Provisioning**: Setup otomatis environment Linux & Security via Bash script.
2. **Systemd Service Management**: Deploy aplikasi Python backend sebagai Linux Daemon yang ter-harden.
3. **Nginx Reverse Proxy & SSL**: Setup Nginx sebagai Reverse Proxy, Rate Limiter, HTTPS, dan Security Headers.
4. **Log Rotation & Automated Backup**: Auto log rotation & backup terkompresi dengan notifikasi Webhook (Discord/Telegram).
5. **SSL & HTTP Monitoring Challenge**: Script Python multithreaded untuk memantau status HTTP & tanggal kadaluwarsa SSL.
6. **Git Workflow & Conventional Commits**: Penerapan branching model dan format commit standar industri.

---

## 💻 Prasyarat Lingkungan (Prerequisites)

- **OS**: Linux (Ubuntu 20.04 / 22.04 LTS diprioritaskan). Jika kamu menggunakan Windows, gunakan **WSL 2 (Ubuntu)** atau **Virtual Machine (Multipass / VirtualBox / VMware)**.
- **Akses**: Privilese `sudo` / `root`.
- **Tools bawaan**: `git`, `bash`, `python3`, `pip3`, `curl`.

---

## 🚀 Langkah Demi Langkah Cara Mengerjakan (Step-by-Step Execution)

### TAHAP 1: Standar Workflow Git & Conventional Commits

Sebelum menyentuh konfigurasi server, gunakan workflow Git yang benar.

1. **Buka Terminal & Masuk ke Folder Project**:
   ```bash
   cd Semua/project-01-linux-automation-git
   ```

2. **Buat & Switch ke Feature Branch Baru**:
   ```bash
   git checkout -b feature/setup-infrastruktur
   ```

3. **Praktik Commit Berstandar (Conventional Commits)**:
   Setiap kali melakukan perubahan file atau menambahkan fitur, gunakan prefix seperti `feat:`, `fix:`, `docs:`, atau `chore:`.
   ```bash
   # Contoh commit pembuatan/pembaruan script
   git add .
   git commit -m "feat(scripts): implement automated backup with webhook notification"
   ```

4. **Tagging Release (Jika sudah menyelesaikan seluruh project)**:
   ```bash
   git checkout main
   git merge feature/setup-infrastruktur
   git tag -a v1.0.0 -m "Release v1.0.0: Automated Linux Web Infrastructure"
   ```

---

### TAHAP 2: Provisioning Infrastruktur Otomatis (`setup_infrastructure.sh`)

Script `scripts/setup_infrastructure.sh` akan menginstal dependencies, membuat user/group `www-data`, membuat direktori aplikasi (`/opt/my-python-app`), direktori log (`/var/log/my-app`), serta mengatur Firewall (UFW).

1. **Berikan Izin Eksekusi pada Script**:
   ```bash
   chmod +x scripts/setup_infrastructure.sh
   ```

2. **Jalankan Script dengan Akses Root (`sudo`)**:
   ```bash
   sudo ./scripts/setup_infrastructure.sh
   ```

3. **Verifikasi Hasil Provisioning**:
   - Pastikan Nginx terinstall & aktif:
     ```bash
     systemctl status nginx
     ```
   - Pastikan direktori `/opt/my-python-app` dan `/var/log/my-app` berhasil dibuat:
     ```bash
     ls -ld /opt/my-python-app /var/log/my-app
     ```
   - Pastikan status Firewall UFW mengizinkan Nginx & SSH:
     ```bash
     sudo ufw status verbose
     ```

---

### TAHAP 3: Deployment Aplikasi Python Backend via Systemd

Aplikasi `dummy_app.py` berperan sebagai backend server yang mendengarkan di port `127.0.0.1:8000`. Kita akan mengelolanya sebagai Systemd Daemon.

1. **Salin Script Aplikasi ke Folder `/opt/my-python-app`**:
   ```bash
   sudo mkdir -p /opt/my-python-app/scripts
   sudo cp scripts/dummy_app.py /opt/my-python-app/scripts/
   sudo chown -R www-data:www-data /opt/my-python-app
   sudo chmod +x /opt/my-python-app/scripts/dummy_app.py
   ```

2. **Salin Service File ke `/etc/systemd/system/`**:
   ```bash
   sudo cp systemd/my-python-app.service /etc/systemd/system/
   ```

3. **Reload Systemd Manager & Start Service**:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable --now my-python-app.service
   ```

4. **Verifikasi Status Service**:
   ```bash
   sudo systemctl status my-python-app.service
   ```

5. **Uji Respons Aplikasi Backend (Port 8000)**:
   ```bash
   curl http://127.0.0.1:8000
   ```
   *Ekspektasi Output*: JSON berisi `{"status": "online", "service": "my-python-app", ...}`.

6. **Pengujian Auto-Restart Systemd (Resiliency Test)**:
   Cari PID proses Python dan bunuh secara paksa (`SIGKILL` / `kill -9`):
   ```bash
   PID=$(pgrep -f dummy_app.py)
   sudo kill -9 $PID
   ```
   Cek kembali status service beberapa detik kemudian:
   ```bash
   sudo systemctl status my-python-app.service
   ```
   *Ekspektasi*: Systemd akan mendeteksi proses mati dan otomatis menyalakannya kembali (*Active: active (running)* dengan PID baru).

---

### TAHAP 4: Konfigurasi Nginx Reverse Proxy, Security & SSL

Nginx bertindak sebagai entri utama (*Reverse Proxy*) di port 80/443 yang melempar traffic ke backend `127.0.0.1:8000`.

1. **Salin Konfigurasi Nginx**:
   ```bash
   sudo cp nginx/nginx.conf /etc/nginx/nginx.conf
   sudo cp nginx/conf.d/app.conf /etc/nginx/conf.d/
   ```

2. **Setup Domain Lokal / Testing DNS (`/etc/hosts`)**:
   Untuk simulasi domain `app.domain.com` secara lokal:
   ```bash
   echo "127.0.0.1 app.domain.com" | sudo tee -a /etc/hosts
   ```

3. **(Opsional) Setup SSL / HTTPS**:
   - **Jika di Server Publik**: Gunakan Certbot untuk otomatisasi SSL Let's Encrypt:
     ```bash
     sudo certbot --nginx -d app.domain.com
     ```
   - **Jika di Environment Lokal / Testing**: Buat Self-Signed Certificate agar Nginx tidak error saat membaca path SSL di `app.conf`:
     ```bash
     sudo mkdir -p /etc/letsencrypt/live/app.domain.com
     sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
       -keyout /etc/letsencrypt/live/app.domain.com/privkey.pem \
       -out /etc/letsencrypt/live/app.domain.com/fullchain.pem \
       -subj "/CN=app.domain.com"
     sudo cp /etc/letsencrypt/live/app.domain.com/fullchain.pem /etc/letsencrypt/live/app.domain.com/chain.pem
     ```

4. **Uji Validasi Syntax Nginx & Reload**:
   ```bash
   sudo nginx -t
   sudo systemctl reload nginx
   ```

5. **Verifikasi Nginx Reverse Proxy & Headers**:
   ```bash
   curl -k -i https://app.domain.com
   ```
   *Ekspektasi Output*: HTTP 200 OK dengan security headers (`X-Frame-Options`, `Strict-Transport-Security`, dll).

6. **Pengujian Rate Limiting Nginx**:
   Kirim 10+ request secara cepat untuk menguji rate limiter (burst 5):
   ```bash
   for i in {1..15}; do curl -k -s -o /dev/null -w "%{http_code}\n" https://app.domain.com; done
   ```
   *Ekspektasi*: Beberapa request pertama menghasilkan `200`, lalu request berlebih akan menghasilkan HTTP `537` / `503 Service Temporarily Unavailable` (Rate Limited).

---

### TAHAP 5: Log Rotation & Automated Backup Script

Aplikasi menulis log di `/var/log/my-app/app.log`. Kita akan mengatur otomatisasi rotasi log & backup ke folder `/var/backups/my-app`.

1. **Pasang Konfigurasi Logrotate**:
   ```bash
   sudo cp logrotate.d/my-python-app /etc/logrotate.d/
   sudo chmod 644 /etc/logrotate.d/my-python-app
   ```

2. **Uji Paksa Log Rotation**:
   ```bash
   sudo logrotate -f /etc/logrotate.d/my-python-app
   ls -la /var/log/my-app/
   ```
   *Ekspektasi*: Muncul file log yang terkompresi seperti `app.log.1.gz`.

3. **Uji Script Backup Otomatis (`backup_with_rotation.sh`)**:
   Berikan izin eksekusi dan jalankan script:
   ```bash
   chmod +x scripts/backup_with_rotation.sh
   sudo ./scripts/backup_with_rotation.sh /var/log/my-app /var/backups/my-app "HTTPS_DISCORD_WEBHOOK_URL_KAMU"
   ```
   - Ganti `"HTTPS_DISCORD_WEBHOOK_URL_KAMU"` dengan URL Discord/Telegram webhook milikmu untuk menerima notifikasi. Jika tidak ada, kosongkan parameter ketiga `""`.

4. **Pemeriksaan Hasil Backup**:
   ```bash
   ls -la /var/backups/my-app/
   ```
   *Ekspektasi*: File archive terkompresi `backup_YYYYMMDD_HHMMSS.tar.gz` berhasil dibuat.

5. **Penjadwalan Otomatis via Cron (Automation)**:
   Tambahkan ke `crontab` root agar backup berjalan otomatis setiap hari jam 02:00 pagi:
   ```bash
   sudo crontab -e
   ```
   Tambahkan baris berikut di bagian paling bawah:
   ```cron
   0 2 * * * /opt/my-python-app/scripts/backup_with_rotation.sh /var/log/my-app /var/backups/my-app "WEBHOOK_URL" >> /var/log/backup.log 2>&1
   ```

---

### TAHAP 6: Monitoring SSL Expiry & HTTP Health Check Challenge

Script `scripts/ssl_monitor.py` berguna untuk memantau status HTTP & kedaluwarsa SSL pada sekumpulan domain yang tercantum di file `scripts/targets.csv`.

1. **Cek / Edit File `scripts/targets.csv`**:
   Pastikan daftar domain/IP sesuai dengan target yang ingin dipantau:
   ```csv
   hostname,port,path
   google.com,443,/
   github.com,443,/
   app.domain.com,443,/
   ```

2. **Jalankan Monitoring Script**:
   ```bash
   python3 scripts/ssl_monitor.py --file scripts/targets.csv --days 7
   ```

3. **Verifikasi Output Monitoring**:
   Script akan memproses domain secara paralel dan menampilkan tabel atau JSON hasil pemeriksaan status SSL (hari tersisa) dan response HTTP code.

---

### TAHAP 7: Diagnostic & Troubleshooting Playbook

Jika mengalami kendala saat mengerjakan, gunakan metode diagnostik ber-layer berikut:

| Gejala Masalah | Langkah Diagnostik & Solusi |
| :--- | :--- |
| **Backend Service Fail / Failed to Start** | Cek log Systemd: `sudo journalctl -u my-python-app.service -n 50 --no-pager`. Pastikan path `/opt/my-python-app/scripts/dummy_app.py` ada dan izin akses `www-data` sudah benar. |
| **Nginx 502 Bad Gateway** | Nginx tidak bisa berkomunikasi dengan backend. Cek apakah backend aktif: `curl http://127.0.0.1:8000`. Cek `sudo netstat -tulnp \| grep 8000` atau `sudo ss -tulnp \| grep 8000`. |
| **Permission Denied / Access Error** | Pastikan folder `/var/log/my-app` dan `/opt/my-python-app` dimiliki oleh user `www-data`: `sudo chown -R www-data:www-data /var/log/my-app /opt/my-python-app`. |
| **Nginx SSL Certificate Error** | Cek apakah path sertifikat di `/etc/nginx/conf.d/app.conf` sesuai dengan lokasi file `.pem`. Jalankan `sudo nginx -t` untuk melihat lokasi baris error syntax. |

---

## ✅ Checklist Demokrasi / Verifikasi Selesai (Definition of Done)

Gunakan checklist ini untuk memastikan seluruh tugas proyek telah berhasil kamu kerjakan 100%:

- [ ] `setup_infrastructure.sh` berjalan sukses tanpa error dengan `sudo`.
- [ ] User `www-data`, folder `/opt/my-python-app`, dan `/var/log/my-app` tercipta dengan permission 755/750.
- [ ] Service `my-python-app.service` berstatus *active (running)* di bawah Systemd.
- [ ] Simulasi `kill -9` terbukti otomatis di-restart oleh Systemd.
- [ ] Nginx Reverse Proxy merespons HTTP `200 OK` saat diakses via domain/host.
- [ ] Security headers & Rate limiting Nginx terverifikasi aktif.
- [ ] `logrotate` berhasil memutar log `app.log` menjadi `app.log.1.gz`.
- [ ] `backup_with_rotation.sh` berhasil membuat archive `.tar.gz` di `/var/backups/my-app`.
- [ ] Notifikasi Webhook (Discord/Telegram) terkirim saat backup selesai.
- [ ] `ssl_monitor.py` sukses mengeksekusi health check paralel dari `targets.csv`.
- [ ] Semua perubahan di-commit dengan standar **Conventional Commits** dan di-push ke repository Git.
