// import 'package:app_car_rental/domain/car.dart';
// import 'package:app_car_rental/domain/user.dart';
// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/auth_user_provider.dart';
// import 'package:app_car_rental/presentation/providers/cars_provider.dart';
// import 'package:app_car_rental/presentation/providers/users_provider.dart';
import 'package:app_car_rental/presentation/screens/access_denied_screen.dart';
import 'package:app_car_rental/presentation/screens/add_car_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

class AddCarScreen extends ConsumerWidget {
  const AddCarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncUserDoc = ref.watch(userDocProvider);

    return asyncUserDoc.when(
      data: (userDoc) {
        if (userDoc?['role'] != 'admin') {
          return const AccessDeniedScreen();
        }

        // ✅ Si es admin, mostramos tu pantalla original completa
        return const AddCarScreenView();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const AccessDeniedScreen(),
    );
  }
}
