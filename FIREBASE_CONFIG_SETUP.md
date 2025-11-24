# Firebase Configuration Setup

Aplikasi ini menggunakan **Firebase Firestore** untuk menyimpan konfigurasi dinamis (API keys, base URLs, dll). Dengan cara ini, Anda dapat mengupdate konfigurasi tanpa perlu rebuild aplikasi.

## 🎯 Keuntungan

- ✅ **Update tanpa rebuild**: Update config langsung di Firebase, aplikasi akan otomatis menggunakan nilai baru
- ✅ **Fallback ke .env**: Jika Firebase tidak tersedia, aplikasi akan otomatis menggunakan `.env` file
- ✅ **Caching**: Config di-cache selama 24 jam untuk performa lebih baik
- ✅ **Zero downtime**: Update config tidak akan mengganggu aplikasi yang sedang berjalan

## 📋 Setup Firestore Collection

### 1. Buat Collection di Firestore

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Pilih project Anda
3. Masuk ke **Firestore Database**
4. Klik **Start collection** (jika belum ada collection)

### 2. Buat Collection dan Document

**Collection Name**: `AppConfig`  
**Document ID**: `api_config`

### 3. Tambahkan Fields

Tambahkan semua field berikut sebagai **String** di document `api_config`:

#### API Keys
```
OPENWEATHER_API_KEY: "your_openweather_api_key"
YOUTUBE_API_KEY: "your_youtube_api_key"
SECRET_API_KEY: "your_secret_api_key"
GEMINI_API_KEY: "your_gemini_api_key"
BADAN_PANGAN_API_KEY: "your_badan_pangan_api_key"
```

**Catatan untuk Badan Pangan API Key:**
- Daftar di [Portal WebAPI Badan Pangan](https://webapi.badanpangan.go.id/register)
- Setelah verifikasi email dan disetujui oleh Pusdatin, API Key akan tersedia di dashboard
- API Key digunakan untuk autentikasi semua request ke API Badan Pangan

#### YouTube Channel Configuration
```
YOUTUBE_DEFAULT_CHANNEL_ID: "UCrOkSpB5JDBCUrZaOzbsUcw"
YOUTUBE_CHANNEL_IDS: "UCrOkSpB5JDBCUrZaOzbsUcw,UCdPDUMhCqE6hW2Ja39EJQOw,UCPtpZkU1fNgdW2VUZz6boHw,UC757MLmzhe5QXlr9yWyHcpQ,UCB0IUuzY203wj7jPLDlBsRg,UC2M0KWQ7_e3oCqnWL4urUVQ,UCNnCpWr9yvBiHwNlHpSNgSA,UCBStUYo5AKwqVP_iPANSqsw,UCVo4uXlUX14ra051-i3AbMg,UCb1C-wSCygELT8P294qocHw,UCpv_DdfS-_HIbJmE4va8MPg,UCXzOJru703AhCJXikZEEmsw"
```

#### Cloudinary Configuration
```
CLOUDINARY_CLOUD_NAME: "your_cloud_name"
CLOUDINARY_API_KEY: "your_cloudinary_api_key"
CLOUDINARY_API_SECRET: "your_cloudinary_api_secret"
CLOUDINARY_UPLOAD_PRESETS: "profile_agroai,kenongotask_img"
```

#### Base URLs
```
OPENWEATHER_BASE_URL: "https://api.openweathermap.org/data/2.5"
YOUTUBE_BASE_URL: "https://www.googleapis.com/youtube/v3"
CLOUDINARY_BASE_URL: "https://api.cloudinary.com/v1_1"
AGRI_INFO_BASE_URL: "https://api-panelhargav2.badanpangan.go.id/api/front"
SATU_DATA_BASE_URL: "https://satudata.gresikkab.go.id/api/3/action"
API_BASE_URL: "https://your-api-base-url.com"
```

#### Google Gemini AI
```
GEMINI_MODEL_NAME: "gemini-2.5-flash"
```

#### Satu Data Gresik
```
SATU_DATA_SAWAH_RESOURCE_ID: "6558d003-413c-11f0-8b48-005056016148"
SATU_DATA_LAHAN_RESOURCE_ID: "919459eb-413b-11f0-8b48-005056016148"
SATU_DATA_COOKIE_SAWAH: "cookie-satudata_2024=u9528obkpk99sg3sa6b23psaln6ma26f"
SATU_DATA_COOKIE_LAHAN: "cookie-satudata_2024=sg6l3o4jqu0ie91ii0p7912rc8sdm515"
SATU_DATA_DINAS_PERTANIAN_ORG_ID: "971a678c-c734-4277-b2e6-e78b1bfcfa42"
```

#### Location & Geolocation
```
DEFAULT_LOCATION: "Gresik, Jawa Timur"
LOCATION_ACCURACY: "high"
```

#### Agri Info Default Values
```
AGRI_INFO_DEFAULT_PROVINCE_ID: "15"
AGRI_INFO_DEFAULT_CITY_ID: "250"
```

#### App Configuration
```
APP_ENV: "production"
DEBUG_MODE: "false"
```

## 🔒 Security Rules

Pastikan Firestore Security Rules mengizinkan read untuk semua user (karena config bersifat public):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read untuk AppConfig (public config)
    match /AppConfig/{document} {
      allow read: if true;
      allow write: if false; // Hanya admin yang bisa write via console
    }
    
    // Rules untuk collection lainnya...
  }
}
```

## 📱 Cara Update Config

### Via Firebase Console

1. Buka Firebase Console → Firestore Database
2. Navigate ke collection `AppConfig` → document `api_config`
3. Edit field yang ingin di-update
4. Klik **Update**
5. Aplikasi akan otomatis menggunakan nilai baru pada fetch berikutnya (maksimal 24 jam, atau restart app)

### Force Refresh (dari aplikasi)

Jika ingin memaksa refresh config tanpa menunggu cache expire, tambahkan method berikut di controller/screen:

```dart
// Force refresh config dari Firebase
await FirebaseConfigService.instance.refreshConfig();
```

## 🔄 Priority Order

Aplikasi akan mengambil config dengan urutan prioritas berikut:

1. **Firebase Firestore** (jika tersedia dan sudah di-load)
2. **.env file** (jika Firebase tidak tersedia atau gagal)
3. **Default values** (hardcoded di `APIConstants`)

## ⚠️ Catatan Penting

- **.env file masih diperlukan** sebagai fallback jika Firebase tidak tersedia
- Config di-cache selama **24 jam** untuk performa
- Pastikan semua field di Firestore menggunakan tipe data **String**
- Field names harus **exact match** dengan yang ada di `APIConstants`
- Untuk security, jangan simpan sensitive data di Firestore tanpa encryption jika tidak perlu

## 🧪 Testing

Setelah setup, test dengan:

1. Update salah satu config di Firestore
2. Restart aplikasi atau panggil `refreshConfig()`
3. Cek apakah aplikasi menggunakan nilai baru dari Firebase

## 📝 Contoh Document Structure

```
Collection: AppConfig
Document ID: api_config
Fields:
  ├── OPENWEATHER_API_KEY (string)
  ├── YOUTUBE_API_KEY (string)
  ├── GEMINI_API_KEY (string)
  ├── CLOUDINARY_CLOUD_NAME (string)
  ├── ... (dan seterusnya)
```

---

**Note**: Jika Anda tidak ingin menggunakan Firebase config, aplikasi akan otomatis fallback ke `.env` file. Tidak perlu melakukan perubahan apapun.

