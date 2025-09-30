import 'package:agrigres/utils/logging/logger.dart';

/// Exception class for handling various platform-related errors.
class TPlatformException implements Exception {
  final String code;

  TPlatformException(this.code){
    TLoggerHelper.error('Platform Exception: $code');
  }
  String get message {
    switch (code) {
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Kredensial login tidak valid. Silakan periksa informasi Anda dan coba lagi.';
      case 'too-many-requests':
        return 'Terlalu banyak permintaan. Silakan coba lagi nanti.';
      case 'invalid-argument':
        return 'Argumen yang diberikan untuk metode autentikasi tidak valid.';
      case 'invalid-password':
        return 'Kata sandi salah. Silakan coba lagi.';
      case 'invalid-phone-number':
        return 'Nomor telepon yang diberikan tidak valid.';
      case 'operation-not-allowed':
        return 'Penyedia masuk ini dinonaktifkan untuk proyek Firebase Anda.';
      case 'session-cookie-expired':
        return 'Cookie sesi Firebase telah kedaluwarsa. Silakan masuk lagi.';
      case 'uid-already-exists':
        return 'ID pengguna yang diberikan sudah digunakan oleh pengguna lain.';
      case 'sign_in_failed':
        return 'Gagal masuk. Silakan coba lagi.';
      case 'network-request-failed':
        return 'Permintaan jaringan gagal. Silakan periksa koneksi internet Anda.';
      case 'internal-error':
        return 'Terjadi kesalahan internal. Silakan coba lagi nanti.';
      case 'invalid-verification-code':
        return 'Kode verifikasi tidak valid. Silakan masukkan kode yang valid.';
      case 'invalid-verification-id':
        return 'ID verifikasi tidak valid. Silakan minta kode verifikasi baru.';
      case 'quota-exceeded':
        return 'Kuota terlampaui. Silakan coba lagi nanti.';
      default:
        return 'Terjadi kesalahan platform yang tidak terduga. Silakan coba lagi.';
    }
  }

  // String get message {
  //   switch (code) {
  //     case 'INVALID_LOGIN_CREDENTIALS':
  //       return 'Invalid login credentials. Please double-check your information.';
  //     case 'too-many-requests':
  //       return 'Too many requests. Please try again later.';
  //     case 'invalid-argument':
  //       return 'Invalid argument provided to the authentication method.';
  //     case 'invalid-password':
  //       return 'Incorrect password. Please try again.';
  //     case 'invalid-phone-number':
  //       return 'The provided phone number is invalid.';
  //     case 'operation-not-allowed':
  //       return 'The sign-in provider is disabled for your Firebase project.';
  //     case 'session-cookie-expired':
  //       return 'The Firebase session cookie has expired. Please sign in again.';
  //     case 'uid-already-exists':
  //       return 'The provided user ID is already in use by another user.';
  //     case 'sign_in_failed':
  //       return 'Sign-in failed. Please try again.';
  //     case 'network-request-failed':
  //       return 'Network request failed. Please check your internet connection.';
  //     case 'internal-error':
  //       return 'Internal error. Please try again later.';
  //     case 'invalid-verification-code':
  //       return 'Invalid verification code. Please enter a valid code.';
  //     case 'invalid-verification-id':
  //       return 'Invalid verification ID. Please request a new verification code.';
  //     case 'quota-exceeded':
  //       return 'Quota exceeded. Please try again later.';
  //   // Add more cases as needed...
  //     default:
  //       return 'An unexpected platform error occurred. Please try again.';
  //   }
  // }
}
