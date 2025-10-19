import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showAuthButtons;
  final bool showDarkModeButton;
  final VoidCallback? onLoginPressed;
  final VoidCallback? onRegisterPressed;
  // final VoidCallback? onDarkModePressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showAuthButtons = false,
    this.showDarkModeButton = false,
    this.onLoginPressed,
    this.onRegisterPressed,
    // this.onDarkModePressed,
  });

  @override
  Widget build(BuildContext context) {
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
      backgroundColor: Colors.blue,
      foregroundColor: Colors.white,
      actions: [
        if (showAuthButtons) ...[
          TextButton(
            onPressed: onLoginPressed,
            child: const Text('Login', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: onRegisterPressed,
            child: const Text('Register', style: TextStyle(color: Colors.white)),
          ),
        ] else ...[
          IconButton(
            onPressed: () {
              // Podés pasar una acción por parámetro si querés hacerlo más flexible
            },
            // icon: const Icon(Icons.directions_car),
            icon: const Icon(Icons.dark_mode),
            tooltip: 'Car Rent',
          ),

          // ] else if (showDarkModeButton) ...[
          // IconButton(
          //   // onPressed: onDarkModePressed,
          //   icon: const Icon(Icons.dark_mode),
          //   tooltip: 'Modo oscuro',
          // )
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
