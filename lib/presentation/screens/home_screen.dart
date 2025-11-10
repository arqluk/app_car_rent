import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/components/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _HomeView();
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      appBar: CustomAppBar(
        title: '',
        showAuthButtons: true, // muestra los botones
        onLoginPressed: () {
          // Navegar a la pantalla de login
          context.push('/login_screen');
        },
        onRegisterPressed: () {
          // Navegar a la pantalla de registro
          context.push('/register_screen');
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bienvenido a',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
              ),

              const SizedBox(height: 5),

              Image.asset('assets/images/cr_logo.jpg', width: 150, height: 150),

              const Text(
                'Car Rent',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 50),

              // ✅ IMAGEN DE VARIOS AUTOS DEBAJO DEL BOTÓN
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: Image.asset(
                  'assets/images/cars_banner.jpg', // imagen agregada a carpeta assets
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => context.push('/fleet_screen'),
                  icon: const Icon(Icons.directions_car, size: 25),
                  label: Text(
                    'Conocé nuestra flota',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      drawer: DrawerMenu(scaffoldKey: scaffoldKey),
    );
  }
}

