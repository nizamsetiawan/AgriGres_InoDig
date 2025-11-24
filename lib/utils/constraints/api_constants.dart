/* -- list of constants used in APIs --*/
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:agrigres/data/services/firebase_config_service.dart';

/// Centralized API configuration constants
/// Priority: Firebase Firestore > .env file > default values
/// Update config di Firebase Firestore (collection: AppConfig, doc: api_config)
/// untuk update tanpa perlu rebuild aplikasi
class APIConstants {
  /// Helper method untuk mendapatkan config value
  /// Priority: Firebase > .env > default
  static String _getConfig({
    required String firebaseKey,
    required String envKey,
    String defaultValue = '',
  }) {
    try {
      // Coba ambil dari Firebase jika service sudah di-initialize
      if (Get.isRegistered<FirebaseConfigService>()) {
        final firebaseConfig = FirebaseConfigService.instance;
        // Cek apakah config sudah di-load dari Firebase
        if (firebaseConfig.isConfigLoaded) {
          final firebaseValue = firebaseConfig.getConfigValue(
            firebaseKey: firebaseKey,
            envKey: envKey,
            defaultValue: defaultValue,
          );
          // Jika Firebase punya nilai (tidak kosong), gunakan itu
          if (firebaseValue.isNotEmpty) {
            return firebaseValue;
          }
        }
      }
    } catch (e) {
      // Jika error, fallback ke .env
    }
    
    // Fallback ke .env
    return dotenv.env[envKey] ?? defaultValue;
  }
  // ============================================
  // API Keys
  // ============================================
  
  /// OpenWeatherMap API Key
  static String get openWeatherApiKey {
    return _getConfig(
      firebaseKey: 'OPENWEATHER_API_KEY',
      envKey: 'OPENWEATHER_API_KEY',
    );
  }

  /// YouTube Data API Key
  static String get youtubeApiKey {
    return _getConfig(
      firebaseKey: 'YOUTUBE_API_KEY',
      envKey: 'YOUTUBE_API_KEY',
    );
  }

  /// YouTube Default Channel ID (for single channel operations)
  static String get youtubeDefaultChannelId {
    return _getConfig(
      firebaseKey: 'YOUTUBE_DEFAULT_CHANNEL_ID',
      envKey: 'YOUTUBE_DEFAULT_CHANNEL_ID',
      defaultValue: 'UCrOkSpB5JDBCUrZaOzbsUcw',
    );
  }

