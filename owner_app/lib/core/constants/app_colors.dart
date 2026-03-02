import 'package:flutter/material.dart';

class AppColors {
  // Primary & Secondary
  static const Color primaryGreen = Color(0xFF22C55E); // Revenue, CTA, progress
  static const Color mutedGreen = Color.fromRGBO(34, 197, 94, 0.6);
  static const Color secondaryAmber = Color(0xFFF59E0B); // Call status, highlights
  
  // Base
  static const Color backgroundBlack = Color(0xFF0B0F0E); // Base App Background
  
  // Surface (Glass Cards)
  static const Color surfaceGlass = Color.fromRGBO(255, 255, 255, 0.06); 
  static const Color borderGlass = Color.fromRGBO(255, 255, 255, 0.10);
  
  // Timeline Components
  static const Color timelineLine = Color.fromRGBO(255, 255, 255, 0.18);
  static const Color dividerGlass = Color.fromRGBO(255, 255, 255, 0.08);

  // Charts
  static const Color graphMuted = Color.fromRGBO(148, 163, 184, 0.45);
  
  // Text
  static const Color textPrimary = Color(0xFFE5E7EB); // Text Primary
  static const Color textMuted = Color(0xFF9CA3AF); // Text Muted
  
  // Accents
  static const Color accentBlue = Color(0xFF3B82F6);
  static const Color accentGlow = Color.fromRGBO(34, 197, 94, 0.35);
  
  // Others (keeping existing references where useful or mapping them)
  static const Color red = Color(0xFFEF4444);
  static const Color amber = secondaryAmber; // Alias for backward compatibility
  static const Color textWhite = textPrimary; // Alias
  static const Color textGray = textMuted; // Alias
  
  static const Color dividerGray = Color(0xFF374151); // Keeping for dividers
  static const Color surfaceBlack = Color(0xFF1E1E1E); // Keeping for legacy
  
  // Restored for compatibility
  static const Color darkGreen = Color(0xFF059669);
  static const Color borderGray = Color(0xFF374151);
}
