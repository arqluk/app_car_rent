// data/fleet_notifier.dart
// import 'package:app_car_rental/domain/car.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../domain/car.dart';

// class FleetNotifier extends StateNotifier<List<Car>> {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   StreamSubscription? _sub;

//   FleetNotifier(): super([]) {
//     _listen();
//   }

//   void _listen() {
//     _sub = _db.collection('cars').snapshots().listen((snap) {
//       final cars = snap.docs.map((d) => Car.fromMap(d.id, d.data())).toList();
//       state = cars;
//     });
//   }

//   Future<void> addCar(Car car) async {
//     await _db.collection('cars').add(car.toMap());
//   }

//   Future<void> removeCar(String id) async {
//     await _db.collection('cars').doc(id).delete();
//   }

//   Future<void> updateCar(Car car) async {
//     await _db.collection('cars').doc(car.id).set(car.toMap());
//   }

//   Future<void> reserveCar(String carId, String uid) async {
//     // atomic: set reservedBy only if null
//     final ref = _db.collection('cars').doc(carId);
//     await _db.runTransaction((tx) async {
//       final snap = await tx.get(ref);
//       final current = snap.data()?['reservedBy'] as String?;
//       if (current != null) throw Exception('Car already reserved');
//       tx.update(ref, {'reservedBy': uid});
//     });
//   }

//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }
// }

// final fleetProvider = StateNotifierProvider<FleetNotifier, List<Car>>((ref) {
//   return FleetNotifier();
// });


// -----------------------------------------------------------------------------------

// import 'package:app_car_rental/data/car_repository.dart';
import 'dart:async';

import 'package:app_car_rental/domain/car.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';

final fleetNotifierProvider = StateNotifierProvider<fleetNotifier, List<Car>>((ref) {
  return fleetNotifier();
});

// class CarsNotifier extends StateNotifier<List<Car>> {
//   CarsNotifier() : super([])  {
//     getAllCars();
//   }

class fleetNotifier extends StateNotifier<List<Car>> {
  final db = FirebaseFirestore.instance;
  StreamSubscription? _sub;
  

  // fleetNotifier() : super([]);
  fleetNotifier() : super([]) {
    _listen();
  }

  void _listen() {
    _sub = db.collection('cars').snapshots().listen((snap) {
      // final cars = snap.docs.map((d) => Car.fromMap(d.id, d.data())).toList();
      final cars = snap.docs.map((d) => Car.fromFirestore(d, null)).toList();

      state = cars;
    });
  }

  Future<void> addCar(Car car) async {
    final doc = db.collection('cars').doc(); // genera ID automático
      try {
        await doc.set(car.toFirestore());
        state = [...state, car];
      } catch (e) {
        print (e);
      }
  }

  Future<void> removeCar(String id) async {
    final doc = db.collection('cars').doc(id); 
      try {
        await doc.delete();
        // state = [...state, car];
      } catch (e) {
        print (e);
      }
  }

  Future<void> updateCarPrice(Car car, int newPrice) async {
    final doc = db.collection('cars').doc(car.id); 
      try {
        await doc.update({"precio": newPrice});
        // state = [...state, car];
      } catch (e) {
        print (e);
      }
  }


  //  {
    // getAllCars();
  //}

  // Future<void> getAllCars() async {
  //   //final carRepository = CarRepository();
  //   // final List<Car> carsList;
  //   // final carsList = CarRepository().getCars();
  //   final carsList = await CarRepository().getCars();
  //   state = carsList;
  // }

  Future<void> getAllCars() async {
    //final carRepository = CarRepository();
    // final List<Car> carsList;
    // final carsList = CarRepository().getCars();
     try {
      // final docs = db.collection('cars').withConverter(
      final docs = db.collection('cars').withConverter(
      fromFirestore: Car.fromFirestore,
      toFirestore: (Car car, _) => car.toFirestore());
      
      final cars = await docs.get();
        // state = [...state, ...cars.docs.map((c) => c.data())];
        // ✅ Reemplaza lista, no acumula
      state = cars.docs.map((doc) => doc.data()).toList();
      } catch (e) {
        print('Error obteniendo autos: $e');
      }
  }

}