  /// YouTube Channel IDs List (comma-separated)
  /// Used for fetching multiple channels
  static List<String> get youtubeChannelIds {
    final channelIdsString = _getConfig(
      firebaseKey: 'YOUTUBE_CHANNEL_IDS',
      envKey: 'YOUTUBE_CHANNEL_IDS',
      defaultValue: 'UCrOkSpB5JDBCUrZaOzbsUcw,UCdPDUMhCqE6hW2Ja39EJQOw,UCPtpZkU1fNgdW2VUZz6boHw,UC757MLmzhe5QXlr9yWyHcpQ,UCB0IUuzY203wj7jPLDlBsRg,UC2M0KWQ7_e3oCqnWL4urUVQ,UCNnCpWr9yvBiHwNlHpSNgSA,UCBStUYo5AKwqVP_iPANSqsw,UCVo4uXlUX14ra051-i3AbMg,UCb1C-wSCygELT8P294qocHw,UCpv_DdfS-_HIbJmE4va8MPg,UCXzOJru703AhCJXikZEEmsw',
    );
    return channelIdsString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  /// Secret API Key (for general use)
  static String get secretApiKey {
    return _getConfig(
      firebaseKey: 'SECRET_API_KEY',
      envKey: 'SECRET_API_KEY',
    );
  }

  /// Google Gemini AI API Key
  static String get geminiApiKey {
    return _getConfig(
      firebaseKey: 'GEMINI_API_KEY',
      envKey: 'GEMINI_API_KEY',
    );
  }

  /// Badan Pangan Indonesia API Key
  static String get badanPanganApiKey {
    return _getConfig(
      firebaseKey: 'BADAN_PANGAN_API_KEY',
      envKey: 'BADAN_PANGAN_API_KEY',
    );
  }

  // ============================================
  // Cloudinary Configuration
  // ============================================
  
  static String get cloudinaryCloudName {
    return _getConfig(
      firebaseKey: 'CLOUDINARY_CLOUD_NAME',
      envKey: 'CLOUDINARY_CLOUD_NAME',
    );
  }

  static String get cloudinaryApiKey {
    return _getConfig(
      firebaseKey: 'CLOUDINARY_API_KEY',
      envKey: 'CLOUDINARY_API_KEY',
    );
  }

  static String get cloudinaryApiSecret {
    return _getConfig(
      firebaseKey: 'CLOUDINARY_API_SECRET',
      envKey: 'CLOUDINARY_API_SECRET',
    );
  }

  // ============================================
  // Base URLs
  // ============================================
  
  /// OpenWeatherMap API Base URL
  static String get openWeatherBaseUrl {
    return _getConfig(
      firebaseKey: 'OPENWEATHER_BASE_URL',
      envKey: 'OPENWEATHER_BASE_URL',
      defaultValue: 'https://api.openweathermap.org/data/2.5',
    );
  }

  /// YouTube Data API Base URL
  static String get youtubeBaseUrl {
    return _getConfig(
      firebaseKey: 'YOUTUBE_BASE_URL',
      envKey: 'YOUTUBE_BASE_URL',
      defaultValue: 'https://www.googleapis.com/youtube/v3',
    );
  }

  /// Cloudinary API Base URL
  static String get cloudinaryBaseUrl {
    return _getConfig(
      firebaseKey: 'CLOUDINARY_BASE_URL',
      envKey: 'CLOUDINARY_BASE_URL',
      defaultValue: 'https://api.cloudinary.com/v1_1',
    );
  }

  /// Agri Info API Base URL (Badan Pangan)
  static String get agriInfoBaseUrl {
    return _getConfig(
      firebaseKey: 'AGRI_INFO_BASE_URL',
      envKey: 'AGRI_INFO_BASE_URL',
      defaultValue: 'https://api-panelhargav2.badanpangan.go.id/api/front',
    );
  }

  /// Satu Data Gresik API Base URL
  static String get satuDataBaseUrl {
    return _getConfig(
      firebaseKey: 'SATU_DATA_BASE_URL',
      envKey: 'SATU_DATA_BASE_URL',
      defaultValue: 'https://satudata.gresikkab.go.id/api/3/action',
    );
  }

  /// Satu Data Gresik - Dinas Pertanian Organization ID
  static String get satuDataDinasPertanianOrgId {
    return _getConfig(
      firebaseKey: 'SATU_DATA_DINAS_PERTANIAN_ORG_ID',
      envKey: 'SATU_DATA_DINAS_PERTANIAN_ORG_ID',
      defaultValue: '971a678c-c734-4277-b2e6-e78b1bfcfa42',
    );
  }

  /// General API Base URL
  static String get apiBaseUrl {
    return _getConfig(
      firebaseKey: 'API_BASE_URL',
      envKey: 'API_BASE_URL',
      defaultValue: 'https://your-api-base-url.com',
    );
  }

  // ============================================
  // Google Gemini AI Configuration
  // ============================================
  
  /// Gemini Model Name
  static String get geminiModelName {
    return _getConfig(
      firebaseKey: 'GEMINI_MODEL_NAME',
      envKey: 'GEMINI_MODEL_NAME',
      defaultValue: 'gemini-2.5-flash',
    );
  }

  // ============================================
  // Satu Data Gresik Configuration
  // ============================================
  
  /// Resource ID for Sawah (Lahan Sawah) data
  static String get satuDataSawahResourceId {
    return _getConfig(
      firebaseKey: 'SATU_DATA_SAWAH_RESOURCE_ID',
      envKey: 'SATU_DATA_SAWAH_RESOURCE_ID',
      defaultValue: '6558d003-413c-11f0-8b48-005056016148',
    );
  }

  /// Resource ID for Lahan (Lahan Pertanian) data
  static String get satuDataLahanResourceId {
    return _getConfig(
      firebaseKey: 'SATU_DATA_LAHAN_RESOURCE_ID',
      envKey: 'SATU_DATA_LAHAN_RESOURCE_ID',
      defaultValue: '919459eb-413b-11f0-8b48-005056016148',
    );
  }

  /// Cookie for Satu Data Gresik API (Sawah)
  static String get satuDataCookieSawah {
    return _getConfig(
      firebaseKey: 'SATU_DATA_COOKIE_SAWAH',
      envKey: 'SATU_DATA_COOKIE_SAWAH',
      defaultValue: 'cookie-satudata_2024=u9528obkpk99sg3sa6b23psaln6ma26f',
    );
  }

  /// Cookie for Satu Data Gresik API (Lahan)
  static String get satuDataCookieLahan {
    return _getConfig(
      firebaseKey: 'SATU_DATA_COOKIE_LAHAN',
      envKey: 'SATU_DATA_COOKIE_LAHAN',
      defaultValue: 'cookie-satudata_2024=sg6l3o4jqu0ie91ii0p7912rc8sdm515',
    );
  }

  // ============================================
  // Location & Geolocation Configuration
  // ============================================
  
  /// Default Location (for fallback)
  static String get defaultLocation {
    return _getConfig(
      firebaseKey: 'DEFAULT_LOCATION',
      envKey: 'DEFAULT_LOCATION',
      defaultValue: 'Gresik, Jawa Timur',
    );
  }

  /// Location Accuracy
  static String get locationAccuracy {
    return _getConfig(
      firebaseKey: 'LOCATION_ACCURACY',
      envKey: 'LOCATION_ACCURACY',
      defaultValue: 'high',
    );
  }

  // ============================================
  // Cloudinary Upload Presets
  // ============================================
  
  /// Cloudinary Upload Presets (comma-separated)
  static List<String> get cloudinaryUploadPresets {
    final presets = _getConfig(
      firebaseKey: 'CLOUDINARY_UPLOAD_PRESETS',
      envKey: 'CLOUDINARY_UPLOAD_PRESETS',
      defaultValue: 'profile_agroai,kenongotask_img',
    );
    return presets.split(',').map((e) => e.trim()).toList();
  }

  // ============================================
  // Agri Info Default Values
  // ============================================
  
  /// Default Province ID (15 = Jawa Timur)
  static int get agriInfoDefaultProvinceId {
    final value = _getConfig(
      firebaseKey: 'AGRI_INFO_DEFAULT_PROVINCE_ID',
      envKey: 'AGRI_INFO_DEFAULT_PROVINCE_ID',
      defaultValue: '15',
    );
    return int.tryParse(value) ?? 15;
  }

  /// Default City ID (250 = Kab. Gresik)
  static int get agriInfoDefaultCityId {
    final value = _getConfig(
      firebaseKey: 'AGRI_INFO_DEFAULT_CITY_ID',
      envKey: 'AGRI_INFO_DEFAULT_CITY_ID',
      defaultValue: '250',
    );
    return int.tryParse(value) ?? 250;
  }

  // ============================================
  // App Configuration
  // ============================================
  
  /// App Environment
  static String get appEnv {
    return _getConfig(
      firebaseKey: 'APP_ENV',
      envKey: 'APP_ENV',
      defaultValue: 'development',
    );
  }

  /// Debug Mode
  static bool get debugMode {
    final value = _getConfig(
      firebaseKey: 'DEBUG_MODE',
      envKey: 'DEBUG_MODE',
      defaultValue: 'false',
    );
    return value.toLowerCase() == 'true';
  }

  // ============================================
  // Validation Helpers
  // ============================================
  
  static bool get isOpenWeatherConfigured => openWeatherApiKey.isNotEmpty;
  static bool get isYouTubeConfigured => youtubeApiKey.isNotEmpty;
  static bool get isGeminiConfigured => geminiApiKey.isNotEmpty;
  static bool get isCloudinaryConfigured => 
      cloudinaryCloudName.isNotEmpty && 
      cloudinaryApiKey.isNotEmpty && 
      cloudinaryApiSecret.isNotEmpty;
  static bool get isBadanPanganConfigured => badanPanganApiKey.isNotEmpty;
}
