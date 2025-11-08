// data/reservation_notifier.dart
import 'dart:async';

import 'package:app_car_rental/domain/reservation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
// import '../domain/reservation.dart';

// ✅ Estado global de carga para reservations
final ReservationLoadingProvider= StateProvider<bool>((ref) => true);

final ReservationNotifierProvider = StateNotifierProvider<ReservationNotifier, List<Reservation>>((ref) {
  // final FirebaseFirestore _db = FirebaseFirestore.instance;
  // StreamSubscription? _sub;
  // final String uid;

  // ReservationNotifierProvider(this.uid): super([]) {
  //   _listen();
  return ReservationNotifier();
  });

  class ReservationNotifier extends StateNotifier<List<Reservation>> {
  final db = FirebaseFirestore.instance;

  ReservationNotifier() : super([]);


  // void _listen() {
  //   _sub = _db.collection('reservations')
  //     .where('userId', isEqualTo: uid)
  //     .snapshots()
  //     .listen((snap) {
  //       // state = snap.docs.map((d) => Reservation.fromMap(d.id, d.data())).toList();
  //       state = snap.docs.map((d) => Reservation.fromFirestore(d.id, d.data())).toList();
  //     });
  // }


// void _listen() {
//     final reservationsRef = _db.collection('reservations').withConverter<Reservation>(
//       fromFirestore: Reservation.fromFirestore,
//       toFirestore: (r, _) => r.toFirestore(),
//     );

//     _sub = reservationsRef
//         .where('userId', isEqualTo: uid)
//         .snapshots()
//         .listen((snap) {
//       state = snap.docs.map((d) => d.data()).toList(); // 👈 ya son Reservation
//     });
//   }


  Future<String?> addReservation(Reservation reservation) async {
    final doc = db.collection('reservations').doc();
    // final newCar = car.copyWith(id: doc.id);
    reservation.id = doc.id;    // asigna el id al objeto
      try {
        await doc.set(reservation.toFirestore());
        // await doc.set(newCar.toFirestore());
        state = [...state, reservation];
        return null; // éxito
      } catch (e) {
        print('Error al agregar reserva: $e');
        return 'Error al agregar reserva: $e'; // devolvés el error
      }
  }




  //   Future<String?> addReservation(Reservation reservation) async {
  //   final doc = db.collection('reservations').doc();
  //   reservation.id = doc.id; // asigna el id al objeto

  //   try {
  //     await doc.set(reservation.toFirestore());
  //     state = [...state, reservation];
  //     return null; // éxito
  //   } catch (e) {
  //     return 'Error al agregar reserva: $e';
  //   }
  // }






  Future<void> getAllReservations() async {
    //final carRepository = CarRepository();
    // final List<Car> carsList;
    // final carsList = CarRepository().getCars();
     try {
      // final docs = db.collection('cars').withConverter(
      final docs = db.collection('reservations').withConverter(
      fromFirestore: Reservation.fromFirestore,
      toFirestore: (Reservation reservation, _) => reservation.toFirestore());
      
      final reservations = await docs.get();
        // state = [...state, ...cars.docs.map((c) => c.data())];
        // ✅ Reemplaza lista, no acumula
      state = reservations.docs.map((doc) => doc.data()).toList();
      } catch (e) {
        print('Error obteniendo reservas: $e');
      }
  }

  Future<void> getReservationsByUser(String userId, ref) async {
    ref.read(ReservationLoadingProvider.notifier).state = true;
    try {
    final docs = db.collection('reservations').withConverter(
      fromFirestore: Reservation.fromFirestore,
      toFirestore: (Reservation reservation, _) => reservation.toFirestore());

      final reservations = await docs.where('userId', isEqualTo: userId).get();
      state = reservations.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error obteniendo reservas: $e');
    }

    ref.read(ReservationLoadingProvider.notifier).state = false;
}




  // static Future<void> updateReservationStatus(String reservationId, String newStatus) async {
  Future<void> updateReservationStatus(String reservationId, String newStatus) async {
    // final db = FirebaseFirestore.instance;
    try {
      await db.collection('reservations').doc(reservationId).update({'status': newStatus});

      // 🔄 Actualizar el estado local también
    state = [
      for (final r in state)
        if (r.id == reservationId) r.copyWith(status: newStatus) else r
    ];

    } catch (e) {
      print('Error al actualizar estado de la reserva: $e');
    }
  }





  // Future<void> createReservation(Reservation r) async {
  //   // await _db.collection('reservations').add(r.toMap());
  //   await _db.collection('reservations').add(r.toFirestore());  // 👈 no hace falta toMap ni toFirestore()
  // }

  // @override
  // void dispose() {
  //   _sub?.cancel();
  //   super.dispose();
  // }
}

// // provider factory: crear por uid cuando el user loguea
// final reservationProvider = StateNotifierProvider.family<ReservationNotifierProvider, List<Reservation>, String>((ref, uid) {
//   return ReservationNotifierProvider(uid);
// });
