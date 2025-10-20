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
  const _HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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
      //     TextButton(
      //       onPressed: () => context.push('/start_session_screen'),
      //       // onPressed: () {
      //       //   // TODO: Navegar a pantalla de Login
      //       // },
      //       child: const Text(
      //         'Login',
      //         style: TextStyle(color: Colors.white),
      //       ),
      //     ),
      //     TextButton(
      //       onPressed: () => context.push('/register_screen'),
      //       // onPressed: () {
      //       //   // TODO: Navegar a pantalla de Registro
      //       // },
      //       child: const Text(
      //         'Registrar',
      //         style: TextStyle(color: Colors.white),
      //       ),
      //     ),
      //   ],
      // ),

      appBar: CustomAppBar(
        title: 'Car Rent',
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

            const SizedBox(height: 5),

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
            const SizedBox(height: 5),

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

            // TextButton.icon(
            //   onPressed: () => context.push('/theme_selector'),
            //   icon: const Icon(
            //     Icons.palette,
            //     // color: Colors.blue
            //    ),
            //   label: const Text(
            //     'Seleccionar Tema',
            //     style: TextStyle(
            //       fontSize: 18,
            //       decoration: TextDecoration.underline,
            //       // color: Colors.blue,
            //     ),
            //   ),
            // ),

            // TextButton.icon(
            //   onPressed: () => context.push('/cars_screen'),
            //   icon: const Icon(
            //     Icons.directions_car,
            //     // color: Colors.blue
            //     size: 45, // 👈 ÍCONO MUCHO MÁS GRANDE
            //    ),
            //   label: const Text(
            //     'Ver nuestra flota',
            //     style: TextStyle(
            //       fontSize: 18,
            //       decoration: TextDecoration.underline,
            //       // color: Colors.blue,
            //     ),
            //   ),
            // ),
            // ✅ IMAGEN DE VARIOS AUTOS DEBAJO DEL BOTÓN
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: Image.asset(
                'assets/images/cars_banner.jpg', // <-- agregá esta imagen a tu carpeta assets
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),


            FilledButton.icon(
              onPressed: () => context.push('/cars_screen'),
              icon: const Icon(
                Icons.directions_car,
                size: 45,
              ),
             label: Text(
              'Ver nuestra flota',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
            ),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999), // botón tipo píldora
                ),
                backgroundColor: Theme.of(context).colorScheme.primary, // usa color del theme
              ),
            ),


            

      // // ✅ IMAGEN DE VARIOS AUTOS DEBAJO DEL BOTÓN
      //       ClipRRect(
      //         borderRadius: BorderRadius.circular(999),
      //         child: Image.asset(
      //           'assets/images/cars_banner.jpg', // <-- agregá esta imagen a tu carpeta assets
      //           width: 150,
      //           height: 75,
      //           fit: BoxFit.cover,
      //         ),
      //       ),

          ],
        ),
      ),

      // drawer: DrawerMenu(),
      drawer: DrawerMenu(scaffoldKey: scaffoldKey), // ✅ se pasa aquí
    );
  }
}