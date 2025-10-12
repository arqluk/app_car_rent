import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartSessionScreen extends StatelessWidget {
  const StartSessionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _StartSesionScreenView();
  }
}

class _StartSesionScreenView extends StatelessWidget {
  const _StartSesionScreenView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/cr_logo.jpg',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text('Car Rent'),
          ],
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Agregar funcionalidad del ícono de auto
            },
            icon: const Icon(Icons.directions_car),
            tooltip: 'Car Rent',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              ' -----    Iniciar con    -----',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 30),
             ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.g_mobiledata),
              // icon: Image.asset('assets/images/google_logo.png'),
              // icon: SizedBox(
              //   width: 24,
              //   height: 24,
              //   child: Image.asset('assets/images/google_logo.png')
              // ),
            //   icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
              label: Text('Google'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.apple),
              label: Text('Apple'),
            ),
             const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () {},
              icon: Icon(Icons.email),
              label: Text('email'),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: () => context.push('/register_screen'),
            //   onPressed: () {},
              child: const Text('No estoy registrado',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
              ),
           ),
          ],
        ),
      ),
    );
  }
}