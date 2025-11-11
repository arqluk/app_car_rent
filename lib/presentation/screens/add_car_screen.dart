import 'package:app_car_rental/presentation/providers/auth_user_provider.dart';
import 'package:app_car_rental/presentation/screens/access_denied_screen.dart';
import 'package:app_car_rental/presentation/screens/add_car_screen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

        // Si es admin, muestra la pantalla original completa
        return const AddCarScreenView();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (_, __) => const AccessDeniedScreen(),
    );
  }
}
