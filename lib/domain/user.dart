import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String userName;
  final String userEmail;
  final String role; // admin | user
  final String password;
  final String document;
  final String country;
  final DateTime? createdAt;

  User({
    required this.uid,
    required this.userName,
    required this.userEmail,
    this.role = 'user',
    required this.password,
    required this.document,
    required this.country,
    this.createdAt,
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
}
