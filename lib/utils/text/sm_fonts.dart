import 'package:flutter/material.dart';

abstract class SMFontPoppins {
  static const TextStyle _poppins =
      TextStyle(fontFamily: "poppins");

  /// DISPLAY 1
  static TextStyle display1Semibold = _poppins.copyWith(
    fontSize: 40,
    height: 56 / 40,
    letterSpacing: -2,
    fontWeight: FontWeight.w600,
  );
  static TextStyle display1Medium = _poppins.copyWith(
    fontSize: 40,
    height: 56 / 40,
    letterSpacing: -2,
    fontWeight: FontWeight.w500,
  );

  static TextStyle display1Reguler = _poppins.copyWith(
    fontSize: 40,
    height: 56 / 40,
    letterSpacing: -2,
    fontWeight: FontWeight.w400,
  );

  /// DISPLAY 2
  static TextStyle display2Semibold = _poppins.copyWith(
    fontSize: 36,
    height: 44 / 36,
    letterSpacing: -1.5,
    fontWeight: FontWeight.w600,
  );
  static TextStyle display2Medium = _poppins.copyWith(
    fontSize: 36,
    height: 44 / 36,
    letterSpacing: -1.5,
    fontWeight: FontWeight.w500,
  );

  static TextStyle display2Reguler = _poppins.copyWith(
    fontSize: 36,
    height: 44 / 36,
    letterSpacing: -1.5,
    fontWeight: FontWeight.w400,
  );

  /// HEADER 1
  static TextStyle header1Semibold = _poppins.copyWith(
    fontSize: 32,
    height: 40 / 32,
    letterSpacing: -1,
    fontWeight: FontWeight.w600,
  );
  static TextStyle header1Medium = _poppins.copyWith(
    fontSize: 32,
    height: 40 / 32,
    letterSpacing: -1,
    fontWeight: FontWeight.w500,
  );

  static TextStyle header1Reguler = _poppins.copyWith(
    fontSize: 32,
    height: 40 / 32,
    letterSpacing: -1,
    fontWeight: FontWeight.w400,
  );

  /// HEADER 2
  static TextStyle header2Semibold = _poppins.copyWith(
    fontSize: 28,
    height: 32 / 28,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w600,
  );
  static TextStyle header2Medium = _poppins.copyWith(
    fontSize: 28,
    height: 32 / 28,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w500,
  );

  static TextStyle header2Reguler = _poppins.copyWith(
    fontSize: 28,
    height: 32 / 28,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w400,
  );

  /// HEADER 3
  static TextStyle header3Semibold = _poppins.copyWith(
    fontSize: 24,
    height: 32 / 24,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w600,
  );
  static TextStyle header3Medium = _poppins.copyWith(
    fontSize: 24,
    height: 32 / 24,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w500,
  );

  static TextStyle header3Reguler = _poppins.copyWith(
    fontSize: 24,
    height: 32 / 24,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w400,
  );

  /// HEADER 4
  static TextStyle header4Bold = _poppins.copyWith(
    fontSize: 20,
    height: 24 / 20,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w700,
  );
  static TextStyle header4SemiBold = _poppins.copyWith(
    fontSize: 20,
    height: 24 / 20,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w600,
  );
  static TextStyle header4Medium = _poppins.copyWith(
    fontSize: 20,
    height: 24 / 20,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w500,
  );
  static TextStyle header4Reguler = _poppins.copyWith(
    fontSize: 20,
    height: 24 / 20,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w400,
  );

  /// HEADER 5
  static TextStyle header5Bold = _poppins.copyWith(
    fontSize: 16,
    height: 20 / 16,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w700,
  );
  static TextStyle header5SemiBold = _poppins.copyWith(
    fontSize: 16,
    height: 20 / 16,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w600,
  );
  static TextStyle header5Medium = _poppins.copyWith(
    fontSize: 16,
    height: 20 / 16,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w500,
  );
  static TextStyle header5Reguler = _poppins.copyWith(
    fontSize: 16,
    height: 20 / 16,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w400,
  );

  /// HEADER 6
  static TextStyle header6Bold = _poppins.copyWith(
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w700,
  );
  static TextStyle header6SemiBold = _poppins.copyWith(
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w600,
  );
  static TextStyle header6Medium = _poppins.copyWith(
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w500,
  );
  static TextStyle header6Reguler = _poppins.copyWith(
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: -0.2,
    fontWeight: FontWeight.w400,
  );

  /// PARAGRAPH 1
  static TextStyle paragraph1Reguler = _poppins.copyWith(
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w400,
  );
  static TextStyle paragraph1Light = _poppins.copyWith(
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w300,
  );

  /// PARAGRAPH 2
  static TextStyle paragraph2Reguler = _poppins.copyWith(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
  );
  static TextStyle paragraph2Light = _poppins.copyWith(
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w300,
  );

  /// PARAGRAPH 3
  static TextStyle paragraph3Reguler = _poppins.copyWith(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w400,
  );
  static TextStyle paragraph3Light = _poppins.copyWith(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w300,
  );

  /// SMALLCAPS
  static TextStyle smallcapsBold = _poppins.copyWith(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 2,
  );
  static TextStyle smallcapsLight = _poppins.copyWith(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 1,
  );

  /// ACTION
  static TextStyle actionReguler20 = _poppins.copyWith(
    fontSize: 20,
    height: 24 / 20,
    fontWeight: FontWeight.w400,
  );
  static TextStyle actionReguler16 = _poppins.copyWith(
    fontSize: 16,
    height: 20 / 16,
    fontWeight: FontWeight.w400,
  );

  static TextStyle actionMedium14 = _poppins.copyWith(
    fontSize: 14,
    height: 16 / 14,
    fontWeight: FontWeight.w500,
  );
  static TextStyle actionMedium12 = _poppins.copyWith(
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
  );
  static TextStyle actionMedium10 = _poppins.copyWith(
    fontSize: 10,
    height: 12 / 10,
    fontWeight: FontWeight.w500,
  );
}
