// import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/enums/payment_enums.dart';
import 'package:app_car_rental/domain/payment.dart';
import 'package:app_car_rental/domain/reservation.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/payment_ui_provider.dart';
import 'package:app_car_rental/presentation/providers/payments_provider.dart';
import 'package:app_car_rental/presentation/providers/reservations_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

// enum Protection {
//   todo_riesgo_sin_franquicia,
//   todo_riesgo_con_franquicia,
//   terceros
// }

// enum Accesories {
//   wifi_y_auxilio_mecanico,
//   wifi,
//   auxilio_mecanico,
// }

class AddPaymentScreen extends ConsumerStatefulWidget {
  // final Car car;
  // final Car? car;
  // const ReservationScreen({super.key, required this.car});
  final Reservation reservation; // 👈 recibe la reserva desde AddReservationScreen
  

  const AddPaymentScreen(this.reservation,{super.key});

  @override
  ConsumerState<AddPaymentScreen> createState() => _AddPaymentScreenState();

  // @override
  // Widget build(BuildContext context) {
  //   // return _ReservationScreenView(car: car);
  //   return _AddPaymentScreenView();
  // }
}

class _AddPaymentScreenState extends ConsumerState<AddPaymentScreen> {

  // Protection? selectedProtection = Protection.todo_riesgo_sin_franquicia;
  // Accesories? selectedAccesories = Accesories.wifi_y_auxilio_mecanico;

  final _formKey = GlobalKey<FormState>();
  // final _protectionCtrl = TextEditingController();
  // final _wifiCtrl = TextEditingController();

  bool _loading = false;
  String? _error;

  int totalAmount = 0; // MONTO TOTAL CALCULADO (visible en el widget)
  bool _loadingAmount = true;





  @override
    void initState() {
      super.initState();
      _loadCarAndCalculateAmount();
    }

  //   Future<void> _loadCarAndCalculateAmount() async {
  //     final r = widget.reservation;

  //     final carDoc = await FirebaseFirestore.instance
  //         .collection('cars')
  //         .doc(r.carId)
  //         .get();

  //     final car = Car.fromFirestore(carDoc, null);

  //     setState(() {
  //       totalAmount = r.days * car.precio;
  //     });
  //   }


Future<void> _loadCarAndCalculateAmount() async {
  final r = widget.reservation;

  final carDoc = await FirebaseFirestore.instance
      .collection('cars')
      .doc(r.carId)
      .get();

  final car = Car.fromFirestore(carDoc, null);

  setState(() {
    totalAmount = r.days * car.precio;
    _loadingAmount = false;
  });
}






