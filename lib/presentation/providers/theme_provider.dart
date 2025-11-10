import 'package:app_car_rental/core/theme/app_theme.dart';
import 'package:flutter_riverpod/legacy.dart';

// Un provider simple para el índice del color seleccionado (opcional)
StateProvider<int> selectedColorProvider = StateProvider<int>((ref) {
  return 0;
});

// Provider que expone el estado actual (AppTheme)
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((
  ref,
) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppTheme());

  void selectColor(int color) {
    state = state.copyWith(selectedColor: color);
  }

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }
}
