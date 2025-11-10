import 'package:app_car_rental/core/theme/app_theme.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeSelectorScreen extends ConsumerWidget {
  ThemeSelectorScreen({super.key});

  final colors = availableColors;

  @override
  Widget build(BuildContext context, ref) {
    final appTheme = ref.watch(themeNotifierProvider); // obtiene AppTheme

    return Scaffold(
      appBar: CustomAppBar(
        title: ' Preferencias',
        showDarkModeButton: true,
        isDarkMode: appTheme.isDarkMode,
        onDarkModePressed: () {
          // ✅ aquí llamamos al método del notifier — ya debe existir
          ref.read(themeNotifierProvider.notifier).toggleDarkMode();
        },
      ),

      body: _ThemeSelectorView(colorsList: colors),
    );
  }
}

class _ThemeSelectorView extends ConsumerWidget {
  final List<Color> colorsList;

  _ThemeSelectorView({super.key, this.colorsList = const []});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedColor = ref.watch(selectedColorProvider);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: SizedBox(
          width: 400, // opcional para desktop / podés quitarlo en mobile
          child: Column(
            mainAxisSize: MainAxisSize
                .min, // ✅ hace que la columna tome solo su altura necesaria
            children: [
              Text(
                'Seleccioná el color que prefieras',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),
      
              // ✅ la lista se adapta automáticamente y ya no colapsa
              for (int index = 0; index < colorsList.length; index++)
                RadioListTile(
                  title: Text(
                    'Color $index',
                    style: TextStyle(color: colorsList[index]),
                  ),
                  value: index,
                  groupValue: selectedColor,
                  onChanged: (value) {
                    ref.read(themeNotifierProvider.notifier).selectColor(value!);
                    ref.read(selectedColorProvider.notifier).state = value;
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
