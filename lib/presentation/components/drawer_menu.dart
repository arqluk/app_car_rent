import 'package:app_car_rental/menu/menu_item.dart';
import 'package:app_car_rental/presentation/providers/auth_provider.dart';
import 'package:app_car_rental/presentation/providers/auth_user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DrawerMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const DrawerMenu({super.key, required this.scaffoldKey});

  @override
  ConsumerState<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends ConsumerState<DrawerMenu> {
  int selectedItem = 0;

  bool _needsAdmin(String route) {
    return route == '/admin_screen' || route == '/add_car_screen';
  }

  @override
  Widget build(BuildContext context) {
    final asyncUserDoc = ref.watch(userDocProvider);

    return asyncUserDoc.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text("Error cargando usuario")),
      data: (userDoc) {
        final role = userDoc?['role'];

        return Column(
          children: [
            _DrawerHeader(userDoc: userDoc),

            Expanded(
              child: NavigationDrawer(
                selectedIndex: selectedItem,
                onDestinationSelected: (index) {
                  final route = menuItems[index].link;

                  setState(() => selectedItem = index);
                  Navigator.pop(context);

                  if (_needsAdmin(route)) {
                    if (role == 'admin') {
                      context.push(route);
                    } else {
                      context.push('/access_denied_screen');
                    }
                    return;
                  }

                  context.push(route);
                },
                children: [
                  ...menuItems.map(
                    (item) => NavigationDrawerDestination(
                      icon: Icon(item.icon),
                      label: Text(item.title),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// -----------------------------------------------------------------------------
// ✅ HEADER DEL DRAWER
// -----------------------------------------------------------------------------

class _DrawerHeader extends ConsumerWidget {
  final Map<String, dynamic>? userDoc;

  const _DrawerHeader({required this.userDoc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final user = ref.watch(authStateProvider).asData?.value;
    final bool isLogged = user != null;

    return InkWell(
      onTap: () {
        isLogged
            ? context.push('/profile_screen')
            : context.push('/login_screen');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        color: colorScheme.primaryContainer,
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: colorScheme.primary,
              child: Icon(
                Icons.person,
                size: 32,
                color: colorScheme.onPrimary,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Email o Invitado
                  Text(
                    isLogged
                        ? (userDoc?['email'] ?? user!.email ?? 'Usuario')
                        : 'Invitado',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Rol o mensaje para iniciar sesión
                  Text(
                    isLogged
                        ? (userDoc?['role'] ?? 'user')
                        : 'Iniciá sesión para más opciones',
                    style: TextStyle(
                      fontSize: 14,
                      color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                    ),
                  ),


                  // ✅ nueva línea solo para usuarios logueados
                  if (isLogged) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Hace click aquí para ver tu perfil',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onPrimaryContainer.withOpacity(0.75),
                      ),
                    ),
                  ],

                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// --------------------------------------------------------------------------------------------------


// import 'package:app_car_rental/menu/menu_item.dart';
// import 'package:app_car_rental/presentation/providers/auth_provider.dart';
// import 'package:app_car_rental/presentation/providers/auth_user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class DrawerMenu extends ConsumerStatefulWidget {
//   final GlobalKey<ScaffoldState> scaffoldKey;

//   const DrawerMenu({super.key, required this.scaffoldKey});

//   @override
//   ConsumerState<DrawerMenu> createState() => _DrawerMenuState();
// }

// class _DrawerMenuState extends ConsumerState<DrawerMenu> {
//   int selectedItem = 0;

//   bool _needsAdmin(String route) {
//     return route == '/admin_screen' || route == '/add_car_screen';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final asyncUserDoc = ref.watch(userDocProvider);

//     return asyncUserDoc.when(
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (_, __) => const Center(child: Text("Error cargando usuario")),
//       data: (userDoc) {
//         final role = userDoc?['role'];

//         return Column(
//           children: [
//             _DrawerHeader(userDoc: userDoc), // ✅ Header dentro del Drawer

//             Expanded(
//               child: NavigationDrawer(
//                 selectedIndex: selectedItem,
//                 onDestinationSelected: (index) {
//                   final route = menuItems[index].link;

//                   setState(() => selectedItem = index);

//                   Navigator.pop(context);

//                   if (_needsAdmin(route)) {
//                     if (role == 'admin') {
//                       context.push(route);
//                     } else {
//                       context.push('/access_denied_screen');
//                     }
//                     return;
//                   }

//                   context.push(route);
//                 },
//                 children: [
//                   ...menuItems.map(
//                     (item) => NavigationDrawerDestination(
//                       icon: Icon(item.icon),
//                       label: Text(item.title),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// -----------------------------------------------------------------------------
// ✅ HEADER DEL DRAWER (clic en header → perfil o login)
// -----------------------------------------------------------------------------

// class _DrawerHeader extends ConsumerWidget {
//   final Map<String, dynamic>? userDoc;

//   const _DrawerHeader({required this.userDoc});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final user = ref.watch(authStateProvider).asData?.value;
//     final bool isLogged = user != null;

//     return InkWell(
//       onTap: () {
//         isLogged
//             ? context.push('/profile_screen')
//             : context.push('/login_screen');
//       },
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(20),
//         color: colorScheme.primaryContainer,
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 28,
//               backgroundColor: colorScheme.primary,
//               child: Icon(
//                 Icons.person,
//                 size: 32,
//                 color: colorScheme.onPrimary,
//               ),
//             ),
//             const SizedBox(width: 16),

//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     isLogged
//                         ? (userDoc?['email'] ?? user!.email ?? 'Usuario')
//                         : 'Invitado',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: colorScheme.onPrimaryContainer,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     isLogged
//                         ? (userDoc?['role'] ?? 'user')
//                         : 'Iniciá sesión para más opciones',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: colorScheme.onPrimaryContainer.withOpacity(0.8),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// --------------------------------------------------------------------------------------------------

// import 'package:app_car_rental/menu/menu_item.dart';
// import 'package:app_car_rental/presentation/providers/auth_provider.dart';
// import 'package:app_car_rental/presentation/providers/auth_user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class DrawerMenu extends ConsumerStatefulWidget {
//   final GlobalKey<ScaffoldState> scaffoldKey;

//   const DrawerMenu({super.key, required this.scaffoldKey});

//   @override
//   ConsumerState<DrawerMenu> createState() => _DrawerMenuState();
// }

// class _DrawerMenuState extends ConsumerState<DrawerMenu> {
//   int selectedItem = 0;

//   bool _needsAdmin(String route) {
//     return route == '/admin_screen' || route == '/add_car_screen';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final asyncUserDoc = ref.watch(userDocProvider);

//     return asyncUserDoc.when(
//       data: (userDoc) {
//         return Column(
//           children: [
//             // ✅ Encabezado dentro del Drawer
//             _DrawerHeader(userDoc: userDoc),

//             // ✅ Lista de elementos del drawer
//             Expanded(
//               child: NavigationDrawer(
//                 selectedIndex: selectedItem,
//                 onDestinationSelected: (index) {
//                   final route = menuItems[index].link;

//                   setState(() => selectedItem = index);

//                   Navigator.pop(context); // cierra drawer

//                   // ✅ Validación de administrador
//                   final role = userDoc?['role'];
//                   if (_needsAdmin(route)) {
//                     if (role == 'admin') {
//                       context.push(route);
//                     } else {
//                       context.push('/access_denied_screen');
//                     }
//                   } else {
//                     context.push(route);
//                   }
//                 },
//                 children: [
//                   ...menuItems.map(
//                     (item) => NavigationDrawerDestination(
//                       icon: Icon(item.icon),
//                       label: Text(item.title),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (_, __) => const Text("Error cargando usuario"),
//     );
//   }
// }

// // -----------------------------------------------------------------------------
// // ✅ HEADER DEL DRAWER
// // -----------------------------------------------------------------------------

// class _DrawerHeader extends ConsumerWidget {
//   final Map<String, dynamic>? userDoc;

//   const _DrawerHeader({required this.userDoc});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final user = ref.watch(authStateProvider).asData?.value;

//     final bool isLogged = user != null;

//     return InkWell(
//       onTap: () {
//         if (isLogged) {
//           context.push('/profile_screen');
//         } else {
//           context.push('/login_screen');
//         }
//       },
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(20),
//         color: colorScheme.primaryContainer,
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 28,
//               backgroundColor: colorScheme.primary,
//               child: Icon(
//                 Icons.person,
//                 size: 32,
//                 color: colorScheme.onPrimary,
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     isLogged
//                         ? (userDoc?['email'] ?? user!.email ?? 'Usuario')
//                         : 'Invitado',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: colorScheme.onPrimaryContainer,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     isLogged
//                         ? (userDoc?['role'] ?? 'user')
//                         : 'Iniciá sesión para más opciones',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: colorScheme.onPrimaryContainer.withOpacity(0.8),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// --------------------------------------------------------------------------------------------------
// // Con Header dentro del menu drawer .....

// import 'package:app_car_rental/menu/menu_item.dart';
// import 'package:app_car_rental/presentation/providers/auth_provider.dart';
// import 'package:app_car_rental/presentation/providers/auth_user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class DrawerMenu extends ConsumerStatefulWidget {
//   final GlobalKey<ScaffoldState> scaffoldKey;

//   const DrawerMenu({super.key, required this.scaffoldKey});

//   @override
//   ConsumerState<DrawerMenu> createState() => _DrawerMenuState();
// }

// class _DrawerMenuState extends ConsumerState<DrawerMenu> {
//   int selectedItem = 0;

//   bool _needsAdmin(String route) {
//     return route == '/admin_screen' || route == '/add_car_screen';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final asyncUserDoc = ref.watch(userDocProvider);

//     return asyncUserDoc.when(
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (_, __) => const Text("Error cargando usuario"),

//       data: (userDoc) {
//         final user = ref.watch(authStateProvider).asData?.value;
//         final bool isLogged = user != null;

//         final role = userDoc?['role'];

//         return NavigationDrawer(
//           selectedIndex: selectedItem,
//           onDestinationSelected: (index) {
//             final route = menuItems[index].link;

//             setState(() => selectedItem = index);

//             Navigator.pop(context); // cerrar drawer

//             if (_needsAdmin(route)) {
//               if (role == 'admin') {
//                 context.push(route);
//               } else {
//                 context.push('/access_denied_screen');
//               }
//               return;
//             }

//             context.push(route);
//           },

//           children: [
//             _DrawerHeader(
//               userDoc: userDoc,
//               isLogged: isLogged,
//             ),

//             const Divider(height: 1),

//             ...menuItems.map(
//               (item) => NavigationDrawerDestination(
//                 icon: Icon(item.icon),
//                 label: Text(item.title),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

// class _DrawerHeader extends ConsumerWidget {
//   final Map<String, dynamic>? userDoc;
//   final bool isLogged;

//   const _DrawerHeader({
//     required this.userDoc,
//     required this.isLogged,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final user = ref.watch(authStateProvider).asData?.value;

//       return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       color: colorScheme.primaryContainer,
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 28,
//             backgroundColor: colorScheme.primary,
//             child: Icon(
//               Icons.person,
//               size: 32,
//               color: colorScheme.onPrimary,
//             ),
//           ),

//     // return Container(
//     //   width: double.infinity,
//     //   padding: const EdgeInsets.all(20),
//     //   color: colorScheme.primaryContainer,
//     //   child: Row(
//     //     children: [
//     //       CircleAvatar(
//     //         radius: 28,
//     //         backgroundColor: colorScheme.primary,
//     //         child: Icon(
//     //           Icons.person,
//     //           size: 32,
//     //           color: colorScheme.onPrimary,
//     //         ),
//     //       ),

//           const SizedBox(width: 16),

//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   isLogged
//                       ? (userDoc?['email'] ?? user?.email ?? 'Usuario')
//                       : 'Invitado',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: colorScheme.onPrimaryContainer,
//                   ),
//                 ),

//                 const SizedBox(height: 4),

//                 Text(
//                   isLogged
//                       ? (userDoc?['role'] ?? 'user')
//                       : 'Iniciá sesión para más opciones',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: colorScheme.onPrimaryContainer.withOpacity(0.8),
//                   ),
//                 ),

//                 if (!isLogged)
//                   TextButton(
//                     onPressed: () => context.push('/login_screen'),
//                     child: const Text("Iniciar sesión"),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// ----------------------------------------------------------------------------------------

// import 'package:app_car_rental/menu/menu_item.dart';
// import 'package:app_car_rental/presentation/providers/auth_provider.dart';
// import 'package:app_car_rental/presentation/providers/auth_user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class DrawerMenu extends ConsumerStatefulWidget {
//   final GlobalKey<ScaffoldState> scaffoldKey;

//   const DrawerMenu({super.key, required this.scaffoldKey});

//   @override
//   ConsumerState<DrawerMenu> createState() => _DrawerMenuState();
// }

// class _DrawerMenuState extends ConsumerState<DrawerMenu> {
//   int selectedItem = 0;

//   bool _needsAdmin(String route) {
//     return route == '/admin_screen' || route == '/add_car_screen';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final asyncUserDoc = ref.watch(userDocProvider);

//     return asyncUserDoc.when(
//       data: (userDoc) {
//         print("USER DOC = $userDoc");
//         final role = userDoc?['role'];

// return Column(
//   children: [
//     _DrawerHeader(userDoc: userDoc),
//     Expanded(
//       child: NavigationDrawer(
//         selectedIndex: selectedItem,
//         onDestinationSelected: (index) {
//           final route = menuItems[index].link;

//           setState(() => selectedItem = index);
//           Navigator.pop(context);

//           if (_needsAdmin(route)) {
//             if (role == 'admin') {
//               context.push(route);
//             } else {
//               context.push('/access_denied_screen');
//             }
//           } else {
//             context.push(route);
//           }
//         },
//         children: [
//           ...menuItems.map(
//             (item) => NavigationDrawerDestination(
//               icon: Icon(item.icon),
//               label: Text(item.title),
//             ),
//           ),
//         ],
//       ),
//     ),
//   ],
// );

//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (_, __) => const Text("Error cargando usuario"),
//     );
//   }
// }

// class _DrawerHeader extends ConsumerWidget {
//   final Map<String, dynamic>? userDoc;

//   const _DrawerHeader({required this.userDoc});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final user = ref.watch(authStateProvider).asData?.value;

//     final bool isLogged = user != null;

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       color: colorScheme.primaryContainer,
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 28,
//             backgroundColor: colorScheme.primary,
//             child: Icon(
//               Icons.person,
//               size: 32,
//               color: colorScheme.onPrimary,
//             ),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   isLogged ? (userDoc?['email'] ?? user.email ?? 'Usuario') : 'Invitado',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: colorScheme.onPrimaryContainer,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   isLogged
//                       ? (userDoc?['role'] ?? 'user')
//                       : 'Iniciá sesión para más opciones',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: colorScheme.onPrimaryContainer.withOpacity(0.8),
//                   ),
//                 ),
//                 if (!isLogged)
//                   TextButton(
//                     onPressed: () => context.push('/login_screen'),
//                     child: const Text("Iniciar sesión"),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// ------------------------------------------------------------------------------------------

// import 'package:app_car_rental/menu/menu_item.dart';
// import 'package:app_car_rental/presentation/providers/auth_user_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class DrawerMenu extends ConsumerStatefulWidget {
//   final GlobalKey<ScaffoldState> scaffoldKey;

//   const DrawerMenu({super.key, required this.scaffoldKey});

//   @override
//   ConsumerState<DrawerMenu> createState() => _DrawerMenuState();
// }

// class _DrawerMenuState extends ConsumerState<DrawerMenu> {
//   int selectedItem = 0;

//   bool _needsAdmin(String route) {
//     return route == '/admin_screen' || route == '/add_car_screen';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final asyncUserDoc = ref.watch(userDocProvider);

//     return asyncUserDoc.when(
//       data: (userDoc) {
//         print("USER DOC = $userDoc");
//         final role = userDoc?['role'];

//         return NavigationDrawer(
//           selectedIndex: selectedItem,
//           onDestinationSelected: (index) {
//             final route = menuItems[index].link;

//             setState(() => selectedItem = index);

//             Navigator.pop(context); // cierra drawer

//             // ✅ si requiere admin → validar rol
//             if (_needsAdmin(route)) {
//               if (role == 'admin') {
//                 context.push(route);
//               } else {
//                 context.push('/access_denied_screen');
//               }
//             } else {
//               context.push(route);
//             }
//           },
//           children: [
//             ...menuItems.map(
//               (item) => NavigationDrawerDestination(
//                 icon: Icon(item.icon),
//                 label: Text(item.title),
//               ),
//             ),
//           ],
//         );
//       },
//       loading: () => const Center(child: CircularProgressIndicator()),
//       error: (_, __) => const Text("Error cargando usuario"),
//     );
//   }
// }



// --------------------------------------------------------------------------------------

// // import 'package:app_car_rental/presentation/screens/menu_item.dart';
// // import 'package:app_car_rental/presentation/screens/menu_item.dart';
// import 'package:app_car_rental/menu/menu_item.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class DrawerMenu extends StatefulWidget {
//   // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   final GlobalKey<ScaffoldState> scaffoldKey;

//   // DrawerMenu({super.key});
//   const DrawerMenu({super.key, required this.scaffoldKey});

//   @override
//   State<DrawerMenu> createState() => _DrawerMenuState();
// }

// class _DrawerMenuState extends State<DrawerMenu> {
//   int selectedItem = 0;

//   @override
//   Widget build(BuildContext context) {
//     return NavigationDrawer(
//       // onDestinationSelected: (index) {
//       //   setState(() {
//       //     selectedItem = index;
//       //   });
//       //     widget.scaffoldKey.currentState?.closeDrawer(); // 👈 Primero cerrar
//       //     context.push(menuItems[index].link);            // 👈 Luego navegar
//       // },

//       onDestinationSelected: (index) async {
//         setState(() {
//           selectedItem = index;
//         });

//         Navigator.pop(context); // Cierra el drawer

//         // await Future.delayed(const Duration(milliseconds: 200)); // ⏳ Espera breve

//         // if (context.mounted) {
//         //   context.push(menuItems[index].link);
//         // }
//         final item = menuItems[index];

        
//         Navigator.pop(context); // 👈 Cierra el Drawer primero

//         // 🔹 Si el usuario eligió "Logout"
//         if (item.title == 'Logout') {
//           await FirebaseAuth.instance.signOut();

//           // 🔸 Redirige al home (usa go en lugar de push para limpiar la pila)
//           if (context.mounted) {
//             context.go('/home_screen');
//           }

//           return; // 👈 Importante: no continuar con el resto
//         }

//         // 🔹 Si no es Logout, navega normalmente
//         if (context.mounted) {
//           context.push(item.link);
//         }
//       },
//       children: [
//         ...menuItems.map(
//           (item) => NavigationDrawerDestination(
//             icon: Icon(item.icon),
//             label: Text(item.title),
//           ),
//         ),
//       ],
//     );
//   }
// }

// -----------------------------------------------------------------------
// Última versión usada

// // import 'package:app_car_rental/presentation/screens/menu_item.dart';
// // import 'package:app_car_rental/presentation/screens/menu_item.dart';
// import 'package:app_car_rental/menu/menu_item.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class DrawerMenu extends StatefulWidget {
//   // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//   final GlobalKey<ScaffoldState> scaffoldKey;

//   // DrawerMenu({super.key});
//   const DrawerMenu({super.key, required this.scaffoldKey});

//   @override
//   State<DrawerMenu> createState() => _DrawerMenuState();
// }

// class _DrawerMenuState extends State<DrawerMenu> {
//   int selectedItem = 0;

//   @override
//   Widget build(BuildContext context) {
//     return NavigationDrawer(
//       // onDestinationSelected: (index) {
//       //   setState(() {
//       //     selectedItem = index;
//       //   });
//       //     widget.scaffoldKey.currentState?.closeDrawer(); // 👈 Primero cerrar
//       //     context.push(menuItems[index].link);            // 👈 Luego navegar
//       // },

//       onDestinationSelected: (index) async {
//         setState(() {
//           selectedItem = index;
//         });

//         Navigator.pop(context); // Cierra el drawer

//         // await Future.delayed(const Duration(milliseconds: 200)); // ⏳ Espera breve

//         // if (context.mounted) {
//         //   context.push(menuItems[index].link);
//         // }

//         context.push(menuItems[index].link);
//       },


//       selectedIndex: selectedItem,
//       children: [
//         ...menuItems.map((item) => NavigationDrawerDestination(
//           icon: Icon(item.icon),
//           label: Text(item.title),
//           ))
//         ]
//     );
//   }
// }