import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/enums/payment_enums.dart';
import 'package:app_car_rental/domain/payment.dart';
import 'package:app_car_rental/domain/reservation.dart';
import 'package:app_car_rental/domain/payment_price_rules.dart';
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

class AddPaymentScreen extends ConsumerStatefulWidget {
  final Reservation reservation;

  const AddPaymentScreen(this.reservation, {super.key});

  @override
  ConsumerState<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends ConsumerState<AddPaymentScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _loading = false;
  bool _loadingAmount = true;

  late Car loadedCar;
  int totalAmount = 0;

  final numberFormat = NumberFormat('#,##0', 'es_AR');

  @override
  void initState() {
    super.initState();
    _loadCar();
  }

  Future<void> _loadCar() async {
    final doc = await FirebaseFirestore.instance
        .collection('cars')
        .doc(widget.reservation.carId)
        .get();

    loadedCar = Car.fromFirestore(doc, null);

    _recalculate();
    setState(() => _loadingAmount = false);
  }

  void _recalculate() {
    final ui = ref.read(PaymentUiNotifierProvider);

    final base = widget.reservation.days * loadedCar.precio;
    final protection = PaymentPriceRules.protectionPrices[ui.protection] ?? 0;
    final accessories = PaymentPriceRules.accessoriesPrices[ui.accessories] ?? 0;

    setState(() {
      totalAmount = base + protection + accessories;
    });
  }

