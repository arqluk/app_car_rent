import 'package:flutter/material.dart';


  final List<Color> availableColors = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.red,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
  ];
class AppTheme {
  // final Color selectedColor;
  final int selectedColor;
  final bool isDarkMode;

  AppTheme({
    // this.selectedColor = Colors.blue,
    this.selectedColor = 0,
    this.isDarkMode = false,
  });

  ThemeData getTheme() {
    return ThemeData(
      // colorSchemeSeed: selectedColor,
      colorSchemeSeed: availableColors[selectedColor],
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      useMaterial3: true,
    );
  }

  AppTheme copyWith({
    int? selectedColor,
    bool? isDarkMode,
  }) {
    return AppTheme(
      selectedColor: selectedColor ?? this.selectedColor,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

