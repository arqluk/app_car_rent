// import 'package:app_car_rental/domain/car.dart';
import 'package:flutter/material.dart';

class ReservationScreen extends StatelessWidget {
  // final Car car;
  // final Car? car;
  // const ReservationScreen({super.key, required this.car});
  const ReservationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return _ReservationScreenView(car: car);
    return _ReservationScreenView();
  }
}

class _ReservationScreenView extends StatelessWidget {
  const _ReservationScreenView({
    // super.key, required Car car,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
     appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/cr_logo.jpg',
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 8),
            const Text('Car Rent'),
          ],
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Agregar funcionalidad del ícono de auto
            },
            icon: const Icon(Icons.directions_car),
            tooltip: 'Car Rent',
          ),
        ],
      ),
      body: const Center(
        child: Text('Aquí se mostrarán las reservas del usuario'),
      ),
    );
  }
}