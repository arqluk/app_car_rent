import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 👈 para formatear números

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

    //   // ✅ Agregá esta línea: crea el formateador de moneda
    // final formatCurrency = NumberFormat.currency(
    //   locale: 'es_AR', // formato argentino (podés cambiarlo si querés)
    //   symbol: '\$', // símbolo del peso
    //   decimalDigits: 0,
    // );

    // ✅ Definimos el formateador acá
    final NumberFormat formatNumber = NumberFormat('#,##0', 'es_AR');

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: textStyle.titleLarge),
          SizedBox(height: 5,),
          Text(subtitle, style: textStyle.titleMedium,),
          SizedBox(height: 10,),
          Text(colorDetail),
          Text(description),
          Text(subdescription),
          SizedBox(height: 40,),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(imageUrl, width: 350,)),
          SizedBox(height: 20),
          // Text(precio as String),

          // Text(precio.toString()),

          // // 💰 Texto del precio con formato bonito
          // Text(
          //   '${formatCurrency.format(precio)} por día',
          //   style: textStyle.titleMedium!.copyWith(
          //     // color: Colors.blueAccent,
          //     fontWeight: FontWeight.bold,
          //     fontSize: 20,
          //   ),
          // ),

              // 💰 Cuadro azul con borde negro y texto "$100.- por día"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue, // fondo azul
              border: Border.all(color: Colors.black, width: 2), // borde negro
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '\$ ${formatNumber.format(precio)}.- por día',
              style: const TextStyle(
                color: Colors.white, // texto negro
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