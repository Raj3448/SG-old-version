import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:silver_genie/core/constants/fonts.dart';

abstract class AppTextStyle {
  //------------------- Plus Jakarta Sans -------------------------

  //---Bold----------------------------
  static const heading1Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 48,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  static const heading2Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 40,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  static const heading3Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 32,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  static const heading4Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  static const heading5Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  static const heading6Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 18,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  //---SemiBold----------------------------
  static const heading1SemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 48,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  static const heading2SemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 40,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  static const heading3SemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 32,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  static const heading4SemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 24,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  static const heading5SemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  static const heading6SemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  //---Medium----------------------------
  static const heading1Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 48,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  static const heading2Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 40,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  static const heading3Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 32,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  static const heading4Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 24,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  static const heading5Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 20,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  static const heading6Medium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    letterSpacing: 0.5,
    fontFamily: FontFamily.plusJakarta,
  );

  //--------------------------------------------------------------

  //------------------------- Inter ------------------------------

  //---Bold----------------------------
  static const bodyXLBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18,
    letterSpacing: 0.5,
    fontFamily: FontFamily.inter,
  );

  static const bodyLargeBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    letterSpacing: 0.5,
    fontFamily: FontFamily.inter,
  );

  static const bodyMediumBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    letterSpacing: 0.5,
    fontFamily: FontFamily.inter,
  );

  static const bodySmallBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    letterSpacing: 0.5,
    fontFamily: FontFamily.inter,
  );

  //---SemiBold----------------------------
  static const bodyXLSemiBold = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 18,
    letterSpacing: 0.5,
    fontFamily: FontFamily.inter,
  );

  static const bodyLargeSemiBold = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 16,
    letterSpacing: 0.5,
    fontFamily: FontFamily.inter,
  );

  static const bodyMediumSemiBold = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    letterSpacing: 0.5,
    fontFamily: FontFamily.inter,
  );

  static const bodySmallSemiBold = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    letterSpacing: 0.5,
    fontFamily: FontFamily.inter,
  );

  //---Medium----------------------------
  static const bodyXLMedium = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 18,
    fontFamily: FontFamily.inter,
  );

  static const bodyLargeMedium = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    fontFamily: FontFamily.inter,
  );

  static const bodyMediumMedium = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    letterSpacing: 0.5,
    height: 1.4,
    fontFamily: FontFamily.inter,
  );

  static const bodySmallMedium = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    letterSpacing: 0.5,
    fontFamily: FontFamily.inter,
  );

  //--------------------------------------------------------------
}

extension AppTextStyleExtension on TextStyle {
  // Style
  TextStyle toItalic() => copyWith(fontStyle: FontStyle.italic);

  // Font Weight
  TextStyle toMedium() => copyWith(fontWeight: FontWeight.w500);
  TextStyle toSemiBold() => copyWith(fontWeight: FontWeight.w600);
  TextStyle toBold() => copyWith(fontWeight: FontWeight.bold);

  // Color
  TextStyle colored(Color color) => copyWith(color: color);
}
