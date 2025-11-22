# Setup Admin Panel

Dokumentasi untuk setup dan penggunaan Admin Panel AgriGres.

## 📋 Daftar Isi

1. [Membuat Admin Pertama](#membuat-admin-pertama)
2. [Akses Admin Panel](#akses-admin-panel)
3. [Fitur Admin Panel](#fitur-admin-panel)
4. [Struktur Database](#struktur-database)

## 🔐 Membuat Admin Pertama

### Cara 1: Via Firebase Console (Recommended)

1. **Buka Firebase Console**
   - Masuk ke [Firebase Console](https://console.firebase.google.com/)
   - Pilih project Anda

2. **Buat User di Authentication**
   - Masuk ke **Authentication** > **Users**
   - Klik **Add user**
   - Masukkan email: `admin@agrigres.com` (atau email yang Anda inginkan)
   - Masukkan password yang kuat
   - Klik **Add user**
   - **Copy UID** dari user yang baru dibuat

3. **Buat Document di Firestore**
   - Masuk ke **Firestore Database**
   - Buat collection baru dengan nama: `Admins`
   - Klik **Add document**
   - **Document ID**: Paste UID yang sudah di-copy
   - Tambahkan fields berikut:
     ```
     Email: "admin@agrigres.com" (String)
     Name: "Admin Utama" (String)
     Role: "super_admin" (String)
     CreatedAt: "2024-01-01T00:00:00.000Z" (String) - atau gunakan timestamp sekarang
     IsActive: true (Boolean)
     ```

4. **Selesai!**
   - Admin pertama sudah dibuat
   - Anda bisa login menggunakan email dan password yang sudah dibuat

### Cara 2: Via Code (Development Only)

Jika Anda ingin membuat admin via code (untuk development), gunakan script di `lib/scripts/create_admin.dart`.

**PENTING**: Jangan gunakan cara ini di production!

## 🚀 Akses Admin Panel

### Dari Aplikasi

1. Buka aplikasi AgriGres
2. Tambahkan route atau button untuk akses admin login
3. Atau langsung akses via route: `/admin/login`

### Default Credentials (Development)

```
Email: admin@agrigres.com
Password: [password yang Anda buat di Firebase]
```

**PENTING**: Ganti password default di production!

## 📱 Fitur Admin Panel

### 1. Dashboard
- Overview admin panel
- Informasi admin yang sedang login
- Quick access ke semua fitur manajemen

### 2. Manajemen Pengguna
- **View**: Lihat semua pengguna aplikasi
- **Search**: Cari pengguna berdasarkan nama, email, atau username
- **Edit**: Edit data pengguna (nama, nomor telepon)
- **Delete**: Hapus pengguna dari sistem

### 3. Manajemen Forum
- **View**: Lihat semua postingan forum
- **Search**: Cari postingan berdasarkan konten, user, atau tags
- **Edit**: Edit konten postingan
- **Delete**: Hapus postingan yang tidak sesuai

### 4. Manajemen Artikel
- **View**: Lihat semua artikel
- **Create**: Tambah artikel baru
- **Search**: Cari artikel berdasarkan judul, kategori, atau penulis
- **Edit**: Edit artikel (judul, kategori, konten, dll)
- **Delete**: Hapus artikel

### 5. Manajemen Notifikasi
- **View**: Lihat semua notifikasi darurat
- **Search**: Cari notifikasi berdasarkan jenis, lokasi, atau status
- **Update Status**: Ubah status notifikasi (pending, processing, resolved)
- **Delete**: Hapus notifikasi

## 🗄️ Struktur Database

### Collection: Admins

```javascript
{
  "Admins": {
    "[UID]": {
      "Email": "admin@agrigres.com",
      "Name": "Admin Utama",
      "Role": "super_admin", // atau "admin"
      "CreatedAt": "2024-01-01T00:00:00.000Z",
      "LastLoginAt": "2024-01-01T00:00:00.000Z", // optional
      "IsActive": true
    }
  }
}
```

### Roles

- **super_admin**: Admin dengan akses penuh (dapat membuat admin baru)
- **admin**: Admin biasa (hanya dapat mengelola data)

## 🔒 Security Rules

Pastikan Firestore Security Rules mengizinkan akses untuk admin:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Admins collection - hanya admin yang bisa read
    match /Admins/{adminId} {
      allow read: if request.auth != null && 
                     exists(/databases/$(database)/documents/Admins/$(request.auth.uid));
      allow write: if false; // Hanya via console atau admin tools
    }
    
    // Users collection - admin bisa read/write
    match /Users/{userId} {
      allow read, write: if request.auth != null && 
                            exists(/databases/$(database)/documents/Admins/$(request.auth.uid));
    }
    
    // ForumPosts collection - admin bisa read/write
    match /ForumPosts/{postId} {
      allow read, write: if request.auth != null && 
                            exists(/databases/$(database)/documents/Admins/$(request.auth.uid));
    }
    
    // Articles collection - admin bisa read/write
    match /Articles/{articleId} {
      allow read, write: if request.auth != null && 
                            exists(/databases/$(database)/documents/Admins/$(request.auth.uid));
    }
    
    // Notifications collection - admin bisa read/write
    match /Notifications/{notificationId} {
      allow read, write: if request.auth != null && 
                            exists(/databases/$(database)/documents/Admins/$(request.auth.uid));
    }
  }
}
```

## 📝 Catatan Penting

1. **Password**: Pastikan menggunakan password yang kuat untuk admin
2. **Role**: Gunakan `super_admin` hanya untuk admin utama
3. **IsActive**: Set `IsActive` ke `false` untuk menonaktifkan admin tanpa menghapus data
4. **Security**: Jangan share kredensial admin ke sembarang orang
5. **Backup**: Selalu backup data sebelum melakukan operasi delete

## 🆘 Troubleshooting

### Admin tidak bisa login
- Pastikan email dan password benar
- Pastikan document di collection `Admins` sudah dibuat dengan benar
- Pastikan `IsActive` = `true`
- Pastikan UID di document sama dengan UID di Authentication

### Admin tidak muncul di dashboard
- Pastikan `AdminRepository` sudah di-register di `GeneralBindings`
- Pastikan route admin sudah ditambahkan di `AppRoutes`
- Check console untuk error messages

### Tidak bisa CRUD data
- Pastikan Firestore Security Rules sudah di-set dengan benar
- Pastikan admin sudah login dengan benar
- Check console untuk error messages

---

**Dibuat oleh**: AgriGres Development Team
**Versi**: 1.0.0
**Tanggal**: 2024

