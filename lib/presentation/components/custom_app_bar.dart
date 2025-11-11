import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_car_rental/presentation/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = ref.watch(authStateProvider);

    return AppBar(
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('assets/images/cr_logo.jpg', width: 40, height: 40),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      actions: [
        // Si el usuario está logueado → muestra botón de "Cerrar sesión"
        authState.when(
          data: (user) {
            final currentLocation = GoRouterState.of(context).uri.toString();
            final isLogin = currentLocation == '/login_screen';
            final isRegister = currentLocation == '/register_screen';

            if (!isLogin && !isRegister && user != null) {
              // Usuario logueado → Logout + DarkMode
              return Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Cerrar sesión',
                    color: colorScheme.onPrimary,
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        context.go('/home_screen');
                      }
                    },
                  ),

                  // Mostrar dark mode también cuando está logueado
                  if (showDarkModeButton)
                    IconButton(
                      onPressed: onDarkModePressed,
                      icon: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: colorScheme.onPrimary,
                      ),
                      tooltip: isDarkMode
                          ? 'Cambiar a modo claro'
                          : 'Cambiar a modo oscuro',
                    ),
                ],
              );
            } else {
              // Usuario NO logueado → Login/Register + DarkMode
              // Usuario no logueado → mostrar login/register en pantallas que lo pidan
              return Row(
                children: [
                  if (showAuthButtons) ...[
                    TextButton(
                      onPressed: onLoginPressed,
                      child: Text(
                        'Login',
                        style: TextStyle(color: colorScheme.onPrimary),
                      ),
                    ),
                    TextButton(
                      onPressed: onRegisterPressed,
                      child: Text(
                        'Register',
                        style: TextStyle(color: colorScheme.onPrimary),
                      ),
                    ),
                  ],

                  if (showDarkModeButton)
                    IconButton(
                      onPressed: onDarkModePressed,
                      icon: Icon(
                        isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        color: colorScheme.onPrimary,
                      ),
                      tooltip: isDarkMode
                          ? 'Cambiar a modo claro'
                          : 'Cambiar a modo oscuro',
                    ),
                ],
              );
            }
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
