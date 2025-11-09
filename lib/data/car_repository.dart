  // import 'package:app_car_rental/domain/car.dart';

// // import '../domain/user.dart';

// class CarRepository {
//   static final List<Car> _cars = [
//     Car(id: 'NK', grupo: 'Econ', marca: 'Nissan', modelo: 'Kicks', color: 'Blanco', capacidad: 5,
//     equipaje: 3, automatico: false, aire: true, precio: 100, imageUrl: 'https://www.localiza.com/argentina-site/geral/Frota/KICA.png'),

//     Car(id: 'CO', grupo: 'Super', marca: 'Chevrolet', modelo: 'Onix', color: 'Blanco', capacidad: 5,
//     equipaje: 5, automatico: false, aire: false, precio: 500, imageUrl: 'https://www.localiza.com/argentina-site/geral/Frota/ONIS.png'),

//     Car(id: 'FP', grupo: 'Medium', marca: 'Fiat', modelo: 'Pulse', color: 'Rojo', capacidad: 5,
//     equipaje: 4, automatico: true, aire: false, precio: 250, imageUrl: 'https://www.localiza.com/argentina-site/geral/Frota/PLSE.png'),

//     Car(id: 'CS', grupo: 'Super', marca: 'Chevrolet', modelo: 'Spin', color: 'Gris', capacidad: 7,
//     equipaje: 5, automatico: false, aire: true, precio: 500, imageUrl: 'https://www.localiza.com/argentina-site/geral/Frota/SPIN.png'),

//     Car(id: 'EH', grupo: 'Econ', marca: 'Etios', modelo: 'Hatchback', color: 'Blanco', capacidad: 5,
//     equipaje: 3, automatico: false, aire: true, precio: 100, imageUrl: 'https://www.localiza.com/argentina-site/geral/Frota/ETIH.png'),
//     // equipaje: 3, automatico: false, aire: true, precio: 100, imageUrl: ''),

//   ];

//   List<Car> getCars() {Blanco
//     return _cars;
//   }

//   static void addCar(Car car) {
//     _cars.add(car);
//   }

//   static Car? findcar(String carId) {
//     try {
//       return _cars.firstWhere(
//         (c) => c.id == carId,
//       );
//     } catch (_) {
//       return null;
//     }
//   }

//   static bool existsByid(String carId) {
//     return _cars.any((c) => c.id == carId);
//   }
// }
