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
  String? reservedBy; // uid que resrvó, null = disponible

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
    this.reservedBy,
  });

  factory Car.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Car(
      id: snapshot.id,
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
      reservedBy: data?['reservedBy'],
    );
  }

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
      if (reservedBy != null) "reservedBy": reservedBy,
    };
  }
}
