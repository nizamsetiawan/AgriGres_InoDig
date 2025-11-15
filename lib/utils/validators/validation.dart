
class TValidator {

  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return 'Nama wajib diisi';
    }
    return null;
  }
  static String? validateEmail(String? value) {
    if( value == null || value.isEmpty) {
      return 'Email wajib diisi';
    }

    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegExp.hasMatch(value)) {
      return 'Alamat email tidak valid';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if( value == null || value.isEmpty) {
      return 'Kata sandi wajib diisi';
    }

    if(value.length < 6) {
      return 'Kata sandi minimal 6 karakter';
    }

    return null;

  }

  static String? validatePhoneNumber(String? value) {
    if( value == null || value.isEmpty) {
      return 'Nomor telepon wajib diisi';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'Nomor telepon harus berupa angka';
    }
    return null;
  }

  static String? validateGeneral(String? value) {
    if( value == null || value.isEmpty) {
      return 'Tidak boleh kosong';
    }
    return null;
  }



}