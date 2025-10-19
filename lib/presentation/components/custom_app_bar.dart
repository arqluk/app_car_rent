import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showAuthButtons;
  final bool showDarkModeButton;
  final bool isDarkMode;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onRegisterPressed;
  final VoidCallback? onDarkModePressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showAuthButtons = false,
    this.showDarkModeButton = false,
    this.isDarkMode = false,
    this.onLoginPressed,
    this.onRegisterPressed,
    this.onDarkModePressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      title: Row(
        children: [
          Image.asset(
            'assets/images/cr_logo.jpg',
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
      // backgroundColor: Colors.blue,
      backgroundColor: colorScheme.primary,
   
      // foregroundColor: Colors.white,
      foregroundColor: colorScheme.onPrimary,
      actions: [
        if (showAuthButtons) ...[
          TextButton(
            onPressed: onLoginPressed,
            // child: const Text('Login', style: TextStyle(color: Colors.white)),
            child: Text('Login', style: TextStyle(color: colorScheme.onPrimary)),
          ),
          TextButton(
            onPressed: onRegisterPressed,
            // child: const Text('Register', style: TextStyle(color: Colors.white)),
            child: Text('Register', style: TextStyle(color: colorScheme.onPrimary)),
          ),
        // ] else ...[
        //   IconButton(
        //     onPressed: () {
        //       // Podés pasar una acción por parámetro si querés hacerlo más flexible
        //     },
        //     // icon: const Icon(Icons.directions_car),
        //     icon: const Icon(Icons.dark_mode),
        //     tooltip: 'Car Rent',
        //   ),

          ] else if (showDarkModeButton) ...[
          IconButton(
      onPressed: onDarkModePressed,
      icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
        color: colorScheme.onPrimary,
        tooltip: isDarkMode ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
    ),
  ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
