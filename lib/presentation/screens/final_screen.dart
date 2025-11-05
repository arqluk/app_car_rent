// import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/payment.dart';
import 'package:app_car_rental/domain/reservation.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';

class FinalScreen extends StatelessWidget {
  final Car car;
  final Reservation reservation;
  final Payment payment;
  // final Car? car;
  // const ReservationScreen({super.key, required this.car});
  const FinalScreen({super.key, required this.car, required this.reservation, required this.payment});

//   @override
//   Widget build(BuildContext context) {
//     // return _ReservationScreenView(car: car);
//     return _FinalScreenView();
//   }
// }

// class _FinalScreenView extends StatelessWidget {
//   const _FinalScreenView({
//     // super.key, required Car car,
//     super.key,
//   });

  @override
  Widget build(BuildContext context) {
    final user = fb.FirebaseAuth.instance.currentUser;
    return Scaffold(
      //  appBar: AppBar(
      //     title: Row(
      //       children: [
      //         Image.asset(
      //           'assets/images/cr_logo.jpg',
      //           width: 40,
      //           height: 40,
      //         ),
      //         const SizedBox(width: 8),
      //         const Text('Car Rent'),
      //       ],
      //     ),
      //     backgroundColor: Colors.blue,
      //     foregroundColor: Colors.white,
      //     actions: [
      //       IconButton(
      //         onPressed: () {
      //           // TODO: Agregar funcionalidad del ícono de auto
      //         },
      //         icon: const Icon(Icons.directions_car),
      //         tooltip: 'Car Rent',
      //       ),
      //     ],
      //   ),
      appBar: const CustomAppBar(title: 'Car Rent'),

    //   body: const Center(
    //     child: Text('Aquí se mostrará el resumen de la reserva'),
    //   ),
    // );


    body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 10),
            Text(
              '✅ Operación completada con éxito',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 30),

            // --- Datos del usuario ---
            Text(
              '👤 Datos del Usuario',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _infoRow('Nombre', user?.displayName ?? 'No disponible'),
            _infoRow('Email', user?.email ?? 'No disponible'),
            const Divider(height: 30),

            // --- Datos del auto ---
            Text(
              '🚗 Datos del Auto',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _infoRow('Marca', car.marca),
            _infoRow('Modelo', car.modelo),
            _infoRow('Grupo', car.grupo),
            _infoRow('Color', car.color),
            _infoRow('Precio por día', '\$${car.precio.toString()}'),
            _infoRow('Aire acondicionado', car.aire ? 'Sí' : 'No'),
            _infoRow('Automático', car.automatico ? 'Sí' : 'No'),
            const Divider(height: 30),

            // --- Datos de la reserva ---
            Text(
              '📅 Datos de la Reserva',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _infoRow('ID Reserva', reservation.id),
            _infoRow('Estado', reservation.status),
            _infoRow('Método de pago', reservation.paymentMethod),
            _infoRow('Cantidad de días', reservation.days.toString()),
            const Divider(height: 30),

            // --- Datos del pago ---
            Text(
              '💳 Datos del Pago',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _infoRow('ID Pago', payment.id),
            _infoRow('Estado', payment.status),
            // _infoRow('Protección', payment.protection ? 'Sí' : 'No'),
            _infoRow('Protección', payment.protection),
            // _infoRow('Wi-Fi', payment.wifi ? 'Sí' : 'No'),
            _infoRow('Wi-Fi', payment.accesories),
            _infoRow('Monto', '\$${payment.amount}'),
            const Divider(height: 30),

            // --- Botón de finalización ---
            Center(
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                icon: const Icon(Icons.home),
                label: const Text('Volver al inicio'),
                style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  }

  

Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Flexible(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
