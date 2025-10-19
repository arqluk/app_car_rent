import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SettingsScreenView();
  }
}

class _SettingsScreenView extends StatelessWidget {
  const _SettingsScreenView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       Image.asset(
      //         'assets/images/cr_logo.jpg',
      //         width: 40,
      //         height: 40,
      //       ),
      //       const SizedBox(width: 8),
      //       const Text('Car Rent'),
      //     ],
      //   ),
      //   backgroundColor: Colors.blue,
      //   foregroundColor: Colors.white,
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         // TODO: Agregar funcionalidad del ícono de auto
      //       },
      //       icon: const Icon(Icons.directions_car),
      //       tooltip: 'Car Rent',
      //     ),
      //   ],
      // ),

      appBar: const CustomAppBar(title: 'Car Rent'),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Acá van a ir las configuraciones'),
          ],
        ),
      ),
    );
  }
}