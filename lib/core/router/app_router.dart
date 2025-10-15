import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/presentation/screens/car_detail_screen.dart';
import 'package:app_car_rental/presentation/screens/cars_screen.dart';
import 'package:app_car_rental/presentation/screens/home_screen.dart';
import 'package:app_car_rental/presentation/screens/login_screen.dart';
import 'package:app_car_rental/presentation/screens/register_screen.dart';
import 'package:app_car_rental/presentation/screens/reservations_screen.dart';
import 'package:app_car_rental/presentation/screens/settings_screen.dart';
import 'package:app_car_rental/presentation/screens/start_session_screen.dart';
import 'package:app_car_rental/presentation/screens/theme_selector_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/home_screen',
  // initialLocation: '/start_session_screen',
  routes: [
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
      builder: (context, state) => const ThemeSelectorScreen(),
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
    GoRoute(
      path: '/cars_screen',
      builder: (context, state) => CarsScreen(),
    ),
    GoRoute(
      path: '/car_detail_screen',
      builder: (context, state) => CarDetailScreen(car: state.extra as Car),
    ),
     GoRoute(
      path: '/reservations_screen',
      // builder: (context, state) => ReservationScreen(car: state.extra as Car),
      builder: (context, state) => ReservationScreen(),
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