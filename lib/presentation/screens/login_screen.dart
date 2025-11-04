import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Iniciar sesión')),
      appBar: const CustomAppBar(title: 'Car Rent'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) =>
                    v != null && v.contains('@') ? null : 'Email inválido',
              ),
              TextFormField(
                controller: _passCtrl,
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (v) =>
                    v != null && v.length >= 6 ? null : 'Mínimo 6 caracteres',
              ),
              const SizedBox(height: 20),
              if (_error != null)
                Text(_error!,
                    style: const TextStyle(color: Colors.red, fontSize: 14)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;
                        setState(() {
                          _loading = true;
                          _error = null;
                        });

                        final notifier =
                            ref.read(UsersNotifierProvider.notifier);
                        final user = await notifier.loginUser(
                          _emailCtrl.text.trim(),
                          _passCtrl.text.trim(),
                        );

                        setState(() => _loading = false);

                        if (user != null) {
                          context.go('/home_screen');
                        } else {
                          setState(() => _error = 'Email o contraseña incorrectos');
                        }
                      },
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// --------------------------------------------------------------------------------------------


// // presentation/screens/login_screen.dart
// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:app_car_rental/presentation/providers/users_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// class LoginScreen extends ConsumerStatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   ConsumerState<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends ConsumerState<LoginScreen> {
//   final TextEditingController _emailCtrl = TextEditingController();
//   final TextEditingController _passCtrl = TextEditingController();
//   bool _loading = false;

//   @override
//   void dispose() {
//     _emailCtrl.dispose();
//     _passCtrl.dispose();
//     super.dispose();
//   }

//   Future<void> _onLogin() async {
//     final email = _emailCtrl.text.trim();
//     final pass = _passCtrl.text.trim();

//     if (email.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingrese email')));
//       return;
//     }
//     if (pass.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingrese contraseña')));
//       return;
//     }

//     setState(() => _loading = true);

//     // final user = await ref.read(usersProvider.notifier).loginUser(email, pass);
//     final user = await ref.read(UsersNotifierProvider.notifier).loginUser(email, pass);

//     setState(() => _loading = false);

//     if (user == null) {
//       // No existe o password incorrecto
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario o contraseña incorrectos')));
//       // Redirigir a registro (opcional)
//       if (context.mounted) context.push('/register_screen');
//       return;
//     }

//     // Login correcto: redirigir a home/cars
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login exitoso')));
//     if (context.mounted) context.pushReplacement('/home_screen');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Scaffold(
//       appBar: const CustomAppBar(title: 'Car Rent'),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Center(
//           child: SizedBox(
//             width: 420,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 TextField(
//                   controller: _emailCtrl,
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 12),
//                 TextField(
//                   controller: _passCtrl,
//                   decoration: const InputDecoration(
//                     labelText: 'Contraseña',
//                     border: OutlineInputBorder(),
//                   ),
//                   obscureText: true,
//                 ),
//                 const SizedBox(height: 18),
//                 FilledButton(
//                   onPressed: _loading ? null : _onLogin,
//                   style: FilledButton.styleFrom(
//                     backgroundColor: colorScheme.primary,
//                     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
//                   child: _loading
//                   ? const CircularProgressIndicator()
//                   : Text(
//                     'Login', style: TextStyle(color: colorScheme.onPrimary)
//                     ),
//                 ),
//                 const SizedBox(height: 12),
//                 TextButton(onPressed: () => context.push('/register_screen'), child: const Text('¿No tenés cuenta? Registrate')),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





// -----------------------------------------------------------------------------

// // Hasta 22/10/2025


// import 'package:app_car_rental/domain/user.dart';
// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:app_car_rental/data/user_repository.dart';

// // import 'package:list_view_al_ej/domain/user.dart';

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

//   // final List<User> users = [
//   //   User(userEmail: 'ale@gmail.com', password: '123', passport: 'A12345', country: 'ARG'),
//   //   User(userEmail: 'ben@gmail.com', password: '234', passport: 'A12345', country: 'BRA'),
//   //   User(userEmail: 'cam@gmail.com', password: '345', passport: 'A12345', country: 'CHN'),
//   //   User(userEmail: 'dan@gmail.com', password: '456', passport: 'A12345', country: 'DEN'),
//   //   User(userEmail: 'eva@gmail.com', password: '567', passport: 'A12345', country: 'ESP'),
//   // ];

//   // 🔹 initState: se ejecuta al crear el State
//   @override
//   void initState() {
//     super.initState();
//     inputUserEmail.text = '';
//     inputPassword.text = '';
//   }

//   // 🔹 dispose: se ejecuta cuando se destruye el State
//   @override
//   void dispose() {
//     inputUserEmail.dispose();
//     inputPassword.dispose();
//     super.dispose();
//   }



//   void _login() {
//     final userEmail = inputUserEmail.text.trim();
//     final password = inputPassword.text.trim();

//     setState(() {
//       userEmailError = null;
//       passwordError = null;
//     });

//     if (userEmail.isEmpty) {
//       setState(() => userEmailError = 'El email no puede estar vacío');
//       return;
//     }

//     if (password.isEmpty) {
//       setState(() => passwordError = 'La contraseña no puede estar vacía');
//       return;
//     }

//     // final userFound = users.any(
//     // // final userFound = users.firstWhere(
//     //   (u) => u.username == username && u.password == password,
//     // );

//     // final userFound = users.firstWhere(
//     // (u) => u.userEmail == userEmail && u.password == password,
//     // orElse: () => User(userEmail: '', password: '', passport: '', country: ''),
//     // );



//     final userFound = UserRepository.findUser(userEmail, password);


