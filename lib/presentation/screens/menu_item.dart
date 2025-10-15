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
  MenuItem(title: 'Autos', subtitle: 'Lista de Autos', icon: Icons.circle, link: '/cars_screen'),
];

