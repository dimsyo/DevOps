# 03. DevOps Networking, Nginx Reverse Proxy & TLS/DNS Architecture

Dokumentasi ini menjelaskan dasar-dasar jaringan untuk DevOps, mulai dari arsitektur DNS, HTTP/HTTPS Header, mekanisme SSL/TLS Handshake, hingga implementasi Nginx Reverse Proxy, CORS, dan Rate Limiting.

---

## 1. End-to-End Traffic Flow Architecture

Ketika user membuka `https://app.domain.com` di browser, berikut alur traffic lengkapnya:

1. **DNS Query:** Browser menanyakan alamat IP dari `app.domain.com` ke Resolver DNS.
2. **TCP 3-Way Handshake:** Browser membuka koneksi TCP ke Edge IP pada port 443 (`SYN` -> `SYN-ACK` -> `ACK`).
3. **TLS Handshake:** Negosiasi cipher suite dan verifikasi sertifikat SSL Let's Encrypt antara Client dan Nginx.
4. **HTTP Request:** Client mengirim HTTP GET Request beserta HTTP Headers.
5. **Nginx Ingress Filtering:** Nginx mengecek Rate Limiting (apakah melebih threshold?) dan Security Headers.
6. **Reverse Proxy Pass:** Nginx meneruskan request ke aplikasi backend lokal (`http://127.0.0.1:8000`).
7. **HTTP Response:** Backend merespons data -> Nginx membungkus header & merespons balik ke Client.

---

## 2. DNS Record Types Explained

| Tipe Record | Fungsi Utama | Contoh Value |
|---|---|---|
| **`A`** | Memetakan nama domain ke IPv4 Address 32-bit. | `example.com. IN A 192.0.2.1` |
| **`AAAA`** | Memetakan nama domain ke IPv6 Address 128-bit. | `example.com. IN AAAA 2001:db8::1` |
| **`CNAME`** | Alias dari nama domain lain (Canonical Name). | `app.example.com. IN CNAME target.domain.com.` |
| **`TXT`** | Catatan teks arbitrer untuk verifikasi kepemilikan domain, SPF, DKIM, DMARC. | `"v=spf1 include:_spf.google.com ~all"` |
| **`ALIAS / ANAME`** | CNAME buatan (pseudo-record) yang bisa digunakan di Root/Apex domain (`example.com`). | Diproses di level provider DNS. |

---

## 3. SSL/TLS Handshake (TLS 1.3)

Handshake TLS 1.3 telah dioptimalkan menjadi **1-RTT (Round Trip Time)**:

```text
Client                                                         Server
  |                                                              |
  |--- ClientHello (Supported Ciphers, Key Share) -------------->|
  |                                                              |
  |<-- ServerHello (Selected Cipher, Key Share, Certificate, ----|
  |    CertificateVerify, Finished)                              |
  |                                                              |
  | [Client verifies certificate chain & key exchange]           |
  |                                                              |
  |--- Finished (Encrypted Application Data begins) ------------>|
```

* **Certbot / ACME Protocol:** Certbot menggunakan tantangan `HTTP-01` (`/.well-known/acme-challenge/`) atau `DNS-01` untuk membuktikan kepemilikan domain sebelum Let's Encrypt merilis sertifikat TLS valid 90 hari.

---

## 4. Nginx Reverse Proxy & Hardening Features

Reverse Proxy bertindak sebagai perantara antara client luar dan service internal.

### A. Reverse Proxy Benefits:
* **Security:** Sembunyikan IP internal & port backend (`127.0.0.1:8000`) dari jaringan publik.
* **SSL Termination:** Mengenkripsi enkripsi/dekripsi TLS di Nginx, membebaskan beban komputasi backend app.
* **Rate Limiting:** Mencegah serangan DDoS / Brute Force dengan membatasi jumlah request per IP.
* **Load Balancing:** Membagi beban trafik ke beberapa backend instance.

### B. Security Headers & CORS Configured:
```nginx
# Security Headers
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-XSS-Protection "1; mode=block" always;
add_header X-Content-Type-Options "nosniff" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

# CORS (Cross-Origin Resource Sharing)
add_header Access-Control-Allow-Origin "https://domain.com" always;
add_header Access-Control-Allow-Methods "GET, POST, OPTIONS" always;
add_header Access-Control-Allow-Headers "Authorization, Content-Type" always;
```