//     // if (!userFound) {
//     // // if (userFound.username.isNotEmpty) {
//     //   setState(() {
//     //     usernameError = 'Usuario o contraseña incorrectos';
//     //     passwordError = 'Usuario o contraseña incorrectos';
//     //   });
//     //   return;
//     // }

//     // Usuario no encontrado
//   // if (userFound.userEmail.isEmpty) {
//   if (userFound == null) {

//     setState(() {
//       userEmailError = 'email o contraseña incorrectos';
//       passwordError = 'email o contraseña incorrectos';
//     });
//     return;
//   }


//     // ✅ Login correcto
//     // context.push('/home', extra: username);
//     // context.push('/animal_screen', extra: username);
//     // context.push('/animal_screen', extra: username);
//     // context.push('/perfil_screen', extra: userFound);
//     // context.push('/settings_screen', extra: userFound);

//     // context.pushReplacement('/home', extra: userFound);
//     context.pushReplacement('/cars_screen', extra: userFound);
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(title: const Text('Login Screen')),

//       // appBar: AppBar(
//       //   title: Row(
//       //     children: [
//       //       Image.asset(
//       //         'assets/images/cr_logo.jpg',
//       //         width: 40,
//       //         height: 40,
//       //       ),
//       //       const SizedBox(width: 8),
//       //       const Text('Car Rent'),
//       //     ],
//       //   ),
//       //   backgroundColor: Colors.blue,
//       //   foregroundColor: Colors.white,
//       //   actions: [
//       //     IconButton(
//       //       onPressed: () {
//       //         // TODO: Agregar funcionalidad del ícono de auto
//       //       },
//       //       icon: const Icon(Icons.directions_car),
//       //       tooltip: 'Car Rent',
//       //     ),
//       //   ],
//       // ),

//       appBar: const CustomAppBar(title: 'Car Rent'),


//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: TextField(
//                 controller: inputUserEmail,
//                 decoration: InputDecoration(
//                   hintText: 'Enter your email',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   errorText: userEmailError, // 👈 mensaje debajo
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: TextField(
//                 controller: inputPassword,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   hintText: 'Enter your password',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   errorText: passwordError, // 👈 mensaje debajo
//                 ),
//               ),
//             ),
//             const SizedBox(height: 200),
//             OutlinedButton(
//               // onPressed: () => context.push('/cars_screen'),
//               onPressed: _login,
//               child: const Text('Login')
//               ),


//             TextButton(
//               onPressed: () => context.push('/register_screen'),
//               child: const Text('¿No tenés cuenta? Registrate'),
//             ),




//           ],
//         ),
//       ),
//     );
//   }
// }


// // -----------------------------------------------------------------

// // import 'package:app_car_rental/domain/user.dart';
// // import 'package:flutter/material.dart';
// // import 'package:go_router/go_router.dart';

// // class LoginScreen extends StatefulWidget {
// //   const LoginScreen({super.key});

// //   @override
// //   State<LoginScreen> createState() => _LoginScreenState();
// // }

// // class _LoginScreenState extends State<LoginScreen> {
// //   final TextEditingController inputUserEmail = TextEditingController();
// //   final TextEditingController inputPassword = TextEditingController();

// //   String? userEmailError;
// //   String? passwordError;

// //   // 🔹 Lista temporal de usuarios
// //   final List<User> users = [
// //     User(userEmail: 'ale@gmail.com', password: '123', passport: 'A12345', country: 'ARG'),
// //     User(userEmail: 'ben@gmail.com', password: '234', passport: 'A12345', country: 'BRA'),
// //   ];

// //   @override
// //   void dispose() {
// //     inputUserEmail.dispose();
// //     inputPassword.dispose();
// //     super.dispose();
// //   }

// //   void _login() {
// //     final email = inputUserEmail.text.trim();
// //     final pass = inputPassword.text.trim();

// //     setState(() {
// //       userEmailError = null;
// //       passwordError = null;
// //     });

// //     if (email.isEmpty) {
// //       setState(() => userEmailError = 'Ingrese su email');
// //       return;
// //     }
// //     if (pass.isEmpty) {
// //       setState(() => passwordError = 'Ingrese su contraseña');
// //       return;
// //     }

// //     final userFound = users.firstWhere(
// //       (u) => u.userEmail == email && u.password == pass,
// //       orElse: () => User(userEmail: '', password: '', passport: '', country: ''),
// //     );

// //     if (userFound.userEmail.isEmpty) {
// //       setState(() {
// //         userEmailError = 'Usuario o contraseña incorrectos';
// //         passwordError = 'Usuario o contraseña incorrectos';
// //       });
// //       return;
// //     }

// //     context.pushReplacement('/home', extra: userFound);
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Iniciar Sesión'),
// //         backgroundColor: Colors.blue,
// //         foregroundColor: Colors.white,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             TextField(
// //               controller: inputUserEmail,
// //               decoration: InputDecoration(
// //                 labelText: 'Email',
// //                 border: const OutlineInputBorder(),
// //                 errorText: userEmailError,
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             TextField(
// //               controller: inputPassword,
// //               obscureText: true,
// //               decoration: InputDecoration(
// //                 labelText: 'Contraseña',
// //                 border: const OutlineInputBorder(),
// //                 errorText: passwordError,
// //               ),
// //             ),
// //             const SizedBox(height: 30),
// //             ElevatedButton(
// //               onPressed: _login,
// //               style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
// //               child: const Text('Login'),
// //             ),
// //             const SizedBox(height: 10),
// //             TextButton(
// //               onPressed: () => context.push('/register_screen'),
// //               child: const Text('¿No tienes cuenta? Registrate'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
