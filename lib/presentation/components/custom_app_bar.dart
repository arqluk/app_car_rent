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
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      actions: [
        // 🔹 Si el usuario está logueado → muestra botón de "Cerrar sesión"
        authState.when(
          data: (user) {

            // final location = GoRouter.of(context).location;
            //   final isLogin = location == '/login_screen';
            //   final isRegister = location == '/register_screen';

            final currentLocation = GoRouterState.of(context).uri.toString();
              final isLogin = currentLocation == '/login_screen';
              final isRegister = currentLocation == '/register_screen';






      // if (user != null) {
      if (!isLogin && !isRegister && user != null) {
              // ✅ Usuario logueado → Logout + DarkMode
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

                  // ✅ Mostrar dark mode también cuando está logueado
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
              // ✅ Usuario NO logueado → Login/Register + DarkMode
              // ✅ // Usuario no logueado → mostrar login/register en pantallas que lo pidan
              return Row(
                children: [
                  if (showAuthButtons) ...[
                    TextButton(
                      onPressed: onLoginPressed,
                      child: Text('Login',
                          style: TextStyle(color: colorScheme.onPrimary)),
                    ),
                    TextButton(
                      onPressed: onRegisterPressed,
                      child: Text('Register',
                          style: TextStyle(color: colorScheme.onPrimary)),
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


// ------------------------------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:app_car_rental/presentation/providers/auth_provider.dart';
// import 'package:go_router/go_router.dart';

// class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
//   final String title;
//   final bool showAuthButtons;
//   final bool showDarkModeButton;
//   final bool isDarkMode;
//   final VoidCallback? onLoginPressed;
//   final VoidCallback? onRegisterPressed;
//   final VoidCallback? onDarkModePressed;

//   const CustomAppBar({
//     super.key,
//     required this.title,
//     this.showAuthButtons = false,
//     this.showDarkModeButton = false,
//     this.isDarkMode = false,
//     this.onLoginPressed,
//     this.onRegisterPressed,
//     this.onDarkModePressed,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final authState = ref.watch(authStateProvider);

//     return AppBar(
//       title: Row(
//         children: [
//           Image.asset(
//             'assets/images/cr_logo.jpg',
//             width: 40,
//             height: 40,
//           ),
//           const SizedBox(width: 8),
//           Text(title),
//         ],
//       ),
//       backgroundColor: colorScheme.primary,
//       foregroundColor: colorScheme.onPrimary,
//       actions: [
//         // 🔹 Si el usuario está logueado → muestra botón de "Cerrar sesión"
//         authState.when(
//           data: (user) {
//             if (user != null) {
//               return IconButton(
//                 icon: const Icon(Icons.logout),
//                 tooltip: 'Cerrar sesión',
//                 color: colorScheme.onPrimary,
//                 onPressed: () async {
//                   await FirebaseAuth.instance.signOut();

//                   if (context.mounted) {
//                     // Redirige al login (ajustá la ruta si tu login tiene otro nombre)
//                     // context.go('/login_screen');
//                     context.go('/home_screen');
//                   }
//                 },
//               );
//             } else {
//               // 🔹 Si no hay usuario logueado → muestra login/register y/o modo oscuro
//               return Row(
//                 children: [
//                   if (showAuthButtons) ...[
//                     TextButton(
//                       onPressed: onLoginPressed,
//                       child: Text('Login',
//                           style: TextStyle(color: colorScheme.onPrimary)),
//                     ),
//                     TextButton(
//                       onPressed: onRegisterPressed,
//                       child: Text('Register',
//                           style: TextStyle(color: colorScheme.onPrimary)),
//                     ),
//                   ],
//                   if (showDarkModeButton)
//                     IconButton(
//                       onPressed: onDarkModePressed,
//                       icon: Icon(
//                         isDarkMode ? Icons.light_mode : Icons.dark_mode,
//                         color: colorScheme.onPrimary,
//                       ),
//                       tooltip: isDarkMode
//                           ? 'Cambiar a modo claro'
//                           : 'Cambiar a modo oscuro',
//                     ),
//                 ],
//               );
//             }
//           },
//           loading: () => const SizedBox.shrink(),
//           error: (_, __) => const SizedBox.shrink(),
//         ),
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }



// -------------------------------------------------------------------------------------------------

// import 'package:flutter/material.dart';

// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   final bool showAuthButtons;
//   final bool showDarkModeButton;
//   final bool isDarkMode;
//   final VoidCallback? onLoginPressed;
//   final VoidCallback? onRegisterPressed;
//   final VoidCallback? onDarkModePressed;

//   const CustomAppBar({
//     super.key,
//     required this.title,
//     this.showAuthButtons = false,
//     this.showDarkModeButton = false,
//     this.isDarkMode = false,
//     this.onLoginPressed,
//     this.onRegisterPressed,
//     this.onDarkModePressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return AppBar(
//       title: Row(
//         children: [
//           Image.asset(
//             'assets/images/cr_logo.jpg',
//             width: 40,
//             height: 40,
//           ),
//           const SizedBox(width: 8),
//           Text(title),
//         ],
//       ),
//       // backgroundColor: Colors.blue,
//       backgroundColor: colorScheme.primary,
   
//       // foregroundColor: Colors.white,
//       foregroundColor: colorScheme.onPrimary,
//       actions: [
//         if (showAuthButtons) ...[
//           TextButton(
//             onPressed: onLoginPressed,
//             // child: const Text('Login', style: TextStyle(color: Colors.white)),
//             child: Text('Login', style: TextStyle(color: colorScheme.onPrimary)),
//           ),
//           TextButton(
//             onPressed: onRegisterPressed,
//             // child: const Text('Register', style: TextStyle(color: Colors.white)),
//             child: Text('Register', style: TextStyle(color: colorScheme.onPrimary)),
//           ),
//         // ] else ...[
//         //   IconButton(
//         //     onPressed: () {
//         //       // Podés pasar una acción por parámetro si querés hacerlo más flexible
//         //     },
//         //     // icon: const Icon(Icons.directions_car),
//         //     icon: const Icon(Icons.dark_mode),
//         //     tooltip: 'Car Rent',
//         //   ),

//           ] else if (showDarkModeButton) ...[
//           IconButton(
//       onPressed: onDarkModePressed,
//       icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
//         color: colorScheme.onPrimary,
//         tooltip: isDarkMode ? 'Cambiar a modo claro' : 'Cambiar a modo oscuro',
//     ),
//   ],
//       ],
//     );
//   }

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }
