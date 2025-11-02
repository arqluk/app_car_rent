// Agregado en ale18

import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  String id;
  String userId;
  String carId;
  String startdate;
  String endDate;
  String status;    // pending, paid, cancelled
  String paymentId; // opcional


  // String imageUrl;

  Reservation({
    required this.id,
    required this.userId,
    required this.carId,
    required this.startdate,
    required this.endDate,
    required this.status,     // pending, paid, cancelled
    required this.paymentId,  // opcional
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
      startdate: data?['startdate'],
      endDate: data?['endDate'],
      status: data?['status'],
      paymentId: data?['paymentId'],
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
      "startdate": startdate,
      "endDate": endDate,
      "status": status,
      "paymentId": paymentId,
    };
  }

}





