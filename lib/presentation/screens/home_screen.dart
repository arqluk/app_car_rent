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
  const _HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
          TextButton(
            onPressed: () => context.push('/start_session_screen'),
            // onPressed: () {
            //   // TODO: Navegar a pantalla de Login
            // },
            child: const Text(
              'Login',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => context.push('/register_screen'),
            // onPressed: () {
            //   // TODO: Navegar a pantalla de Registro
            // },
            child: const Text(
              'Registrar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
 //           Center(
 //             Center(
       //         Row(
       //           mainAxisAlignment: MainAxisAlignment.center, // 👈 centra horizontalmente
       //           children: [
              const Text(
              'Bienvenido a',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
            ),

            const SizedBox(height: 20),

            Image.asset(
              'assets/images/cr_logo.jpg',
                width: 150,
                height: 150,
            ),

            // const SizedBox(height: 5),

            const Text(
              'Car Rent',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
        //          ],
        //        ),
 //             ),
 //           ),
            const SizedBox(height: 50),

            // const Text(
            //   'Bienvenido a',
            //   style: TextStyle(fontSize: 25, fontWeight: FontWeight.normal),
            // ),
            const SizedBox(height: 50),
            // // ElevatedButton.icon(
            // ElevatedButton.icon(
            //   // onPressed: () => context.go('/theme_selector'),
            //   onPressed: () => context.push('/theme_selector'),
            //   icon: const Icon(Icons.palette),
            //   label: const Text('Seleccionar Tema'),
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            //   ),
            // ),

            TextButton.icon(
              onPressed: () => context.push('/theme_selector'),
              icon: const Icon(
                Icons.palette,
                // color: Colors.blue
               ),
              label: const Text(
                'Seleccionar Tema',
                style: TextStyle(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                  // color: Colors.blue,
                ),
              ),
            ),

          ],
        ),
      ),

      // drawer: DrawerMenu(),
      drawer: DrawerMenu(scaffoldKey: scaffoldKey), // ✅ se pasa aquí
    );
  }
}