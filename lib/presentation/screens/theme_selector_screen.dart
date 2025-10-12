import 'package:flutter/material.dart';
import 'package:app_car_rental/core/theme/app_theme.dart';

class ThemeSelectorScreen extends StatefulWidget {
  const ThemeSelectorScreen({super.key});

  @override
  State<ThemeSelectorScreen> createState() => _ThemeSelectorScreenState();
}

class _ThemeSelectorScreenState extends State<ThemeSelectorScreen> {
  Color selectedColor = Colors.blue;
  bool isDarkMode = false;

  // Lista de colores disponibles
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

  // Nombres de los colores para mostrar
  final Map<Color, String> colorNames = {
    Colors.blue: 'Azul',
    Colors.green: 'Verde',
    Colors.purple: 'Púrpura',
    Colors.orange: 'Naranja',
    Colors.red: 'Rojo',
    Colors.teal: 'Verde Azulado',
    Colors.indigo: 'Índigo',
    Colors.pink: 'Rosa',
  };

  void _toggleDarkMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  void _selectColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme(
        selectedColor: selectedColor,
        isDarkMode: isDarkMode,
      ).getTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const SizedBox(width: 16),
              Image.asset(
                'assets/images/cr_logo.jpg',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 8),
              const Text(
                'Car Rent',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              onPressed: _toggleDarkMode,
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
              ),
              tooltip: isDarkMode ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selecciona un color para el tema:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: availableColors.length,
                  itemBuilder: (context, index) {
                    final color = availableColors[index];
                    final colorName = colorNames[color] ?? 'Color';
                    
                    return RadioListTile<Color>(
                      title: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            colorName,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      value: color,
                      groupValue: selectedColor,
                      onChanged: (Color? value) {
                        if (value != null) {
                          _selectColor(value);
                        }
                      },
                      activeColor: selectedColor,
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Implementar guardado de preferencias
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Tema aplicado: ${colorNames[selectedColor]} - '
                          '${isDarkMode ? "Modo oscuro" : "Modo claro"}',
                        ),
                        backgroundColor: selectedColor,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Aplicar Tema',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
