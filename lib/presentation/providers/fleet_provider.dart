import 'dart:async';
import 'package:app_car_rental/domain/car.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';

final fleetNotifierProvider = StateNotifierProvider<fleetNotifier, List<Car>>((
  ref,
) {
  return fleetNotifier();
});

class fleetNotifier extends StateNotifier<List<Car>> {
  final db = FirebaseFirestore.instance;

  fleetNotifier() : super([]) {
    _listen();
  }

  void _listen() {
    db.collection('cars').snapshots().listen((snap) {
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
      print(e);
    }
  }

  Future<void> removeCar(String id) async {
    final doc = db.collection('cars').doc(id);
    try {
      await doc.delete();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateCarPrice(Car car, int newPrice) async {
    final doc = db.collection('cars').doc(car.id);
    try {
      await doc.update({"precio": newPrice});
    } catch (e) {
      print(e);
    }
  }

  Future<void> getAllCars() async {
    try {
      final docs = db
          .collection('cars')
          .withConverter(
            fromFirestore: Car.fromFirestore,
            toFirestore: (Car car, _) => car.toFirestore(),
          );

      final cars = await docs.get();

      // Reemplaza lista, no acumula
      state = cars.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error obteniendo autos: $e');
    }
  }
}
