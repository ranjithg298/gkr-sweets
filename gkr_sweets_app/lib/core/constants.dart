import 'package:flutter/material.dart';

class AppConstants {
  // Supabase Configuration
  static const String supabaseUrl = 'https://mamsjkoxduulgveshdcf.supabase.co';
  static const String supabaseAnonKey = 
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1hbXNqa294ZHV1bGd2ZXNoZGNmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjM4MjY3NzEsImV4cCI6MjA3OTQwMjc3MX0.rk2qTSXHJbdR23Buesz7kEV0CCk9IJP961Ym2TyWFEo';
  
  // Razorpay Configuration
  // Get your key from: https://dashboard.razorpay.com/app/keys
  // For testing, use: rzp_test_xxxxxxxxxxxxxxxx
  // For production, use: rzp_live_xxxxxxxxxxxxxxxx
  static const String razorpayKeyId = 'rzp_test_RkrGSzXx0GtFhx'; // Key from backend/config.js
  
  // App Info
  static const String appName = 'GKR Sweets';
  static const String appTagline = 'Traditional Sweets & Snacks';
}

class AppColors {
  // Primary Colors - Rich Gold & Deep Brown
  static const Color primary = Color(0xFFD4AF37); // Gold
  static const Color primaryDark = Color(0xFFB8860B); // Dark Gold
  static const Color secondary = Color(0xFF8B4513); // Saddle Brown
  static const Color secondaryDark = Color(0xFF654321); // Dark Brown
  
  // Background Colors
  static const Color background = Color(0xFFFFFBF5); // Cream
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBg = Color(0xFFFFF8E7);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2C1810);
  static const Color textSecondary = Color(0xFF6B4423);
  static const Color textLight = Color(0xFF9E7B5B);
  
  // Accent Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFD4AF37), Color(0xFFFFD700)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFBF5), Color(0xFFFFF8E7)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppTextStyles {
  static const String fontFamily = 'Poppins';
  
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textLight,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );
  
  static const TextStyle price = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );
}

class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;
  
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusXLarge = 24.0;
  
  static const double iconSizeSmall = 20.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
}
