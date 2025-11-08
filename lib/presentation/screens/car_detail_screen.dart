import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/components/item_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_car_rental/presentation/providers/auth_provider.dart';

class CarDetailScreen extends ConsumerWidget {
  final Car car;
  
  CarDetailScreen({super.key, required this.car});
  // final textStyle = Theme.of(context).textTheme;
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final authState = ref.watch(authStateProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
      // appBar: AppBar(
      //   title: Row(
      //     children: [
      //       Image.asset(
      //         'assets/images/cr_logo.jpg',
      //         width: 40,
      //         height: 40,
      //       ),
      //       const SizedBox(width: 8),
      //       const Text('Car Rent'),
      //     ],
      //   ),
      //   backgroundColor: Colors.blue,
      //   foregroundColor: Colors.white,
      //   actions: [
      //     IconButton(
      //       onPressed: () {
      //         // TODO: Agregar funcionalidad del ícono de auto
      //       },
      //       icon: const Icon(Icons.directions_car),
      //       tooltip: 'Car Rent',
      //     ),
      //   ],
      // ),

      appBar: const CustomAppBar(title: 'Car Rent'),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ItemDetailScreen(
            title: 'Grupo: ${car.grupo}',
            subtitle: '${car.marca} ${car.modelo}',
            colorDetail: 'Color: ${car.color}',
            description: '${car.capacidad} personas - ${car.equipaje} maletas',
            subdescription: 'Aire: ${car.aire ? "Sí" : "No"} - Automático: ${car.automatico ? "Sí" : "No"}',
            // imageUrl: car.imageUrl,
            imageUrl: car.imageUrl.isNotEmpty ? car.imageUrl : 'https://blocks.astratic.com/img/general-img-landscape.png',
            // precio: 'Precio: ${car.precio} por día',
            precio: car.precio,
          ),
          SizedBox(height: 50,),
          // ElevatedButton(
          //   // style: ButtonStyle(backgroundColor: Colors.lightBlueAccent),

            
          //   onPressed: () {
          //     context.push('/reservations_screen', extra: car);
          //   },

          //   ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: colorScheme.primary,
          //       // backgroundColor: colorScheme.secondary,
          //       foregroundColor: colorScheme.onPrimary,
          //       // foregroundColor: colorScheme.onSecondary,
          //     ),
          //     onPressed: () {
          //       context.push('/reservations_screen', extra: car);
          //     },


          //   child: Text('Reservar',
          //   style: const TextStyle(
          //       color: Colors.black, // texto negro
          //       fontWeight: FontWeight.bold,
          //       fontSize: 18,
          //     ),)
          // )

        //   FilledButton(
        //   onPressed: () => context.push('/reservations_screen', extra: car),
        //   child: const Text('Reservar'),
        // )

        // SizedBox(
        //   width: 200,   // 👈 más ancho
        //   height: 50,   // 👈 más alto
        //   child: FilledButton(
        //     onPressed: () => context.push('/reservation_screen', extra: car),
        //     style: FilledButton.styleFrom(
        //       textStyle: const TextStyle(
        //         fontSize: 25,
        //         fontWeight: FontWeight.bold,
        //       ),
        //     ),
        //     child: const Text('Reservar'),
        //   ),
        // ),




// último 05/11
        // 👇 Botón solo visible si hay un usuario logueado
          authState.when(
            data: (user) {
              if (user != null) {
                return FilledButton.icon(
                  onPressed: () => context.push('/add_reservation_screen', extra: car),
                  icon: const Icon(Icons.directions_car),
                  label: Text(
                    'Reservar',
                    style: Theme.of(context)
                        .textTheme
                        .headlineLarge
                        ?.copyWith(color: colorScheme.onPrimary),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                    backgroundColor: colorScheme.primary,
                  ),
                );
              } else {
                return Column(
                  // padding: const EdgeInsets.all(8.0),
                  children: [
                    // const Text(
                    //   'Iniciá sesión para reservar este auto.',
                    //   style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                    // ),

                  //   Text(
                  //   'Iniciá sesión para reservar este auto.',
                  //   textAlign: TextAlign.center,
                  //   // style: textStyle.bodyLarge?.copyWith(
                  //   style: textStyle.bodyLarge?.copyWith(
                  //     fontSize: 16, fontWeight: FontWeight.normal,
                  //     // color: Colors.black87,
                  //   ),
                  // ),


                  Text(
                  'Iniciá sesión para reservar este auto.',
                  textAlign: TextAlign.center,
                  style: textStyle.bodyLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: colorScheme.onSurface,
                  ),
                ),



                  // const SizedBox(height: 20),

                    // TextButton.icon(
                    //   onPressed: () => context.push('/login_screen'),
                    //   icon: const Icon(Icons.login, color: Colors.blue),
                    //   label: const Text(
                    //     // 'Ir a Iniciar Sesión',
                    //     'Iniciar Sesión',
                    //     style: TextStyle(color: Colors.blue),
                    //   ),
                    // ),


                    TextButton.icon(
                      onPressed: () => context.push('/login_screen'),
                      style: TextButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                      ),
                      // icon: const Icon(Icons.login),
                      icon: Icon(Icons.login,
                      size: Theme.of( context).textTheme.titleMedium!.fontSize! * 1.6,
                    ),
                      // label: const Text('Iniciar Sesión'),
                      label: Text('Iniciar Sesión',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
                    ),
                    ),




                  ],




                );
              }
            },
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
          ),
        ],
      ),
    );
  }
}





