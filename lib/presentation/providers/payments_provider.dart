// data/reservation_notifier.dart
import 'dart:async';

import 'package:app_car_rental/domain/payment.dart';
import 'package:app_car_rental/domain/reservation.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';
// import '../domain/reservation.dart';

final PaymentNotifierProvider = StateNotifierProvider<PaymentNotifier, List<Payment>>((ref) {
  // final FirebaseFirestore _db = FirebaseFirestore.instance;
  // StreamSubscription? _sub;
  // final String uid;

  // ReservationNotifierProvider(this.uid): super([]) {
  //   _listen();
  return PaymentNotifier();
  });

  class PaymentNotifier extends StateNotifier<List<Payment>> {
  final db = FirebaseFirestore.instance;

  PaymentNotifier() : super([]);


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


  Future<String?> addPayment(Payment payment) async {
    final doc = db.collection('payments').doc();
    // final newCar = car.copyWith(id: doc.id);
    payment.id = doc.id;    // asigna el id al objeto
      try {
        await doc.set(payment.toFirestore());
        // await doc.set(newCar.toFirestore());
        state = [...state, payment];
        return null; // éxito
      } catch (e) {
        print('Error al agregar pago: $e');
        return 'Error al agregar pago: $e'; // devolvés el error
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






  Future<void> getAllPayments() async {
    //final carRepository = CarRepository();
    // final List<Car> carsList;
    // final carsList = CarRepository().getCars();
     try {
      // final docs = db.collection('cars').withConverter(
      final docs = db.collection('payments').withConverter(
      fromFirestore: Payment.fromFirestore,
      toFirestore: (Payment payment, _) => payment.toFirestore());

      final payments = await docs.get();
        // state = [...state, ...cars.docs.map((c) => c.data())];
        // ✅ Reemplaza lista, no acumula
      state = payments.docs.map((doc) => doc.data()).toList();
      } catch (e) {
        print('Error obteniendo pagos: $e');
      }
  }

    Future<void> getPaymentsByUser(String userId) async {
    try {
    final docs = db.collection('payments').withConverter(
      fromFirestore: Payment.fromFirestore,
      toFirestore: (Payment payment, _) => payment.toFirestore());

      final payments = await docs.where('userId', isEqualTo: userId).get();
      state = payments.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error obteniendo pagos: $e');
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
