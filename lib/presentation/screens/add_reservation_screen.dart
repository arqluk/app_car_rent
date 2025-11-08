import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/reservation.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/reservations_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum PaymentMethod {
  creditCard,
  debitCard,
  bankTransfer,
  cash,
}

class AddReservationScreen extends ConsumerStatefulWidget {
  final Car car;

  const AddReservationScreen(this.car, {super.key});

  @override
  ConsumerState<AddReservationScreen> createState() =>
      _AddReservationScreenState();
}

class _AddReservationScreenState
    extends ConsumerState<AddReservationScreen> {
  final _formKey = GlobalKey<FormState>();

  PaymentMethod? selectedPaymentMethod = PaymentMethod.creditCard;
  int? selectedDays;

  bool _loading = false;
  String? _error;

  @override
Widget build(BuildContext context) {
  final car = widget.car;

  return Scaffold(
    appBar: const CustomAppBar(title: 'Car Rent'),

    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [

            // ---------------- MÉTODO DE PAGO ----------------
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Container(
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
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    iconColor: Theme.of(context).colorScheme.primary,
                    collapsedIconColor: Theme.of(context).colorScheme.primary,

                    title: Text(
                      'Método de Pago',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    subtitle: Text(
                      selectedPaymentMethod?.name ?? '',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    children: [
                      RadioListTile(
                        title: const Text('Tarjeta de Crédito'),
                        value: PaymentMethod.creditCard,
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) => setState(() => selectedPaymentMethod = value),
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                      RadioListTile(
                        title: const Text('Tarjeta de Débito'),
                        value: PaymentMethod.debitCard,
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) => setState(() => selectedPaymentMethod = value),
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                      RadioListTile(
                        title: const Text('Transferencia Bancaria'),
                        value: PaymentMethod.bankTransfer,
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) => setState(() => selectedPaymentMethod = value),
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                      RadioListTile(
                        title: const Text('Efectivo'),
                        value: PaymentMethod.cash,
                        groupValue: selectedPaymentMethod,
                        onChanged: (value) => setState(() => selectedPaymentMethod = value),
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 80),

            // ---------------- CANTIDAD DE DÍAS ----------------
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: Container(
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
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    iconColor: Theme.of(context).colorScheme.primary,
                    collapsedIconColor: Theme.of(context).colorScheme.primary,

                    title: Text(
                      'Cantidad de días',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    subtitle: Text(
                      selectedDays == null
                          ? 'Seleccione días'
                          : '$selectedDays día${selectedDays! > 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    children: [
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: 60,
                          itemBuilder: (context, i) {
                            final day = i + 1;
                            return RadioListTile<int>(
                              title: Text(
                                '$day día${day > 1 ? 's' : ''}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              value: day,
                              groupValue: selectedDays,
                              activeColor: Theme.of(context).colorScheme.primary,
                              onChanged: (value) {
                                setState(() => selectedDays = value);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 120),

            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 20),

            // ---------------- BOTÓN RESERVAR ----------------
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
                          _error = 'Debes iniciar sesión para reservar un auto.';
                          _loading = false;
                        });
                        return;
                      }

                      final notifier = ref.read(ReservationNotifierProvider.notifier);

                      final newReservation = Reservation(
                        id: '',
                        userId: currentUser.uid,
                        carId: car.id,
                        status: 'pending',
                        paymentMethod: selectedPaymentMethod!.name,
                        days: selectedDays ?? 0,
                      );

                      final err = await notifier.addReservation(newReservation);

                      setState(() => _loading = false);

                      if (err == null) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Reserva realizada con éxito')),
                          );
                          context.push('/add_payment_screen', extra: newReservation);
                        }
                      } else {
                        setState(() => _error = err);
                      }
                    },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: _loading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                    )
                  : Text(
                      'Reservar',
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
}
}

// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// // import 'package:app_car_rental/domain/car.dart';
// import 'package:app_car_rental/domain/car.dart';
// import 'package:app_car_rental/domain/reservation.dart';
// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:app_car_rental/presentation/providers/reservations_provider.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:firebase_auth/firebase_auth.dart' as fb;
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';


// enum PaymentMethod {
//   creditCard,
//   debitCard,
//   bankTransfer,
//   cash,
// }

// class AddReservationScreen extends ConsumerStatefulWidget {
//   final Car car;  // 👈 recibe el auto desde CarDetailScreen
//   // final Car? car;
//   // const AddReservationScreen(Car car, {super.key, required this.car});
//   const AddReservationScreen(this.car, {super.key});

//   @override
//   ConsumerState<AddReservationScreen> createState() => _AddReservationScreenState();
// }

// // class _AddReservationScreenState extends ConsumerState<AddReservationScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return _AddReservationScreenView();
// //   }
// // }

// class _AddReservationScreenState extends ConsumerState<AddReservationScreen>  {

//   PaymentMethod? selectedPaymentMethod = PaymentMethod.creditCard;
//   // int selectedPaymentMethod;

//   final _formKey = GlobalKey<FormState>();
//   // final _payMethodCtrl = TextEditingController();
//   final _daysCtrl = TextEditingController();
//   // final _brandCtrl = TextEditingController();
//   // // final _phoneCtrl = TextEditingController();
//   // final _modelCtrl = TextEditingController();
//   // final _colorCtrl = TextEditingController();
//   // final _capacityCtrl = TextEditingController();
//   // final _luggageCtrl = TextEditingController();
//   // final _automaticCtrl = TextEditingController();
//   // final _airCtrl = TextEditingController();
//   // final _priceCtrl = TextEditingController();
//   // final _imageUrlCtrl = TextEditingController();

//   int? selectedDays; // 👈 agregalo arriba en tu State



//   bool _loading = false;
//   String? _error;

//   @override
//   Widget build(BuildContext context) {
//     final car = widget.car;  // 👈 obtiene el auto desde el widget
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

//               // ExpansionTile(
//               //   title: const Text('Método de Pago'),
//               //   subtitle: Text('${selectedPaymentMethod?.name}'),
//               //   children: [
//               //     RadioListTile(
//               //       title: const Text('Tarjeta de Crédito'),
//               //       value: PaymentMethod.creditCard,
//               //       groupValue: selectedPaymentMethod,
//               //       onChanged: (value) {
//               //         selectedPaymentMethod = value;
//               //         setState(() {});
//               //       },
//               //     ),
//               //     RadioListTile(
//               //       title: const Text('Tarjeta de Débito'),
//               //       value: PaymentMethod.debitCard,
//               //       groupValue: selectedPaymentMethod,
//               //       onChanged: (value) {
//               //         selectedPaymentMethod = value;
//               //         setState(() {});
//               //       },
//               //     ),
//               //     RadioListTile(
//               //       title: const Text('Transferencia Bancaria'),
//               //       value: PaymentMethod.bankTransfer,
//               //       groupValue: selectedPaymentMethod,
//               //       onChanged: (value) {
//               //         selectedPaymentMethod = value;
//               //         setState(() {});
//               //       },
//               //     ),
//               //     RadioListTile(
//               //       title: const Text('Efectivo'),
//               //       value: PaymentMethod.cash,
//               //       groupValue: selectedPaymentMethod,
//               //       onChanged: (value) {
//               //         selectedPaymentMethod = value;
//               //         setState(() {});
//               //       },
//               //     ),
//               //   ],
//               // ),

//               // RadioListTile(
//               //   title: const Text('Tarjeta de Crédito'),
//               //   // value: 'Tarjeta de Crédito',
//               //   // value: PaymentMethod.creditCard.name,
//               //   value: PaymentMethod.creditCard,
//               //   // groupValue: _payMethodCtrl.text,
//               //   // ignore: deprecated_member_use
//               //   // groupValue: _selectedPaymentMethod?.name,
//               //   groupValue: selectedPaymentMethod,
//               //   onChanged: (value) {
//               //     // _selectedPaymentMethod = PaymentMethod.values.firstWhere((e) => e.name == value);
//               //     selectedPaymentMethod = value;
//               //     setState(() {
//               //       // _payMethodCtrl.text = value!;
//               //     });
//               //   },
//               // ),

//               // RadioListTile(
//               //   title: const Text('Tarjeta de Débito'),
//               //   // value: 'Tarjeta de Débito',
//               //   value: PaymentMethod.debitCard,
//               //   groupValue: selectedPaymentMethod,
//               //   onChanged: (value) {
//               //     selectedPaymentMethod = value;
//               //     setState(() {
                    
//               //     });
//               //   },
//               // ),

//               // RadioListTile(
//               //   title: const Text('Transferencia Bancaria'),
//               //   // value: 'Transferencia Bancaria',
//               //   value: PaymentMethod.bankTransfer,
//               //   groupValue: selectedPaymentMethod,
//               //   onChanged: (value) {
//               //     selectedPaymentMethod = value;
//               //     setState(() {
//               //       // _payMethodCtrl.text = value;
//               //     });
//               //   },
//               // ),

//               //    RadioListTile(
//               //   title: const Text('Efectivo'),
//               //   // value: 'Efectivo',
//               //   value: PaymentMethod.cash,
//               //   groupValue: selectedPaymentMethod,
//               //   onChanged: (value) {
//               //     selectedPaymentMethod = value;
//               //     setState(() {
                    
//               //     });
//               //   },
//               // ),
//               // RadioListTile(SizedBox(
//                // TextFormField(
//               //   controller: _payMethodCtrl,
//               //   decoration: const InputDecoration(labelText: 'Método de Pago'),
//               //   validator: (v) =>
//               //       v == null || v.isEmpty ? 'Ingrese el método de pago' : null,
//               // ),


//               SizedBox(
//                   width: MediaQuery.of(context).size.width * 0.75,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.surface,
//                       borderRadius: BorderRadius.circular(14),
//                       border: Border.all(
//                         color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Theme.of(context).shadowColor.withOpacity(0.1),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//                     ),
//                     child: Theme(
//                       data: Theme.of(context).copyWith(
//                         dividerColor: Colors.transparent,   // saca línea fea del ExpansionTile
//                       ),
//                       child: ExpansionTile(
//                         tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                         childrenPadding: const EdgeInsets.only(bottom: 12),

//                         iconColor: Theme.of(context).colorScheme.primary,
//                         collapsedIconColor: Theme.of(context).colorScheme.primary,

//                         title: Text(
//                           'Método de Pago',
//                           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                                 color: Theme.of(context).colorScheme.primary,
//                               ),
//                         ),

//                         subtitle: Text(
//                           selectedPaymentMethod?.name ?? '',
//                           style: Theme.of(context).textTheme.bodyMedium,
//                         ),

//                         children: [
//                           RadioListTile(
//                             title: const Text('Tarjeta de Crédito'),
//                             value: PaymentMethod.creditCard,
//                             groupValue: selectedPaymentMethod,
//                             activeColor: Theme.of(context).colorScheme.primary,
//                             onChanged: (value) {
//                               setState(() => selectedPaymentMethod = value);
//                             },
//                           ),
//                           RadioListTile(
//                             title: const Text('Tarjeta de Débito'),
//                             value: PaymentMethod.debitCard,
//                             groupValue: selectedPaymentMethod,
//                             activeColor: Theme.of(context).colorScheme.primary,
//                             onChanged: (value) {
//                               setState(() => selectedPaymentMethod = value);
//                             },
//                           ),
//                           RadioListTile(
//                             title: const Text('Transferencia Bancaria'),
//                             value: PaymentMethod.bankTransfer,
//                             groupValue: selectedPaymentMethod,
//                             activeColor: Theme.of(context).colorScheme.primary,
//                             onChanged: (value) {
//                               setState(() => selectedPaymentMethod = value);
//                             },
//                           ),
//                           RadioListTile(
//                             title: const Text('Efectivo'),
//                             value: PaymentMethod.cash,
//                             groupValue: selectedPaymentMethod,
//                             activeColor: Theme.of(context).colorScheme.primary,
//                             onChanged: (value) {
//                               setState(() => selectedPaymentMethod = value);
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),

             

//               const SizedBox(height: 80),

//               // TextFormField(
//               //   controller: _daysCtrl,
//               //   decoration: const InputDecoration(labelText: 'Cantidad de días'),
//               //   validator: (v) =>
//               //       v == null || v.isEmpty ? 'Ingrese la cantidad de días' : null,
//               // ),



//               // DropdownButtonFormField<int>(
//               //   decoration: const InputDecoration(labelText: 'Cantidad de días'),
//               //   value: selectedDays,
//               //   items: List.generate(30, (i) => i + 1)
//               //       .map((day) => DropdownMenuItem(
//               //             value: day,
//               //             child: Text('$day día${day > 1 ? 's' : ''}'),
//               //           ))
//               //       .toList(),
//               //   onChanged: (value) {
//               //     setState(() {
//               //       selectedDays = value;
//               //     });
//               //   },
//               //   validator: (value) =>
//               //       value == null ? 'Seleccione la cantidad de días' : null,
//               // ),



//             // SizedBox(
//             //   width: MediaQuery.of(context).size.width * 0.75,
//             //   child: DropdownButtonFormField<int>(
//             //     value: selectedDays,

//             //     menuMaxHeight: MediaQuery.of(context).size.height * 0.4,

//             //     decoration: InputDecoration(
//             //       labelText: 'Cantidad de días',
//             //       labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
//             //             color: Theme.of(context).colorScheme.primary,
//             //           ),
//             //       prefixIcon: Icon(
//             //         Icons.calendar_month,
//             //         color: Theme.of(context).colorScheme.primary,
//             //       ),
//             //       filled: true,
//             //       fillColor: Theme.of(context).colorScheme.surface,
//             //       border: OutlineInputBorder(
//             //         borderRadius: BorderRadius.circular(14),
//             //       ),
//             //       enabledBorder: OutlineInputBorder(
//             //         borderRadius: BorderRadius.circular(14),
//             //         borderSide: BorderSide(
//             //           color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
//             //         ),
//             //       ),
//             //       focusedBorder: OutlineInputBorder(
//             //         borderRadius: BorderRadius.circular(14),
//             //         borderSide: BorderSide(
//             //           color: Theme.of(context).colorScheme.primary,
//             //           width: 2,
//             //         ),
//             //       ),
//             //     ),

//             //     items: List.generate(30, (i) => i + 1)
//             //         .map((day) => DropdownMenuItem(
//             //               value: day,
//             //               child: Text(
//             //                 '$day día${day > 1 ? 's' : ''}',
//             //                 style: Theme.of(context).textTheme.bodyMedium,
//             //               ),
//             //             ))
//             //         .toList(),

//             //     onChanged: (value) {
//             //       setState(() {
//             //         selectedDays = value;
//             //       });
//             //     },

//             //     validator: (value) =>
//             //         value == null ? 'Seleccione la cantidad de días' : null,
//             //   ),
//             // ),




// //             SizedBox(
// //   width: MediaQuery.of(context).size.width * 0.75,
// //   child: Container(
// //     decoration: BoxDecoration(
// //       color: Theme.of(context).colorScheme.surface,
// //       borderRadius: BorderRadius.circular(14),
// //       border: Border.all(
// //         color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
// //         width: 1.2,
// //       ),
// //       boxShadow: [
// //         BoxShadow(
// //           color: Theme.of(context).shadowColor.withOpacity(0.1),
// //           blurRadius: 4,
// //           offset: const Offset(0, 2),
// //         ),
// //       ],
// //     ),
// //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

// //     child: DropdownButtonFormField<int>(
// //       value: selectedDays,

// //       menuMaxHeight: MediaQuery.of(context).size.height * 0.4,

// //       decoration: InputDecoration(
// //         labelText: 'Cantidad de días',
// //         labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
// //               color: Theme.of(context).colorScheme.primary,
// //             ),
// //         border: InputBorder.none,
// //         prefixIcon: Icon(
// //           Icons.calendar_month,
// //           color: Theme.of(context).colorScheme.primary,
// //         ),
// //       ),

// //       items: List.generate(30, (i) => i + 1)
// //           .map(
// //             (day) => DropdownMenuItem(
// //               value: day,
// //               child: Text(
// //                 '$day día${day > 1 ? 's' : ''}',
// //                 style: Theme.of(context).textTheme.bodyMedium,
// //               ),
// //             ),
// //           )
// //           .toList(),

// //       onChanged: (value) {
// //         setState(() => selectedDays = value);
// //       },

// //       validator: (value) =>
// //           value == null ? 'Seleccione la cantidad de días' : null,
// //     ),
// //   ),
// // )




// // SizedBox(
// //   width: MediaQuery.of(context).size.width * 0.75,
// //   child: Container(
// //     decoration: BoxDecoration(
// //       color: Theme.of(context).colorScheme.surface,
// //       borderRadius: BorderRadius.circular(14),
// //       border: Border.all(
// //         color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
// //         width: 1.2,
// //       ),
// //       boxShadow: [
// //         BoxShadow(
// //           color: Theme.of(context).shadowColor.withOpacity(0.1),
// //           blurRadius: 4,
// //           offset: const Offset(0, 2),
// //         ),
// //       ],
// //     ),
// //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

// //     child: DropdownButtonHideUnderline(
// //       child: DropdownButton2<int>(
// //         value: selectedDays,
// //         isExpanded: true,

// //         // ✅ Menú con el MISMO ancho del widget
// //         dropdownStyleData: DropdownStyleData(
// //           maxHeight: MediaQuery.of(context).size.height * 0.4,
// //           width: MediaQuery.of(context).size.width * 0.75,
// //           decoration: BoxDecoration(
// //             color: Theme.of(context).colorScheme.surface,
// //             borderRadius: BorderRadius.circular(14),
// //             boxShadow: [
// //               BoxShadow(
// //                 color: Theme.of(context).shadowColor.withOpacity(0.15),
// //                 blurRadius: 6,
// //                 offset: const Offset(0, 3),
// //               ),
// //             ],
// //           ),
// //         ),

// //         buttonStyleData: const ButtonStyleData(
// //           padding: EdgeInsets.zero,
// //         ),

// //         hint: Text(
// //           'Cantidad de días',
// //           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
// //                 color: Theme.of(context).colorScheme.primary,
// //               ),
// //         ),

// //         items: List.generate(30, (i) => i + 1)
// //             .map(
// //               (day) => DropdownMenuItem(
// //                 value: day,
// //                 child: Text(
// //                   '$day día${day > 1 ? 's' : ''}',
// //                   style: Theme.of(context).textTheme.bodyMedium,
// //                 ),
// //               ),
// //             )
// //             .toList(),

// //         onChanged: (value) {
// //           setState(() => selectedDays = value);
// //         },
// //       ),
// //     ),
// //   ),
// // )





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
//       data: Theme.of(context).copyWith(
//         dividerColor: Colors.transparent,
//       ),
//       child: ExpansionTile(
//         tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         childrenPadding: const EdgeInsets.only(bottom: 12),

//         iconColor: Theme.of(context).colorScheme.primary,
//         collapsedIconColor: Theme.of(context).colorScheme.primary,

//         title: Text(
//           'Cantidad de días',
//           style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//         ),

//         subtitle: Text(
//           selectedDays == null
//               ? 'Seleccione días'
//               : '$selectedDays día${selectedDays! > 1 ? 's' : ''}',
//           style: Theme.of(context).textTheme.bodyMedium,
//         ),

//         children: [
//           SizedBox(
//             height: 300, // ✅ altura máxima del panel
//             child: ListView.builder(
//               itemCount: 30,
//               itemBuilder: (context, i) {
//                 final day = i + 1;
//                 return RadioListTile<int>(
//                   title: Text(
//                     '$day día${day > 1 ? 's' : ''}',
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                   value: day,
//                   groupValue: selectedDays,
//                   activeColor: Theme.of(context).colorScheme.primary,
//                   onChanged: (value) {
//                     setState(() => selectedDays = value);
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     ),
//   ),
// ),

// ElevatedButton(
//                 onPressed: _loading
//                     ? null
//                     : () async {
//                         if (!_formKey.currentState!.validate()) return;

//                         setState(() {
//                           _loading = true;
//                           _error = null;
//                         });

//                         final notifier =
//                             ref.read(ReservationNotifierProvider.notifier);

//                         // final newReservation = Reservation(
//                         //   id: '', // se asigna automáticamente
//                         //   userId: user.uid,
//                         //   carId: car.id,
//                         //   status: 'pending', // 👈 valor por defecto
//                         //   paymentMethod: _payMethodCtrl.text.trim(),
//                         //   days: int.tryParse(_daysCtrl.text.trim()) ?? 0, 
//                         //   // modelo: _modelCtrl.text.trim(),
//                         //   // // year: int.tryParse(_yearCtrl.text.trim()) ?? 0,
//                         //   // color: _colorCtrl.text.trim(),
//                         //   // capacidad: int.tryParse(_capacityCtrl.text.trim()) ?? 0,
//                         //   // equipaje: int.tryParse(_luggageCtrl.text.trim()) ?? 0,
//                         //   // automatico: _automaticCtrl.text.trim().toLowerCase() == 'true',
//                         //   // aire: _airCtrl.text.trim().toLowerCase() == 'true',
//                         //   // precio: int.tryParse(_priceCtrl.text.trim()) ?? 0,
//                         //   // imageUrl: _imageUrlCtrl.text.trim(),
//                         // );






//                         final currentUser = fb.FirebaseAuth.instance.currentUser;
//                           if (currentUser == null) {
//                             setState(() {
//                               _error = 'Debes iniciar sesión para reservar un auto.';
//                               _loading = false;
//                             });
//                             return;
//                           }

//                           final newReservation = Reservation(
//                             id: '', // se asigna automáticamente en Firestore
//                             userId: currentUser.uid,
//                             carId: car.id,
//                             status: 'pending', // 👈 valor por defecto
//                             // paymentMethod: _payMethodCtrl.text.trim(),
//                             paymentMethod: selectedPaymentMethod!.name,
//                             days: int.tryParse(_daysCtrl.text.trim()) ?? 0,
//                           );










//                         final err = await notifier.addReservation(newReservation);

//                         setState(() => _loading = false);

//                         if (err == null) {
//                           if (mounted) {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                   content: Text('Reserva realizada con éxito')),
//                             );
//                             // context.go('/home_screen');
//                             context.push('/add_payment_screen', extra: newReservation);
//                             // context.push('/add_payment_screen', extra: {
//                             //   'car': car,
//                             //   'reservation': newReservation
//                             //  });
//                           }
//                         } else {
//                           setState(() => _error = err);
//                         }
//                       },
//                 child: _loading
//                     ? const CircularProgressIndicator()
//                     : const Text('Reservar'),
//               ),
//             ],
//           ),
//         ),
//       ),








//             ],
//           );
//     //     ),
//     //   ),


//     //   // body: const Center(
//     //   //   child: Text('Aquí se mostrará el formulario para reservar'),
//     //   // ),
//     // );
//   }
// }




// // -----------------------------------------------------------------------------

// // // import 'package:app_car_rental/domain/car.dart';
// // import 'package:app_car_rental/domain/car.dart';
// // import 'package:app_car_rental/domain/reservation.dart';
// // import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// // import 'package:app_car_rental/presentation/providers/reservations_provider.dart';
// // import 'package:firebase_auth/firebase_auth.dart' as fb;
// // import 'package:flutter/material.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:go_router/go_router.dart';


// // enum PaymentMethod {
// //   creditCard,
// //   debitCard,
// //   bankTransfer,
// //   cash,
// // }

// // class AddReservationScreen extends ConsumerStatefulWidget {
// //   final Car car;  // 👈 recibe el auto desde CarDetailScreen
// //   // final Car? car;
// //   // const AddReservationScreen(Car car, {super.key, required this.car});
// //   const AddReservationScreen(this.car, {super.key});

// //   @override
// //   ConsumerState<AddReservationScreen> createState() => _AddReservationScreenState();
// // }

// // // class _AddReservationScreenState extends ConsumerState<AddReservationScreen> {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return _AddReservationScreenView();
// // //   }
// // // }

// // class _AddReservationScreenState extends ConsumerState<AddReservationScreen>  {

// //   PaymentMethod? selectedPaymentMethod = PaymentMethod.creditCard;
// //   // int selectedPaymentMethod;

// //   final _formKey = GlobalKey<FormState>();
// //   // final _payMethodCtrl = TextEditingController();
// //   final _daysCtrl = TextEditingController();
// //   // final _brandCtrl = TextEditingController();
// //   // // final _phoneCtrl = TextEditingController();
// //   // final _modelCtrl = TextEditingController();
// //   // final _colorCtrl = TextEditingController();
// //   // final _capacityCtrl = TextEditingController();
// //   // final _luggageCtrl = TextEditingController();
// //   // final _automaticCtrl = TextEditingController();
// //   // final _airCtrl = TextEditingController();
// //   // final _priceCtrl = TextEditingController();
// //   // final _imageUrlCtrl = TextEditingController();

// //   bool _loading = false;
// //   String? _error;

// //   @override
// //   Widget build(BuildContext context) {
// //     final car = widget.car;  // 👈 obtiene el auto desde el widget
// //     return Scaffold(
// //       //  appBar: AppBar(
// //       //     title: Row(
// //       //       children: [
// //       //         Image.asset(
// //       //           'assets/images/cr_logo.jpg',
// //       //           width: 40,
// //       //           height: 40,
// //       //         ),
// //       //         const SizedBox(width: 8),
// //       //         const Text('Car Rent'),
// //       //       ],
// //       //     ),
// //       //     backgroundColor: Colors.blue,
// //       //     foregroundColor: Colors.white,
// //       //     actions: [
// //       //       IconButton(
// //       //         onPressed: () {
// //       //           // TODO: Agregar funcionalidad del ícono de auto
// //       //         },
// //       //         icon: const Icon(Icons.directions_car),
// //       //         tooltip: 'Car Rent',
// //       //       ),
// //       //     ],
// //       //   ),
// //       appBar: const CustomAppBar(title: 'Car Rent'),

// // body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Form(
// //           key: _formKey,
// //           child: ListView(
// //             children: [

// //               ExpansionTile(
// //                 title: const Text('Método de Pago'),
// //                 subtitle: Text('${selectedPaymentMethod?.name}'),
// //                 children: [
// //                   RadioListTile(
// //                     title: const Text('Tarjeta de Crédito'),
// //                     value: PaymentMethod.creditCard,
// //                     groupValue: selectedPaymentMethod,
// //                     onChanged: (value) {
// //                       selectedPaymentMethod = value;
// //                       setState(() {});
// //                     },
// //                   ),
// //                   RadioListTile(
// //                     title: const Text('Tarjeta de Débito'),
// //                     value: PaymentMethod.debitCard,
// //                     groupValue: selectedPaymentMethod,
// //                     onChanged: (value) {
// //                       selectedPaymentMethod = value;
// //                       setState(() {});
// //                     },
// //                   ),
// //                   RadioListTile(
// //                     title: const Text('Transferencia Bancaria'),
// //                     value: PaymentMethod.bankTransfer,
// //                     groupValue: selectedPaymentMethod,
// //                     onChanged: (value) {
// //                       selectedPaymentMethod = value;
// //                       setState(() {});
// //                     },
// //                   ),
// //                   RadioListTile(
// //                     title: const Text('Efectivo'),
// //                     value: PaymentMethod.cash,
// //                     groupValue: selectedPaymentMethod,
// //                     onChanged: (value) {
// //                       selectedPaymentMethod = value;
// //                       setState(() {});
// //                     },
// //                   ),
// //                 ],
// //               ),

// //               // RadioListTile(
// //               //   title: const Text('Tarjeta de Crédito'),
// //               //   // value: 'Tarjeta de Crédito',
// //               //   // value: PaymentMethod.creditCard.name,
// //               //   value: PaymentMethod.creditCard,
// //               //   // groupValue: _payMethodCtrl.text,
// //               //   // ignore: deprecated_member_use
// //               //   // groupValue: _selectedPaymentMethod?.name,
// //               //   groupValue: selectedPaymentMethod,
// //               //   onChanged: (value) {
// //               //     // _selectedPaymentMethod = PaymentMethod.values.firstWhere((e) => e.name == value);
// //               //     selectedPaymentMethod = value;
// //               //     setState(() {
// //               //       // _payMethodCtrl.text = value!;
// //               //     });
// //               //   },
// //               // ),

// //               // RadioListTile(
// //               //   title: const Text('Tarjeta de Débito'),
// //               //   // value: 'Tarjeta de Débito',
// //               //   value: PaymentMethod.debitCard,
// //               //   groupValue: selectedPaymentMethod,
// //               //   onChanged: (value) {
// //               //     selectedPaymentMethod = value;
// //               //     setState(() {
                    
// //               //     });
// //               //   },
// //               // ),

// //               // RadioListTile(
// //               //   title: const Text('Transferencia Bancaria'),
// //               //   // value: 'Transferencia Bancaria',
// //               //   value: PaymentMethod.bankTransfer,
// //               //   groupValue: selectedPaymentMethod,
// //               //   onChanged: (value) {
// //               //     selectedPaymentMethod = value;
// //               //     setState(() {
// //               //       // _payMethodCtrl.text = value;
// //               //     });
// //               //   },
// //               // ),

// //               //    RadioListTile(
// //               //   title: const Text('Efectivo'),
// //               //   // value: 'Efectivo',
// //               //   value: PaymentMethod.cash,
// //               //   groupValue: selectedPaymentMethod,
// //               //   onChanged: (value) {
// //               //     selectedPaymentMethod = value;
// //               //     setState(() {
                    
// //               //     });
// //               //   },
// //               // ),


// //               // TextFormField(
// //               //   controller: _payMethodCtrl,
// //               //   decoration: const InputDecoration(labelText: 'Método de Pago'),
// //               //   validator: (v) =>
// //               //       v == null || v.isEmpty ? 'Ingrese el método de pago' : null,
// //               // ),

// //               const SizedBox(height: 80),

// //               TextFormField(
// //                 controller: _daysCtrl,
// //                 decoration: const InputDecoration(labelText: 'Cantidad de días'),
// //                 validator: (v) =>
// //                     v == null || v.isEmpty ? 'Ingrese la cantidad de días' : null,
// //               ),
// //               // TextFormField(
// //               //   controller: _brandCtrl,
// //               //   decoration: const InputDecoration(labelText: 'Marca'),
// //               //   validator: (v) =>
// //               //        v == null || v.isEmpty ? 'Ingrese la marca' : null,
// //               // ),
// //               // TextFormField(
// //               //   controller: _modelCtrl,
// //               //   decoration: const InputDecoration(labelText: 'Modelo'),
// //               //   validator: (v) =>
// //               //        v == null || v.isEmpty ? 'Ingrese el modelo' : null,
// //               // ),
// //               // TextFormField(
// //               //   controller: _colorCtrl,
// //               //   decoration: const InputDecoration(labelText: 'Color'),
// //               //   validator: (v) =>
// //               //        v == null || v.isEmpty ? 'Ingrese el color' : null,
// //               // ),
// //               // TextFormField(
// //               //   controller: _capacityCtrl,
// //               //   decoration: const InputDecoration(labelText: 'Capacidad'),
// //               //   validator: (v) =>
// //               //        v == null || v.isEmpty ? 'Ingrese la cantidad de personas' : null,
// //               // ),
// //               // TextFormField(
// //               //   controller: _luggageCtrl,
// //               //   decoration: const InputDecoration(labelText: 'Equipaje'),
// //               //   validator: (v) =>
// //               //        v == null || v.isEmpty ? 'Ingrese la cantidad de equipaje' : null,
// //               // ),
// //               // TextFormField(
// //               //   controller: _automaticCtrl,
// //               //   decoration: const InputDecoration(labelText: 'Transmisión'),
// //               //   validator: (v) =>
// //               //        v == null || v.isEmpty ? 'Ingrese la transmision' : null,
// //               // ),
// //               // TextFormField(
// //               //   controller: _airCtrl,
// //               //   decoration: const InputDecoration(labelText: 'Aire Acondicionado'),
// //               //   validator: (v) =>
// //               //        v == null || v.isEmpty ? 'Ingrese el aire acondicionado' : null,
// //               // ),
// //               // TextFormField(
// //               //   controller: _priceCtrl,
// //               //   decoration: const InputDecoration(labelText: 'Precio'),
// //               //   validator: (v) =>
// //               //        v == null || v.isEmpty ? 'Ingrese el precio' : null,
// //               // ),
// //               // TextFormField(
// //               //   controller: _imageUrlCtrl,
// //               //   decoration: const InputDecoration(labelText: 'URL de la Imagen'),
// //               //   validator: (v) =>
// //               //        v == null || v.isEmpty ? 'Ingrese la URL de la imagen' : null,
// //               // ),
// //               // // TextFormField(
// //               // //   controller: _phoneCtrl,
// //               // //   decoration:
// //               // //       const InputDecoration(labelText: 'Teléfono'),
// //               // // ),
// //               // // TextFormField(
// //               // //   controller: _countryCtrl,
// //               // //   decoration: const InputDecoration(labelText: 'País'),
// //               // // ),
// //               // // TextFormField(
// //               // //   controller: _docCtrl,
// //               // //   decoration: const InputDecoration(labelText: 'Documento'),
// //               // // ),
// //               const SizedBox(height: 120),
// //               if (_error != null)
// //                 Text(_error!,
// //                     style: const TextStyle(color: Colors.red, fontSize: 14)),
// //               // const SizedBox(height: 12),

// //               ElevatedButton(
// //                 onPressed: _loading
// //                     ? null
// //                     : () async {
// //                         if (!_formKey.currentState!.validate()) return;

// //                         setState(() {
// //                           _loading = true;
// //                           _error = null;
// //                         });

// //                         final notifier =
// //                             ref.read(ReservationNotifierProvider.notifier);

// //                         // final newReservation = Reservation(
// //                         //   id: '', // se asigna automáticamente
// //                         //   userId: user.uid,
// //                         //   carId: car.id,
// //                         //   status: 'pending', // 👈 valor por defecto
// //                         //   paymentMethod: _payMethodCtrl.text.trim(),
// //                         //   days: int.tryParse(_daysCtrl.text.trim()) ?? 0, 
// //                         //   // modelo: _modelCtrl.text.trim(),
// //                         //   // // year: int.tryParse(_yearCtrl.text.trim()) ?? 0,
// //                         //   // color: _colorCtrl.text.trim(),
// //                         //   // capacidad: int.tryParse(_capacityCtrl.text.trim()) ?? 0,
// //                         //   // equipaje: int.tryParse(_luggageCtrl.text.trim()) ?? 0,
// //                         //   // automatico: _automaticCtrl.text.trim().toLowerCase() == 'true',
// //                         //   // aire: _airCtrl.text.trim().toLowerCase() == 'true',
// //                         //   // precio: int.tryParse(_priceCtrl.text.trim()) ?? 0,
// //                         //   // imageUrl: _imageUrlCtrl.text.trim(),
// //                         // );






// //                         final currentUser = fb.FirebaseAuth.instance.currentUser;
// //                           if (currentUser == null) {
// //                             setState(() {
// //                               _error = 'Debes iniciar sesión para reservar un auto.';
// //                               _loading = false;
// //                             });
// //                             return;
// //                           }

// //                           final newReservation = Reservation(
// //                             id: '', // se asigna automáticamente en Firestore
// //                             userId: currentUser.uid,
// //                             carId: car.id,
// //                             status: 'pending', // 👈 valor por defecto
// //                             // paymentMethod: _payMethodCtrl.text.trim(),
// //                             paymentMethod: selectedPaymentMethod!.name,
// //                             days: int.tryParse(_daysCtrl.text.trim()) ?? 0,
// //                           );










// //                         final err = await notifier.addReservation(newReservation);

// //                         setState(() => _loading = false);

// //                         if (err == null) {
// //                           if (mounted) {
// //                             ScaffoldMessenger.of(context).showSnackBar(
// //                               const SnackBar(
// //                                   content: Text('Reserva realizada con éxito')),
// //                             );
// //                             // context.go('/home_screen');
// //                             context.push('/add_payment_screen', extra: newReservation);
// //                             // context.push('/add_payment_screen', extra: {
// //                             //   'car': car,
// //                             //   'reservation': newReservation
// //                             //  });
// //                           }
// //                         } else {
// //                           setState(() => _error = err);
// //                         }
// //                       },
// //                 child: _loading
// //                     ? const CircularProgressIndicator()
// //                     : const Text('Reservar'),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),


// //       // body: const Center(
// //       //   child: Text('Aquí se mostrará el formulario para reservar'),
// //       // ),
// //     );
// //   }
// // }



// --------------------------------------------------------------------

// // import 'package:app_car_rental/domain/car.dart';
// import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
// import 'package:flutter/material.dart';

// class ReservationScreen extends StatelessWidget {
//   // final Car car;
//   // final Car? car;
//   // const ReservationScreen({super.key, required this.car});
//   const ReservationScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // return _ReservationScreenView(car: car);
//     return _ReservationScreenView();
//   }
// }

// class _ReservationScreenView extends StatelessWidget {
//   const _ReservationScreenView({
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
//         child: Text('Aquí se mostrará el formulario para reservar'),
//       ),
//     );
//   }
// }

