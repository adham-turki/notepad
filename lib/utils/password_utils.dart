import 'package:flutter/material.dart';

enum PasswordStrength { weak, medium, strong }

class PasswordUtils {
  static PasswordStrength getPasswordStrength(String password) {
    if (password.length < 8) return PasswordStrength.weak;
    
    int score = 0;
    
    // Length check
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    
    // Character variety checks
    if (password.contains(RegExp(r'[a-z]'))) score++; // lowercase
    if (password.contains(RegExp(r'[A-Z]'))) score++; // uppercase
    if (password.contains(RegExp(r'[0-9]'))) score++; // numbers
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++; // special chars
    
    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }
  
  static String getStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }
  
  static Color getStrengthColor(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return const Color(0xFFEF4444); // Red
      case PasswordStrength.medium:
        return const Color(0xFFF59E0B); // Orange
      case PasswordStrength.strong:
        return const Color(0xFF10B981); // Green
    }
  }
}
