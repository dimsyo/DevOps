# 02. Advanced Linux Automation, Systemd & Process Management

Dokumentasi ini mencakup pengelolaan background service dengan Systemd, kontrol resource menggunakan cgroups, manajemen sinyal proses Linux (`SIGTERM`/`SIGKILL`), dan pengolahan log otomatis dengan Logrotate.

---

## 1. Systemd Architecture & Custom Unit Files

Systemd adalah init system dan service manager standar pada distro Linux modern (PID 1) yang mengelola lifecycle service, socket, device, dan mount point.

### Komponen Utama Unit File Service (`.service`)
* `[Unit]`: Metadata service, deskripsi, dan dependensi startup (`After=`, `Wants=`, `Requires=`).
* `[Service]`: Perintah eksekusi (`ExecStart=`), tipe service (`simple`, `notify`, `forking`), strategi auto-restart (`Restart=always`), serta fitur keamanan (*Hardening*).
* `[Install]`: Target runlevel saat di-enable (`WantedBy=multi-user.target`).

### Contoh Production Unit File:
```ini
[Unit]
Description=Python Application Service (Hardened)
After=network.target nginx.service
Wants=network-online.target

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=/opt/my-python-app
ExecStart=/usr/bin/python3 /opt/my-python-app/dummy_app.py
Restart=always
RestartSec=5s

# Security Hardening
ProtectSystem=full
ProtectHome=true
PrivateTmp=true
NoNewPrivileges=true

# Resource Limits (cgroups v2)
MemoryMax=256M
CPUQuota=50%

[Install]
WantedBy=multi-user.target
```

---

## 2. Linux Process Isolation & Control Groups (cgroups)

cgroups (Control Groups) adalah fitur kernel Linux yang membatasi, mencatat, dan mengisolasi penggunaan resource (CPU, Memory, Disk I/O, Network) untuk sekelompok proses.

### Mekanisme cgroups v2 di Systemd:
* **`MemoryMax=256M`**: Membatasi RAM maksimal 256 Megabyte. Jika melebihi batas ini, Out-Of-Memory (OOM) Killer akan menghentikan proses.
* **`CPUQuota=50%`**: Membatasi penggunaan CPU maksimal 50% dari 1 core CPU.
* **`TasksMax=100`**: Membatasi jumlah maksimum thread/proses untuk mencegah *Fork Bomb*.

---

## 3. Linux Signals: `SIGTERM` vs `SIGKILL`

Sinyal Linux adalah mekanisme IPC (Inter-Process Communication) asinkron untuk memberitahu proses tentang suatu kejadian.

| Sinyal | Kode Signal | Deskripsi & Behavior |
|---|---|---|
| **`SIGINT`** | 2 | Interrupt dari keyboard (`Ctrl + C`). |
| **`SIGTERM`** | 15 | Sinyal terminasi standar. Meminta proses berhenti secara halus (**Graceful Shutdown**), menutup koneksi database, membuang buffer log, dan melepaskan resource. |
| **`SIGKILL`** | 9 | Sinyal terminasi paksa dari Kernel Linux. Tidak dapat ditangkap (*unhandled*), diabaikan, atau diblokir oleh aplikasi. Langsung membunuh proses seketika. |
| **`SIGHUP`** | 1 | Hangup signal. Biasanya digunakan aplikasi server (seperti Nginx) untuk **Reload Config** tanpa menghentikan service. |

### Penanganan Signal di Code Python:
```python
import signal
import sys

def graceful_shutdown(signum, frame):
    print(f"Received signal {signum}. Closing database connections & exiting cleanly...")
    # cleanup logic here
    sys.exit(0)

signal.signal(signal.SIGTERM, graceful_shutdown)
signal.signal(signal.SIGINT, graceful_shutdown)
```

---

## 4. Log Rotation & Logrotate Configuration

Tanpa rotasi log yang teratur, file log aplikasi akan membesar dan menghabiskan ruang disk (*Disk Partition Full*). `logrotate` dijalankan secara berkala oleh Systemd timer / Cron untuk merotasi, mengompresi, dan menghapus log lama.

### Spesifikasi Konfigurasi `/etc/logrotate.d/my-python-app`:
```text
/var/log/my-app/*.log {
    daily
    rotate 7
    missingok
    notifempty
    compress
    delaycompress
    create 0640 www-data www-data
    sharedscripts
    postrotate
        systemctl reload my-python-app.service > /dev/null 2>&1 || true
    endscript
}
```

### Penjelasan Opsi:
* `daily`: Merotasi log setiap hari.
* `rotate 7`: Menyimpan maksimal 7 archive log lama (menghapus log ke-8).
* `compress`: Mengompresi file log hasil rotasi menggunakan `gzip`.
* `delaycompress`: Menunda kompresi log paling baru hingga siklus rotasi berikutnya (mencegah masalah proses yang masih menulis log).
* `postrotate`: Mengeksekusi command (seperti `systemctl reload`) setelah proses rotasi selesai.
