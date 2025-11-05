// Agregado en ale18

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
  // String paymentMethod; // tarjetaCredito, Tarjetadebito, transferencia, Efectivo


  // String imageUrl;

  Payment({
    required this.id,
    required this.userId,
    required this.carId,
    required this.reservationId,
    required this.amount,
    required this.status,     // pending, paid, cancelled
    required this.timestamp,
    required this.protection,
    required this.accesories
    // required this.paymentMethod,  // opcional
    });


    factory Payment.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    
    return Payment(
      // id: data?['id'],
      id: snapshot.id,
      userId: data?['userId'],
      carId: data?['carId'],
      reservationId: data?['reservationId'],
      amount: data?['amount'],
      status: data?['status'],
      timestamp: data?['timestamp'],
      protection: data?['protection'],
      accesories: data?['accesories'],
      // paymentMethod: data?['paymentMethod'],
    );
  }

  // Map<String, dynamic> toFirestore() {
  //   return {
  //     if (id != null) "id": id,
  //     if (grupo != null) "grupo": grupo,
  //     if (marca != null) "marca": marca,
  //     if (modelo != null) "modelo": modelo,
  //     if (color != null) "color": color,
  //     if (capacidad != null) "capacidad": capacidad,
  //     if (equipaje != null) "capacidad": equipaje,
  //     if (automatico != null) "capacidad": equipaje,
  //     if (equipaje != null) "automatico": automatico,
  //     if (aire != null) "aire": aire,
  //     if (precio != null) "precio": precio,
  //     if (imageUrl != null) "imageUrl": imageUrl,
  //   };
  // }

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
      // "paymentMethod": paymentMethod,
    };
  }

}