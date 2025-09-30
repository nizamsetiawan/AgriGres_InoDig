import 'package:flutter/material.dart';

class TColors{
  TColors._();

  //app basic colors
  static const Color primary = Color(0xFF218c3e);
  static const Color secondary = Color(0xFFf68620);
  static const Color accent = Color(0xFFb0c7ff);

  //text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;

  //Background colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  //Background container colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static  Color darkContainer = TColors.white.withOpacity(0.1);

  //Button colors
  static const Color buttonPrimary = Color(0xFF218c3e);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  //Border colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  //Error and validation colors
  static const Color error = Color(0xFFF55151);
  static const Color success = Color(0xFF74B816);
  static const Color warning = Color(0xFFFCC419);
  static const Color info = Color(0xFF004D94);

  //Neutral shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}