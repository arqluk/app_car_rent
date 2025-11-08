import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/auth_user_provider.dart';
import 'package:app_car_rental/presentation/screens/access_denied_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUserDoc = ref.watch(userDocProvider);

    return asyncUserDoc.when(
      data: (userDoc) {
        if (userDoc?['role'] != 'admin') {
          return const AccessDeniedScreen();
        }
        return const _AdminScreenView();
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const AccessDeniedScreen(),
    );
  }
}

class _AdminScreenView extends StatelessWidget {
  const _AdminScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Car Rent - Admin'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilledButton.icon(
              onPressed: () => context.push('/add_car_screen'),
              icon: const Icon(Icons.add_circle),
              label: const Text("Agregar auto a la flota"),
            ),

            const SizedBox(height: 80),

            FilledButton.icon(
              onPressed: () => context.push('/users_list_screen'),
              icon: const Icon(Icons.people),
              label: const Text("Ver usuarios registrados"),
            ),
          ],
        ),
      ),
    );
  }
}



// ------------------------------------------------------------------------------------------

// // import 'package:app_car_rental/domain/car.dart';
// // import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// // import 'package:app_car_rental/presentation/providers/auth_provider.dart';
// // import 'package:app_car_rental/presentation/screens/access_denied_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:app_car_rental/presentation/providers/auth_user_provider.dart';
// import 'package:app_car_rental/presentation/screens/access_denied_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class AdminScreen extends ConsumerWidget {
//   const AdminScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final asyncUserDoc = ref.watch(userDocProvider);

//     return asyncUserDoc.when(
//       data: (userDoc) {
//         if (userDoc?['role'] != 'admin') {
//           return const AccessDeniedScreen();
//         }
//         return const _AdminScreenView();
//       },
//       loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
//       error: (_, __) => const AccessDeniedScreen(),
//     );
//   }
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


// -------------------------------------------------------------------------------

// import 'package:app_car_rental/domain/car.dart';
// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:app_car_rental/presentation/providers/auth_provider.dart';
// import 'package:app_car_rental/presentation/screens/access_denied_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class AdminScreen extends StatelessWidget {
//   // final Car car;
//   // final Car? car;
//   // const ReservationScreen({super.key, required this.car});
//   const AdminScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // return _ReservationScreenView(car: car);
//     return _AdminScreenView();
//   }
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
