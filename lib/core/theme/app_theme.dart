import 'package:flutter/material.dart';

class AppTheme {
  final Color selectedColor;
  final bool isDarkMode;

  AppTheme({
    this.selectedColor = Colors.blue,
    this.isDarkMode = false,
  });

  ThemeData getTheme() {
    return ThemeData(
      colorSchemeSeed: selectedColor,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      useMaterial3: true,
    );
  }
}