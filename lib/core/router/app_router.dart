import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/reservation.dart';
import 'package:app_car_rental/presentation/screens/access_denied_screen.dart';
import 'package:app_car_rental/presentation/screens/add_car_screen.dart';
import 'package:app_car_rental/presentation/screens/admin_screen.dart';
import 'package:app_car_rental/presentation/screens/car_detail_screen.dart';
import 'package:app_car_rental/presentation/screens/payment_summary_screen.dart';
import 'package:app_car_rental/presentation/screens/fleet_screen.dart';
import 'package:app_car_rental/presentation/screens/home_screen.dart';
import 'package:app_car_rental/presentation/screens/login_screen.dart';
import 'package:app_car_rental/presentation/screens/add_payment_screen.dart';
import 'package:app_car_rental/presentation/screens/payments_list_screen.dart';
import 'package:app_car_rental/presentation/screens/profile_screen.dart';
import 'package:app_car_rental/presentation/screens/register_screen.dart';
import 'package:app_car_rental/presentation/screens/add_reservation_screen.dart';
import 'package:app_car_rental/presentation/screens/reservations_list_screen.dart';
import 'package:app_car_rental/presentation/screens/theme_selector_screen.dart';
import 'package:app_car_rental/presentation/screens/users_list_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/home_screen',
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
      path: '/register_screen',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/theme_selector',
      builder: (context, state) => ThemeSelectorScreen(),
    ),
    GoRoute(
      path: '/profile_screen',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(path: '/fleet_screen', builder: (context, state) => FleetScreen()),
    GoRoute(
      path: '/add_car_screen',
      builder: (context, state) => AddCarScreen(),
    ),
    GoRoute(
      path: '/car_detail_screen',
      builder: (context, state) => CarDetailScreen(car: state.extra as Car),
    ),
    GoRoute(
      path: '/add_reservation_screen',
      builder: (context, state) {
        final car = state.extra as Car;
        return AddReservationScreen(car);
      },
    ),
    GoRoute(
      path: '/reservations_list_screen',
      builder: (context, state) => ReservationsListScreen(),
    ),
    GoRoute(
      path: '/add_payment_screen',
      builder: (context, state) {
        final reservation = state.extra as Reservation;
        return AddPaymentScreen(reservation);
      },
    ),
    GoRoute(
      path: '/payments_list_screen',
      builder: (context, state) => PaymentsListScreen(),
    ),
    GoRoute(
      path: '/payment_summary_screen',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return PaymentSummaryScreen(
          car: extras['car'],
          reservation: extras['reservation'],
          payment: extras['payment'],
        );
      },
    ),
    GoRoute(path: '/admin_screen', builder: (context, state) => AdminScreen()),
    GoRoute(
      path: '/access_denied_screen',
      builder: (context, state) => AccessDeniedScreen(),
    ),
    GoRoute(
      path: '/users_list_screen',
      builder: (context, state) => UsersListScreen(),
    ),
  ],
);
