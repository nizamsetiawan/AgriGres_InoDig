# Environment Variables Setup Guide

## 📋 Daftar Lengkap Environment Variables

File `.env` berisi semua konfigurasi API keys, base URLs, dan pengaturan lainnya untuk aplikasi agriGres.

**Total: 27 environment variables**

## 🚀 Cara Setup

1. **Buat file `.env`** di root project (salin dari template di bawah).

2. **Edit file `.env`** dan isi dengan nilai yang sebenarnya untuk setiap variabel.

3. **Pastikan file `.env` ada di `.gitignore`** (jangan commit file `.env` ke repository).

## 📝 Daftar Environment Variables

### 🔑 API Keys (5 variables)

| Variable | Description | Where to Get |
|----------|-------------|--------------|
| `OPENWEATHER_API_KEY` | OpenWeatherMap API Key | [https://openweathermap.org/api](https://openweathermap.org/api) |
| `YOUTUBE_API_KEY` | YouTube Data API Key | [https://console.cloud.google.com/apis/credentials](https://console.cloud.google.com/apis/credentials) |
| `GEMINI_API_KEY` | Google Gemini AI API Key | [https://makersuite.google.com/app/apikey](https://makersuite.google.com/app/apikey) |
| `SECRET_API_KEY` | Secret API Key (for general use) | Your own API key |
| `BADAN_PANGAN_API_KEY` | Badan Pangan Indonesia API Key | [https://webapi.badanpangan.go.id/register](https://webapi.badanpangan.go.id/register) |

### 📺 YouTube Channel Configuration (2 variables)

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `YOUTUBE_DEFAULT_CHANNEL_ID` | `UCrOkSpB5JDBCUrZaOzbsUcw` | Default YouTube Channel ID (for single channel operations) |
| `YOUTUBE_CHANNEL_IDS` | `UCrOkSpB5JDBCUrZaOzbsUcw,UCdPDUMhCqE6hW2Ja39EJQOw,...` | Comma-separated list of YouTube Channel IDs (12 channels) |

### ☁️ Cloudinary Configuration (4 variables)

| Variable | Description | Where to Get |
|----------|-------------|--------------|
| `CLOUDINARY_CLOUD_NAME` | Cloudinary Cloud Name | [https://cloudinary.com/console](https://cloudinary.com/console) |
| `CLOUDINARY_API_KEY` | Cloudinary API Key | [https://cloudinary.com/console](https://cloudinary.com/console) |
| `CLOUDINARY_API_SECRET` | Cloudinary API Secret | [https://cloudinary.com/console](https://cloudinary.com/console) |
| `CLOUDINARY_UPLOAD_PRESETS` | Upload Presets (comma-separated) | e.g., `profile_agroai,kenongotask_img` |

### 🌐 Base URLs (6 variables)

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `OPENWEATHER_BASE_URL` | `https://api.openweathermap.org/data/2.5` | OpenWeatherMap API Base URL |
| `YOUTUBE_BASE_URL` | `https://www.googleapis.com/youtube/v3` | YouTube Data API Base URL |
| `CLOUDINARY_BASE_URL` | `https://api.cloudinary.com/v1_1` | Cloudinary API Base URL |
| `AGRI_INFO_BASE_URL` | `https://api-panelhargav2.badanpangan.go.id/api/front` | Agri Info API Base URL |
| `SATU_DATA_BASE_URL` | `https://satudata.gresikkab.go.id/api/3/action` | Satu Data Gresik API Base URL |
| `API_BASE_URL` | `https://your-api-base-url.com` | General API Base URL (if you have your own backend) |

### 🤖 Google Gemini AI Configuration (1 variable)

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `GEMINI_MODEL_NAME` | `gemini-2.5-flash` | Gemini Model Name (e.g., `gemini-2.5-flash`, `gemini-1.5-flash-latest`) |

### 📍 Satu Data Gresik Configuration (4 variables)

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `SATU_DATA_SAWAH_RESOURCE_ID` | `6558d003-413c-11f0-8b48-005056016148` | Resource ID for Sawah (Lahan Sawah) data |
| `SATU_DATA_LAHAN_RESOURCE_ID` | `919459eb-413b-11f0-8b48-005056016148` | Resource ID for Lahan (Lahan Pertanian) data |
| `SATU_DATA_COOKIE_SAWAH` | `cookie-satudata_2024=u9528obkpk99sg3sa6b23psaln6ma26f` | Cookie for Satu Data Gresik API (Sawah) |
| `SATU_DATA_COOKIE_LAHAN` | `cookie-satudata_2024=sg6l3o4jqu0ie91ii0p7912rc8sdm515` | Cookie for Satu Data Gresik API (Lahan) |
| `SATU_DATA_DINAS_PERTANIAN_ORG_ID` | `971a678c-c734-4277-b2e6-e78b1bfcfa42` | Organization ID for Dinas Pertanian datasets |

### 📍 Location & Geolocation Configuration (2 variables)

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `DEFAULT_LOCATION` | `Gresik, Jawa Timur` | Default Location (for fallback) |
| `LOCATION_ACCURACY` | `high` | Location Accuracy (`high`, `medium`, `low`) |

### 🌾 Agri Info Default Values (2 variables)

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `AGRI_INFO_DEFAULT_PROVINCE_ID` | `15` | Default Province ID (15 = Jawa Timur) |
| `AGRI_INFO_DEFAULT_CITY_ID` | `250` | Default City ID (250 = Kab. Gresik) |

### ⚙️ App Configuration (2 variables)

| Variable | Default Value | Description |
|----------|---------------|-------------|
| `APP_ENV` | `development` | App Environment (`development`, `staging`, `production`) |
| `DEBUG_MODE` | `true` | Enable Debug Mode (`true`/`false`) |

## 📋 Template File .env

Berikut adalah template lengkap untuk file `.env`:

```env
# ============================================
# API Keys
# ============================================
OPENWEATHER_API_KEY=your_openweather_api_key_here
YOUTUBE_API_KEY=your_youtube_api_key_here
GEMINI_API_KEY=your_gemini_api_key_here
SECRET_API_KEY=your_secret_api_key_here
BADAN_PANGAN_API_KEY=your_badan_pangan_api_key_here

# ============================================
# YouTube Channel Configuration
# ============================================
YOUTUBE_DEFAULT_CHANNEL_ID=UCrOkSpB5JDBCUrZaOzbsUcw
YOUTUBE_CHANNEL_IDS=UCrOkSpB5JDBCUrZaOzbsUcw,UCdPDUMhCqE6hW2Ja39EJQOw,UCPtpZkU1fNgdW2VUZz6boHw,UC757MLmzhe5QXlr9yWyHcpQ,UCB0IUuzY203wj7jPLDlBsRg,UC2M0KWQ7_e3oCqnWL4urUVQ,UCNnCpWr9yvBiHwNlHpSNgSA,UCBStUYo5AKwqVP_iPANSqsw,UCVo4uXlUX14ra051-i3AbMg,UCb1C-wSCygELT8P294qocHw,UCpv_DdfS-_HIbJmE4va8MPg,UCXzOJru703AhCJXikZEEmsw

# ============================================
# Cloudinary Configuration
# ============================================
CLOUDINARY_CLOUD_NAME=your_cloud_name_here
CLOUDINARY_API_KEY=your_cloudinary_api_key_here
CLOUDINARY_API_SECRET=your_cloudinary_api_secret_here
CLOUDINARY_UPLOAD_PRESETS=profile_agroai,kenongotask_img

# ============================================
# API Base URLs
# ============================================
OPENWEATHER_BASE_URL=https://api.openweathermap.org/data/2.5
YOUTUBE_BASE_URL=https://www.googleapis.com/youtube/v3
CLOUDINARY_BASE_URL=https://api.cloudinary.com/v1_1
AGRI_INFO_BASE_URL=https://api-panelhargav2.badanpangan.go.id/api/front
SATU_DATA_BASE_URL=https://satudata.gresikkab.go.id/api/3/action
API_BASE_URL=https://your-api-base-url.com

# ============================================
# Google Gemini AI Configuration
# ============================================
GEMINI_MODEL_NAME=gemini-2.5-flash

# ============================================
# Satu Data Gresik Configuration
# ============================================
SATU_DATA_SAWAH_RESOURCE_ID=6558d003-413c-11f0-8b48-005056016148
SATU_DATA_LAHAN_RESOURCE_ID=919459eb-413b-11f0-8b48-005056016148
SATU_DATA_COOKIE_SAWAH=cookie-satudata_2024=u9528obkpk99sg3sa6b23psaln6ma26f
SATU_DATA_COOKIE_LAHAN=cookie-satudata_2024=sg6l3o4jqu0ie91ii0p7912rc8sdm515
SATU_DATA_DINAS_PERTANIAN_ORG_ID=971a678c-c734-4277-b2e6-e78b1bfcfa42

# ============================================
# Location & Geolocation Configuration
# ============================================
DEFAULT_LOCATION=Gresik, Jawa Timur
LOCATION_ACCURACY=high

# ============================================
# Agri Info Default Values
# ============================================
AGRI_INFO_DEFAULT_PROVINCE_ID=15
AGRI_INFO_DEFAULT_CITY_ID=250

# ============================================
# App Configuration
# ============================================
APP_ENV=development
DEBUG_MODE=true
```

## ✅ Status Perpindahan ke .env

Semua konfigurasi berikut sudah dipindahkan ke `.env`:

- ✅ OpenWeatherMap API Key & Base URL
- ✅ YouTube API Key & Base URL
- ✅ Google Gemini AI API Key & Model Name
- ✅ Cloudinary Configuration (Cloud Name, API Key, API Secret, Base URL, Upload Presets)
- ✅ Badan Pangan Indonesia API Key
- ✅ Agri Info API Base URL
- ✅ Satu Data Gresik API Base URL, Resource IDs, & Cookies
- ✅ Location Configuration (Default Location, Accuracy)
- ✅ Agri Info Default Values (Province ID, City ID)
- ✅ App Configuration (Environment, Debug Mode)
- ✅ General API Base URL

## 📝 File yang Diupdate

### Services & Repositories
- `lib/data/services/weather_service.dart` - OpenWeatherMap
- `lib/features/agri_edu/repositories/youtube_repository.dart` - YouTube
- `lib/data/repositories/disease/model_repository.dart` - Gemini AI
- `lib/data/repositories/forum/forum_repository.dart` - Cloudinary
- `lib/features/notification/repositories/notification_repository.dart` - Cloudinary
- `lib/data/repositories/user/user_repository.dart` - Cloudinary
- `lib/data/repositories/location/location_repository.dart` - Location
- `lib/utils/http/http_client.dart` - General API

### Controllers
- `lib/features/agri_info/controllers/detail_agri_info_controller.dart`
- `lib/features/agri_info/controllers/monthly_detail_agri_info_controller.dart`
- `lib/features/agri_info/controllers/table_detail_agri_info_controller.dart`
- `lib/features/agri_info/controllers/rekapitulasi_controller.dart`
- `lib/features/agri_info/controllers/komoditas_rekapitulasi_controller.dart`
- `lib/features/agri_info/controllers/province_detail_agri_info_controller.dart`
- `lib/features/agri_info/controllers/sawah_controller.dart`
- `lib/features/agri_info/controllers/lahan_controller.dart`

### Constants
- `lib/utils/constraints/api_constants.dart` - Centralized configuration

## ✅ Validasi Konfigurasi

Setelah setup, Anda dapat memvalidasi konfigurasi menggunakan helper methods di `APIConstants`:

```dart
// Check if API keys are configured
APIConstants.isOpenWeatherConfigured  // Returns true if OpenWeatherMap API key is set
APIConstants.isYouTubeConfigured      // Returns true if YouTube API key is set
APIConstants.isGeminiConfigured       // Returns true if Gemini API key is set
APIConstants.isCloudinaryConfigured   // Returns true if all Cloudinary configs are set
```

## 🔒 Security Notes

1. **JANGAN commit file `.env`** ke repository
2. **JANGAN share file `.env`** dengan orang lain
3. **Rotate API keys** secara berkala untuk keamanan
4. **Gunakan environment-specific keys** untuk development, staging, dan production

## 📚 Referensi

- [OpenWeatherMap API Documentation](https://openweathermap.org/api)
- [YouTube Data API Documentation](https://developers.google.com/youtube/v3)
- [Google Gemini AI Documentation](https://ai.google.dev/)
- [Cloudinary Documentation](https://cloudinary.com/documentation)
- [Flutter Dotenv Package](https://pub.dev/packages/flutter_dotenv)
