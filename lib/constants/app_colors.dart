import 'package:flutter/material.dart';

class AppColors {
  // Vinted-inspired color palette
  static const Color primary = Color(0xFF09B1BA); // Vinted teal
  static const Color primaryLight = Color(0xFF4ECDC4); // Lighter teal
  static const Color primaryDark = Color(0xFF007A7A); // Darker teal
  
  static const Color secondary = Color(0xFF7B68EE); // Purple accent
  static const Color secondaryLight = Color(0xFF9B8FFF);
  static const Color secondaryDark = Color(0xFF5A4FCF);
  
  static const Color background = Color(0xFFFAFAFA); // Off-white background
  static const Color surface = Colors.white;
  static const Color error = Color(0xFFFF6B6B); // Coral red
  
  static const Color textPrimary = Color(0xFF2C3E50); // Dark blue-gray
  static const Color textSecondary = Color(0xFF7F8C8D); // Medium gray
  static const Color textHint = Color(0xFFBDC3C7); // Light gray
  
  static const Color divider = Color(0xFFE8F4F8); // Very light teal
  static const Color shadow = Color(0x1A000000);
  
  // Border colors
  static const Color greyBorder = Color(0xFFE8F4F8);
  
  static const Color success = Color(0xFF2ECC71); // Green
  static const Color warning = Color(0xFFF39C12); // Orange
  static const Color info = Color(0xFF3498DB); // Blue
  
  // Vinted-specific colors
  static const Color vintedGreen = Color(0xFF09B1BA);
  static const Color vintedPurple = Color(0xFF7B68EE);
  static const Color vintedCoral = Color(0xFFFF6B6B);
  static const Color vintedYellow = Color(0xFFFFD93D);
  
  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Colors.white, Color(0xFFF8F9FA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient vintedGradient = LinearGradient(
    colors: [vintedGreen, vintedPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
