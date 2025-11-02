// // import 'package:app_car_rental/data/car_repository.dart';
// import 'package:app_car_rental/domain/car.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/legacy.dart';

// final carsNotifierProvider = StateNotifierProvider<CarsNotifier, List<Car>>((ref) {
//   return CarsNotifier();
// });

// // class CarsNotifier extends StateNotifier<List<Car>> {
// //   CarsNotifier() : super([])  {
// //     getAllCars();
// //   }

// class CarsNotifier extends StateNotifier<List<Car>> {
//   final db = FirebaseFirestore.instance;

//   CarsNotifier() : super([]);

//   Future<void> addCar(Car car) async {
//     final doc = db.collection('cars').doc(); // genera ID automático
//       try {
//         await doc.set(car.toFirestore());
//         state = [...state, car];
//       } catch (e) {
//         print (e);
//       }
//   }


//   //  {
//     // getAllCars();
//   //}

//   // Future<void> getAllCars() async {
//   //   //final carRepository = CarRepository();
//   //   // final List<Car> carsList;
//   //   // final carsList = CarRepository().getCars();
//   //   final carsList = await CarRepository().getCars();
//   //   state = carsList;
//   // }

//   Future<void> getAllCars() async {
//     //final carRepository = CarRepository();
//     // final List<Car> carsList;
//     // final carsList = CarRepository().getCars();
//      try {
//       // final docs = db.collection('cars').withConverter(
//       final docs = db.collection('cars').withConverter(
//       fromFirestore: Car.fromFirestore,
//       toFirestore: (Car car, _) => car.toFirestore());
      
//       final cars = await docs.get();
//         // state = [...state, ...cars.docs.map((c) => c.data())];
//         // ✅ Reemplaza lista, no acumula
//       state = cars.docs.map((doc) => doc.data()).toList();
//       } catch (e) {
//         print('Error obteniendo autos: $e');
//       }
//   }

// }