  Widget _styledBox({required Widget child}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(PaymentUiNotifierProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (_loadingAmount) {
      return const Scaffold(
        appBar: CustomAppBar(title: " Cargá adicionales"),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final baseImporte = widget.reservation.days * loadedCar.precio;
    final protectionImporte =
        PaymentPriceRules.protectionPrices[ui.protection] ?? 0;
    final accessoriesImporte =
        PaymentPriceRules.accessoriesPrices[ui.accessories] ?? 0;

    return Scaffold(
      appBar: const CustomAppBar(title: " Adicionales"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // ---------------- PROTECCIÓN ----------------
              _styledBox(
                child: Theme(
                  data:
                      Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    iconColor: colorScheme.primary,
                    collapsedIconColor: colorScheme.primary,
                    title: Text(
                      "Protección",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary),
                    ),
                    subtitle: Text(ui.protection.name),
                    children: Protection.values.map((p) {
                      final extra = PaymentPriceRules.protectionPrices[p]!;
                      return RadioListTile(
                        title: Text(
                          "${p.name.replaceAll("_", " ")}  (+\$${numberFormat.format(extra)})",
                        ),
                        value: p,
                        groupValue: ui.protection,
                        onChanged: (_) {
                          ref
                              .read(PaymentUiNotifierProvider.notifier)
                              .setProtection(p);
                          _recalculate();
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ---------------- ACCESORIOS ----------------
              _styledBox(
                child: Theme(
                  data:
                      Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    iconColor: colorScheme.primary,
                    collapsedIconColor: colorScheme.primary,
                    title: Text(
                      "Accesorios",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary),
                    ),
                    subtitle: Text(ui.accessories.name),
                    children: Accesories.values.map((a) {
                      final extra = PaymentPriceRules.accessoriesPrices[a]!;
                      return RadioListTile(
                        title: Text(
                          "${a.name.replaceAll("_", " ")}  (+\$${numberFormat.format(extra)})",
                        ),
                        value: a,
                        groupValue: ui.accessories,
                        onChanged: (_) {
                          ref
                              .read(PaymentUiNotifierProvider.notifier)
                              .setAccessories(a);
                          _recalculate();
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // ---------------- DESGLOSE ----------------
              _styledBox(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Desglose del importe",
                          // style: Theme.of(context).textTheme.titleMedium),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary),
                      ),
                      const SizedBox(height: 12),
                      Text(
                          "Precio base (${widget.reservation.days} días): \$${numberFormat.format(baseImporte)}"),
                      Text(
                          "Protección: \$${numberFormat.format(protectionImporte)}"),
                      Text(
                          "Accesorios: \$${numberFormat.format(accessoriesImporte)}"),
                      // const SizedBox(height: 12),
                      // Divider(color: colorScheme.primary),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // ---------------- TOTAL A PAGAR ----------------
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  border: Border.all(
                    color: colorScheme.onPrimaryContainer,
                    width: 2,
                  ),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(999),
                    right: Radius.circular(999),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  "Total a pagar: \$${numberFormat.format(totalAmount)}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // ---------------- BOTÓN PAGAR ----------------
              FilledButton(
                onPressed: _loading
                    ? null
                    : () async {
                        setState(() => _loading = true);

                        final fbUser = fb.FirebaseAuth.instance.currentUser;
                        if (fbUser == null) {
                          setState(() => _loading = false);
                          return;
                        }

                        final payment = Payment(
                          id: "",
                          userId: fbUser.uid,
                          carId: widget.reservation.carId,
                          reservationId: widget.reservation.id,
                          amount: totalAmount,
                          status: "Aprobado",
                          timestamp: "",
                          protection: ui.protection.name,
                          accesories: ui.accessories.name,
                        );

                        await ref
                            .read(PaymentNotifierProvider.notifier)
                            .addPayment(payment);

                        await ref
                            .read(ReservationNotifierProvider.notifier)
                            .updateReservationStatus(
                                widget.reservation.id, "Pagado");

                        ref.read(PaymentUiNotifierProvider.notifier).reset();

                        if (!mounted) return;

                        context.push('/final_screen', extra: {
                          'car': loadedCar,
                          'reservation': widget.reservation,
                          'payment': payment,
                        });
                      },
                style: FilledButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  backgroundColor: colorScheme.primary,
                ),
                child: _loading
                    ? CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation(colorScheme.onPrimary))
                    : Text(
                        "Pagar",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                                color: colorScheme.onPrimary,
                                fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------------------------------------

// import 'package:app_car_rental/domain/car.dart';
// import 'package:app_car_rental/domain/enums/payment_enums.dart';
// import 'package:app_car_rental/domain/payment.dart';
// import 'package:app_car_rental/domain/reservation.dart';
// import 'package:app_car_rental/domain/payment_price_rules.dart';
// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:app_car_rental/presentation/providers/payment_ui_provider.dart';
// import 'package:app_car_rental/presentation/providers/payments_provider.dart';
// import 'package:app_car_rental/presentation/providers/reservations_provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart' as fb;
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';

// class AddPaymentScreen extends ConsumerStatefulWidget {
//   final Reservation reservation;

//   const AddPaymentScreen(this.reservation, {super.key});

//   @override
//   ConsumerState<AddPaymentScreen> createState() => _AddPaymentScreenState();
// }

// class _AddPaymentScreenState extends ConsumerState<AddPaymentScreen> {
//   final _formKey = GlobalKey<FormState>();

//   bool _loading = false;
//   bool _loadingAmount = true;
//   int totalAmount = 0;

//   late Car loadedCar;

//   final NumberFormat numberFormat = NumberFormat('#,##0', 'es_AR');
//   //  final colorScheme = Theme.of(context).colorScheme;

//   @override
//   void initState() {
//     super.initState();
//     _loadCarAndCalculateAmount();
//   }

//   Future<void> _loadCarAndCalculateAmount() async {
//     final r = widget.reservation;

//     final doc = await FirebaseFirestore.instance
//         .collection('cars')
//         .doc(r.carId)
//         .get();

//     loadedCar = Car.fromFirestore(doc, null);

//     _recalculate();
//     setState(() => _loadingAmount = false);
//   }

//   void _recalculate() {
//     final ui = ref.read(PaymentUiNotifierProvider);

//     final base = widget.reservation.days * loadedCar.precio;

//     final protection =
//         PaymentPriceRules.protectionPrices[ui.protection] ?? 0;

//     final accessories =
//         PaymentPriceRules.accessoriesPrices[ui.accessories] ?? 0;

//     setState(() {
//       totalAmount = base + protection + accessories;
//     });
//   }

//   Widget _styledBox({required Widget child}) {
//     return Container(
//       width: MediaQuery.of(context).size.width * 0.85,
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.surface,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Theme.of(context).shadowColor.withOpacity(0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final ui = ref.watch(PaymentUiNotifierProvider);

//     if (_loadingAmount) {
//       return Scaffold(
//         appBar: const CustomAppBar(title: "Car Rent"),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }

//     final baseImporte = widget.reservation.days * loadedCar.precio;
//     final protectionImporte =
//         PaymentPriceRules.protectionPrices[ui.protection] ?? 0;
//     final accessoriesImporte =
//         PaymentPriceRules.accessoriesPrices[ui.accessories] ?? 0;

//     final colorScheme = Theme.of(context).colorScheme;

//     return Scaffold(
//       appBar: const CustomAppBar(title: "Car Rent"),

//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [

//               // ---------------- PROTECCIÓN ----------------
//               _styledBox(
//                 child: Theme(
//                   data: Theme.of(context).copyWith(
//                       dividerColor: Colors.transparent),
//                   child: ExpansionTile(
//                     tilePadding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 8),
//                     iconColor: Theme.of(context).colorScheme.primary,
//                     collapsedIconColor:
//                         Theme.of(context).colorScheme.primary,

//                     title: Text(
//                       "Protección",
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           color: Theme.of(context).colorScheme.primary),
//                     ),
//                     subtitle: Text(ui.protection.name),

//                     children: Protection.values.map((p) {
//                       final extra =
//                           PaymentPriceRules.protectionPrices[p]!;
//                       return RadioListTile(
//                         title: Text(
//                           "${p.name.replaceAll("_", " ")}   (+\$${numberFormat.format(extra)})",
//                         ),
//                         value: p,
//                         groupValue: ui.protection,
//                         onChanged: (value) {
//                           ref.read(PaymentUiNotifierProvider.notifier)
//                               .setProtection(p);
//                           _recalculate();
//                         },
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 40),

//               // ---------------- ACCESORIOS ----------------
//               _styledBox(
//                 child: Theme(
//                   data: Theme.of(context).copyWith(
//                       dividerColor: Colors.transparent),
//                   child: ExpansionTile(
//                     tilePadding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 8),
//                     iconColor: Theme.of(context).colorScheme.primary,
//                     collapsedIconColor:
//                         Theme.of(context).colorScheme.primary,

//                     title: Text(
//                       "Accesorios",
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                           color: Theme.of(context).colorScheme.primary),
//                     ),
//                     subtitle: Text(ui.accessories.name),

//                     children: Accesories.values.map((a) {
//                       final extra =
//                           PaymentPriceRules.accessoriesPrices[a]!;
//                       return RadioListTile(
//                         title: Text(
//                           "${a.name.replaceAll("_", " ")}   (+\$${numberFormat.format(extra)})",
//                         ),
//                         value: a,
//                         groupValue: ui.accessories,
//                         onChanged: (value) {
//                           ref.read(PaymentUiNotifierProvider.notifier)
//                               .setAccessories(a);
//                           _recalculate();
//                         },
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 60),

//               // ---------------- DESGLOSE ----------------
//               _styledBox(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Desglose del importe",
//                           style: Theme.of(context).textTheme.titleMedium),

//                       const SizedBox(height: 12),

//                       Text("Precio base (${widget.reservation.days} días): "
//                           "\$${numberFormat.format(baseImporte)}"),

//                       Text("Protección: "
//                           "\$${numberFormat.format(protectionImporte)}"),

//                       Text("Accesorios: "
//                           "\$${numberFormat.format(accessoriesImporte)}"),

//                       const SizedBox(height: 12),

//                       Divider(color: Theme.of(context)
//                           .colorScheme
//                           .primary),

//                       const SizedBox(height: 20),

//               //         Text(
//               //           "TOTAL: \$${numberFormat.format(totalAmount)}",
//               //           style: Theme.of(context).textTheme.titleLarge?.copyWith(
//               //                 fontWeight: FontWeight.bold,
//               //                 color:
//               //                     Theme.of(context).colorScheme.primary,
//               //               ),
//               //         ),
//               //       ],
//               //     ),
//               //   ),
//               // ),
//             // ]



//               // ------------------- TOTAL A PAGAR -------------------
 

//   Container(
//     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//     decoration: BoxDecoration(
//       color: colorScheme.primaryContainer,
//       border: Border.all(
//         color: colorScheme.onPrimaryContainer,
//         width: 2,
//       ),
//       borderRadius: const BorderRadius.horizontal(
//         left: Radius.circular(999),
//         right: Radius.circular(999),
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: Theme.of(context).shadowColor.withOpacity(0.1),
//           blurRadius: 4,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Text(
//       'Total a pagar: \$${numberFormat.format(totalAmount)}',
//       textAlign: TextAlign.center,
//       style: TextStyle(
//         color: colorScheme.onPrimaryContainer,
//         fontWeight: FontWeight.bold,
//         fontSize: 20,
//       ),
//     ),
//   ),


//               const SizedBox(height: 80),







              

//               // // ---------------- BOTÓN PAGAR ----------------
//               // FilledButton(
//               //   onPressed: _loading
//               //       ? null
//               //       : () async {
//               //           if (!_formKey.currentState!.validate()) return;

//               //           setState(() => _loading = true);

//               //           final user = fb.FirebaseAuth.instance.currentUser;

//               //           if (user == null) {
//               //             setState(() => _loading = false);
//               //             return;
//               //           }

//               //           final payment = Payment(
//               //             id: "",
//               //             userId: user.uid,
//               //             carId: widget.reservation.carId,
//               //             reservationId: widget.reservation.id,
//               //             amount: totalAmount,
//               //             status: "Aprobado",
//               //             timestamp: "",
//               //             protection: ui.protection.name,
//               //             accesories: ui.accessories.name,
//               //           );

//               //           await ref
//               //               .read(PaymentNotifierProvider.notifier)
//               //               .addPayment(payment);

//               //           await ref
//               //               .read(ReservationNotifierProvider.notifier)
//               //               .updateReservationStatus(
//               //                   widget.reservation.id, "Pagado");

//               //           ref.read(PaymentUiNotifierProvider.notifier).reset();

//               //           if (!mounted) return;

//               //           context.push('/final_screen', extra: {
//               //             'car': loadedCar,
//               //             'reservation': widget.reservation,
//               //             'payment': payment,
//               //           });
//               //         },
//               //   style: FilledButton.styleFrom(
//               //     padding: const EdgeInsets.symmetric(
//               //         horizontal: 24, vertical: 16),
//               //     shape: RoundedRectangleBorder(
//               //       borderRadius: BorderRadius.circular(999),
//               //     ),
//               //     backgroundColor:
//               //         Theme.of(context).colorScheme.primary,
//               //   ),
//               //   child: _loading
//               //       ? CircularProgressIndicator(
//               //           valueColor: AlwaysStoppedAnimation(
//               //             Theme.of(context).colorScheme.onPrimary,
//               //           ),
//               //         )
//               //       : Text(
//               //           "Pagar",
//               //           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//               //               color: Theme.of(context)
//               //                   .colorScheme
//               //                   .onPrimary,
//               //               fontWeight: FontWeight.bold),
//               //         ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//             ],
            
//                       ),
//         ),
//       ),
      
//     );
//   }
// }



// -------------------------------------------------------------------------

// // import 'package:app_car_rental/domain/car.dart';
// import 'package:app_car_rental/domain/car.dart';
// import 'package:app_car_rental/domain/enums/payment_enums.dart';
// import 'package:app_car_rental/domain/payment.dart';
// import 'package:app_car_rental/domain/reservation.dart';
// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:app_car_rental/presentation/providers/payment_ui_provider.dart';
// import 'package:app_car_rental/presentation/providers/payments_provider.dart';
// import 'package:app_car_rental/presentation/providers/reservations_provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart' as fb;
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';

// // enum Protection {
// //   todo_riesgo_sin_franquicia,
// //   todo_riesgo_con_franquicia,
// //   terceros
// // }

// // enum Accesories {
// //   wifi_y_auxilio_mecanico,
// //   wifi,
// //   auxilio_mecanico,
// // }

// class AddPaymentScreen extends ConsumerStatefulWidget {
//   // final Car car;
//   // final Car? car;
//   // const ReservationScreen({super.key, required this.car});
//   final Reservation reservation; // 👈 recibe la reserva desde AddReservationScreen
  

//   const AddPaymentScreen(this.reservation,{super.key});

//   @override
//   ConsumerState<AddPaymentScreen> createState() => _AddPaymentScreenState();

//   // @override
//   // Widget build(BuildContext context) {
//   //   // return _ReservationScreenView(car: car);
//   //   return _AddPaymentScreenView();
//   // }
// }

// class _AddPaymentScreenState extends ConsumerState<AddPaymentScreen> {

//   // Protection? selectedProtection = Protection.todo_riesgo_sin_franquicia;
//   // Accesories? selectedAccesories = Accesories.wifi_y_auxilio_mecanico;

//   final _formKey = GlobalKey<FormState>();
//   // final _protectionCtrl = TextEditingController();
//   // final _wifiCtrl = TextEditingController();

//   bool _loading = false;
//   String? _error;

//   int totalAmount = 0; // MONTO TOTAL CALCULADO (visible en el widget)
//   bool _loadingAmount = true;





//   @override
//     void initState() {
//       super.initState();
//       _loadCarAndCalculateAmount();
//     }

//   //   Future<void> _loadCarAndCalculateAmount() async {
//   //     final r = widget.reservation;

//   //     final carDoc = await FirebaseFirestore.instance
//   //         .collection('cars')
//   //         .doc(r.carId)
//   //         .get();

//   //     final car = Car.fromFirestore(carDoc, null);

//   //     setState(() {
//   //       totalAmount = r.days * car.precio;
//   //     });
//   //   }


// Future<void> _loadCarAndCalculateAmount() async {
//   final r = widget.reservation;

//   final carDoc = await FirebaseFirestore.instance
//       .collection('cars')
//       .doc(r.carId)
//       .get();

//   final car = Car.fromFirestore(carDoc, null);

//   setState(() {
//     totalAmount = r.days * car.precio;
//     _loadingAmount = false;
//   });
// }






//   @override
//   Widget build(BuildContext context) {

//     final ui = ref.watch(PaymentUiNotifierProvider);

//     // loader inicial
//   if (_loadingAmount) {
//     return Scaffold(
//       appBar: const CustomAppBar(title: 'Car Rent'),
//       body: const Center(child: CircularProgressIndicator()),
//     );
//   }

//     // final textStyle = Theme.of(context).textTheme;
//     final colorScheme = Theme.of(context).colorScheme;

//     // ✅ Definimos el formateador acá
//     final NumberFormat formatNumber = NumberFormat('#,##0', 'es_AR');

//     final reservation = widget.reservation;
    

//     // 1️⃣ Calcular el monto total
//     // final totalAmount = reservation.days * car.precio;
//      if (totalAmount == 0) {
//       return const Center(child: CircularProgressIndicator());
// }
             
                   
//     // final car = widget.car; // 👈 obtiene el auto desde el widget
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

//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [

//             //   ExpansionTile(
//             //     title: const Text('Protección'),
//             //     // subtitle: Text('${selectedProtection?.name}'),
//             //     subtitle: Text(ui.protection.name),
//             //        children: Protection.values.map((p) {
//             //         return RadioListTile(
//             //           title: Text(p.name.replaceAll("_", " ").toUpperCase()),
//             //           value: p,
//             //           groupValue: ui.protection,
//             //           // onChanged: (v) => ref.read(PaymentUiNotifierProvider.notifier).setProtection(v!),
//             //           onChanged: (v) => ref.read(PaymentUiNotifierProvider.notifier).setProtection(p),
//             //         );
//             //     }).toList(),
//             //   ),

//             //   const SizedBox(height: 60),


//             //   ExpansionTile(
//             //   title: const Text("Accesorios"),
//             //   subtitle: Text(ui.accessories.name),
//             //   children: Accesories.values.map((a) {
//             //     return RadioListTile(
//             //       // title: Text(a.name.replaceAll("_", " ").toUpperCase()),
//             //       title: Text(a.name.replaceAll("_", " ")),
//             //       value: a,
//             //       groupValue: ui.accessories,
//             //       // onChanged: (v) => ref.read(PaymentUiNotifierProvider.notifier).setAccessories(v!),
//             //       onChanged: (v) => ref.read(PaymentUiNotifierProvider.notifier).setAccessories(a),
//             //     );
//             //   }).toList(),
//             // ),





//             //     // children: [
//             //     //   RadioListTile(
//             //     //     title: const Text('Todo Riesgo Sin Franquicia'),
//             //     //     value: Protection.todo_riesgo_sin_franquicia,
//             //     //     groupValue: selectedProtection,
//             //     //     onChanged: (value) {
//             //     //       setState(() {
//             //     //         selectedProtection = value;
//             //     //       });
//             //     //     },
                  

//             //       // RadioListTile(
//             //       //   title: const Text('Todo Riesgo Con Franquicia'),
//             //       //   value: Protection.todo_riesgo_con_franquicia,
//             //       //   groupValue: selectedProtection,
//             //       //   onChanged: (value) {
//             //       //     setState(() {
//             //       //       selectedProtection = value;
//             //       //     });
//             //       //   },
//             //       // ),
//             //       // RadioListTile(
//             //       //   title: const Text('Terceros'),
//             //       //   value: Protection.terceros,
//             //       //   groupValue: selectedProtection,
//             //       //   onChanged: (value) {
//             //       //     setState(() {
//             //       //       selectedProtection = value;
//             //       //     });
//             //       //   },
//             //       // ),
//             //   //   ],
//             //   // ),

//             //   // const SizedBox(height: 60),

//             //   // ExpansionTile(
//             //   //   title: const Text('Accesorios'),
//             //   //   subtitle: Text('${selectedAccesories?.name}'),
//             //   //   children: [
//             //   //     RadioListTile(
//             //   //       title: const Text('Wi-Fi y Auxilio Mecánico'),
//             //   //       value: Accesories.wifi_y_auxilio_mecanico,
//             //   //       groupValue: selectedAccesories,
//             //   //       onChanged: (value) {
//             //   //         setState(() {
//             //   //           selectedAccesories = value;
//             //   //         });
//             //   //       },
//             //   //     ),
//             //   //     RadioListTile(
//             //   //       title: const Text('Solo Wi-Fi'),
//             //   //       value: Accesories.wifi,
//             //   //       groupValue: selectedAccesories,
//             //   //       onChanged: (value) {
//             //   //         setState(() {
//             //   //           selectedAccesories = value;
//             //   //         });
//             //   //       },
//             //   //     ),
//             //   //     RadioListTile(
//             //   //       title: const Text('Solo Auxilio Mecánico'),
//             //   //       value: Accesories.auxilio_mecanico,
//             //   //       groupValue: selectedAccesories,
//             //   //       onChanged: (value) {
//             //   //         setState(() {
//             //   //           selectedAccesories = value;
//             //   //         });
//             //   //       },
//             //   //     ),
//             //   //   ],
//             //   // ),

//             //   // const SizedBox(height: 20),

//             //   // if (_error != null)
//             //   //   Text(
//             //   //     _error!,
//             //   //     style: const TextStyle(color: Colors.red, fontSize: 14),
//             //   //   ),

//             //   // const SizedBox(height: 12),

 
              
//             //   const SizedBox(height: 120),

//             //   Container(
//             //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             //     decoration: BoxDecoration(
//             //       // color: colorScheme.primary, // 🎨 fondo según el tema
//             //       color: colorScheme.primaryContainer, // 🎨 fondo según el tema
//             //       border: Border.all(
//             //         color: colorScheme.onPrimaryContainer, // 🎨 borde que contraste
//             //         width: 2,
//             //       ),
//             //       // borderRadius: BorderRadius.circular(16),

//             //       borderRadius: const BorderRadius.horizontal(
//             //         left: Radius.circular(999),
//             //         right: Radius.circular(999),
//             //       ),
//             //     ),
//             //     child: Text(
//             //       textAlign: TextAlign.center,
//             //       '\$ ${formatNumber.format(totalAmount)}.- importe final a pagar',
//             //       style: TextStyle(
//             //         color: colorScheme.onPrimaryContainer, // 🎨 texto según el tema
//             //         fontWeight: FontWeight.bold,
//             //         fontSize: 18,
//             //       ),
//             //     ),
//             //   ),



//               // ------------------- PROTECCIÓN -------------------
// SizedBox(
//   width: MediaQuery.of(context).size.width * 0.75,
//   child: Container(
//     decoration: BoxDecoration(
//       color: Theme.of(context).colorScheme.surface,
//       borderRadius: BorderRadius.circular(14),
//       border: Border.all(
//         color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: Theme.of(context).shadowColor.withOpacity(0.1),
//           blurRadius: 4,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Theme(
//       data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//       child: ExpansionTile(
//         tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         iconColor: Theme.of(context).colorScheme.primary,
//         collapsedIconColor: Theme.of(context).colorScheme.primary,

//         title: Text(
//           'Protección',
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//         ),

//         subtitle: Text(
//           ui.protection.name.replaceAll("_", " "),
//           style: Theme.of(context).textTheme.bodyMedium,
//         ),

//         children: Protection.values.map((p) {
//           return RadioListTile(
//             title: Text(
//               p.name.replaceAll("_", " "),
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             value: p,
//             groupValue: ui.protection,
//             activeColor: Theme.of(context).colorScheme.primary,
//             onChanged: (value) {
//               ref.read(PaymentUiNotifierProvider.notifier).setProtection(p);
//             },
//           );
//         }).toList(),
//       ),
//     ),
//   ),
// ),

// const SizedBox(height: 60),

// // ------------------- ACCESORIOS -------------------
// SizedBox(
//   width: MediaQuery.of(context).size.width * 0.75,
//   child: Container(
//     decoration: BoxDecoration(
//       color: Theme.of(context).colorScheme.surface,
//       borderRadius: BorderRadius.circular(14),
//       border: Border.all(
//         color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
//       ),
//       boxShadow: [
//         BoxShadow(
//           color: Theme.of(context).shadowColor.withOpacity(0.1),
//           blurRadius: 4,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     ),
//     child: Theme(
//       data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//       child: ExpansionTile(
//         tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         iconColor: Theme.of(context).colorScheme.primary,
//         collapsedIconColor: Theme.of(context).colorScheme.primary,

//         title: Text(
//           'Accesorios',
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//         ),

//         subtitle: Text(
//           ui.accessories.name.replaceAll("_", " "),
//           style: Theme.of(context).textTheme.bodyMedium,
//         ),

//         children: Accesories.values.map((a) {
//           return RadioListTile(
//             title: Text(
//               a.name.replaceAll("_", " "),
//               style: Theme.of(context).textTheme.bodyMedium,
//             ),
//             value: a,
//             groupValue: ui.accessories,
//             activeColor: Theme.of(context).colorScheme.primary,
//             onChanged: (value) {
//               ref.read(PaymentUiNotifierProvider.notifier).setAccessories(a);
//             },
//           );
//         }).toList(),
//       ),
//     ),
//   ),
// ),

              
              
              
//               const SizedBox(height: 80),
              
              
              

//              FilledButton(
//               onPressed: _loading
//                   ? null
//                   : () async {
//                       if (!_formKey.currentState!.validate()) return;

//                       setState(() {
//                         _loading = true;
//                         _error = null;
//                       });

//                       final currentUser = fb.FirebaseAuth.instance.currentUser;

//                       if (currentUser == null) {
//                         setState(() {
//                           _error = 'Debes iniciar sesión para pagar una reserva.';
//                           _loading = false;
//                         });
//                         return;
//                       }

//                       final newPayment = Payment(
//                         id: '',
//                         userId: currentUser.uid,
//                         carId: reservation.carId,
//                         reservationId: reservation.id,
//                         amount: totalAmount,
//                         status: 'Aprobado',
//                         timestamp: '',
//                         protection: ui.protection.name,
//                         accesories: ui.accessories.name,
//                       );

//                       final paymentNotifier =
//                           ref.read(PaymentNotifierProvider.notifier);

//                       final err = await paymentNotifier.addPayment(newPayment);

//                       if (err != null) {
//                         setState(() {
//                           _error = err;
//                           _loading = false;
//                         });
//                         return;
//                       }

//                       await ref
//                           .read(ReservationNotifierProvider.notifier)
//                           .updateReservationStatus(reservation.id, "Pagado");

//                       reservation.status = "Pagado";

//                       final carDoc = await FirebaseFirestore.instance
//                           .collection("cars")
//                           .doc(reservation.carId)
//                           .get();

//                       final car = Car.fromFirestore(carDoc, null);

//                       if (!mounted) return;

//                       ref.read(PaymentUiNotifierProvider.notifier).reset();

//                       context.push(
//                         '/final_screen',
//                         extra: {
//                           'car': car,
//                           'reservation': reservation,
//                           'payment': newPayment,
//                         },
//                       );
//                     },
//               style: FilledButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(999),
//                 ),
//                 backgroundColor: Theme.of(context).colorScheme.primary,
//               ),
//               child: _loading
//                   ? SizedBox(
//                       width: 22,
//                       height: 22,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2.5,
//                         valueColor: AlwaysStoppedAnimation(
//                           Theme.of(context).colorScheme.onPrimary,
//                         ),
//                       ),
//                     )
//                   : Text(
//                       'Pagar',
//                       style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                             color: Theme.of(context).colorScheme.onPrimary,
//                             fontWeight: FontWeight.bold,
//                           ),
//                     ),
//                   ),          







//             ],
//     ),
//     ),
//       ),
//           );
//       //   ),
//       // ),


//       // body: const Center(
//       //   child: Text('Aquí se mostrará el formulario para reservar'),
//       // ),
//     // );
//   }

// }



