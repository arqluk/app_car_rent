import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/reservation.dart';
import 'package:app_car_rental/domain/user.dart';
import 'package:app_car_rental/presentation/providers/authProvider.dart';
import 'package:app_car_rental/presentation/screens/access_denied_screen.dart';
import 'package:app_car_rental/presentation/screens/admin_screen.dart';
import 'package:app_car_rental/presentation/screens/car_detail_screen.dart';
import 'package:app_car_rental/presentation/screens/cars_screen.dart';
import 'package:app_car_rental/presentation/screens/fleet_screen.dart';
import 'package:app_car_rental/presentation/screens/home_screen.dart';
import 'package:app_car_rental/presentation/screens/login_screen.dart';
import 'package:app_car_rental/presentation/screens/payment_detail.dart';
import 'package:app_car_rental/presentation/screens/payment_screen.dart';
import 'package:app_car_rental/presentation/screens/payments_screen.dart';
import 'package:app_car_rental/presentation/screens/register_screen.dart';
import 'package:app_car_rental/presentation/screens/reservation_screen.dart';
import 'package:app_car_rental/presentation/screens/reservations_list_screen.dart';
import 'package:app_car_rental/presentation/screens/settings_screen.dart';
import 'package:app_car_rental/presentation/screens/start_session_screen.dart';
import 'package:app_car_rental/presentation/screens/theme_selector_screen.dart';
import 'package:app_car_rental/presentation/screens/user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:app_car_rental/domain/user.dart' as domain;




/// PANTALLA INICIAL AUTOMÁTICA SEGÚN LOGIN Y ROL
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<String?> _getUserRole(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return doc.data()?['role'] as String?;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<fb.User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1️⃣ Si Firebase aún no cargó el estado de sesión:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 2️⃣ Si no hay usuario logueado:
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        final user = snapshot.data!;
        // 3️⃣ Cargar el rol desde Firestore
        return FutureBuilder<String?>(
          future: _getUserRole(user.uid),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final role = roleSnapshot.data;
            if (role == 'admin') {
              return const AdminScreen();
            } else if (role == 'user') {
              return const UserScreen();
            } else {
              return const AccessDeniedScreen();
            }
          },
        );
      },
    );
  }
}






final appRouter = GoRouter(
  // initialLocation: '/home_screen',
  initialLocation: '/',

  // initialLocation: '/fleet_screen',


  // initialLocation: '/start_session_screen',
  routes: [

//     GoRoute(
//   path: '/',
//   builder: (context, state,) {
//     final auth = ref.watch(authProvider);

//     if (auth.isLoading) {
//       return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     }

//     if (auth.user == null) {
//       return const LoginScreen();
//     }

//     final role = auth.userDoc?['role'];
//     if (role == 'admin') return const AdminScreen();
//     return const UserScreen();
//   },
// ),


    GoRoute(
      path: '/',
      builder: (context, state) => const AuthGate(),
    ),



    GoRoute(
      path: '/login_screen',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home_screen',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/start_session_screen',
      builder: (context, state) => const StartSessionScreen(),
    ),
     GoRoute(
      path: '/register_screen',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/theme_selector',
      builder: (context, state) => ThemeSelectorScreen(),
    ),
    // GoRoute(
    //   path: '/perfil_screen',
    //   builder: (context, state) {
    //     final user = state.extra as User;
    //     return PerfilScreen(user: user);
    //   },
    // ),
    GoRoute(
      path: '/settings_screen',
      builder: (context, state) => const SettingsScreen(),
    ),
    // GoRoute(
    //   path: '/cars_screen',
    //   builder: (context, state) => CarsScreen(),
    // ),

      GoRoute(
      path: '/fleet_screen',
      builder: (context, state) => FleetScreen(),
    ),

    GoRoute(
      path: '/car_detail_screen',
      builder: (context, state) => CarDetailScreen(car: state.extra as Car),
    ),
    //   GoRoute(
    //   path: '/reservation_screen',
    //   // builder: (context, state) => ReservationScreen(car: state.extra as Car),
    //   builder: (context, state) => ReservationScreen(carId: '',),
    // ),
    GoRoute(
      path: '/reservation_screen',
      // builder: (context, state) => ReservationScreen(car: state.extra as Car),
      builder: (context, state) {
        // final carId = state.extra as String;
        final car = state.extra as Car;
        // return ReservationScreen(carId: carId,);
        return ReservationScreen(car: car);
      },
    ),
     GoRoute(
      path: '/reservations_list_screen',
      // builder: (context, state) => ReservationScreen(car: state.extra as Car),
      builder: (context, state) {
        final uid = state.extra as String;
        return ReservationsListScreen(uid: uid,);
      },
      
    ),
    GoRoute(
      path: '/payment_screen',
      // builder: (context, state) => ReservationScreen(car: state.extra as Car),
      builder: (context, state) {
        final reservation = state.extra as Reservation;
        return PaymentScreen(reservation: reservation);
      }, 
    ),
    GoRoute(
      path: '/payment_detail_screen',
      // builder: (context, state) => ReservationScreen(car: state.extra as Car),
      builder: (context, state) => PaymentDetailScreen(),
    ),
    GoRoute(
        path: '/payments_screen',
        // builder: (context, state) => ReservationScreen(car: state.extra as Car),
        builder: (context, state) => PaymentsScreen(),
      ),

    GoRoute(
      path: '/admin_screen',
      // builder: (context, state) => ReservationScreen(car: state.extra as Car),
      builder: (context, state) => AdminScreen(),
    ),

     GoRoute(
      path: '/user_screen',
      // builder: (context, state) => ReservationScreen(car: state.extra as Car),
      builder: (context, state) => UserScreen(),
    ),

    GoRoute(
      path: '/access_denied_screen',
      // builder: (context, state) => ReservationScreen(car: state.extra as Car),
      builder: (context, state) => AccessDeniedScreen(),
    ),


    // cuando defines routes con GoRouter builder:
// GoRoute(
//   path: '/admin/*',
//   builder: (context, state) {
//     final auth = ref.read(authProvider);
//     final role = auth.userDoc?['role'];
//     if (role != 'admin') return AccessDeniedScreen();
//     return AdminScreen();
//   },
// ),

GoRoute(
  path: '/admin',
  builder: (context, state) => AdminScreen(),
),






    // GoRoute(
    //   path: '/reservations_screen',
    //   builder: (context, state) {
    //     final car = state.extra;
    //     // Si se pasó un Car, lo usa; si no, lo ignora
    //     return ReservationScreen(car: car is Car ? car : null);
    //   },
    //),

    // GoRoute(
    //   path: '/animal_example_screen',
    //   builder: (context, state) {
    //     final animal = state.extra as Animal;
    //     return AnimalExampleScreen(animal: animal);
    //   },
    // ),
    // GoRoute(
    //   path: '/add_animal_screen',
    //   builder: (context, state)  => const AddAnimalScreen(),
    // ),
    //  GoRoute(
    //   path: '/tutorial',
    //   builder: (context, state)  => const TutorialScreen(),
    // ),
  ],
);