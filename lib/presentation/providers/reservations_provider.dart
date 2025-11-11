import 'dart:async';
import 'package:app_car_rental/domain/reservation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/legacy.dart';

// Estado global de carga para reservations
final ReservationLoadingProvider = StateProvider<bool>((ref) => true);

final ReservationNotifierProvider =
    StateNotifierProvider<ReservationNotifier, List<Reservation>>((ref) {
      return ReservationNotifier();
    });

class ReservationNotifier extends StateNotifier<List<Reservation>> {
  final db = FirebaseFirestore.instance;

  ReservationNotifier() : super([]);

  Future<String?> addReservation(Reservation reservation) async {
    final doc = db.collection('reservations').doc();
    reservation.id = doc.id; // asigna el id al objeto
    try {
      await doc.set(reservation.toFirestore());
      state = [...state, reservation];
      return null; // éxito
    } catch (e) {
      print('Error al agregar reserva: $e');
      return 'Error al agregar reserva: $e';
    }
  }

  Future<void> getAllReservations() async {
    try {
      final docs = db
          .collection('reservations')
          .withConverter(
            fromFirestore: Reservation.fromFirestore,
            toFirestore: (Reservation reservation, _) =>
                reservation.toFirestore(),
          );

      final reservations = await docs.get();
      // Reemplaza lista, no acumula
      state = reservations.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error obteniendo reservas: $e');
    }
  }

  Future<void> getReservationsByUser(String userId, ref) async {
    ref.read(ReservationLoadingProvider.notifier).state = true;
    try {
      final docs = db
          .collection('reservations')
          .withConverter(
            fromFirestore: Reservation.fromFirestore,
            toFirestore: (Reservation reservation, _) =>
                reservation.toFirestore(),
          );

      final reservations = await docs.where('userId', isEqualTo: userId).get();
      state = reservations.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error obteniendo reservas: $e');
    }

    ref.read(ReservationLoadingProvider.notifier).state = false;
  }

  Future<void> updateReservationStatus(
    String reservationId,
    String newStatus,
  ) async {
    try {
      await db.collection('reservations').doc(reservationId).update({
        'status': newStatus,
      });

      // Actualizo el estado local también
      state = [
        for (final r in state)
          if (r.id == reservationId) r.copyWith(status: newStatus) else r,
      ];
    } catch (e) {
      print('Error al actualizar estado de la reserva: $e');
    }
  }
}
