// import 'dart:ffi';

// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';

class Car {
  String id;
  String grupo;
  String marca;
  String modelo;
  String color;
  int capacidad;
  int equipaje;
  bool automatico;
  bool aire;
  int precio;
  String imageUrl;

  // String imageUrl;

  Car({
    required this.id,
    required this.grupo,
    required this.marca,
    required this.modelo,
    required this.color,
    required this.capacidad,
    required this.equipaje,
    required this.automatico,
    required this.aire,
    required this.precio,
    required this.imageUrl,
    });


    factory Car.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    
    return Car(
      id: data?['id'],
      grupo: data?['grupo'],
      marca: data?['marca'],
      modelo: data?['modelo'],
      color: data?['color'],
      capacidad: data?['capacidad'],
      equipaje: data?['equipaje'],
      automatico: data?['automatico'],
      aire: data?['aire'],
      precio: data?['precio'],
      imageUrl: data?['imageUrl'],
      // capacidad:
      //     data?['capacidad'] is Iterable ? List.from(data?['capacidad']) : null,
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
      "grupo": grupo,
      "marca": marca,
      "modelo": modelo,
      "color": color,
      "capacidad": capacidad,
      "equipaje": equipaje,
      "automatico": automatico,
      "aire": aire,
      "precio": precio,
      "imageUrl": imageUrl,
    };
  }

}
