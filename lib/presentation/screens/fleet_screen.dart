// import 'package:app_car_rental/data/car_repository.dart';
// import 'package:app_car_rental/domain/car.dart';
// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:app_car_rental/presentation/providers/carsListProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// // class CarsScreen extends StatelessWidget {
// class CarsScreen extends StatelessWidget {
//   CarsScreen({super.key});
// // final carRepository = CarRepository();

//   @override
//   Widget build(BuildContext context) {
//     return _CarsScreenView();
//   }
// }

// // class _CarsScreenView extends StatelessWidget {
// class _CarsScreenView extends ConsumerWidget {
//   // final carRepository = CarRepository();

//   _CarsScreenView({
//     super.key,
//   });

//   @override
//   // Widget build(BuildContext context) {
//   Widget build(BuildContext context, ref) {

//     List<Car> carsList = ref.watch(carsNotifierProvider);





//     final textStyle = Theme.of(context).textTheme;
//     return  Scaffold(
//       // appBar: AppBar(
//       //   title: Row(
//       //     children: [
//       //       Image.asset(
//       //         'assets/images/cr_logo.jpg',
//       //         width: 40,
//       //         height: 40,
//       //       ),
//       //       const SizedBox(width: 8),
//       //       const Text('Car Rent'),
//       //     ],
//       //   ),
//       //   backgroundColor: Colors.blue,
//       //   foregroundColor: Colors.white,
//       //   actions: [
//       //     IconButton(
//       //       onPressed: () {
//       //         // TODO: Agregar funcionalidad del ícono de auto
//       //       },
//       //       icon: const Icon(Icons.directions_car),
//       //       tooltip: 'Car Rent',
//       //     ),
//       //   ],
//       // ),

//       appBar: const CustomAppBar(title: 'Car Rent'),
//       // body: _CarsListView(carsList: carRepository.getCars(), textStyle: textStyle),
//             // ✅ Cuerpo con texto arriba + lista centrada
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center, // centra verticalmente
//           crossAxisAlignment: CrossAxisAlignment.center, // centra horizontalmente
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   // Text(
//                   //   'Elegí tu vehículo ideal en nuestra flota.\n'
//                   //   'Encontrá autos compactos, SUV o premium al mejor precio.\n'
//                   //   'Hacé clic en cualquier modelo para ver más detalles.',
//                   //   textAlign: TextAlign.center,
//                   //   style: textStyle.bodyLarge?.copyWith(
//                   //     fontSize: 16,
//                   //     color: Colors.black87,
//                   //   ),
//                   // ),
//                   Text(
//                     'Elegí tu vehículo en nuestra flota',
//                     textAlign: TextAlign.center,
//                     style: textStyle.bodyLarge?.copyWith(
//                       fontSize: 20, fontWeight: FontWeight.bold,
//                       // color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   Text(
//                     'Encontrá autos al mejor precio.',
//                     textAlign: TextAlign.center,
//                     style: textStyle.bodyLarge?.copyWith(
//                       fontSize: 18,
//                       // color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 50),
//                   Text(
//                     'Hacé clic en un modelo para ver detalles',
//                     textAlign: TextAlign.center,
//                     style: textStyle.bodyLarge?.copyWith(
//                       fontSize: 16,
//                       // color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // const SizedBox(height: 20),

//             const SizedBox(height: 5),

//             if (carsList.isEmpty)
//             const Expanded(
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             )

//             else




//             // ✅ Lista expandible dentro de la columna
//             Expanded(
//               child: _CarsListView(
//                 // carsList: carRepository.getCars(),
//                 // carsList: ref.watch(carsNotifierProvider),
//                 // carsList: ref.read(carsNotifierProvider),
//                 textStyle: textStyle,
//                 carsList: ref.read(carsNotifierProvider),


//               ),
//             ),




//           ]
//         )
//       )
//     );
//   }
// }

// class _CarsListView extends StatelessWidget {
//   // final carRepository = CarRepository();
//   final List<Car> carsList;
  

//   _CarsListView({
//     super.key,
//     required this.textStyle,
//     required this.carsList,
//   });

