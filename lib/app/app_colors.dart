import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Backgrounds ──────────────────────────────
  static const Color bgDeep = Color(0xFFF5F7FA); // soft off-white
  static const Color bgCard = Color(0xFFFFFFFF); // pure white cards

  // ── Glass surface ────────────────────────────
  static const Color glassFill = Color(0xCCFFFFFF); // white @ 80% opacity
  static const Color glassBorder = Color(0xFFDDE3EE); // light cool grey border

  // ── Accent — Cyan / LinkedIn-Blue ────────────
  static const Color accentPrimary = Color(0xFF0099CC); // slightly deeper cyan
  static const Color accentSecondary = Color(0xFF0073B1); // LinkedIn blue
  static const Color accentGlow = Color(0x1A0099CC); // very subtle cyan tint

  // ── Text ─────────────────────────────────────
  static const Color textPrimary = Color(0xFF0D1526); // near-black
  static const Color textSecondary = Color(0xFF4A5568); // dark slate
  static const Color textMuted = Color(0xFF9AA5B4); // medium grey

  // ── Gradient stops (page background) ─────────
  static const Color gradTop = Color(0xFFEFF2F7); // lightest blue-white
  static const Color gradBottom = Color(0xFFF8F9FC); // near-white
}
