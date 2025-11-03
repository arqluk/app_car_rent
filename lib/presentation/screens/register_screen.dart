// presentation/screens/register_screen.dart
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/authProvider.dart';
import 'package:app_car_rental/presentation/providers/users_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app_car_rental/domain/user.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _roleController = TextEditingController();
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    // Cargar usuarios locales si querés
    // ref.read(usersProvider.notifier).getAllUsers();
    ref.read(UsersNotifierProvider.notifier).getAllUsers();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    // _roleController.dispose();
    _documentController.dispose();
    _countryController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _onSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    final newUser = User(
      userName: _usernameController.text.trim(),
      userEmail: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      // role: _roleController.text.trim(),
      role: 'user',         // 👈 se asigna automáticamente
      // passport: '',
      document: _documentController.text.trim(),
      country: _countryController.text.trim(),
    );

    // final result = await ref.read(usersProvider.notifier).registerUser(newUser);
    // final result = await ref.read(UsersNotifierProvider.notifier).registerUser(newUser);
    // final result = await ref.read(authProvider).registerUser(newUser);
    final result = await ref.read(authProvider).registerUser(newUser.userEmail, newUser.password, newUser.userName);
    // final result = await ref.read(AuthNotifier.notifier).registerUser(newUser.userEmail, newUser.password, newUser.userName);

    setState(() => _submitting = false);

    if (result == null) {
      // éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro exitoso. Inicia sesión.')),
      );
      // redirigir a login
      if (context.mounted) context.pushReplacement('/login_screen');
    } else {
      // error (email existente o fallo)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Car Rent'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Ingrese su nombre' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese su email';
                  if (!v.contains('@')) return 'Email inválido';
                  return null;
                },
              ),

              //  const SizedBox(height: 12),
              // TextFormField(
              //   controller: _roleController,
              //   decoration: const InputDecoration(
              //     labelText: 'Rol',
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (v) => (v == null || v.isEmpty) ? 'Ingrese rol' : null,
              // ),

              const SizedBox(height: 12),
              TextFormField(
                controller: _documentController,
                decoration: const InputDecoration(
                  labelText: 'Documento',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Ingrese documento' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: 'País',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Ingrese país' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) => (v == null || v.length < 3) ? 'Mínimo 3 chars' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar contraseña',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (v) => v != _passwordController.text ? 'No coincide' : null,
              ),
              const SizedBox(height: 18),
              FilledButton(
                onPressed: _submitting ? null : _onSubmit,
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _submitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(
                      'Registrar', style: TextStyle(
                        color: colorScheme.onPrimary
                        )
                      ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.push('/login_screen'),
                child: const Text('¿Ya tienes cuenta? Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}





// -----------------------------------------------------------------------------

// // Hasta 22/10/2025




// // import 'package:flutter/material.dart';

// // class RegisterScreen extends StatelessWidget {
// //   RegisterScreen({super.key});

// //   // final TextEditingController _userNameController = TextEditingController();

// //   @override
// //   Widget build(BuildContext context) {
// //     return _RegisterView();
// //   }
// // }

// // class _RegisterView extends StatelessWidget {
// //   _RegisterView({
// //     super.key,
// //   });

// //   final TextEditingController _userNameController = TextEditingController();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Row(
// //           children: [
// //             Image.asset(
// //               'assets/images/cr_logo.jpg',
// //               width: 40,
// //               height: 40,
// //             ),
// //             const SizedBox(width: 8),
// //             const Text('Car Rent'),
// //           ],
// //         ),
// //         backgroundColor: Colors.blue,
// //         foregroundColor: Colors.white,
// //         actions: [
// //           IconButton(
// //             onPressed: () {
// //               // TODO: Agregar funcionalidad del ícono de auto
// //             },
// //             icon: const Icon(Icons.directions_car),
// //             tooltip: 'Car Rent',
// //           ),
// //         ],
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             const Text(
// //               '-----   Ingresar datos   -----',
// //               style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
// //             ),
// //             const SizedBox(height: 30),

// //             TextField(
// //               controller: _userNameController,
// //             ),

            






// //             TextButton(
// //               onPressed: () {},
// //               child: const Text('Registrar'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }



// // ---------------------------------------------------------------------------



// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:app_car_rental/presentation/providers/usersProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:app_car_rental/domain/user.dart';
// import 'package:app_car_rental/data/user_repository.dart';


// // class RegisterScreen extends StatefulWidget {
// class RegisterScreen extends ConsumerStatefulWidget {
//   const RegisterScreen({super.key});


// @override
//   _RegisterScreenState build(BuildContext context, ref) {
//     return _RegisterScreenState();
//   }
  
//   @override
//   ConsumerState<RegisterScreen> createState() {
//     return _RegisterScreenState();
//   }

  

//   // @override
//   // State<RegisterScreen> createState() => _RegisterScreenState();
  
//   // @override
//   // Widget build(BuildContext context, WidgetRef ref) {
//   //   // TODO: implement build
//   //   throw UnimplementedError();
//   // }
// }

// class _RegisterScreenState extends ConsumerState<RegisterScreen>{
//   @override
//  void initState() {
//   super.initState();
//   ref.read(UsersNotifierProvider.notifier).getAllUsers();
//  }
 
//   @override
//   Widget build(BuildContext context) {
//     List<User> users = ref.watch(UsersNotifierProvider);
//   //   return RegisterScreen();
//   // }

// // class _RegisterScreenState extends State<RegisterScreen> {
//   // Controladores para los campos
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _documenttController = TextEditingController();
//   // final TextEditingController _passportController = TextEditingController();
//   final TextEditingController _countryController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();

//   // Simple lista simulando base de datos
//   // final List<Map<String, String>> _registeredUsers = [];

//   final _formKey = GlobalKey<FormState>();
//   String? _errorMessage;

//   void _registerUser() {
//     if (_formKey.currentState!.validate()) {
//       final name = _usernameController.text.trim();
//       final email = _emailController.text.trim();
//       // final passport = _passportController.text.trim();
//       final document = _documenttController.text.trim();
//       final country = _countryController.text.trim();
//       final password = _passwordController.text.trim();

//       // // Verificar si el usuario ya existe
//       // final existingUser = _registeredUsers.any((user) => user['email'] == email);
//       // if (existingUser) {
//       //   setState(() {
//       //     _errorMessage = "Ya existe un usuario registrado con este email.";
//       //   });
//       //   return;
//       // }

//       // // Guardar nuevo usuario
//       // _registeredUsers.add({
//       //   'username': username,
//       //   'email': email,
//       //   'passport': email,
//       //   'country': email,
//       //   'password': password,
//       // });


//     if (UserRepository.existsByEmail(email)) {
//       setState(() {
//           _errorMessage = "Ya existe un usuario registrado con este email.";
//       });
//         return;
//     }

//     final newUser = User(
//       userName: name,
//       userEmail: email,
//       password: password,
//       // passport: passport,
//       document: document,
//       country: country,
//     );

//     UserRepository.addUser(newUser);

//     ref.read(UsersNotifierProvider.notifier).addUser;


//       setState(() {
//         _errorMessage = null;
//       });

//       // Navegar al login
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Registro exitoso. Inicia sesión.")),
//       );

//       context.push('/login_screen');
//       // context.pop('/login_screen');  // 👈 vuelve al login sin recrearlo
//     }
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     // _emailController.dispose();
//     _emailController.dispose();
//     // _passportController.dispose();
//     _documenttController.dispose();
//     _countryController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   @override
//   // Widget build(BuildContext context) {

//     final colorScheme = Theme.of(context).colorScheme; // último 20/10

//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text("Registro de Usuario"),
//       //   backgroundColor: Colors.blue,
//       //   foregroundColor: Colors.white,
//       // ),

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

//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               TextFormField(
//                 controller: _usernameController,
//                 decoration: const InputDecoration(
//                   labelText: "Nombre de usuario",
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? "Ingrese su nombre" : null,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _emailController,
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   border: OutlineInputBorder(),
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) return "Ingrese su email";
//                   if (!value.contains('@')) return "Email inválido";
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),

//               TextFormField(
//                 // controller: _passportController,
//                 controller: _documenttController,
//                 decoration: const InputDecoration(
//                   labelText: "Número de documento",
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? "Ingrese su número de documento" : null,
//               ),

//               const SizedBox(height: 16),

//               TextFormField(
//                 controller: _countryController,
//                 decoration: const InputDecoration(
//                   labelText: "País",
//                   border: OutlineInputBorder(),
//                 ),
//                 validator: (value) =>
//                     value == null || value.isEmpty ? "Ingrese país" : null,
//               ),


//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _passwordController,
//                 decoration: const InputDecoration(
//                   labelText: "Contraseña",
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//                 validator: (value) =>
//                     value == null || value.length < 3
//                         ? "La contraseña debe tener al menos 3 caracteres"
//                         : null,
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _confirmPasswordController,
//                 decoration: const InputDecoration(
//                   labelText: "Confirmar contraseña",
//                   border: OutlineInputBorder(),
//                 ),
//                 obscureText: true,
//                 validator: (value) =>
//                     value != _passwordController.text
//                         ? "Las contraseñas no coinciden"
//                         : null,
//               ),
//               const SizedBox(height: 20),

//               // ElevatedButton(
//               //   onPressed: _registerUser,
//               //   style: ElevatedButton.styleFrom(
//               //     backgroundColor: Colors.blue,
//               //     padding: const EdgeInsets.symmetric(vertical: 16),
//               //   ),
//               //   child: const Text(
//               //     "Registrar",
//               //     style: TextStyle(fontSize: 18, color: Colors.white),
//               //   ),
//               // ),

//               // último 20/10
//               FilledButton.icon(
//                     // onPressed: () => context.push('/login_screen'),
//                 onPressed: () {
//                   _registerUser;
//                   context.push('/login_screen');
//                 },
//                       // icon: const Icon(
//                       //   Icons.directions_car,
//                         // size: 45,
//                       //),
//                 label: Text(
//                   'Registrar',
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   color: Theme.of(context).colorScheme.onPrimary,
//                   ),
//                 ),
//                 style: FilledButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                   shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(999), // botón tipo píldora
//                   ),
//                   backgroundColor: Theme.of(context).colorScheme.primary, // usa color del theme
//                 ),
//               ),


//               if (_errorMessage != null) ...[
//               const SizedBox(height: 10),
//               Text(
//                 _errorMessage!,
//                 style: const TextStyle(color: Colors.red),
//                 textAlign: TextAlign.center,
//               ),
//               ],
//               const SizedBox(height: 16),
//               TextButton(
//                 onPressed: () => context.push('/login_screen'),
//                 //onPressed: () => context.pop('/login_screen'),   // 👈 vuelve al login sin recrearlo
//                 child: const Text("¿Ya tienes cuenta? Iniciar sesión"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// // ----------------------------------------------------------------------

// // import 'package:flutter/material.dart';
// // import 'package:go_router/go_router.dart';

// // class RegisterScreen extends StatefulWidget {
// //   const RegisterScreen({super.key});

// //   @override
// //   State<RegisterScreen> createState() => _RegisterScreenState();
// // }

// // class _RegisterScreenState extends State<RegisterScreen> {
// //   final TextEditingController _usernameController = TextEditingController();
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _passportController = TextEditingController();
// //   final TextEditingController _countryController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();
// //   final TextEditingController _confirmPasswordController = TextEditingController();

// //   static final List<Map<String, String>> _registeredUsers = [];

// //   final _formKey = GlobalKey<FormState>();
// //   String? _errorMessage;

// //   void _registerUser() {
// //     if (_formKey.currentState!.validate()) {
// //       final email = _emailController.text.trim();

// //       final exists = _registeredUsers.any((u) => u['email'] == email);
// //       if (exists) {
// //         setState(() => _errorMessage = 'Ya existe un usuario con ese email');
// //         return;
// //       }

// //       _registeredUsers.add({
// //         'username': _usernameController.text.trim(),
// //         'email': _emailController.text.trim(),
// //         'passport': _passportController.text.trim(),
// //         'country': _countryController.text.trim(),
// //         'password': _passwordController.text.trim(),
// //       });

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text('Registro exitoso')),
// //       );

// //       context.pop(); // 👈 Vuelve al login sin recrearlo
// //     }
// //   }

// //   @override
// //   void dispose() {
// //     _usernameController.dispose();
// //     _emailController.dispose();
// //     _passportController.dispose();
// //     _countryController.dispose();
// //     _passwordController.dispose();
// //     _confirmPasswordController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Registrar Usuario'),
// //         backgroundColor: Colors.blue,
// //         foregroundColor: Colors.white,
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20),
// //         child: Form(
// //           key: _formKey,
// //           child: ListView(
// //             children: [
// //               TextFormField(
// //                 controller: _usernameController,
// //                 decoration: const InputDecoration(labelText: 'Nombre de usuario', border: OutlineInputBorder()),
// //                 validator: (v) => v == null || v.isEmpty ? 'Ingrese su nombre' : null,
// //               ),
// //               const SizedBox(height: 16),
// //               TextFormField(
// //                 controller: _emailController,
// //                 decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
// //                 validator: (v) => v == null || !v.contains('@') ? 'Email inválido' : null,
// //               ),
// //               const SizedBox(height: 16),
// //               TextFormField(
// //                 controller: _passportController,
// //                 decoration: const InputDecoration(labelText: 'Pasaporte', border: OutlineInputBorder()),
// //                 validator: (v) => v == null || v.isEmpty ? 'Ingrese pasaporte' : null,
// //               ),
// //               const SizedBox(height: 16),
// //               TextFormField(
// //                 controller: _countryController,
// //                 decoration: const InputDecoration(labelText: 'País', border: OutlineInputBorder()),
// //                 validator: (v) => v == null || v.isEmpty ? 'Ingrese país' : null,
// //               ),
// //               const SizedBox(height: 16),
// //               TextFormField(
// //                 controller: _passwordController,
// //                 obscureText: true,
// //                 decoration: const InputDecoration(labelText: 'Contraseña', border: OutlineInputBorder()),
// //                 validator: (v) => v == null || v.length < 6 ? 'Mínimo 6 caracteres' : null,
// //               ),
// //               const SizedBox(height: 16),
// //               TextFormField(
// //                 controller: _confirmPasswordController,
// //                 obscureText: true,
// //                 decoration: const InputDecoration(labelText: 'Confirmar contraseña', border: OutlineInputBorder()),
// //                 validator: (v) => v != _passwordController.text ? 'No coincide' : null,
// //               ),
// //               const SizedBox(height: 20),
// //               ElevatedButton(
// //                 onPressed: _registerUser,
// //                 style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
// //                 child: const Text('Registrar', style: TextStyle(color: Colors.white)),
// //               ),
// //               if (_errorMessage != null)
// //                 Padding(
// //                   padding: const EdgeInsets.only(top: 10),
// //                   child: Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
// //                 ),
// //               TextButton(
// //                 onPressed: () => context.pop(), // 👈 vuelve al login sin recrearlo
// //                 child: const Text('¿Ya tienes cuenta? Iniciar sesión'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

