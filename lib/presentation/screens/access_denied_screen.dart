import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class AccessDeniedScreen extends StatelessWidget {
  const AccessDeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _AceessDeniedScreenView();
  }
}

class _AceessDeniedScreenView extends StatelessWidget {
  const _AceessDeniedScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Car Rent'),

      body: const Center(child: Text('Acceso denegado')),
    );
  }
}
