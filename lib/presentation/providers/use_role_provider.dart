import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userRoleProvider = FutureProvider<String>((ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return 'guest'; // usuario no logueado

  final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  final data = doc.data();
  return data?['role'] ?? 'user'; // por defecto 'user'
});
