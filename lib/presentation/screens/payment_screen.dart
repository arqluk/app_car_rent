// import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/reservation.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  // final Car car;
  // final Car? car;
   final Reservation reservation; 
  // const ReservationScreen({super.key, required this.car});
  const PaymentScreen({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    // return _ReservationScreenView(car: car);
    return _PaymentScreenView(reservation: reservation);
  }
}

class _PaymentScreenView extends StatelessWidget {
  final Reservation reservation; // 👈 se guarda como propiedad
  const _PaymentScreenView({
    // super.key, required Car car,
    super.key,
    required this.reservation, // 👈 se recibe por parámetro
  });

  @override
  Widget build(BuildContext context) {
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

      body: Center(
        child: Text('Procesar pago para la reserva ${reservation.id}'),
      ),
    );
  }
}
