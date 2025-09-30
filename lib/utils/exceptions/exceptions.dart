import '../logging/logger.dart';

/// Exception class for handling various errors.
class TExceptions implements Exception {
  /// The associated error message.
  final String message;

  /// Default constructor with a generic error message.
  const TExceptions([this.message = 'An unexpected error occurred. Please try again.']);

  /// Create an authentication exception from a Firebase authentication exception code.
  factory TExceptions.fromCode(String code) {
    TLoggerHelper.error('Error code received: $code');

    switch (code) {
      case 'email-already-in-use':
        return const TExceptions('Alamat email sudah terdaftar. Silakan gunakan email lain.');
      case 'invalid-email':
        return const TExceptions('Alamat email yang diberikan tidak valid. Silakan masukkan email yang valid.');
      case 'weak-password':
        return const TExceptions('Kata sandi terlalu lemah. Silakan pilih kata sandi yang lebih kuat.');
      case 'user-disabled':
        return const TExceptions('Akun pengguna ini telah dinonaktifkan. Silakan hubungi dukungan untuk bantuan.');
      case 'user-not-found':
        return const TExceptions('Detail login tidak valid. Pengguna tidak ditemukan.');
      case 'wrong-password':
        return const TExceptions('Kata sandi salah. Silakan periksa kata sandi Anda dan coba lagi.');
      case 'INVALID_LOGIN_CREDENTIALS':
        return const TExceptions('Kredensial login tidak valid. Silakan periksa informasi Anda dan coba lagi.');
      case 'too-many-requests':
        return const TExceptions('Terlalu banyak permintaan. Silakan coba lagi nanti.');
      case 'invalid-argument':
        return const TExceptions('Argumen yang diberikan untuk metode autentikasi tidak valid.');
      case 'invalid-password':
        return const TExceptions('Kata sandi salah. Silakan coba lagi.');
      case 'invalid-phone-number':
        return const TExceptions('Nomor telepon yang diberikan tidak valid.');
      case 'operation-not-allowed':
        return const TExceptions('Penyedia masuk ini dinonaktifkan untuk proyek Firebase Anda.');
      case 'session-cookie-expired':
        return const TExceptions('Cookie sesi Firebase telah kedaluwarsa. Silakan masuk lagi.');
      case 'uid-already-exists':
        return const TExceptions('ID pengguna yang diberikan sudah digunakan oleh pengguna lain.');
      case 'sign_in_failed':
        return const TExceptions('Gagal masuk. Silakan coba lagi.');
      case 'network-request-failed':
        return const TExceptions('Permintaan jaringan gagal. Silakan periksa koneksi internet Anda.');
      case 'internal-error':
        return const TExceptions('Terjadi kesalahan internal. Silakan coba lagi nanti.');
      case 'invalid-verification-code':
        return const TExceptions('Kode verifikasi tidak valid. Silakan masukkan kode yang valid.');
      case 'invalid-verification-id':
        return const TExceptions('ID verifikasi tidak valid. Silakan minta kode verifikasi baru.');
      case 'quota-exceeded':
        return const TExceptions('Kuota terlampaui. Silakan coba lagi nanti.');
      default:
        return const TExceptions();
    }
  }

}
