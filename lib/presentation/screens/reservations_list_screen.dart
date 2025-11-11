import 'package:app_car_rental/domain/reservation.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/reservations_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReservationsListScreen extends ConsumerStatefulWidget {
  const ReservationsListScreen({super.key});

  Widget build(BuildContext context) {
    return _ReservationsListScreenView();
  }

  @override
  ConsumerState<ReservationsListScreen> createState() {
    return ReservationsListScreenState();
  }
}

class ReservationsListScreenState
    extends ConsumerState<ReservationsListScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final currentUser = fb.FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        ref
            .read(ReservationNotifierProvider.notifier)
            .getReservationsByUser(currentUser.uid, ref);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ReservationsListScreenView();
  }
}

class _ReservationsListScreenView extends ConsumerWidget {
  _ReservationsListScreenView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = fb.FirebaseAuth.instance.currentUser;
    final reservationList = ref.watch(ReservationNotifierProvider);
    bool loading = ref.watch(ReservationLoadingProvider);

    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: const CustomAppBar(title: ' Tus reservas'),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: currentUser == null
              // Caso SIN usuario logueado
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Iniciá sesión para ver tus reservas.',
                      textAlign: TextAlign.center,
                      style: textStyle.bodyLarge?.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton.icon(
                      onPressed: () => context.push('/login_screen'),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      icon: Icon(
                        Icons.login,
                        size:
                            Theme.of(context).textTheme.titleMedium!.fontSize! *
                            1.6,
                      ),
                      label: Text(
                        'Iniciar Sesión',
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )
              // Caso CON usuario logueado
              : loading
              ? const CircularProgressIndicator()
              : reservationList.isEmpty
              ? Center(
                  child: Text(
                    "No tenés reservas registradas",
                    style: textStyle.bodyLarge,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tus reservas',
                      style: textStyle.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: reservationList.length,
                        itemBuilder: (context, index) {
                          final reservation = reservationList[index];
                          return _ReservationItemView(reservation: reservation);
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ReservationItemView extends StatelessWidget {
  final Reservation reservation;

  const _ReservationItemView({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        title: Text(
          'Reserva #${reservation.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Auto: ${reservation.carId}\nCantidad de días: ${reservation.days}',
        ),
      ),
    );
  }
}