//   final TextTheme textStyle;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: carsList.length,
//       itemBuilder: (context, index) {
//         return _CarsItemView(car: carsList[index],);
//     });



//     // return Center(
//     //   child: Column(
//     //     // crossAxisAlignment: CrossAxisAlignment.center,
//     //     mainAxisAlignment: MainAxisAlignment.center,
//     //     children: [
//     //       // Text('Lista de Autos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),),
//     //       Text('Lista de Autos', style: textStyle.titleLarge),
//     //     ],
//     //   ),
//     // );
//   }
// }

// class _CarsItemView extends StatelessWidget {
//   final Car car;
//   _CarsItemView({
//     super.key,
//     required this.car
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         title: Text(car.grupo),
//         subtitle: Text('${car.marca} ${car.modelo}'),
//         leading: ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child:
//           car.imageUrl.isEmpty ? const Icon(Icons.movie, size: 50)
//          : Image.network(car.imageUrl)
//          ),
//         trailing: Icon(Icons.arrow_forward_ios),
//         onTap: () {
//           context.push('/car_detail_screen', extra: car);
//         },
//       ),
//     );
//   }
// }




// // ListTile(
// //         tileColor: Theme.of(context).colorScheme.inversePrimary,
// //         leading:  CircleAvatar(
// //           radius: 20,
// //           backgroundImage: NetworkImage(animal.imageUrl!),
// //           backgroundColor: Colors.transparent,
// //         ),
// //         title: Text('Group: ${animal.group}'),
// //         subtitle: Text('Subgoup: ${animal.subgroup}\nType: ${animal.type}',
// //         softWrap: true,
// //       ),
// //       trailing: Icon(Icons.arrow_forward_ios),
// //         onTap: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //               builder: (_) => AnimalExampleScreen(animal: animal),
// //             ),
// //           );
// //         },
// //       ),



// ------------------------------------------------------------------------------

//2025/10/21 ale14

// import 'package:app_car_rental/data/car_repository.dart';
import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:app_car_rental/presentation/providers/cars_provider.dart';
import 'package:app_car_rental/presentation/providers/fleet_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// class CarsScreen extends StatelessWidget {
class FleetScreen extends ConsumerStatefulWidget {
  FleetScreen({super.key});
// final carRepository = CarRepository();

  Widget build(BuildContext context) {
    return _FleetScreenView();
  }
  
  @override
  ConsumerState<FleetScreen> createState() {
    return _FleetScreenState();
  }
}

class _FleetScreenState extends ConsumerState<FleetScreen>{
  @override
 void initState() {
  super.initState();
  ref.read(fleetNotifierProvider.notifier).getAllCars();
 }
 
  @override
  Widget build(BuildContext context) {
    // List<Car> fleetList = ref.watch(fleetNotifierProvider);
    return _FleetScreenView();
  }
}

// class _CarsScreenView extends StatelessWidget {
class _FleetScreenView extends ConsumerWidget {
  // final carRepository = CarRepository();

  _FleetScreenView({
    super.key,
  });

