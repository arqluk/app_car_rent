// import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class PaymentsListScreen extends StatelessWidget {
  // final Car car;
  // final Car? car;
  // const ReservationScreen({super.key, required this.car});
  const PaymentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return _ReservationScreenView(car: car);
    return _PaymentsListScreenView();
  }
}

class _PaymentsListScreenView extends StatelessWidget {
  const _PaymentsListScreenView({
    // super.key, required Car car,
    super.key,
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

      body: const Center(
        child: Text('Aquí se mostrarán los pagos realizados'),
      ),
    );
  }
}
