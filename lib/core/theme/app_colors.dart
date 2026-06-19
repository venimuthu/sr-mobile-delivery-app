import 'package:flutter/material.dart';

/// The SR colour system, tuned to feel like apple.com: a near-white canvas,
/// ink-black type, generous neutrals, and a single confident accent.
class AppColors {
  AppColors._();

  // Canvas
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F7); // Apple's signature grey
  static const Color surfaceElevated = Color(0xFFFBFBFD);

  // Ink
  static const Color ink = Color(0xFF1D1D1F); // primary text
  static const Color inkSecondary = Color(0xFF6E6E73); // secondary text
  static const Color inkTertiary = Color(0xFF86868B);

  // Accent (Apple system blue)
  static const Color accent = Color(0xFF0071E3);
  static const Color accentPressed = Color(0xFF0058B0);

  // Lines & dividers
  static const Color divider = Color(0xFFE8E8ED);
  static const Color border = Color(0xFFD2D2D7);

  // Status
  static const Color success = Color(0xFF34C759);
  static const Color warning = Color(0xFFFF9F0A);
  static const Color error = Color(0xFFFF3B30);

  // Veg / non-veg marks (relevant for an Indian catalogue)
  static const Color veg = Color(0xFF34A853);

  // On-accent
  static const Color onAccent = Color(0xFFFFFFFF);

  /// A soft, premium shadow used on floating cards.
  static List<BoxShadow> softShadow = const [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  static List<BoxShadow> subtleShadow = const [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];
}
