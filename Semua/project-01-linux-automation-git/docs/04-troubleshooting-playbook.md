# 04. DevOps Troubleshooting Playbook & Incident Response

Dokumentasi ini memberikan panduan investigasi langkah-demi-langkah untuk 5 skenario kegagalan sistem yang sering terjadi di lingkungan DevOps industri.

---

## 🚨 Scenario 1: Nginx Returns `502 Bad Gateway`

### Root Cause:
Nginx sebagai Reverse Proxy gagal berkomunikasi dengan backend upstream (misal: backend Python down, port binding salah, atau permissions UNIX socket bermasalah).

### Step-by-Step Investigation:
1. **Periksa Status Upstream Application:**
   ```bash
   sudo systemctl status my-python-app.service
   ```
   *Jika status `inactive (dead)` atau `failed`, jalankan `systemctl restart my-python-app.service`.*

2. **Periksa Port & Socket Binding:**
   ```bash
   # Cek apakah port 8000 listening
   sudo ss -tulpn | grep 8000
   # Atau jika menggunakan UNIX socket
   ls -la /run/my-app.sock
   ```

3. **Inspeksi Nginx Error Log:**
   ```bash
   sudo tail -n 50 /var/log/nginx/error.log
   ```
   *Cari log error seperti `connect() failed (111: Connection refused)`.*

4. **Verifikasi Proxy Pass Target di Nginx:**
   Pastikan blok `proxy_pass` di Nginx mengarah ke IP/port yang sesuai:
   `proxy_pass http://127.0.0.1:8000;`

---

## 🚨 Scenario 2: Custom Systemd Service Fails to Start (`CrashLoop`)

### Root Cause:
Python script crash saat launching, executable path salah, environment variable missing, atau permission folder kerja ditolak.

### Step-by-Step Investigation:
1. **Inspeksi Journal Logs Lengkap:**
   ```bash
   sudo journalctl -u my-python-app.service -n 50 --no-pager
   ```
   *Perhatikan traceback Python atau pesan kesalahan seperti `FileNotFoundError` atau `PermissionDenied`.*

2. **Uji Eksekusi Perintah Secara Manual:**
   Jalankan perintah `ExecStart` secara langsung di terminal menggunakan user aplikasi:
   ```bash
   sudo -u www-data /usr/bin/python3 /opt/my-python-app/dummy_app.py
   ```

3. **Periksa Security Hardening Over-Restriction:**
   Jika `ProtectSystem=full` atau `PrivateTmp=true` aktif, pastikan aplikasi tidak mencoba menulis ke folder terlarang seperti `/etc/` atau `/usr/`.

---

## 🚨 Scenario 3: Git Merge Conflict pada Configuration Script

### Root Cause:
Dua developer mengubah variabel atau baris konfigurasi yang sama di branch berbeda sebelum di-merge.

### Step-by-Step Investigation:
1. **Cek File yang Berkonflik:**
   ```bash
   git status
   ```

2. **Lihat Perbedaan Per Baris:**
   ```bash
   git diff
   ```

3. **Buka & Edit Conflict Markers:**
   Cari file yang bertanda `<<<<<<< HEAD` hingga `>>>>>>> branch-name`. Tentukan baris yang benar lalu hapus semua conflict marker.

4. **Tandai Selesai & Commit:**
   ```bash
   git add nginx/conf.d/app.conf
   git commit -m "fix(nginx): resolve rate limiting parameters merge conflict"
   ```

---

## 🚨 Scenario 4: Disk Partition Full Due to Unrotated Logs

### Root Cause:
Aplikasi menghasilkan volume log yang tinggi tanpa adanya mekanisme `logrotate`, menyebabkan partisi disk 100% full.

### Step-by-Step Investigation:
1. **Cek Penggunaan Partisi Disk:**
   ```bash
   df -h
   ```

2. **Cari Direktori / File Berukuran Raksasa:**
   ```bash
   sudo du -sh /var/log/* | sort -h
   ```

3. **Bersihkan Log Darurat (Tanpa Menghapus File Handle):**
   ```bash
   # TRUNCATE log file tanpa rm (agar tidak merusak fd aplikasi)
   sudo truncate -s 0 /var/log/my-app/app.log
   ```

4. **Konfigurasi Logrotate yang Benar:**
   Buat spesifikasi di `/etc/logrotate.d/my-python-app` dan uji coba eksekusi:
   ```bash
   sudo logrotate -f /etc/logrotate.d/my-python-app
   ```

---

## 🚨 Scenario 5: SSL Certificate Handshake Failure

### Root Cause:
Sertifikat TLS telah kadaluarsa (expired), CA intermediate chain terputus, atau domain mismatch.

### Step-by-Step Investigation:
1. **Verifikasi Masa Berlaku & Metadata Sertifikat:**
   ```bash
   openssl x509 -in /etc/letsencrypt/live/domain.com/fullchain.pem -text -noout | grep -A 2 "Validity"
   ```

2. **Uji Koneksi TLS Verbose via Curl:**
   ```bash
   curl -vI https://app.domain.com
   ```
   *Cari pesan error seperti `SSL certificate problem: certificate has expired`.*

3. **Perbarui Sertifikat Let's Encrypt (Certbot):**
   ```bash
   sudo certbot renew --dry-run
   sudo certbot renew
   sudo systemctl reload nginx
   ```
