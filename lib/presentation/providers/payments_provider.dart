import 'dart:async';
import 'package:app_car_rental/domain/payment.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// ✅ Estado global de carga para payments
final PaymentLoadingProvider = StateProvider<bool>((ref) => true);

// ✅ StateNotifier con la lista de pagos
final PaymentNotifierProvider =
    StateNotifierProvider<PaymentNotifier, List<Payment>>((ref) {
      return PaymentNotifier();
    });

class PaymentNotifier extends StateNotifier<List<Payment>> {
  final db = FirebaseFirestore.instance;

  PaymentNotifier() : super([]);

  Future<String?> addPayment(Payment payment) async {
    final doc = db.collection('payments').doc();
    payment.id = doc.id; // asigna el id al objeto
    try {
      await doc.set(payment.toFirestore());
      state = [...state, payment];
      return null; // éxito
    } catch (e) {
      print('Error al agregar pago: $e');
      return 'Error al agregar pago: $e'; // devolvés el error
    }
  }

  Future<void> getAllPayments() async {
    try {
      final docs = db
          .collection('payments')
          .withConverter(
            fromFirestore: Payment.fromFirestore,
            toFirestore: (Payment payment, _) => payment.toFirestore(),
          );

      final payments = await docs.get();
      // ✅ Reemplaza lista, no acumula
      state = payments.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error obteniendo pagos: $e');
    }
  }

  Future<void> getPaymentsByUser(String userId, WidgetRef ref) async {
    ref.read(PaymentLoadingProvider.notifier).state = true;
    try {
      final docs = db
          .collection('payments')
          .withConverter(
            fromFirestore: Payment.fromFirestore,
            toFirestore: (Payment payment, _) => payment.toFirestore(),
          );

      final payments = await docs.where('userId', isEqualTo: userId).get();
      state = payments.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print('Error obteniendo pagos: $e');
    }

    ref.read(PaymentLoadingProvider.notifier).state = false;
  }
}
