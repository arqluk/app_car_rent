import 'package:app_car_rental/data/car_repository.dart';
import 'package:app_car_rental/domain/car.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CarsScreen extends StatelessWidget {
  CarsScreen({super.key});
// final carRepository = CarRepository();
  

  @override
  Widget build(BuildContext context) {
    return _CarsScreenView();
  }
}

class _CarsScreenView extends StatelessWidget {
  final carRepository = CarRepository();
  _CarsScreenView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
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
      body: _CarsListView(carsList: carRepository.getCars(), textStyle: textStyle),
    );
  }
}

class _CarsListView extends StatelessWidget {
  // final carRepository = CarRepository();
  final List<Car> carsList;

  _CarsListView({
    super.key,
    required this.textStyle,
    required this.carsList,
  });

  final TextTheme textStyle;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: carsList.length,
      itemBuilder: (context, index) {
        return _CarsItemView(car: carsList[index],);
    });



    // return Center(
    //   child: Column(
    //     // crossAxisAlignment: CrossAxisAlignment.center,
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       // Text('Lista de Autos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),),
    //       Text('Lista de Autos', style: textStyle.titleLarge),
    //     ],
    //   ),
    // );
  }
}

class _CarsItemView extends StatelessWidget {
  final Car car;
  _CarsItemView({
    super.key,
    required this.car
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(car.grupo),
        subtitle: Text('${car.marca} ${car.modelo}'),
        leading: Image.network(car.imageUrl),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          context.push('/car_detail_screen', extra: car);
        },
      ),
    );
  }
}




// ListTile(
//         tileColor: Theme.of(context).colorScheme.inversePrimary,
//         leading:  CircleAvatar(
//           radius: 20,
//           backgroundImage: NetworkImage(animal.imageUrl!),
//           backgroundColor: Colors.transparent,
//         ),
//         title: Text('Group: ${animal.group}'),
//         subtitle: Text('Subgoup: ${animal.subgroup}\nType: ${animal.type}',
//         softWrap: true,
//       ),
//       trailing: Icon(Icons.arrow_forward_ios),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => AnimalExampleScreen(animal: animal),
//             ),
//           );
//         },
//       ),