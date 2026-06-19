import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Type scale modelled on Apple's marketing typography: large, tightly-tracked
/// display weights down to a calm 17px body. Inter stands in for SF Pro.
class AppTypography {
  AppTypography._();

  static TextStyle get _base => GoogleFonts.inter(color: AppColors.ink);

  static TextStyle get display => _base.copyWith(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.0,
        height: 1.05,
      );

  static TextStyle get title => _base.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
        height: 1.1,
      );

  static TextStyle get headline => _base.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        height: 1.15,
      );

  static TextStyle get subhead => _base.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      );

  static TextStyle get body => _base.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w400,
        height: 1.45,
        color: AppColors.inkSecondary,
      );

  static TextStyle get bodyStrong => body.copyWith(
        color: AppColors.ink,
        fontWeight: FontWeight.w500,
      );

  static TextStyle get callout => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: AppColors.inkSecondary,
      );

  static TextStyle get caption => _base.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: AppColors.inkTertiary,
      );

  static TextStyle get button => _base.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        letterSpacing: -0.2,
      );

  static TextStyle get price => _base.copyWith(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      );
}
