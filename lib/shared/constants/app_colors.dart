import 'package:flutter/material.dart';

/// Single source of truth for every color token in the app.
/// Never use raw Color() values outside this file.
abstract final class AppColors {
  // ── Brand ─────────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // ── Surface ───────────────────────────────────────────────────────────────
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFF8FAFC);
  static const Color cardBackgroundAlt = Color(0xFFF1F5F9);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Border ────────────────────────────────────────────────────────────────
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderFocused = Color(0xFF2563EB);

  // ── Status ────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFF0FDF4);
  static const Color error = Color(0xFFDC2626);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color warning = Color(0xFFD97706);
  static const Color warningLight = Color(0xFFFFFBEB);

  // ── Progress ──────────────────────────────────────────────────────────────
  static const Color progressTrack = Color(0xFFE5E7EB);

  // ── Divider ───────────────────────────────────────────────────────────────
  static const Color divider = Color(0xFFF3F4F6);

  // ── Icon ──────────────────────────────────────────────────────────────────
  static const Color iconPrimary = Color(0xFF374151);
  static const Color iconSecondary = Color(0xFF9CA3AF);

  // ── Subject accent colors (for cards) ────────────────────────────────────
  static const Color physicsAccent = Color(0xFF2563EB);
  static const Color chemistryAccent = Color(0xFF16A34A);
  static const Color mathAccent = Color(0xFFD97706);
  static const Color biologyAccent = Color(0xFF9333EA);

  // Prevent instantiation
  AppColors._();
}