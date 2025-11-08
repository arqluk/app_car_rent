import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Proveedor que expone el estado de autenticación actual
final authStateProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);










// /// Proveedor que expone las funciones de autenticación
// final authProvider = Provider<AuthService>((ref) {
//   final auth = FirebaseAuth.instance;
//   return AuthService(auth);
// });


//---------------------------------------------------------------------------------



// // data/auth_notifier.dart
// import 'dart:async';

// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart' as fb;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/legacy.dart';

// class AuthState {
//   final fb.User? firebaseUser;
//   final Map<String, dynamic>? userDoc; // datos extra (role, passport...)

//   AuthState({this.firebaseUser, this.userDoc});
// }

// class AuthNotifier extends StateNotifier<AuthState> {
//   final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   StreamSubscription<fb.User?>? _sub;
//   StreamSubscription? _docSub;

//   AuthNotifier(): super(AuthState()) {
//     _sub = _auth.userChanges().listen((u) {
//       if (u == null) {
//         state = AuthState(firebaseUser: null, userDoc: null);
//         _docSub?.cancel();
//       } else {
//         // escucha doc users/{uid} para role
//         _docSub?.cancel();
//         _docSub = _db.collection('users').doc(u.uid).snapshots().listen((snap) {
//           state = AuthState(firebaseUser: u, userDoc: snap.exists ? snap.data() : null);
//         });
//       }
//     });
//   }

//   Future<void> signUpWithEmail(String email, String password, Map<String, dynamic> extraUserData) async {
//     final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//     final uid = cred.user!.uid;
//     // guardar doc en users
//     await _db.collection('users').doc(uid).set({
//       'email': email,
//       'role': extraUserData['role'] ?? 'user',
//       ...extraUserData,
//     });
//   }

//   Future<void> signIn(String email, String password) => _auth.signInWithEmailAndPassword(email: email, password: password);
//   Future<void> signOut() => _auth.signOut();

//   @override
//   void dispose() {
//     _sub?.cancel();
//     _docSub?.cancel();
//     super.dispose();
//   }
// }

// final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());
