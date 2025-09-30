import 'package:agrigres/utils/logging/logger.dart';

/// Custom exception class to handle various format-related errors.
class TFormatException implements Exception {
  /// The associated error message.
  final String message;

  /// Default constructor with a generic error message.
  const TFormatException([this.message = 'An unexpected format error occurred. Please check your input.']);

  /// Create a format exception from a specific error message.
  factory TFormatException.fromMessage(String message) {
    TLoggerHelper.error("Format Exception : $message");
    return TFormatException(message);
  }

  /// Get the corresponding error message.
  String get formattedMessage => message;
  factory TFormatException.fromCode(String code) {
    switch (code) {
      case 'invalid-email-format':
        return const TFormatException('Format alamat email tidak valid. Silakan masukkan email yang valid.');
      case 'invalid-phone-number-format':
        return const TFormatException('Format nomor telepon yang diberikan tidak valid. Silakan masukkan nomor yang valid.');
      case 'invalid-date-format':
        return const TFormatException('Format tanggal tidak valid. Silakan masukkan tanggal yang valid.');
      case 'invalid-url-format':
        return const TFormatException('Format URL tidak valid. Silakan masukkan URL yang valid.');
      case 'invalid-credit-card-format':
        return const TFormatException('Format kartu kredit tidak valid. Silakan masukkan nomor kartu kredit yang valid.');
      case 'invalid-numeric-format':
        return const TFormatException('Input harus dalam format numerik yang valid.');
      default:
        return const TFormatException();
    }
  }

  // /// Create a format exception from a specific error code.
  // factory TFormatException.fromCode(String code) {
  //   switch (code) {
  //     case 'invalid-email-format':
  //       return const TFormatException('The email address format is invalid. Please enter a valid email.');
  //     case 'invalid-phone-number-format':
  //       return const TFormatException('The provided phone number format is invalid. Please enter a valid number.');
  //     case 'invalid-date-format':
  //       return const TFormatException('The date format is invalid. Please enter a valid date.');
  //     case 'invalid-url-format':
  //       return const TFormatException('The URL format is invalid. Please enter a valid URL.');
  //     case 'invalid-credit-card-format':
  //       return const TFormatException('The credit card format is invalid. Please enter a valid credit card number.');
  //     case 'invalid-numeric-format':
  //       return const TFormatException('The input should be a valid numeric format.');
  //   // Add more cases as needed...
  //     default:
  //       return const TFormatException();
  //   }
  // }
}