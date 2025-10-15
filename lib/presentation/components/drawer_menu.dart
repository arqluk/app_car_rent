// import 'package:app_car_rental/presentation/screens/menu_item.dart';
// import 'package:app_car_rental/presentation/screens/menu_item.dart';
import 'package:app_car_rental/menu/menu_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerMenu extends StatefulWidget {
  // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> scaffoldKey;

  // DrawerMenu({super.key});
  const DrawerMenu({super.key, required this.scaffoldKey});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  int selectedItem = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationDrawer(
      // onDestinationSelected: (index) {
      //   setState(() {
      //     selectedItem = index;
      //   });
      //     widget.scaffoldKey.currentState?.closeDrawer(); // 👈 Primero cerrar
      //     context.push(menuItems[index].link);            // 👈 Luego navegar
      // },

      onDestinationSelected: (index) async {
        setState(() {
          selectedItem = index;
        });

        Navigator.pop(context); // Cierra el drawer

        // await Future.delayed(const Duration(milliseconds: 200)); // ⏳ Espera breve

        // if (context.mounted) {
        //   context.push(menuItems[index].link);
        // }

        context.push(menuItems[index].link);
      },


      selectedIndex: selectedItem,
      children: [
        ...menuItems.map((item) => NavigationDrawerDestination(
          icon: Icon(item.icon),
          label: Text(item.title),
          ))
        ]
    );
  }
}