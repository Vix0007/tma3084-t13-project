import 'package:flutter/material.dart';

/// Colour tokens taken from the VanQ Figma variables.
class AppColors {
  AppColors._();

  // Brand
  static const brandPrimary = Color(0xFF0E2A47);
  static const brandAccent = Color(0xFFFFB703);
  static const brandAccentSoft = Color(0x40FFB703); // accent @ 25%

  // Backgrounds
  static const bgScreen = Color(0xFFF4F6F9);
  static const bgSurface = Color(0xFFFFFFFF);

  // Text
  static const textPrimary = Color(0xFF0E1726);
  static const textSecondary = Color(0xFF5B6576);

  // Lines / states
  static const border = Color(0xFFE3E7ED);
  static const borderSoft = Color(0x99E3E7ED); // border @ 60%
  static const disabled = Color(0xFFC4CAD3);

  // Status
  static const pendingBg = Color(0xFFFFF4D6);
  static const pendingText = Color(0xFF8A5A00);
  static const confirmedBg = Color(0xFFE3EEFF);
  static const confirmedText = Color(0xFF1D4ED8);
  static const completedBg = Color(0xFFDFF5EC);
  static const completedText = Color(0xFF116A47);
  static const cancelledBg = Color(0xFFFDE4E4);
  static const cancelledText = Color(0xFFB42318);
  static const ongoingBg = Color(0xFFEDE7FF);
  static const ongoingText = Color(0xFF5B3FC4);

  // Glass surfaces (bottom nav, action bars)
  static const glassNav = Color(0x66FFFFFF); // white @ 40%
  static const glassBar = Color(0xBFFFFFFF); // white @ 75%
  static const glassBorder = Color(0x99FFFFFF); // white @ 60%

  // Card Shadow effect: #0E2A47 @ 6%, y 4, blur 16
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x0F0E2A47), offset: Offset(0, 4), blurRadius: 16),
  ];
}
