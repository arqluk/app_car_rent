import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/components/item_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_car_rental/presentation/providers/auth_provider.dart';

class CarDetailScreen extends ConsumerWidget {
  final Car car;

  CarDetailScreen({super.key, required this.car});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const CustomAppBar(title: ' Detalles del auto'),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ItemDetailScreen(
              title: 'Grupo: ${car.grupo}',
              subtitle: '${car.marca} ${car.modelo}',
              colorDetail: 'Color: ${car.color}',
              description:
                  '${car.capacidad} personas - ${car.equipaje} maletas',
              subdescription:
                  'Aire: ${car.aire ? "Sí" : "No"} - Automático: ${car.automatico ? "Sí" : "No"}',
              imageUrl: car.imageUrl.isNotEmpty
                  ? car.imageUrl
                  : 'https://blocks.astratic.com/img/general-img-landscape.png',
              precio: car.precio,
            ),
            SizedBox(height: 50),

            // 👇 Botón solo visible si hay un usuario logueado
            authState.when(
              data: (user) {
                if (user != null) {
                  return SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () =>
                          context.push('/add_reservation_screen', extra: car),
                      icon: const Icon(Icons.directions_car),
                      label: Text(
                        'Quiero reservar',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: colorScheme.onPrimary),
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        backgroundColor: colorScheme.primary,
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      Text(
                        'Iniciá sesión para reservar este auto.',
                        textAlign: TextAlign.center,
                        style: textStyle.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => context.push('/login_screen'),
                        style: TextButton.styleFrom(
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                        ),
                        // icon: const Icon(Icons.login),
                        icon: Icon(
                          Icons.login,
                          size:
                              Theme.of(
                                context,
                              ).textTheme.titleMedium!.fontSize! *
                              1.6,
                        ),
                        // label: const Text('Iniciar Sesión'),
                        label: Text(
                          'Iniciar Sesión',
                          style: Theme.of(context).textTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  );
                }
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
          ],
        ),
      ),
    );
  }
}
