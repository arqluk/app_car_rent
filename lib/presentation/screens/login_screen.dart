import 'package:app_car_rental/domain/user.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_car_rental/data/user_repository.dart';

// import 'package:list_view_al_ej/domain/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController inputUserEmail = TextEditingController();
  final TextEditingController inputPassword = TextEditingController();

  String? userEmailError;
  String? passwordError;

  // final List<User> users = [
  //   User(userEmail: 'ale@gmail.com', password: '123', passport: 'A12345', country: 'ARG'),
  //   User(userEmail: 'ben@gmail.com', password: '234', passport: 'A12345', country: 'BRA'),
  //   User(userEmail: 'cam@gmail.com', password: '345', passport: 'A12345', country: 'CHN'),
  //   User(userEmail: 'dan@gmail.com', password: '456', passport: 'A12345', country: 'DEN'),
  //   User(userEmail: 'eva@gmail.com', password: '567', passport: 'A12345', country: 'ESP'),
  // ];

  // 🔹 initState: se ejecuta al crear el State
  @override
  void initState() {
    super.initState();
    inputUserEmail.text = '';
    inputPassword.text = '';
  }

  // 🔹 dispose: se ejecuta cuando se destruye el State
  @override
  void dispose() {
    inputUserEmail.dispose();
    inputPassword.dispose();
    super.dispose();
  }



  void _login() {
    final userEmail = inputUserEmail.text.trim();
    final password = inputPassword.text.trim();

    setState(() {
      userEmailError = null;
      passwordError = null;
    });

    if (userEmail.isEmpty) {
      setState(() => userEmailError = 'El email no puede estar vacío');
      return;
    }

    if (password.isEmpty) {
      setState(() => passwordError = 'La contraseña no puede estar vacía');
      return;
    }

    // final userFound = users.any(
    // // final userFound = users.firstWhere(
    //   (u) => u.username == username && u.password == password,
    // );

    // final userFound = users.firstWhere(
    // (u) => u.userEmail == userEmail && u.password == password,
    // orElse: () => User(userEmail: '', password: '', passport: '', country: ''),
    // );



    final userFound = UserRepository.findUser(userEmail, password);


    // if (!userFound) {
    // // if (userFound.username.isNotEmpty) {
    //   setState(() {
    //     usernameError = 'Usuario o contraseña incorrectos';
    //     passwordError = 'Usuario o contraseña incorrectos';
    //   });
    //   return;
    // }

    // Usuario no encontrado
  // if (userFound.userEmail.isEmpty) {
  if (userFound == null) {

    setState(() {
      userEmailError = 'email o contraseña incorrectos';
      passwordError = 'email o contraseña incorrectos';
    });
    return;
  }


    // ✅ Login correcto
    // context.push('/home', extra: username);
    // context.push('/animal_screen', extra: username);
    // context.push('/animal_screen', extra: username);
    // context.push('/perfil_screen', extra: userFound);
    // context.push('/settings_screen', extra: userFound);

    // context.pushReplacement('/home', extra: userFound);
    context.pushReplacement('/cars_screen', extra: userFound);
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Login Screen')),

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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: inputUserEmail,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: userEmailError, // 👈 mensaje debajo
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: inputPassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: passwordError, // 👈 mensaje debajo
                ),
              ),
            ),
            const SizedBox(height: 200),
            OutlinedButton(
              // onPressed: () => context.push('/cars_screen'),
              onPressed: _login,
              child: const Text('Login')
              ),


            TextButton(
              onPressed: () => context.push('/register_screen'),
              child: const Text('¿No tenés cuenta? Registrate'),
            ),




          ],
        ),
      ),
    );
  }
}


// -----------------------------------------------------------------

// import 'package:app_car_rental/domain/user.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController inputUserEmail = TextEditingController();
//   final TextEditingController inputPassword = TextEditingController();

//   String? userEmailError;
//   String? passwordError;

//   // 🔹 Lista temporal de usuarios
//   final List<User> users = [
//     User(userEmail: 'ale@gmail.com', password: '123', passport: 'A12345', country: 'ARG'),
//     User(userEmail: 'ben@gmail.com', password: '234', passport: 'A12345', country: 'BRA'),
//   ];

//   @override
//   void dispose() {
//     inputUserEmail.dispose();
//     inputPassword.dispose();
//     super.dispose();
//   }

//   void _login() {
//     final email = inputUserEmail.text.trim();
//     final pass = inputPassword.text.trim();

//     setState(() {
//       userEmailError = null;
//       passwordError = null;
//     });

//     if (email.isEmpty) {
//       setState(() => userEmailError = 'Ingrese su email');
//       return;
//     }
//     if (pass.isEmpty) {
//       setState(() => passwordError = 'Ingrese su contraseña');
//       return;
//     }

//     final userFound = users.firstWhere(
//       (u) => u.userEmail == email && u.password == pass,
//       orElse: () => User(userEmail: '', password: '', passport: '', country: ''),
//     );

//     if (userFound.userEmail.isEmpty) {
//       setState(() {
//         userEmailError = 'Usuario o contraseña incorrectos';
//         passwordError = 'Usuario o contraseña incorrectos';
//       });
//       return;
//     }

//     context.pushReplacement('/home', extra: userFound);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Iniciar Sesión'),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: inputUserEmail,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 border: const OutlineInputBorder(),
//                 errorText: userEmailError,
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: inputPassword,
//               obscureText: true,
//               decoration: InputDecoration(
//                 labelText: 'Contraseña',
//                 border: const OutlineInputBorder(),
//                 errorText: passwordError,
//               ),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: _login,
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//               child: const Text('Login'),
//             ),
//             const SizedBox(height: 10),
//             TextButton(
//               onPressed: () => context.push('/register_screen'),
//               child: const Text('¿No tienes cuenta? Registrate'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
