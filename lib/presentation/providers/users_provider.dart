import 'package:app_car_rental/domain/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_riverpod/legacy.dart';

final UsersNotifierProvider = StateNotifierProvider<UsersNotifier, List<User>>((
  ref,
) {
  return UsersNotifier();
});

class UsersNotifier extends StateNotifier<List<User>> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final fb.FirebaseAuth auth = fb.FirebaseAuth.instance;

  UsersNotifier() : super([]);

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
