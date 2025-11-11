import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  String id;
  String userId;
  String carId;
  String reservationId;
  int amount;
  String status;
  String timestamp;
  String protection;
  String accesories;

  Payment({
    required this.id,
    required this.userId,
    required this.carId,
    required this.reservationId,
    required this.amount,
    required this.status,
    required this.timestamp,
    required this.protection,
    required this.accesories,
  });

  factory Payment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Payment(
      id: snapshot.id,
      userId: data?['userId'],
      carId: data?['carId'],
      reservationId: data?['reservationId'],
      amount: data?['amount'],
      status: data?['status'],
      timestamp: data?['timestamp'],
      protection: data?['protection'],
      accesories: data?['accesories'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "userId": userId,
      "carId": carId,
      "reservationId": reservationId,
      "amount": amount,
      "status": status,
      "timestamp": timestamp,
      "protection": protection,
      "accesories": accesories,
    };
  }

  Payment copyWith({
    String? id,
    String? userId,
    String? carId,
    String? reservationId,
    int? amount,
    String? status,
    String? timestamp,
    String? protection,
    String? accesories,
  }) {
    return Payment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carId: carId ?? this.carId,
      reservationId: reservationId ?? this.reservationId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      protection: protection ?? this.protection,
      accesories: accesories ?? this.accesories,
    );
  }
}
