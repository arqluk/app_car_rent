import 'package:app_car_rental/menu/menu_item.dart';
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
      data: (userDoc) {
        print("USER DOC = $userDoc");
        final role = userDoc?['role'];

        return NavigationDrawer(
          selectedIndex: selectedItem,
          onDestinationSelected: (index) {
            final route = menuItems[index].link;

            setState(() => selectedItem = index);

            Navigator.pop(context); // cierra drawer

            // ✅ si requiere admin → validar rol
            if (_needsAdmin(route)) {
              if (role == 'admin') {
                context.push(route);
              } else {
                context.push('/access_denied_screen');
              }
            } else {
              context.push(route);
            }
          },
          children: [
            ...menuItems.map(
              (item) => NavigationDrawerDestination(
                icon: Icon(item.icon),
                label: Text(item.title),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Text("Error cargando usuario"),
    );
  }
}



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