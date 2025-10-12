// import 'package:flutter/material.dart';

// class RegisterScreen extends StatelessWidget {
//   RegisterScreen({super.key});

//   // final TextEditingController _userNameController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return _RegisterView();
//   }
// }

// class _RegisterView extends StatelessWidget {
//   _RegisterView({
//     super.key,
//   });

//   final TextEditingController _userNameController = TextEditingController();

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
//         actions: [
//           IconButton(
//             onPressed: () {
//               // TODO: Agregar funcionalidad del ícono de auto
//             },
//             icon: const Icon(Icons.directions_car),
//             tooltip: 'Car Rent',
//           ),
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               '-----   Ingresar datos   -----',
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
//             ),
//             const SizedBox(height: 30),

//             TextField(
//               controller: _userNameController,
//             ),

            






//             TextButton(
//               onPressed: () {},
//               child: const Text('Registrar'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_car_rental/domain/user.dart';
import 'package:app_car_rental/domain/user_repository.dart';


class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para los campos
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passportController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Simple lista simulando base de datos
  static final List<Map<String, String>> _registeredUsers = [];

  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  void _registerUser() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final passport = _passportController.text.trim();
      final country = _countryController.text.trim();
      final password = _passwordController.text.trim();

      // // Verificar si el usuario ya existe
      // final existingUser = _registeredUsers.any((user) => user['email'] == email);
      // if (existingUser) {
      //   setState(() {
      //     _errorMessage = "Ya existe un usuario registrado con este email.";
      //   });
      //   return;
      // }

      // // Guardar nuevo usuario
      // _registeredUsers.add({
      //   'username': username,
      //   'email': email,
      //   'passport': email,
      //   'country': email,
      //   'password': password,
      // });


      if (UserRepository.existsByEmail(email)) {
  setState(() {
    _errorMessage = "Ya existe un usuario registrado con este email.";
  });
  return;
}

  final newUser = User(
    userEmail: email,
    password: password,
    passport: passport,
    country: country,
  );
  UserRepository.addUser(newUser);


      setState(() {
        _errorMessage = null;
      });

      // Navegar al login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registro exitoso. Ahora inicia sesión.")),
      );

      context.push('/login_screen');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _emailController.dispose();
    _passportController.dispose();
    _countryController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Registro de Usuario"),
      //   backgroundColor: Colors.blue,
      //   foregroundColor: Colors.white,
      // ),

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


      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: "Nombre de usuario",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Ingrese su nombre" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Ingrese su email";
                  if (!value.contains('@')) return "Email inválido";
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _passportController,
                decoration: const InputDecoration(
                  labelText: "Número de pasaporte",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Ingrese su número de pasaporte" : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _countryController,
                decoration: const InputDecoration(
                  labelText: "País",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? "Ingrese país" : null,
              ),





              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Contraseña",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) =>
                    value == null || value.length < 6
                        ? "La contraseña debe tener al menos 6 caracteres"
                        : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: "Confirmar contraseña",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) =>
                    value != _passwordController.text
                        ? "Las contraseñas no coinciden"
                        : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Registrar",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.push('/login_screen'),
                child: const Text("¿Ya tienes cuenta? Iniciar sesión"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
