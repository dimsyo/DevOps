# 01. Git Internals, Branching Strategies & Conventional Commits

Dokumentasi ini menjelaskan dasar mendalam tentang internal Git, strategi percabangan industri, penyelesaian merge conflict, serta pemberian tag/versi rilis.

---

## 1. Git Internals: How Git Works Under the Hood

Git bukanlah sekadar sistem tracker perubahan berbasis delta file, melainkan sebuah **Directed Acyclic Graph (DAG)** dari objek terenkripsi SHA-1/SHA-256.

### Objek Utama Git (`.git/objects/`)
1. **Blob (Binary Large Object):** Menyimpan isi mentah file (tanpa metadata nama file atau permission).
2. **Tree:** Representasi direktori. Menghubungkan nama file, mode permission (`100644`, `100755`), dan mengaitkannya ke hash Blob atau Sub-tree.
3. **Commit:** Menyimpan pointer ke Root Tree, Parent Commit(s), nama author, committer, timestamp, dan pesan commit.
4. **Annotated Tag:** Pointer permanen ke commit tertentu yang mencakup metadata tagger, tanggal, dan tanda tangan GPG (opsional).

```text
  [Commit Object] ---> Root Tree Object
         |                      |
         v                      +---> Sub-tree Object ---> Blob Object (file.txt)
   Parent Commit                +---> Blob Object (script.sh)
```

---

## 2. Branching Strategies: Gitflow vs Feature Branching

### A. Gitflow Architecture
Cocok untuk software terstruktur dengan rilis versi berkala (`v1.0.0`, `v2.0.0`).

* `main`: Menyimpan code production-ready. Setiap commit di `main` harus di-tag versi.
* `develop`: Branch integrasi utama untuk fitur yang siap digabungkan.
* `feature/*`: Branch independen dari `develop` untuk pengembangan fitur spesifik.
* `release/*`: Branch persiapan rilis (bug fix minor, pembaruan dokumentasi sebelum merge ke `main`).
* `hotfix/*`: Branch darurat langsung dari `main` untuk memperbaiki bug di production.

### B. Feature Branch Workflow (Trunk-Based / GitHub Flow)
Cocok untuk Continuous Delivery (CD) dan pengiriman fitur cepat.

1. Create feature branch from `main`: `git checkout -b feature/nginx-rate-limit`
2. Commit changes using Conventional Commits.
3. Open Pull Request (PR) / Merge Request (MR).
4. Code review & Automated CI pass.
5. Squash & Merge to `main`.

---

## 3. Merge vs Rebase

| Aspek | `git merge` | `git rebase` |
|---|---|---|
| **Mekanisme** | Membuat commit gabungan baru (*Merge Commit*) dengan 2 parent. | Mengulang kembali commit satu per satu di atas base branch baru. |
| **History** | Menjaga histori riil kronologis, termasuk cabang cabang sampingan. | Menghasilkan riwayat commit linier dan bersih (*Clean History*). |
| **Keamanan** | Aman, tidak merubah hash commit lama. | Berbahaya jika dilakukan pada shared branch publik (mengubah SHA hash). |
| **Penggunaan** | Integrasi `release` / `develop` ke `main`. | Merapikan feature branch pribadi sebelum di-PR ke `main`. |

### Command Comparison:
```bash
# Git Merge
git checkout main
git merge feature/backup-script

# Git Rebase (Interactive for squashing commits)
git checkout feature/backup-script
git rebase -i main
```

---

## 4. Resolving Merge Conflicts Step-by-Step

Merge conflict terjadi ketika dua commit mengubah baris kode yang sama pada file yang sama dan Git tidak dapat menentukan mana yang harus dipertahankan secara otomatis.

### Langkah Penyelesaian:
1. Jalankan `git status` untuk mengidentifikasi file bermasalah (*Unmerged paths*).
2. Buka file yang berkonflik, cari *Conflict Markers*:
   ```text
   <<<<<<< HEAD (Current Change)
   rate_limit = "20r/s";
   =======
   rate_limit = "10r/s";
   >>>>>>> feature/nginx-hardening (Incoming Change)
   ```
3. Edit file, hapus marker `<<<<<<<`, `=======`, dan `>>>>>>>`, serta tentukan kode akhir yang benar.
4. Simpan file, lalu tandai sebagai teresolusi:
   ```bash
   git add nginx/conf.d/app.conf
   ```
5. Selesaikan proses merge/rebase:
   ```bash
   git commit -m "fix(nginx): resolve rate limiting merge conflict"
   ```

---

## 5. Tagging & Semantic Versioning (`v1.0.0`)

Semantic Versioning menggunakan format **`MAJOR.MINOR.PATCH`** (`v1.0.0`):
* **MAJOR (`1.0.0`):** Perubahan breaking/incompatible API.
* **MINOR (`1.1.0`):** Penambahan fitur baru yang backward-compatible.
* **PATCH (`1.0.1`):** Perbaikan bug (*bug fixes*) yang backward-compatible.

### Membuat Annotated Tag:
```bash
# Membuat tag berannotasi
git tag -a v1.0.0 -m "Release Candidate 1.0.0 - Production Ready Infrastructure Automation"

# Memeriksa detail tag
git show v1.0.0

# Push tag ke remote repository
git push origin v1.0.0
```
