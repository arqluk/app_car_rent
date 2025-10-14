import 'package:flutter/material.dart';

class ItemDetailScreen extends StatelessWidget {
  String title;
  String subtitle;
  String colorDetail;
  String description;
  String subdescription;
  String imageUrl;
  int precio;

  ItemDetailScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.colorDetail,
    required this.description,
    required this.subdescription,
    required this.imageUrl,
    required this.precio,
    });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title),
          Text(subtitle),
          Text(colorDetail),
          Text(description),
          Text(subdescription),
          Image.network(imageUrl),
          SizedBox(height: 20),
          // Text(precio as String),
        ],
      ),
    );
  }
}