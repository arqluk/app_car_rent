import 'package:flutter/material.dart';

class MenuItem{
  String title;
  String subtitle;
  IconData icon;
  String link;

  MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.link,
  });
}

  final List<MenuItem> menuItems = [
    MenuItem(
      title: 'Flota',
      subtitle: 'Ver autos',
      icon: Icons.directions_car,
      // link: '/cars_screen',
      link: '/fleet_screen',
    ),
    MenuItem(
      title: 'Mis Reservas',
      subtitle: 'Ver reservas',
      icon: Icons.menu_book,
      link: '/reservations_list_screen',
    ),
        MenuItem(
      title: 'Mis Pagos',
      subtitle: 'Ver pagos',
      icon: Icons.payment,
      link: '/payments_list_screen',
    ),
    //  MenuItem(
    //   title: 'Configuración',
    //   subtitle: 'Seleccionar configuraciones',
    //   icon: Icons.select_all,
    //   link: '/settings_screen',
    // ),
    MenuItem(
      title: 'Configuración',
      subtitle: 'Seleccioná el tema de la aplicación',
      icon: Icons.select_all,
      link: '/theme_selector',
    ),
    MenuItem(
      title: 'Administrador',
      subtitle: 'Acceso reservado para administradores',
      icon: Icons.admin_panel_settings,
      link: '/admin_screen',
    ),
    //   MenuItem(
    //   title: 'Agregar auto',
    //   subtitle: 'Agregar un auto a la flota',
    //   icon: Icons.car_rental,
    //   link: '/add_car_screen',
    // ),
    MenuItem(
      title: 'Logout',
      subtitle: 'Salir de la app',
      icon: Icons.exit_to_app,
      link: '/home_screen',
    ),
  ];


