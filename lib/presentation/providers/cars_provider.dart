import 'package:app_car_rental/domain/car.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';

final CarsNotifierProvider = StateNotifierProvider<CarsNotifier, List<Car>>((
  ref,
) {
  return CarsNotifier();
});

class CarsNotifier extends StateNotifier<List<Car>> {
  final db = FirebaseFirestore.instance;

  CarsNotifier() : super([]);

  Future<String?> addCar(Car car) async {
    final doc = db.collection('cars').doc();
    // final newCar = car.copyWith(id: doc.id);
    car.id = doc.id;
    try {
      await doc.set(car.toFirestore());
      state = [...state, car];
      return null; // éxito
    } catch (e) {
      print('Error al agregar auto: $e');
      return 'Error al agregar auto: $e'; // devolvés el error
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
      // ✅ Reemplaza lista, no acumula
      state = cars.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error obteniendo autos: $e');
    }
  }
}
