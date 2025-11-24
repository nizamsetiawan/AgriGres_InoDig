# Setup Detection Config di Firebase

Dokumentasi ini menjelaskan cara mengatur konfigurasi deteksi penyakit tanaman di Firebase Firestore agar bisa dikelola oleh admin.

## 📋 Struktur Firestore

### Collection: `DetectionConfig`

Collection ini berisi konfigurasi untuk setiap jenis tanaman. Setiap document mewakili satu jenis tanaman.

### Document Structure

**Document ID**: Nama jenis tanaman (harus sama persis dengan yang digunakan di aplikasi)
- `Tanaman Tomat`
- `Tanaman Singkong`
- `Tanaman Jagung`

**Fields**:

1. **`labels`** (Array of Strings) - **REQUIRED**
   - Daftar label penyakit yang bisa dideteksi untuk jenis tanaman ini
   - Format: Array of strings
   - Contoh: `["Late Blight (Busuk Daun)", "Tomat Sehat", ...]`

2. **`keyword`** (String) - **OPTIONAL**
   - Custom prompt/keyword untuk Gemini API
   - Jika tidak diisi, akan menggunakan template default
   - Jika diisi, akan menggunakan keyword ini langsung

## 🚀 Setup di Firebase Console

### 1. Buat Collection

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project Anda
3. Masuk ke **Firestore Database**
4. Klik **Start collection** (jika belum ada collection)

### 2. Buat Collection `DetectionConfig`

**Collection Name**: `DetectionConfig`

### 3. Tambahkan Document untuk Tanaman Tomat

**Document ID**: `Tanaman Tomat`

**Fields**:
```json
{
  "labels": [
    "Late Blight (Busuk Daun)",
    "Septoria Leaf Spot (Bercak Daun Septoria)",
    "Leaf Mold (Daun Berjamur)",
    "Target Spot (Bintik Target)",
    "Tomat Sehat",
    "Early Blight (Bercak Daun)",
    "Bacterial Spot",
    "Yellow Leaf Curl Virus (TYLCV)",
    "Two-Spot Spider Mite (Tungau Laba-laba)"
  ],
  "keyword": null
}
```

### 4. Tambahkan Document untuk Tanaman Singkong

**Document ID**: `Tanaman Singkong`

**Fields**:
```json
{
  "labels": [
    "Cassava Mosaic Disease",
    "Cassava Brown Streak Disease",
    "Singkong Sehat",
    "Cassava Green Mite",
    "Mosaic Virus",
    "Cassava Bacterial Blight"
  ],
  "keyword": null
}
```

### 5. Tambahkan Document untuk Tanaman Jagung

**Document ID**: `Tanaman Jagung`

**Fields**:
```json
{
  "labels": [
    "Jagung Sehat",
    "Northern Leaf Blight (Hawar Daun Utara)",
    "Common Rust (Karat Daun)",
    "Gray Leaf Spot (Bintik Abu-abu Daun)"
  ],
  "keyword": null
}
```

## 📝 Cara Menggunakan Custom Keyword

Jika Anda ingin menggunakan custom prompt/keyword untuk Gemini API:

1. Buka document di Firebase Console
2. Tambahkan atau edit field `keyword` (String)
3. Isi dengan prompt lengkap yang ingin digunakan
4. Jika `keyword` diisi, aplikasi akan menggunakan keyword ini langsung tanpa generate dari labels

**Contoh Custom Keyword**:
```
Anda adalah ahli tanaman yang sangat berpengalaman. 
Identifikasi penyakit tanaman dalam gambar ini dengan sangat teliti.
Daftar penyakit yang bisa dideteksi:
- Late Blight (Busuk Daun)
- Tomat Sehat
- Early Blight (Bercak Daun)
...
```

## 🔄 Caching

Aplikasi menggunakan caching untuk performa:
- Cache duration: **1 jam**
- Cache akan otomatis refresh setelah 1 jam
- Untuk force refresh, admin bisa clear cache melalui aplikasi (jika ada fitur admin)

## ⚠️ Fallback Behavior

Jika data tidak ditemukan di Firebase:
- Aplikasi akan menggunakan **default hardcoded labels**
- Ini memastikan aplikasi tetap berfungsi meskipun Firebase tidak tersedia
- Default labels sesuai dengan yang ada di kode aplikasi

## 🎯 Best Practices

1. **Selalu sertakan "Bukan Tanaman"** - Aplikasi akan otomatis menambahkan ini ke validLabels
2. **Gunakan format konsisten** - Pastikan format label sama dengan yang ada di collection `Analyze`
3. **Test setelah update** - Setelah update di Firebase, tunggu maksimal 1 jam atau clear cache
4. **Backup data** - Simpan backup konfigurasi sebelum melakukan perubahan besar

## 📊 Monitoring

Untuk melihat apakah config berhasil di-load:
- Check logs aplikasi untuk pesan: `"Fetched config from Firebase for [plant type]: [count] labels"`
- Jika tidak ada, berarti menggunakan default (hardcoded)

## 🔧 Troubleshooting

**Problem**: Perubahan di Firebase tidak terlihat di aplikasi
- **Solution**: Tunggu 1 jam untuk cache expire, atau clear cache aplikasi

**Problem**: Aplikasi error saat deteksi
- **Solution**: Pastikan field `labels` adalah array dan tidak kosong

**Problem**: Label tidak sesuai dengan hasil deteksi
- **Solution**: Pastikan label di `DetectionConfig` sama persis dengan label di collection `Analyze`

