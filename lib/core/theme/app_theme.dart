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
  final int selectedColor; // índice en availableColors
  final bool isDarkMode;

  AppTheme({this.selectedColor = 0, this.isDarkMode = false});

  ThemeData getTheme() {
    final seed = availableColors[selectedColor];

    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,

      // ✅ SnackBar toma automáticamente colores según tema
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.primaryContainer,
        contentTextStyle: TextStyle(color: colorScheme.onPrimaryContainer),
        behavior: SnackBarBehavior.floating,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  AppTheme copyWith({int? selectedColor, bool? isDarkMode}) {
    return AppTheme(
      selectedColor: selectedColor ?? this.selectedColor,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
