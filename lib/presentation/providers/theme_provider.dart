import 'package:app_car_rental/core/theme/app_theme.dart';
import 'package:flutter_riverpod/legacy.dart';

StateProvider<int> selectedColorProvider = StateProvider<int>((ref) {
  return 0;
});

final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier(): super(AppTheme());

    void selectColor(int color) {
    state = state.copyWith(selectedColor: color);
  }

  void toggleDarkMode(bool darkMode) {
    state = state.copyWith(isDarkMode: darkMode);
  }



}

