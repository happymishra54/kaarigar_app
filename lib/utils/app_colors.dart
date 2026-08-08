import 'package:flutter/material.dart';

class AppColors {
// Brand (blue palette)
  static const primary = Color(0xff2563EB);
  static const primaryDark = Color(0xff1D4ED8);
  static const secondary = Color(0xff0EA5E9);
  static const secondaryDark = Color(0xff0284C7);

  // Semantic
  static const success = Color(0xff16A34A);
  static const danger = Color(0xffDC2626);
  static const warning = Color(0xffF59E0B);

  // Surfaces
  static const background = Color(0xffF7F9FC);
  static const card = Colors.white;
  static const surfaceTint = Color(0xffEFF6FF);

  // Dark footer/header brand nav
  static const brandDark = Color(0xff0F172A);
  static const brandDarker = Color(0xff111827);

  // Text
  static const textPrimary = Color(0xff0F172A);
  static const textSecondary = Color(0xff64748B);
  static const textMuted = Color(0xff94A3B8);

  // Brand gradients
  static const brandGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const accentGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Soft tints (with low alpha) usage helper
  static Color tint(Color color, [double alpha = 0.12]) =>
      color.withValues(alpha: alpha);
}

