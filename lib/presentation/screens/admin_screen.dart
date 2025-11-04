// // import 'package:app_car_rental/domain/car.dart';
// // import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// // import 'package:app_car_rental/presentation/providers/auth_provider.dart';
// // import 'package:app_car_rental/presentation/screens/access_denied_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// // class AdminScreen extends StatelessWidget {
// //   // final Car car;
// //   // final Car? car;
// //   // const ReservationScreen({super.key, required this.car});
// //   const AdminScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     // return _ReservationScreenView(car: car);
// //     return _AdminScreenView();
// //   }
// // }

// // class _AdminScreenView extends StatelessWidget {
// //   const _AdminScreenView({
// //     // super.key, required Car car,
// //     super.key,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       //  appBar: AppBar(
// //       //     title: Row(
// //       //       children: [
// //       //         Image.asset(
// //       //           'assets/images/cr_logo.jpg',
// //       //           width: 40,
// //       //           height: 40,
// //       //         ),
// //       //         const SizedBox(width: 8),
// //       //         const Text('Car Rent'),
// //       //       ],
// //       //     ),
// //       //     backgroundColor: Colors.blue,
// //       //     foregroundColor: Colors.white,
// //       //     actions: [
// //       //       IconButton(
// //       //         onPressed: () {
// //       //           // TODO: Agregar funcionalidad del ícono de auto
// //       //         },
// //       //         icon: const Icon(Icons.directions_car),
// //       //         tooltip: 'Car Rent',
// //       //       ),
// //       //     ],
// //       //   ),
// //       appBar: const CustomAppBar(title: 'Car Rent'),

// //       body: const Center(
// //         child: Text('Aquí se mostrará la pantalla de administrador'),
// //       ),
// //     );
// //   }
// // }


// // -------------------------------------------------------------------------------


// // import 'package:app_car_rental/domain/car.dart';
// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:app_car_rental/presentation/providers/auth_provider.dart';
// import 'package:app_car_rental/presentation/screens/access_denied_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class AdminScreen extends ConsumerWidget {
//   // final Car car;
//   // final Car? car;
//   // const ReservationScreen({super.key, required this.car});
//   const AdminScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final auth = ref.watch(authProvider);
//     final role = auth.userDoc?['role'];

//     if (role != 'admin') {
//       return const AccessDeniedScreen();
//     }

//     return _AdminScreenView();
//     }
// }

// class _AdminScreenView extends StatelessWidget {
//   const _AdminScreenView({
//     // super.key, required Car car,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //  appBar: AppBar(
//       //     title: Row(
//       //       children: [
//       //         Image.asset(
//       //           'assets/images/cr_logo.jpg',
//       //           width: 40,
//       //           height: 40,
//       //         ),
//       //         const SizedBox(width: 8),
//       //         const Text('Car Rent'),
//       //       ],
//       //     ),
//       //     backgroundColor: Colors.blue,
//       //     foregroundColor: Colors.white,
//       //     actions: [
//       //       IconButton(
//       //         onPressed: () {
//       //           // TODO: Agregar funcionalidad del ícono de auto
//       //         },
//       //         icon: const Icon(Icons.directions_car),
//       //         tooltip: 'Car Rent',
//       //       ),
//       //     ],
//       //   ),
//       appBar: const CustomAppBar(title: 'Car Rent'),

//       body: const Center(
//         child: Text('Aquí se mostrará la pantalla de administrador'),
//       ),
//     );
//   }
// }


// // -------------------------------------------------------------------------------

// // class AdminScreen extends ConsumerWidget {
// //   const AdminScreen({super.key});

// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final auth = ref.watch(authProvider);
// //     final role = auth.userDoc?['role'];

// //     if (role != 'admin') {
// //       return const AccessDeniedScreen();
// //     }

// //     return Scaffold(
// //       appBar: AppBar(title: const Text('Panel de Administración')),
// //       body: const Center(child: Text('Bienvenido, administrador')),
// //     );
// //   }
// // }
