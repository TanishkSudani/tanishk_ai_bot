import 'package:flutter/material.dart';

class AppColors {
  // Primary dark background palette
  static const bg = Color(0xFF0A0F1A);
  static const surface = Color(0xFF111827);
  static const card = Color(0xFF1A2235);
  static const cardLight = Color(0xFF202B42);
  static const border = Color(0xFF1E2D45);
  static const borderBright = Color(0xFF2D3E5E);

  // Vibrant accent & action colors
  static const accent = Color(0xFF3B82F6);
  static const accentGlow = Color(0xFF60A5FA);
  static const green = Color(0xFF22C55E);
  static const wa = Color(0xFF25D366);
  static const red = Color(0xFFEF4444);
  static const orange = Color(0xFFF59E0B);
  static const purple = Color(0xFFA855F7);
  static const cyan = Color(0xFF06B6D4);

  // Typography shades
  static const text = Color(0xFFF1F5F9);
  static const textSecondary = Color(0xFFCBD5E1);
  static const sub = Color(0xFF94A3B8);
  static const muted = Color(0xFF475569);

  // Call status gradients
  static const LinearGradient activeCallGradient = LinearGradient(
    colors: [Color(0xFF0F1E36), Color(0xFF162544)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient speakingGradient = LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient waGradient = LinearGradient(
    colors: [Color(0xFF064E3B), Color(0xFF047857)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
