import 'package:app_car_rental/data/car_repository.dart';
import 'package:app_car_rental/domain/car.dart';
import 'package:flutter_riverpod/legacy.dart';

final carsNotifierProvider = StateNotifierProvider<CarsNotifier, List<Car>>((ref) {
  return CarsNotifier();
});

class CarsNotifier extends StateNotifier<List<Car>> {
CarsNotifier() : super([])  {
    getAllCars();
  }

  Future<void> getAllCars() async {
    //final carRepository = CarRepository();
    // final List<Car> carsList;
    // final carsList = CarRepository().getCars();
    final carsList = CarRepository().getCars();
    state = carsList;
  }

}