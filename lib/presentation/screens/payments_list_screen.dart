// import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/payment.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/payments_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PaymentsListScreen extends ConsumerStatefulWidget {
  // final Car car;
  // final Car? car;
  // const ReservationScreen({super.key, required this.car});
  const PaymentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return _ReservationScreenView(car: car);
    return _PaymentsListScreenView();
  }

  @override
  ConsumerState<PaymentsListScreen> createState() {
    return PaymentsListScreenState();
  }
}



class PaymentsListScreenState extends ConsumerState<PaymentsListScreen>{
//   @override
//  void initState() {
//   super.initState();
//   final currentUser = fb.FirebaseAuth.instance.currentUser;
//   if (currentUser != null) {
//     // ref.read(PaymentNotifierProvider.notifier).getPaymentsByUser(currentUser.uid);
//     ref.read(PaymentNotifierProvider.notifier).getPaymentsByUser(currentUser.uid, ref);
//   }
//  }

@override
void initState() {
  super.initState();

  Future.microtask(() {
    final currentUser = fb.FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      ref.read(PaymentNotifierProvider.notifier)
          .getPaymentsByUser(currentUser.uid, ref);
    }
  });
}







  @override
  Widget build(BuildContext context) {
    List<Payment> paymentList = ref.watch(PaymentNotifierProvider);
    // bool loading = ref.watch(PaymentLoadingProvider);
    // return _ReservationsListScreenView(reservationList: reservationList, textStyle: Theme.of(context).textTheme);
    return _PaymentsListScreenView();
  }
 }




 
class _PaymentsListScreenView extends ConsumerWidget {
  const _PaymentsListScreenView({
    // super.key, required Car car,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final currentUser = fb.FirebaseAuth.instance.currentUser;
    final paymentList = ref.watch(PaymentNotifierProvider);
    bool loading = ref.watch(PaymentLoadingProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;


    return Scaffold(
      //  appBar: AppBar(
      //     title: Row(
      //       children: [
      //         Image.asset(
      //           'assets/images/cr_logo.jpg',
      //           width: 40,
      //           height: 40,
      //         ),
      //         const SizedBox(width: 8),
      //         const Text('Car Rent'),
      //       ],
      //     ),
      //     backgroundColor: Colors.blue,
      //     foregroundColor: Colors.white,
      //     actions: [
      //       IconButton(
      //         onPressed: () {
      //           // TODO: Agregar funcionalidad del ícono de auto
      //         },
      //         icon: const Icon(Icons.directions_car),
      //         tooltip: 'Car Rent',
      //       ),
      //     ],
      //   ),
      appBar: const CustomAppBar(title: ' Tus pagos'),

    //   body: const Center(
    //     child: Text('Aquí se mostrarán los pagos realizados'),
    //   ),
    // );



      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(






          child: currentUser == null
              // 🔹 Caso SIN usuario logueado
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                       Text(
                    'Iniciá sesión para ver tus pagos.',
                    textAlign: TextAlign.center,
                    style: textStyle.bodyLarge?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: colorScheme.onSurface,
                    ),
                  ),

                    const SizedBox(height: 20),

                    // TextButton.icon(
                    //   onPressed: () => context.push('/login_screen'),
                    //   icon: const Icon(Icons.login, color: Colors.blue),
                    //   label: const Text(
                    //     'Ir a Iniciar Sesión',
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
                )

              // 🔹 Caso CON usuario logueado
              // : paymentList.isEmpty
              //     ? const Center(
              //         child: CircularProgressIndicator(),
              //       )
              //     : Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             'Tus pagos',
              //             style: textStyle.headlineSmall?.copyWith(
              //               fontWeight: FontWeight.bold,
              //             ),
                        // ),
                        // const SizedBox(height: 10),
                        // Text(
                        //   'Hacé clic en un pago para ver detalles',
                        //   style: textStyle.bodyMedium,
                        // ),
               : loading
                  ? const CircularProgressIndicator()         
                        
              : paymentList.isEmpty
                ? Center(
                    child: Text(
                      "No tenés pagos registrados",
                      style: textStyle.bodyLarge,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tus pagos',
                        style: textStyle.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      ),            
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: paymentList.length,
                            itemBuilder: (context, index) {
                              final payment = paymentList[index];
                              return _PaymentItemView(payment: payment);
                            },
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}

class _PaymentItemView extends StatelessWidget {
  final Payment payment;

  const _PaymentItemView({
    super.key,
    required this.payment,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: ListTile(
        title: Text(
          'Pago #${payment.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Monto: ${payment.amount}'),
        // trailing: const Icon(Icons.arrow_forward_ios),
        // onTap: () {
        //   context.push('/payment_detail_screen', extra: payment);
        // },
      ),
    );
  }
}

  // });

  // @override
  // Widget build(BuildContext context) {
  //   return Card(
  //     margin: const EdgeInsets.symmetric(vertical: 8),
  //     elevation: 2,
  //     child: ListTile(
  //       title: Text(
  //         'Pago #${payment.id}',
  //         style: const TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       subtitle: Text('Monto: ${payment.amount}'),
  //       trailing: const Icon(Icons.arrow_forward_ios),
  //       onTap: () {
  //         context.push('/payment_detail_screen', extra: payment);
  //       },
  //     ),
  //   );
  // }
// }



// ---------------------------------------------------------------

// // import 'package:app_car_rental/domain/car.dart';
// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:flutter/material.dart';

// class PaymentsListScreen extends StatelessWidget {
//   // final Car car;
//   // final Car? car;
//   // const ReservationScreen({super.key, required this.car});
//   const PaymentsListScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // return _ReservationScreenView(car: car);
//     return _PaymentsListScreenView();
//   }
// }

// class _PaymentsListScreenView extends StatelessWidget {
//   const _PaymentsListScreenView({
//     // super.key, required Car car,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //  appBar: AppBar(
//       //     title: Row(
//       //       children: [
//       //         Image.asset(
//       //           'assets/images/cr_logo.jpg',
//       //           width: 40,
//       //           height: 40,
//       //         ),
//       //         const SizedBox(width: 8),
//       //         const Text('Car Rent'),
//       //       ],
//       //     ),
//       //     backgroundColor: Colors.blue,
//       //     foregroundColor: Colors.white,
//       //     actions: [
//       //       IconButton(
//       //         onPressed: () {
//       //           // TODO: Agregar funcionalidad del ícono de auto
//       //         },
//       //         icon: const Icon(Icons.directions_car),
//       //         tooltip: 'Car Rent',
//       //       ),
//       //     ],
//       //   ),
//       appBar: const CustomAppBar(title: 'Car Rent'),

//       body: const Center(
//         child: Text('Aquí se mostrarán los pagos realizados'),
//       ),
//     );
//   }
// }
