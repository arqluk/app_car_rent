import 'package:app_car_rental/domain/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
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
  final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;

  UsersNotifier() : super([]);
  // UsersNotifier() : super({} as User);



  

  /// Registra el usuario en Firebase Auth y luego en Firestore.
  /// Retorna `null` si todo fue bien o un mensaje de error si algo falló.
  Future<String?> registerUser(User user) async {
    try {
      // Crear cuenta en Firebase Auth
      final credential = await auth.createUserWithEmailAndPassword(
        email: user.userEmail,
        password: user.password,
      );

      final uid = credential.user?.uid;
      if (uid == null) {
        return 'Error interno: UID no generado';
      }

      // Crear documento en Firestore
      final userWithUid = User(
        uid: uid,
        userName: user.userName,
        userEmail: user.userEmail,
        password: user.password,
        country: user.country,
        document: user.document,
        role: user.role,
      );

      await db.collection('users').doc(uid).set(userWithUid.toFirestore());


      state = [...state, userWithUid];
        return null;
      } on fb.FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          return 'Ya existe una cuenta con ese correo';
        } else if (e.code == 'weak-password') {
          return 'La contraseña es demasiado débil';
        } else {
          return 'Error de autenticación: ${e.message}';
        }
      } catch (e) {
        return 'Error al registrar usuario: $e';
      }
    }



  /// Loguea un usuario y devuelve la instancia si el login fue exitoso.
  Future<User?> loginUser(String email, String password) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = credential.user?.uid;
      if (uid == null) return null;

      final doc = await db.collection('users').doc(uid).get();
      if (!doc.exists) return null;

      return User.fromFirestore(doc, null);
    } catch (e) {
      print('loginUser error: $e');
      return null;
    }
  }
// }


  /// Carga todos los usuarios desde Firestore y actualiza el state.
  Future<void> getAllUsers() async {
    try {
      final querySnapshot = await db.collection('users').get();

      final users = querySnapshot.docs.map((doc) {
        return User.fromFirestore(doc, null);
      }).toList();

      state = users;
    } catch (e) {
      print('Error al obtener los usuarios: $e');
    }
  }
}












  // Future<void> addUser(User user) async {
  //   final doc = db.collection('users').doc(); // genera ID automático
  //     try {
  //       await doc.set(user.toFirestore());
  //       state = [...state, user];
  //       // state = user;
  //     } catch (e) {
  //       print (e);
  //     }
  // }


  // Future<void> getAllUsers() async {
  //    try {
  //     // final docs = db.collection('cars').withConverter(
  //     final doc = db.collection('users').withConverter(
  //     fromFirestore: User.fromFirestore,
  //     toFirestore: (User user, _) => user.toFirestore());
      
  //     final users = await doc.get();
  //     // final user = docSnap.data();
  //       // state = [...state, ...cars.docs.map((c) => c.data())];
  //       // ✅ Reemplaza lista, no acumula
  //      state = users.docs.map((doc) => doc.data()).toList();
  //     // state = user as User;
  //     } catch (e) {
  //       print('Error obteniendo usuarios: $e');
  //     }


//}


// --------------------------------------------------------------------------------------------

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
//   // final db = FirebaseFirestore.instance;
//   final FirebaseFirestore db = FirebaseFirestore.instance;

//   UsersNotifier() : super([]);
//   // UsersNotifier() : super({} as User);



  

//   /// Registra un usuario en Firestore si no existe (por email).
//   /// Retorna null si OK, o un String con mensaje de error.
//   Future<String?> registerUser(User user) async {
//     try {
//       // Verificar existencia por email
//       final q = await db.collection('users')
//         .where('email', isEqualTo: user.userEmail)
//         .get();

//       if (q.docs.isNotEmpty) {
//         return 'Ya existe un usuario con ese email';
//       }

//       // Construir el map a guardar: usar la representación del modelo
//       final Map<String, dynamic> payload = user.toFirestore();