  @override
  Widget build(BuildContext context) {

    final ui = ref.watch(PaymentUiNotifierProvider);

    // loader inicial
  if (_loadingAmount) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Car Rent'),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

    // final textStyle = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // ✅ Definimos el formateador acá
    final NumberFormat formatNumber = NumberFormat('#,##0', 'es_AR');

    final reservation = widget.reservation;
    

    // 1️⃣ Calcular el monto total
    // final totalAmount = reservation.days * car.precio;
     if (totalAmount == 0) {
      return const Center(child: CircularProgressIndicator());
}
             
                   
    // final car = widget.car; // 👈 obtiene el auto desde el widget
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
      appBar: const CustomAppBar(title: 'Car Rent'),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

              ExpansionTile(
                title: const Text('Protección'),
                // subtitle: Text('${selectedProtection?.name}'),
                subtitle: Text(ui.protection.name),
                   children: Protection.values.map((p) {
                    return RadioListTile(
                      title: Text(p.name.replaceAll("_", " ").toUpperCase()),
                      value: p,
                      groupValue: ui.protection,
                      // onChanged: (v) => ref.read(PaymentUiNotifierProvider.notifier).setProtection(v!),
                      onChanged: (v) => ref.read(PaymentUiNotifierProvider.notifier).setProtection(p),
                    );
                }).toList(),
              ),

              const SizedBox(height: 60),


              ExpansionTile(
              title: const Text("Accesorios"),
              subtitle: Text(ui.accessories.name),
              children: Accesories.values.map((a) {
                return RadioListTile(
                  // title: Text(a.name.replaceAll("_", " ").toUpperCase()),
                  title: Text(a.name.replaceAll("_", " ")),
                  value: a,
                  groupValue: ui.accessories,
                  // onChanged: (v) => ref.read(PaymentUiNotifierProvider.notifier).setAccessories(v!),
                  onChanged: (v) => ref.read(PaymentUiNotifierProvider.notifier).setAccessories(a),
                );
              }).toList(),
            ),





                // children: [
                //   RadioListTile(
                //     title: const Text('Todo Riesgo Sin Franquicia'),
                //     value: Protection.todo_riesgo_sin_franquicia,
                //     groupValue: selectedProtection,
                //     onChanged: (value) {
                //       setState(() {
                //         selectedProtection = value;
                //       });
                //     },
                  

                  // RadioListTile(
                  //   title: const Text('Todo Riesgo Con Franquicia'),
                  //   value: Protection.todo_riesgo_con_franquicia,
                  //   groupValue: selectedProtection,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedProtection = value;
                  //     });
                  //   },
                  // ),
                  // RadioListTile(
                  //   title: const Text('Terceros'),
                  //   value: Protection.terceros,
                  //   groupValue: selectedProtection,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       selectedProtection = value;
                  //     });
                  //   },
                  // ),
              //   ],
              // ),

              // const SizedBox(height: 60),

              // ExpansionTile(
              //   title: const Text('Accesorios'),
              //   subtitle: Text('${selectedAccesories?.name}'),
              //   children: [
              //     RadioListTile(
              //       title: const Text('Wi-Fi y Auxilio Mecánico'),
              //       value: Accesories.wifi_y_auxilio_mecanico,
              //       groupValue: selectedAccesories,
              //       onChanged: (value) {
              //         setState(() {
              //           selectedAccesories = value;
              //         });
              //       },
              //     ),
              //     RadioListTile(
              //       title: const Text('Solo Wi-Fi'),
              //       value: Accesories.wifi,
              //       groupValue: selectedAccesories,
              //       onChanged: (value) {
              //         setState(() {
              //           selectedAccesories = value;
              //         });
              //       },
              //     ),
              //     RadioListTile(
              //       title: const Text('Solo Auxilio Mecánico'),
              //       value: Accesories.auxilio_mecanico,
              //       groupValue: selectedAccesories,
              //       onChanged: (value) {
              //         setState(() {
              //           selectedAccesories = value;
              //         });
              //       },
              //     ),
              //   ],
              // ),

              // const SizedBox(height: 20),

              // if (_error != null)
              //   Text(
              //     _error!,
              //     style: const TextStyle(color: Colors.red, fontSize: 14),
              //   ),

              // const SizedBox(height: 12),

 
              
              const SizedBox(height: 120),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  // color: colorScheme.primary, // 🎨 fondo según el tema
                  color: colorScheme.primaryContainer, // 🎨 fondo según el tema
                  border: Border.all(
                    color: colorScheme.onPrimaryContainer, // 🎨 borde que contraste
                    width: 2,
                  ),
                  // borderRadius: BorderRadius.circular(16),

                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(999),
                    right: Radius.circular(999),
                  ),
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  '\$ ${formatNumber.format(totalAmount)}.- importe final a pagar',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer, // 🎨 texto según el tema
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              
              
              
              const SizedBox(height: 80),
              
              
              

             FilledButton(
              onPressed: _loading
                  ? null
                  : () async {
                      if (!_formKey.currentState!.validate()) return;

                      setState(() {
                        _loading = true;
                        _error = null;
                      });

                      final currentUser = fb.FirebaseAuth.instance.currentUser;

                      if (currentUser == null) {
                        setState(() {
                          _error = 'Debes iniciar sesión para pagar una reserva.';
                          _loading = false;
                        });
                        return;
                      }

                      final newPayment = Payment(
                        id: '',
                        userId: currentUser.uid,
                        carId: reservation.carId,
                        reservationId: reservation.id,
                        amount: totalAmount,
                        status: 'Aprobado',
                        timestamp: '',
                        protection: ui.protection.name,
                        accesories: ui.accessories.name,
                      );

                      final paymentNotifier =
                          ref.read(PaymentNotifierProvider.notifier);

                      final err = await paymentNotifier.addPayment(newPayment);

                      if (err != null) {
                        setState(() {
                          _error = err;
                          _loading = false;
                        });
                        return;
                      }

                      await ref
                          .read(ReservationNotifierProvider.notifier)
                          .updateReservationStatus(reservation.id, "Pagado");

                      reservation.status = "Pagado";

                      final carDoc = await FirebaseFirestore.instance
                          .collection("cars")
                          .doc(reservation.carId)
                          .get();

                      final car = Car.fromFirestore(carDoc, null);

                      if (!mounted) return;

                      ref.read(PaymentUiNotifierProvider.notifier).reset();

                      context.push(
                        '/final_screen',
                        extra: {
                          'car': car,
                          'reservation': reservation,
                          'payment': newPayment,
                        },
                      );
                    },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: _loading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Pagar',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),          







            ],
    ),
    ),
      ),
          );
      //   ),
      // ),


      // body: const Center(
      //   child: Text('Aquí se mostrará el formulario para reservar'),
      // ),
    // );
  }

}



