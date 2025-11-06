// Agregado en ale18

import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  String id;
  String userId;
  String carId;
  // String startdate;
  // String endDate;
  int days;
  String status;    // pending, completed, cancelled
  String paymentMethod; // TarjetaCredito, Tarjetadebito, transferencia, Efectivo


  // String imageUrl;

  Reservation({
    required this.id,
    required this.userId,
    required this.carId,
    // required this.startdate,
    // required this.endDate,
    required this.days,
    required this.status,     // pending, paid, cancelled
    required this.paymentMethod,  // opcional
    });


    factory Reservation.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    
    return Reservation(
      // id: data?['id'],
      id: snapshot.id,
      userId: data?['userId'],
      carId: data?['carId'],
      // startdate: data?['startdate'],
      // endDate: data?['endDate'],
      days: data?['days'],
      status: data?['status'],
      paymentMethod: data?['paymentMethod'],
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
      // "startdate": startdate,
      // "endDate": endDate,
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