  @override
  // Widget build(BuildContext context) {
  Widget build(BuildContext context, ref) {

    // List<Car> carsList = ref.watch(carsNotifierProvider);
    final fleetList = ref.watch(fleetNotifierProvider);





    final textStyle = Theme.of(context).textTheme;
    return  Scaffold(
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       Image.asset(
      //         'assets/images/cr_logo.jpg',
      //         width: 40,
      //         height: 40,
      //       ),
      //       const SizedBox(width: 8),
      //       const Text('Car Rent'),
      //     ],
      //   ),
      //   backgroundColor: Colors.blue,
      //   foregroundColor: Colors.white,
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         // TODO: Agregar funcionalidad del ícono de auto
      //       },
      //       icon: const Icon(Icons.directions_car),
      //       tooltip: 'Car Rent',
      //     ),
      //   ],
      // ),

      appBar: const CustomAppBar(title: ' Nuestra Flota'),
      // body: _CarsListView(carsList: carRepository.getCars(), textStyle: textStyle),
            // ✅ Cuerpo con texto arriba + lista centrada
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // centra verticalmente
          crossAxisAlignment: CrossAxisAlignment.center, // centra horizontalmente
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Text(
                  //   'Elegí tu vehículo ideal en nuestra flota.\n'
                  //   'Encontrá autos compactos, SUV o premium al mejor precio.\n'
                  //   'Hacé clic en cualquier modelo para ver más detalles.',
                  //   textAlign: TextAlign.center,
                  //   style: textStyle.bodyLarge?.copyWith(
                  //     fontSize: 16,
                  //     color: Colors.black87,
                  //   ),
                  // ),
                  Text(
                    'Elegí tu auto en nuestra flota',
                    textAlign: TextAlign.center,
                    style: textStyle.bodyLarge?.copyWith(
                      fontSize: 20, fontWeight: FontWeight.bold,
                      // color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Encontrá autos al mejor precio.',
                    textAlign: TextAlign.center,
                    style: textStyle.bodyLarge?.copyWith(
                      fontSize: 18,
                      // color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 50),
                  Text(
                    'Hacé clic en un modelo para ver detalles',
                    textAlign: TextAlign.center,
                    style: textStyle.bodyLarge?.copyWith(
                      fontSize: 16,
                      // color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(height: 20),

            const SizedBox(height: 5),

            if (fleetList.isEmpty)
            const Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )

            else




            // ✅ Lista expandible dentro de la columna
            Expanded(
              child: _FleetListView(
                // carsList: carRepository.getCars(),
                // carsList: ref.watch(carsNotifierProvider),
                // carsList: ref.read(carsNotifierProvider),
                textStyle: textStyle,
                fleetList: ref.read(fleetNotifierProvider),


              ),
            ),




          ]
        )
      ),



    // floatingActionButton: FloatingActionButton(
    //   onPressed: () async {
    //     final newCar = Car (
    //       id: 'NK',
    //       grupo: 'Econ',
    //       marca: 'Nissan',
    //       modelo: 'Kicks',
    //       color: 'Blanco',
    //       capacidad: 5,
    //       equipaje: 3,
    //       automatico: false,
    //       aire: true,
    //       precio: 100,
    //       imageUrl: 'https://www.localiza.com/argentina-site/geral/Frota/KICA.png' 
    //       );
    //       await ref.read(fleetNotifierProvider.notifier).addCar(newCar);
    //   },
    //   child: const Icon(Icons.add),
    //   )
    );
  }
}

class _FleetListView extends StatelessWidget {
  // final carRepository = CarRepository();
  final List<Car> fleetList;
  

  _FleetListView({
    super.key,
    required this.textStyle,
    required this.fleetList,
  });

  final TextTheme textStyle;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: fleetList.length,
      itemBuilder: (context, index) {
        return _FleetItemView(car: fleetList[index],);
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

class _FleetItemView extends StatelessWidget {
  final Car car;
  _FleetItemView({
    super.key,
    required this.car
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(car.grupo),
        subtitle: Text('${car.marca} ${car.modelo}'),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
          car.imageUrl.isEmpty ? const Icon(Icons.movie, size: 50)
         : Image.network(car.imageUrl)
         ),
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

// --------------------------------------------------------------------

// import 'package:app_car_rental/data/car_repository.dart';
// import 'package:app_car_rental/domain/car.dart';
// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:app_car_rental/presentation/providers/carsListProvider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// // class CarsScreen extends StatelessWidget {
// class CarsScreen extends StatelessWidget {
//   CarsScreen({super.key});
// // final carRepository = CarRepository();

//   @override
//   Widget build(BuildContext context) {
//     return _CarsScreenView();
//   }
// }

// // class _CarsScreenView extends StatelessWidget {
// class _CarsScreenView extends ConsumerWidget {
//   // final carRepository = CarRepository();

//   _CarsScreenView({
//     super.key,
//   });

//   @override
//   // Widget build(BuildContext context) {
//   Widget build(BuildContext context, ref) {

//     List<Car> carsList = ref.watch(carsNotifierProvider);





//     final textStyle = Theme.of(context).textTheme;
//     return  Scaffold(
//       // appBar: AppBar(
//       //   title: Row(
//       //     children: [
//       //       Image.asset(
//       //         'assets/images/cr_logo.jpg',
//       //         width: 40,
//       //         height: 40,
//       //       ),
//       //       const SizedBox(width: 8),
//       //       const Text('Car Rent'),
//       //     ],
//       //   ),
//       //   backgroundColor: Colors.blue,
//       //   foregroundColor: Colors.white,
//       //   actions: [
//       //     IconButton(
//       //       onPressed: () {
//       //         // TODO: Agregar funcionalidad del ícono de auto
//       //       },
//       //       icon: const Icon(Icons.directions_car),
//       //       tooltip: 'Car Rent',
//       //     ),
//       //   ],
//       // ),

//       appBar: const CustomAppBar(title: 'Car Rent'),
//       // body: _CarsListView(carsList: carRepository.getCars(), textStyle: textStyle),
//             // ✅ Cuerpo con texto arriba + lista centrada
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center, // centra verticalmente
//           crossAxisAlignment: CrossAxisAlignment.center, // centra horizontalmente
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   // Text(
//                   //   'Elegí tu vehículo ideal en nuestra flota.\n'
//                   //   'Encontrá autos compactos, SUV o premium al mejor precio.\n'
//                   //   'Hacé clic en cualquier modelo para ver más detalles.',
//                   //   textAlign: TextAlign.center,
//                   //   style: textStyle.bodyLarge?.copyWith(
//                   //     fontSize: 16,
//                   //     color: Colors.black87,
//                   //   ),
//                   // ),
//                   Text(
//                     'Elegí tu vehículo en nuestra flota',
//                     textAlign: TextAlign.center,
//                     style: textStyle.bodyLarge?.copyWith(
//                       fontSize: 20, fontWeight: FontWeight.bold,
//                       // color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   Text(
//                     'Encontrá autos al mejor precio.',
//                     textAlign: TextAlign.center,
//                     style: textStyle.bodyLarge?.copyWith(
//                       fontSize: 18,
//                       // color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 50),
//                   Text(
//                     'Hacé clic en un modelo para ver detalles',
//                     textAlign: TextAlign.center,
//                     style: textStyle.bodyLarge?.copyWith(
//                       fontSize: 16,
//                       // color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // const SizedBox(height: 20),

//             const SizedBox(height: 5),

//             if (carsList.isEmpty)
//             const Expanded(
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             )

//             else




//             // ✅ Lista expandible dentro de la columna
//             Expanded(
//               child: _CarsListView(
//                 // carsList: carRepository.getCars(),
//                 // carsList: ref.watch(carsNotifierProvider),
//                 // carsList: ref.read(carsNotifierProvider),
//                 textStyle: textStyle,
//                 carsList: ref.read(carsNotifierProvider),


//               ),
//             ),




//           ]
//         )
//       )
//     );
//   }
// }

// class _CarsListView extends StatelessWidget {
//   // final carRepository = CarRepository();
//   final List<Car> carsList;
  

//   _CarsListView({
//     super.key,
//     required this.textStyle,
//     required this.carsList,
//   });

//   final TextTheme textStyle;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: carsList.length,
//       itemBuilder: (context, index) {
//         return _CarsItemView(car: carsList[index],);
//     });



//     // return Center(
//     //   child: Column(
//     //     // crossAxisAlignment: CrossAxisAlignment.center,
//     //     mainAxisAlignment: MainAxisAlignment.center,
//     //     children: [
//     //       // Text('Lista de Autos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),),
//     //       Text('Lista de Autos', style: textStyle.titleLarge),
//     //     ],
//     //   ),
//     // );
//   }
// }

// class _CarsItemView extends StatelessWidget {
//   final Car car;
//   _CarsItemView({
//     super.key,
//     required this.car
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         title: Text(car.grupo),
//         subtitle: Text('${car.marca} ${car.modelo}'),
//         leading: ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child:
//           car.imageUrl.isEmpty ? const Icon(Icons.movie, size: 50)
//          : Image.network(car.imageUrl)
//          ),
//         trailing: Icon(Icons.arrow_forward_ios),
//         onTap: () {
//           context.push('/car_detail_screen', extra: car);
//         },
//       ),
//     );
//   }
// }




// // ListTile(
// //         tileColor: Theme.of(context).colorScheme.inversePrimary,
// //         leading:  CircleAvatar(
// //           radius: 20,
// //           backgroundImage: NetworkImage(animal.imageUrl!),
// //           backgroundColor: Colors.transparent,
// //         ),
// //         title: Text('Group: ${animal.group}'),
// //         subtitle: Text('Subgoup: ${animal.subgroup}\nType: ${animal.type}',
// //         softWrap: true,
// //       ),
// //       trailing: Icon(Icons.arrow_forward_ios),
// //         onTap: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //               builder: (_) => AnimalExampleScreen(animal: animal),
// //             ),
// //           );
// //         },
// //       ),



// ------------------------------------------------------------------------------

// //2025/10/21 ale14

// // import 'package:app_car_rental/data/car_repository.dart';
// import 'package:app_car_rental/domain/car.dart';
// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:app_car_rental/presentation/providers/cars_provider.dart';
// import 'package:app_car_rental/presentation/providers/fleet_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// // class CarsScreen extends StatelessWidget {
// class FleetScreen extends ConsumerStatefulWidget {
//   FleetScreen({super.key});
// // final carRepository = CarRepository();

//   @override
//   Widget build(BuildContext context) {
//     return _FleetScreenView();
//   }
  
//   @override
//   ConsumerState<FleetScreen> createState() {
//     return _FleetScreenState();
//   }
// }

// class _FleetScreenState extends ConsumerState<FleetScreen>{
//   @override
//  void initState() {
//   super.initState();
//   ref.read(fleetNotifierProvider.notifier).getAllCars();
//  }
 
//   @override
//   Widget build(BuildContext context) {
//     List<Car> fleetList = ref.watch(fleetNotifierProvider);
//     return _FleetScreenView();
//   }
// }











// // class _CarsScreenView extends StatelessWidget {
// class _FleetScreenView extends ConsumerWidget {
//   // final carRepository = CarRepository();












//   _FleetScreenView({
//     super.key,
//   });

//   @override
//   // Widget build(BuildContext context) {
//   Widget build(BuildContext context, ref) {

//     // List<Car> carsList = ref.watch(carsNotifierProvider);
//     final fleetList = ref.watch(fleetNotifierProvider);





//     final textStyle = Theme.of(context).textTheme;
//     return  Scaffold(
//       // appBar: AppBar(
//       //   title: Row(
//       //     children: [
//       //       Image.asset(
//       //         'assets/images/cr_logo.jpg',
//       //         width: 40,
//       //         height: 40,
//       //       ),
//       //       const SizedBox(width: 8),
//       //       const Text('Car Rent'),
//       //     ],
//       //   ),
//       //   backgroundColor: Colors.blue,
//       //   foregroundColor: Colors.white,
//       //   actions: [
//       //     IconButton(
//       //       onPressed: () {
//       //         // TODO: Agregar funcionalidad del ícono de auto
//       //       },
//       //       icon: const Icon(Icons.directions_car),
//       //       tooltip: 'Car Rent',
//       //     ),
//       //   ],
//       // ),

//       appBar: const CustomAppBar(title: ' Nuestra Flota'),
//       // body: _CarsListView(carsList: carRepository.getCars(), textStyle: textStyle),
//             // ✅ Cuerpo con texto arriba + lista centrada
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center, // centra verticalmente
//           crossAxisAlignment: CrossAxisAlignment.center, // centra horizontalmente
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 20),
//                   // Text(
//                   //   'Elegí tu vehículo ideal en nuestra flota.\n'
//                   //   'Encontrá autos compactos, SUV o premium al mejor precio.\n'
//                   //   'Hacé clic en cualquier modelo para ver más detalles.',
//                   //   textAlign: TextAlign.center,
//                   //   style: textStyle.bodyLarge?.copyWith(
//                   //     fontSize: 16,
//                   //     color: Colors.black87,
//                   //   ),
//                   // ),
//                   Text(
//                     'Elegí tu vehículo en nuestra flota',
//                     textAlign: TextAlign.center,
//                     style: textStyle.bodyLarge?.copyWith(
//                       fontSize: 20, fontWeight: FontWeight.bold,
//                       // color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 30),
//                   Text(
//                     'Encontrá autos al mejor precio.',
//                     textAlign: TextAlign.center,
//                     style: textStyle.bodyLarge?.copyWith(
//                       fontSize: 18,
//                       // color: Colors.black87,
//                     ),
//                   ),
//                   const SizedBox(height: 50),
//                   Text(
//                     'Hacé clic en un modelo para ver detalles',
//                     textAlign: TextAlign.center,
//                     style: textStyle.bodyLarge?.copyWith(
//                       fontSize: 16,
//                       // color: Colors.black87,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // const SizedBox(height: 20),

//             const SizedBox(height: 5),

//             if (fleetList.isEmpty)
//             const Expanded(
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             )

//             else




//             // ✅ Lista expandible dentro de la columna
//             Expanded(
//               child: _FleetListView(
//                 // carsList: carRepository.getCars(),
//                 // carsList: ref.watch(carsNotifierProvider),
//                 // carsList: ref.read(carsNotifierProvider),
//                 textStyle: textStyle,
//                 fleetList: ref.read(fleetNotifierProvider),


//               ),
//             ),




//           ]
//         )
//       ),



//     // floatingActionButton: FloatingActionButton(
//     //   onPressed: () async {
//     //     final newCar = Car (
//     //       id: 'NK',
//     //       grupo: 'Econ',
//     //       marca: 'Nissan',
//     //       modelo: 'Kicks',
//     //       color: 'Blanco',
//     //       capacidad: 5,
//     //       equipaje: 3,
//     //       automatico: false,
//     //       aire: true,
//     //       precio: 100,
//     //       imageUrl: 'https://www.localiza.com/argentina-site/geral/Frota/KICA.png' 
//     //       );
//     //       await ref.read(fleetNotifierProvider.notifier).addCar(newCar);
//     //   },
//     //   child: const Icon(Icons.add),
//     //   )
//     );
//   }
// }

// class _FleetListView extends StatelessWidget {
//   // final carRepository = CarRepository();
//   final List<Car> fleetList;
  

//   _FleetListView({
//     super.key,
//     required this.textStyle,
//     required this.fleetList,
//   });

//   final TextTheme textStyle;

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: fleetList.length,
//       itemBuilder: (context, index) {
//         return _FleetItemView(car: fleetList[index],);
//     });




//     // return Center(
//     //   child: Column(
//     //     // crossAxisAlignment: CrossAxisAlignment.center,
//     //     mainAxisAlignment: MainAxisAlignment.center,
//     //     children: [
//     //       // Text('Lista de Autos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),),
//     //       Text('Lista de Autos', style: textStyle.titleLarge),
//     //     ],
//     //   ),
//     // );
//   }
// }

// class _FleetItemView extends StatelessWidget {
//   final Car car;
//   _FleetItemView({
//     super.key,
//     required this.car
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         title: Text(car.grupo),
//         subtitle: Text('${car.marca} ${car.modelo}'),
//         leading: ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child:
//           car.imageUrl.isEmpty ? const Icon(Icons.movie, size: 50)
//          : Image.network(car.imageUrl)
//          ),
//         trailing: Icon(Icons.arrow_forward_ios),
//         onTap: () {
//           context.push('/car_detail_screen', extra: car);
//         },
//       ),
//     );
//   }
// }




// // ListTile(
// //         tileColor: Theme.of(context).colorScheme.inversePrimary,
// //         leading:  CircleAvatar(
// //           radius: 20,
// //           backgroundImage: NetworkImage(animal.imageUrl!),
// //           backgroundColor: Colors.transparent,
// //         ),
// //         title: Text('Group: ${animal.group}'),
// //         subtitle: Text('Subgoup: ${animal.subgroup}\nType: ${animal.type}',
// //         softWrap: true,
// //       ),
// //       trailing: Icon(Icons.arrow_forward_ios),
// //         onTap: () {
// //           Navigator.push(
// //             context,
// //             MaterialPageRoute(
// //               builder: (_) => AnimalExampleScreen(animal: animal),
// //             ),
// //           );
// //         },
// //       ),
