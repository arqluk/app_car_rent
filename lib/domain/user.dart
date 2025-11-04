// // Agregado en ale18

// import 'package:list_view_al_ej/domain/welcoming_interface.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String userName;
  final String userEmail;
  final String role;              // admin | user
  final String password;
  // String passport;
  final String document;
  final String country;
  // String imageUrl;
  final DateTime? createdAt;

  User({
    required this.uid,
    required this.userName,
    required this.userEmail,
    // required this.role,
    this.role ='user',
    required this.password,
    // required this.passport,
    required this.document,
    required this.country,
    this.createdAt
    });

    factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(
      uid: snapshot.id,
      userName: data?['userName'],
      userEmail: data?['userEmail'],
      role: data?['role'],
      password: data?['password'],
      document: data?['document'],
      country: data?['country'],
    );
  }

    Map<String, dynamic> toFirestore() {
    return {
      "uid": uid,
      "userName": userName,
      "userEmail": userEmail,
      "role": role,
      "password": password,
      "document": document,
      "country": country,
    };
  }

    

  // @override
  // String welcome() {
  //   return 'Bienvenido/a $username';
  // }
}

// --------------------------------------------------------------------------------------------
// Hasta ale17

// // import 'package:list_view_al_ej/domain/welcoming_interface.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

// class User {
//   String userName;
//   String userEmail;
//   String password;
//   // String passport;
//   String document;
//   String country;
//   // String imageUrl;

//   User({
//     required this.userName,
//     required this.userEmail,
//     required this.password,
//     // required this.passport,
//     required this.document,
//     required this.country,
//     });

//     factory User.fromFirestore(
//     DocumentSnapshot<Map<String, dynamic>> snapshot,
//     SnapshotOptions? options,
//   ) {
//     final data = snapshot.data();
//     return User(
//       userName: data?['userName'],
//       userEmail: data?['userEmail'],
//       password: data?['password'],
//       document: data?['document'],
//       country: data?['country'],
//     );
//   }

//     Map<String, dynamic> toFirestore() {
//     return {
//       "userName": userName,
//       "userEmail": userEmail,
//       "password": password,
//       "document": document,
//       "country": country,
//     };
//   }

    

//   // @override
//   // String welcome() {
//   //   return 'Bienvenido/a $username';
//   // }
// }