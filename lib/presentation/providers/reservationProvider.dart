// data/reservation_notifier.dart
import 'dart:async';

import 'package:app_car_rental/domain/reservation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
// import '../domain/reservation.dart';

class ReservationNotifier extends StateNotifier<List<Reservation>> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  StreamSubscription? _sub;
  final String uid;

  ReservationNotifier(this.uid): super([]) {
    _listen();
  }


  // void _listen() {
  //   _sub = _db.collection('reservations')
  //     .where('userId', isEqualTo: uid)
  //     .snapshots()
  //     .listen((snap) {
  //       // state = snap.docs.map((d) => Reservation.fromMap(d.id, d.data())).toList();
  //       state = snap.docs.map((d) => Reservation.fromFirestore(d.id, d.data())).toList();
  //     });
  // }


void _listen() {
    final reservationsRef = _db.collection('reservations').withConverter<Reservation>(
      fromFirestore: Reservation.fromFirestore,
      toFirestore: (r, _) => r.toFirestore(),
    );

    _sub = reservationsRef
        .where('userId', isEqualTo: uid)
        .snapshots()
        .listen((snap) {
      state = snap.docs.map((d) => d.data()).toList(); // 👈 ya son Reservation
    });
  }

  Future<void> createReservation(Reservation r) async {
    // await _db.collection('reservations').add(r.toMap());
    await _db.collection('reservations').add(r.toFirestore());  // 👈 no hace falta toMap ni toFirestore()
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

// provider factory: crear por uid cuando el user loguea
final reservationProvider = StateNotifierProvider.family<ReservationNotifier, List<Reservation>, String>((ref, uid) {
  return ReservationNotifier(uid);
});
