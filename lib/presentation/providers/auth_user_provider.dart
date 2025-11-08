import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';


final userDocProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  return FirebaseAuth.instance.authStateChanges().asyncMap((user) async {
    if (user == null) return null;

    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (!snap.exists) return null;

    return snap.data();
  });
});












// final userDocProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
//   final user = FirebaseAuth.instance.currentUser;
//   if (user == null) return null;

//   final doc = await FirebaseFirestore.instance
//       .collection('users')
//       .doc(user.uid)
//       .get();

//   return doc.data();
// });
