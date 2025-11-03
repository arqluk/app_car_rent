// import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/reservationProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReservationsListScreen extends ConsumerWidget {
  // final Car car;
  // final Car? car;
  final String uid;
  // const ReservationScreen({super.key, required this.car});
  const ReservationsListScreen({super.key, required this.uid});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // return _ReservationScreenView(car: car);
//     return _ReservationsListScreenView();
//   }
// }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reservations = ref.watch(reservationProvider(uid));
//   }
// }

return Scaffold(
      appBar: const CustomAppBar(title: 'Mis Reservas'),
      body: reservations.isEmpty
          ? const Center(
              child: Text('No tenés reservas todavía'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reservations.length,
              itemBuilder: (context, index) {
                final r = reservations[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: Icon(
                      Icons.directions_car,
                      color: r.status == 'paid'
                          ? Colors.green
                          : r.status == 'pending'
                              ? Colors.orange
                              : Colors.red,
                    ),
                    title: Text(
                      'Auto: ${r.carId}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text('Desde: ${r.startdate}'),
                        // Text('Hasta: ${r.endDate}'),
                        Text('cantidad de días: ${r.days}'),
                        Text('Estado: ${r.status}'),
                      ],
                    ),
                    trailing: r.status == 'pending'
                        ? ElevatedButton(
                            onPressed: () {
                              // Ir a la pantalla de pago
                              Navigator.pushNamed(
                                context,
                                '/payment_screen',
                                arguments: r,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Pagar'),
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }
}