// class _CarDetailView extends StatelessWidget {
//   const _CarDetailView({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }



// -----------------------------------------------------------------------------


// import 'package:app_car_rental/domain/car.dart';
// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:app_car_rental/presentation/components/item_detail.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class CarDetailScreen extends StatelessWidget {
//   final Car car;
  
//   CarDetailScreen({super.key, required this.car});
//   // final textStyle = Theme.of(context).textTheme;
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: Row(
//       //     children: [
//       //       Image.asset(
//       //         'assets/images/cr_logo.jpg',
//       //         width: 40,
//       //         height: 40,
//       //       ),
//       //       const SizedBox(width: 8),
//       //       const Text('Car Rent'),
//       //     ],
//       //   ),
//       //   backgroundColor: Colors.blue,
//       //   foregroundColor: Colors.white,
//       //   actions: [
//       //     IconButton(
//       //       onPressed: () {
//       //         // TODO: Agregar funcionalidad del ícono de auto
//       //       },
//       //       icon: const Icon(Icons.directions_car),
//       //       tooltip: 'Car Rent',
//       //     ),
//       //   ],
//       // ),

//       appBar: const CustomAppBar(title: 'Car Rent'),

//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ItemDetailScreen(
//             title: 'Grupo: ${car.grupo}',
//             subtitle: '${car.marca} ${car.modelo}',
//             colorDetail: 'Color: ${car.color}',
//             description: '${car.capacidad} personas - ${car.equipaje} maletas',
//             subdescription: 'Aire: ${car.aire ? "Sí" : "No"} - Automático: ${car.automatico ? "Sí" : "No"}',
//             // imageUrl: car.imageUrl,
//             imageUrl: car.imageUrl.isNotEmpty ? car.imageUrl : 'https://blocks.astratic.com/img/general-img-landscape.png',
//             // precio: 'Precio: ${car.precio} por día',
//             precio: car.precio,
//           ),
//           SizedBox(height: 50,),
//           // ElevatedButton(
//           //   // style: ButtonStyle(backgroundColor: Colors.lightBlueAccent),

            
//           //   onPressed: () {
//           //     context.push('/reservations_screen', extra: car);
//           //   },

//           //   ElevatedButton(
//           //     style: ElevatedButton.styleFrom(
//           //       backgroundColor: colorScheme.primary,
//           //       // backgroundColor: colorScheme.secondary,
//           //       foregroundColor: colorScheme.onPrimary,
//           //       // foregroundColor: colorScheme.onSecondary,
//           //     ),
//           //     onPressed: () {
//           //       context.push('/reservations_screen', extra: car);
//           //     },


//           //   child: Text('Reservar',
//           //   style: const TextStyle(
//           //       color: Colors.black, // texto negro
//           //       fontWeight: FontWeight.bold,
//           //       fontSize: 18,
//           //     ),)
//           // )

//         //   FilledButton(
//         //   onPressed: () => context.push('/reservations_screen', extra: car),
//         //   child: const Text('Reservar'),
//         // )

//         // SizedBox(
//         //   width: 200,   // 👈 más ancho
//         //   height: 50,   // 👈 más alto
//         //   child: FilledButton(
//         //     onPressed: () => context.push('/reservation_screen', extra: car),
//         //     style: FilledButton.styleFrom(
//         //       textStyle: const TextStyle(
//         //         fontSize: 25,
//         //         fontWeight: FontWeight.bold,
//         //       ),
//         //     ),
//         //     child: const Text('Reservar'),
//         //   ),
//         // ),




// // último 20/10
//         FilledButton.icon(
//               // onPressed: () => context.push('/reservation_screen'),
//               onPressed: () => context.push('/add_reservation_screen',
//               extra: car, ),   // 👈 pasa el auto seleccionado
//               // icon: const Icon(
//               //   Icons.directions_car,
//                 // size: 45,
//               //),
//              label: Text(
//               'Reservar',
//               style: Theme.of(context).textTheme.headlineLarge?.copyWith(
//                     color: Theme.of(context).colorScheme.onPrimary,
//                   ),
//             ),
//               style: FilledButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(999), // botón tipo píldora
//                 ),
//                 backgroundColor: Theme.of(context).colorScheme.primary, // usa color del theme
//               ),
//             ),





//         ],
//       ),
//     );
//   }
// }






// // class _CarDetailView extends StatelessWidget {
// //   const _CarDetailView({
// //     super.key,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return const Placeholder();
// //   }
// // }