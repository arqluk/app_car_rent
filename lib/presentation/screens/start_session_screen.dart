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

    // const buttonWidth = 200.0;
    const buttonWidth = 0.5;
    const buttonHeight = 50.0;

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
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       const Text(
      //         ' -----    Iniciar con    -----',
      //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
      //       ),



          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50.0),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                          endIndent: 15,
                        ),
                      ),
                      Text(
                        'Iniciar con',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 15,
                        ),
                      ),
                    ],
                  ),
                ),


            const SizedBox(height: 30),
            //  ElevatedButton.icon(
            //   onPressed: () {},
            //   icon: Icon(Icons.g_mobiledata),
            //   // icon: Image.asset('assets/images/google_logo.png'),
            //   // icon: SizedBox(
            //   //   width: 24,
            //   //   height: 24,
            //   //   child: Image.asset('assets/images/google_logo.png')
            //   // ),
            // //   icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
            //   label: Text('Google'),
            // ),


            // 🔹 Google Button
            SizedBox(
              // width: buttonWidth,
              width: MediaQuery.of(context).size.width * buttonWidth,
              height: buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.g_mobiledata),
                label: const Text('Google'),
              ),
            ),

            const SizedBox(height: 15),

            // ElevatedButton.icon(
            //   onPressed: () {},
            //   icon: Icon(Icons.apple),
            //   label: Text('Apple'),
            // ),

            // 🔹 Apple Button
             SizedBox(
              // width: buttonWidth,
              width: MediaQuery.of(context).size.width * buttonWidth,
              height: buttonHeight,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.apple),
                label: const Text('Apple'),
              ),
            ),

            const SizedBox(height: 15),


            //  const SizedBox(height: 10),
            // ElevatedButton.icon(
            //   onPressed: () {},
            //   icon: Icon(Icons.email),
            //   label: Text('email'),
            // ),


            // 🔹 Email Button
            SizedBox(
              // width: buttonWidth,
              width: MediaQuery.of(context).size.width * buttonWidth,
              height: buttonHeight,
              child: ElevatedButton.icon(
                // onPressed: () {},
                onPressed: () => context.push('/login_screen'),
                icon: const Icon(Icons.email),
                label: const Text('Email'),
              ),
            ),


            const SizedBox(height: 30),

            TextButton(
              onPressed: () => context.push('/register_screen'),
            //   onPressed: () {},
              child: const Text('¿No tenés cuenta? Regístrate',
              style: TextStyle(fontSize: 18,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.underline, // 👈 subraya el texto
              ),
              ),
           ),
          ],
        ),
      ),
    );
  }
}


// ----------------------------------------------------------------------

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class StartSessionScreen extends StatelessWidget {
//   const StartSessionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           children: [
//             Image.asset(
//               'assets/images/cr_logo.jpg',
//               width: 40,
//               height: 40,
//             ),
//             const SizedBox(width: 8),
//             const Text('Car Rent'),
//           ],
//         ),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () => context.push('/login_screen'),
//               child: const Text('Iniciar sesión'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => context.push('/register_screen'),
//               child: const Text('Registrarse'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
