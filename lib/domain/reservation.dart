import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  String id;
  String userId;
  String carId;
  int days;
  String status; // pending, completed, cancelled
  String
  paymentMethod; // TarjetaCredito, Tarjetadebito, Transferencia, Efectivo

  Reservation({
    required this.id,
    required this.userId,
    required this.carId,
    required this.days,
    required this.status,
    required this.paymentMethod,
  });

  factory Reservation.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Reservation(
      id: snapshot.id,
      userId: data?['userId'],
      carId: data?['carId'],
      days: data?['days'],
      status: data?['status'],
      paymentMethod: data?['paymentMethod'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      "id": id,
      "userId": userId,
      "carId": carId,
      "days": days,
      "status": status,
      "paymentMethod": paymentMethod,
    };
  }

  Reservation copyWith({
    String? id,
    String? userId,
    String? carId,
    int? days,
    String? status,
    String? paymentMethod,
  }) {
    return Reservation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      carId: carId ?? this.carId,
      days: days ?? this.days,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}
