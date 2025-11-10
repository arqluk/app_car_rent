import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 👈 para formatear números

// ignore: must_be_immutable
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
    final textStyle = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // ✅ Definimos el formateador acá
    final NumberFormat formatNumber = NumberFormat('#,##0', 'es_AR');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: textStyle.titleLarge),
          SizedBox(height: 5),
          Text(subtitle, style: textStyle.titleMedium),
          SizedBox(height: 10),
          Text(colorDetail),
          Text(description),
          Text(subdescription),
          SizedBox(height: 40),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(imageUrl, width: 350),
          ),
          SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer, // 🎨 fondo según el tema
              border: Border.all(
                color: colorScheme.onPrimaryContainer, // 🎨 borde que contraste
                width: 2,
              ),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(999),
                right: Radius.circular(999),
              ),
            ),
            child: Text(
              '\$ ${formatNumber.format(precio)}.- por día',
              style: TextStyle(
                color: colorScheme.onPrimaryContainer, // 🎨 texto según el tema
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