//       // Aseguramos los campos solicitados por tu schema
//       payload['email'] = user.userEmail;
//       payload['password'] = user.password;
//       payload['name'] = user.userName;
//       payload['document'] = user.document;
//       payload['country'] = user.country;
//       payload['role'] = payload['role'] ?? 'client';
//       payload['createdAt'] = FieldValue.serverTimestamp();

//       await db.collection('users').add(payload);








//       // Actualizar estado local (opcional, aquí añadimos el user localmente)
//       state = [...state, user];

//       return null; // success
//     } catch (e) {
//       return 'Error al registrar usuario: $e';
//     }
//   }



//   /// Intenta loguear con email+password.
//   /// Retorna el User si coincide, o null si no existe / no coincide.
//   Future<User?> loginUser(String email, String password) async {
//     try {
//       final q = await db.collection('users')
//           .where('email', isEqualTo: email)
//           .where('password', isEqualTo: password)
//           .limit(1)
//           .get();

//       if (q.docs.isEmpty) return null;

//       final data = q.docs.first.data();
//       // Crear instancia User a partir del map (ajustamos nombres de campos)
//       final user = User(
//         userName: (data['name'] as String?) ?? (data['userName'] as String?) ?? '',
//         userEmail: (data['email'] as String?) ?? (data['userEmail'] as String?) ?? '',
//         role: (data['role'] as String?) ?? (data['role'] as String?) ?? '',
//         password: (data['password'] as String?) ?? '',
//         // passport: (data['passport'] as String?) ?? '',
//         document: (data['document'] as String?) ?? '',
//         country: (data['country'] as String?) ?? '',
//       );

//       // Podés actualizar el state si querés mantener usuarios en memoria
//       // state = [...state.where((u) => u.userEmail != user.userEmail), user];

//       return user;
//     } catch (e) {
//       print('loginUser error: $e');
//       return null;
//     }
//   }

//   /// Opcional: carga todos los usuarios desde Firestore a state
//   Future<void> getAllUsers() async {
//     try {
//       final col = db.collection('users').withConverter<Map<String, dynamic>>(
//         fromFirestore: (snap, _) => snap.data()!,
//         toFirestore: (map, _) => map,
//       );

//       final snapshot = await col.get();
//       final loaded = snapshot.docs.map((d) {
//         final data = d.data();
//         return User(
//           userName: data['name'] ?? data['userName'] ?? '',
//           userEmail: data['email'] ?? data['userEmail'] ?? '',
//           role: data['role'] ?? data['role'] ?? '',
//           password: data['password'] ?? '',
//           // passport: data['passport'] ?? '',
//           document: data['document'] ?? '',
//           country: data['country'] ?? '',
//         );
//       }).toList();

//       state = loaded;
//     } catch (e) {
//       print('getAllUsers error: $e');
//     }
//   }
// }











//   // Future<void> addUser(User user) async {
//   //   final doc = db.collection('users').doc(); // genera ID automático
//   //     try {
//   //       await doc.set(user.toFirestore());
//   //       state = [...state, user];
//   //       // state = user;
//   //     } catch (e) {
//   //       print (e);
//   //     }
//   // }


//   // Future<void> getAllUsers() async {
//   //    try {
//   //     // final docs = db.collection('cars').withConverter(
//   //     final doc = db.collection('users').withConverter(
//   //     fromFirestore: User.fromFirestore,
//   //     toFirestore: (User user, _) => user.toFirestore());
      
//   //     final users = await doc.get();
//   //     // final user = docSnap.data();
//   //       // state = [...state, ...cars.docs.map((c) => c.data())];
//   //       // ✅ Reemplaza lista, no acumula
//   //      state = users.docs.map((doc) => doc.data()).toList();
//   //     // state = user as User;
//   //     } catch (e) {
//   //       print('Error obteniendo usuarios: $e');
//   //     }


// //}

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



