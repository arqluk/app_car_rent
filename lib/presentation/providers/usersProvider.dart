import 'package:app_car_rental/domain/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';

// final UsersNotifierProvider = StateNotifierProvider<UsersNotifier, User>((ref) {
final UsersNotifierProvider = StateNotifierProvider<UsersNotifier, List<User>>((ref) {
  return UsersNotifier();
});

// class CarsNotifier extends StateNotifier<List<Car>> {
//   CarsNotifier() : super([])  {
//     getAllCars();
//   }

// class UsersNotifier extends StateNotifier<User> {
class UsersNotifier extends StateNotifier<List<User>> {
  // final db = FirebaseFirestore.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  UsersNotifier() : super([]);
  // UsersNotifier() : super({} as User);



  

  /// Registra un usuario en Firestore si no existe (por email).
  /// Retorna null si OK, o un String con mensaje de error.
  Future<String?> registerUser(User user) async {
    try {
      // Verificar existencia por email
      final q = await db.collection('users')
        .where('email', isEqualTo: user.userEmail)
        .get();

      if (q.docs.isNotEmpty) {
        return 'Ya existe un usuario con ese email';
      }

      // Construir el map a guardar: usar la representación del modelo
      final Map<String, dynamic> payload = user.toFirestore();

      // Aseguramos los campos solicitados por tu schema
      payload['email'] = user.userEmail;
      payload['password'] = user.password;
      payload['name'] = user.userName;
      payload['document'] = user.document;
      payload['country'] = user.country;
      payload['role'] = payload['role'] ?? 'client';
      payload['createdAt'] = FieldValue.serverTimestamp();

      await db.collection('users').add(payload);

      // Actualizar estado local (opcional, aquí añadimos el user localmente)
      state = [...state, user];

      return null; // success
    } catch (e) {
      return 'Error al registrar usuario: $e';
    }
  }


  











  Future<void> addUser(User user) async {
    final doc = db.collection('users').doc(); // genera ID automático
      try {
        await doc.set(user.toFirestore());
        state = [...state, user];
        // state = user;
      } catch (e) {
        print (e);
      }
  }


  Future<void> getAllUsers() async {
     try {
      // final docs = db.collection('cars').withConverter(
      final doc = db.collection('users').withConverter(
      fromFirestore: User.fromFirestore,
      toFirestore: (User user, _) => user.toFirestore());
      
      final users = await doc.get();
      // final user = docSnap.data();
        // state = [...state, ...cars.docs.map((c) => c.data())];
        // ✅ Reemplaza lista, no acumula
       state = users.docs.map((doc) => doc.data()).toList();
      // state = user as User;
      } catch (e) {
        print('Error obteniendo usuarios: $e');
      }
  }

}

// -----------------------------------------------------------------------------

// Hasta 22/10/2025


// import 'package:app_car_rental/data/car_repository.dart';
// import 'package:app_car_rental/domain/car.dart';
// import 'package:app_car_rental/domain/user.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/legacy.dart';

// // final UsersNotifierProvider = StateNotifierProvider<UsersNotifier, User>((ref) {
// final UsersNotifierProvider = StateNotifierProvider<UsersNotifier, List<User>>((ref) {
//   return UsersNotifier();
// });

// // class CarsNotifier extends StateNotifier<List<Car>> {
// //   CarsNotifier() : super([])  {
// //     getAllCars();
// //   }

// // class UsersNotifier extends StateNotifier<User> {
// class UsersNotifier extends StateNotifier<List<User>> {
//   final db = FirebaseFirestore.instance;

//   UsersNotifier() : super([]);
//   // UsersNotifier() : super({} as User);

//   Future<void> addUser(User user) async {
//     final doc = db.collection('users').doc(); // genera ID automático
//       try {
//         await doc.set(user.toFirestore());
//         state = [...state, user];
//         // state = user;
//       } catch (e) {
//         print (e);
//       }
//   }


//   Future<void> getAllUsers() async {
//      try {
//       // final docs = db.collection('cars').withConverter(
//       final doc = db.collection('users').withConverter(
//       fromFirestore: User.fromFirestore,
//       toFirestore: (User user, _) => user.toFirestore());
      
//       final users = await doc.get();
//       // final user = docSnap.data();
//         // state = [...state, ...cars.docs.map((c) => c.data())];
//         // ✅ Reemplaza lista, no acumula
//        state = users.docs.map((doc) => doc.data()).toList();
//       // state = user as User;
//       } catch (e) {
//         print('Error obteniendo usuarios: $e');
//       }
//   }

// }



