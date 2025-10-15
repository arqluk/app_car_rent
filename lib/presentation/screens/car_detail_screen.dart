import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/presentation/components/item_detail.dart';
import 'package:flutter/material.dart';

class CarDetailScreen extends StatelessWidget {
  final Car car;
  
  CarDetailScreen({super.key, required this.car});
  // final textStyle = Theme.of(context).textTheme;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: ItemDetailScreen(
        title: 'Grupo: ${car.grupo}',
        subtitle: '${car.marca} ${car.modelo}',
        colorDetail: 'Color: ${car.color}',
        description: '${car.capacidad} personas - ${car.equipaje} maletas',
        subdescription: 'Aire: ${car.aire ? "Sí" : "No"} - Automático: ${car.automatico ? "Sí" : "No"}',
        // imageUrl: car.imageUrl,
        imageUrl: car.imageUrl.isNotEmpty ? car.imageUrl : 'https://blocks.astratic.com/img/general-img-landscape.png',
        // precio: 'Precio: ${car.precio} por día',
        precio: car.precio,
      ),
    );
  }
}





// class _CarDetailView extends StatelessWidget {
//   const _CarDetailView({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }