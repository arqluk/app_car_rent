// import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/payment.dart';
import 'package:app_car_rental/domain/reservation.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/payments_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

enum Protection {
  todo_riesgo_sin_franquicia,
  todo_riesgo_con_franquicia,
  terceros
}

enum Accesories {
  wifi_y_auxilio_mecanico,
  wifi,
  auxilio_mecanico,
}

class AddPaymentScreen extends ConsumerStatefulWidget {
  // final Car car;
  // final Car? car;
  // const ReservationScreen({super.key, required this.car});
  
  final Reservation reservation; // 👈 recibe la reserva desde AddReservationScreen
  const AddPaymentScreen(this.reservation, {super.key});

  @override
  ConsumerState<AddPaymentScreen> createState() => _AddPaymentScreenState();

  // @override
  // Widget build(BuildContext context) {
  //   // return _ReservationScreenView(car: car);
  //   return _AddPaymentScreenView();
  // }
}

class _AddPaymentScreenState extends ConsumerState<AddPaymentScreen> {

  Protection? selectedProtection = Protection.todo_riesgo_sin_franquicia;
  Accesories? selectedAccesories = Accesories.wifi_y_auxilio_mecanico;

  final _formKey = GlobalKey<FormState>();
  // final _protectionCtrl = TextEditingController();
  // final _wifiCtrl = TextEditingController();

  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // ✅ Definimos el formateador acá
    final NumberFormat formatNumber = NumberFormat('#,##0', 'es_AR');

    final reservation = widget.reservation; // 👈 obtiene la reserva desde el widget
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
                subtitle: Text('${selectedProtection?.name}'),
                children: [
                  RadioListTile(
                    title: const Text('Todo Riesgo Sin Franquicia'),
                    value: Protection.todo_riesgo_sin_franquicia,
                    groupValue: selectedProtection,
                    onChanged: (value) {
                      setState(() {
                        selectedProtection = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Todo Riesgo Con Franquicia'),
                    value: Protection.todo_riesgo_con_franquicia,
                    groupValue: selectedProtection,
                    onChanged: (value) {
                      setState(() {
                        selectedProtection = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Terceros'),
                    value: Protection.terceros,
                    groupValue: selectedProtection,
                    onChanged: (value) {
                      setState(() {
                        selectedProtection = value;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 60),

              ExpansionTile(
                title: const Text('Accesorios'),
                subtitle: Text('${selectedAccesories?.name}'),
                children: [
                  RadioListTile(
                    title: const Text('Wi-Fi y Auxilio Mecánico'),
                    value: Accesories.wifi_y_auxilio_mecanico,
                    groupValue: selectedAccesories,
                    onChanged: (value) {
                      setState(() {
                        selectedAccesories = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Solo Wi-Fi'),
                    value: Accesories.wifi,
                    groupValue: selectedAccesories,
                    onChanged: (value) {
                      setState(() {
                        selectedAccesories = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: const Text('Solo Auxilio Mecánico'),
                    value: Accesories.auxilio_mecanico,
                    groupValue: selectedAccesories,
                    onChanged: (value) {
                      setState(() {
                        selectedAccesories = value;
                      });
                    },
                  ),
                ],
              ),

              // const SizedBox(height: 20),

              if (_error != null)
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),

              // const SizedBox(height: 12),



              // ExpansionTile(
              //   title: const Text('Protección'),
              //   subtitle: Text('${selectedProtection?.name}'),
              //   children: [
              //     RadioListTile(
              //       title: const Text('Todo Riesgo Sin Franquicia'),
              //       value: Protection.todo_riesgo_sin_franquicia,
              //       groupValue: selectedProtection,
              //       onChanged: (value) {
              //         selectedProtection = value;
              //         setState(() {});
              //       },
              //     ),
              //     RadioListTile(
              //       title: const Text('Accesorios'),
              //       value: Accesories.wifi_y_auxilio_mecanico,
              //       groupValue: selectedAccesories,
              //       onChanged: (value) {
              //         selectedAccesories = value;
              //         setState(() {});
              //       },
              //     ),
              //   ]
              //     // RadioListTile(
              //     //   title: const Text('Transferencia Bancaria'),
              //     //   value: PaymentMethod.bankTransfer,
              //     //   groupValue: selectedPaymentMethod,
              //     //   onChanged: (value) {
              //     //     selectedPaymentMethod = value;
              //     //     setState(() {});
              //     //   },
              //     // ),
              //     // RadioListTile(
              //     //   title: const Text('Efectivo'),
              //     //   value: PaymentMethod.cash,
              //     //   groupValue: selectedPaymentMethod,
              //     //   onChanged: (value) {
              //     //     selectedPaymentMethod = value;
              //     //     setState(() {});
              //     //   },
              //     ),
                // ],
        //   )
        // )
        //       ),






              // TextFormField(
              //   controller: _protectionCtrl,
              //   decoration: const InputDecoration(labelText: 'Protección'),
              //   validator: (v) =>
              //       v == null || v.isEmpty ? 'Ingrese la protección' : null,
              // ),
              // TextFormField(
              //   controller: _wifiCtrl,
              //   decoration: const InputDecoration(labelText: 'Wi-Fi'),
              //   validator: (v) =>
              //       v == null || v.isEmpty ? 'Ingrese Wi-Fi' : null,
              // ),
              // TextFormField(
              //   controller: _brandCtrl,
              //   decoration: const InputDecoration(labelText: 'Marca'),
              //   validator: (v) =>
              //        v == null || v.isEmpty ? 'Ingrese la marca' : null,
              // ),
              // TextFormField(
              //   controller: _modelCtrl,
              //   decoration: const InputDecoration(labelText: 'Modelo'),
              //   validator: (v) =>
              //        v == null || v.isEmpty ? 'Ingrese el modelo' : null,
              // ),
              // TextFormField(
              //   controller: _colorCtrl,
              //   decoration: const InputDecoration(labelText: 'Color'),
              //   validator: (v) =>
              //        v == null || v.isEmpty ? 'Ingrese el color' : null,
              // ),
              // TextFormField(
              //   controller: _capacityCtrl,
              //   decoration: const InputDecoration(labelText: 'Capacidad'),
              //   validator: (v) =>
              //        v == null || v.isEmpty ? 'Ingrese la cantidad de personas' : null,
              // ),
              // TextFormField(
              //   controller: _luggageCtrl,
              //   decoration: const InputDecoration(labelText: 'Equipaje'),
              //   validator: (v) =>
              //        v == null || v.isEmpty ? 'Ingrese la cantidad de equipaje' : null,
              // ),
              // TextFormField(
              //   controller: _automaticCtrl,
              //   decoration: const InputDecoration(labelText: 'Transmisión'),
              //   validator: (v) =>
              //        v == null || v.isEmpty ? 'Ingrese la transmision' : null,
              // ),
              // TextFormField(
              //   controller: _airCtrl,
              //   decoration: const InputDecoration(labelText: 'Aire Acondicionado'),
              //   validator: (v) =>
              //        v == null || v.isEmpty ? 'Ingrese el aire acondicionado' : null,
              // ),
              // TextFormField(
              //   controller: _priceCtrl,
              //   decoration: const InputDecoration(labelText: 'Precio'),
              //   validator: (v) =>
              //        v == null || v.isEmpty ? 'Ingrese el precio' : null,
              // ),
              // TextFormField(
              //   controller: _imageUrlCtrl,
              //   decoration: const InputDecoration(labelText: 'URL de la Imagen'),
              //   validator: (v) =>
              //        v == null || v.isEmpty ? 'Ingrese la URL de la imagen' : null,
              // ),
              // // TextFormField(
              // //   controller: _phoneCtrl,
              // //   decoration:
              // //       const InputDecoration(labelText: 'Teléfono'),
              // // ),
              // // TextFormField(
              // //   controller: _countryCtrl,
              // //   decoration: const InputDecoration(labelText: 'País'),
              // // ),
              // // TextFormField(
              // //   controller: _docCtrl,
              // //   decoration: const InputDecoration(labelText: 'Documento'),
              // // ),
              // const SizedBox(height: 20),
              // if (_error != null)
              //   Text(_error!,
              //       style: const TextStyle(color: Colors.red, fontSize: 14)),
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
                  '\$ ${formatNumber.format(0)}.- importe final a pagar',
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer, // 🎨 texto según el tema
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              
              
              
              const SizedBox(height: 80),
              
              
              
              
              ElevatedButton(
                onPressed: _loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;

                        setState(() {
                          _loading = true;
                          _error = null;
                        });

                        final notifier =
                            ref.read(PaymentNotifierProvider.notifier);

                        // final newReservation = Reservation(
                        //   id: '', // se asigna automáticamente
                        //   userId: user.uid,
                        //   carId: car.id,
                        //   status: 'pending', // 👈 valor por defecto
                        //   paymentMethod: _payMethodCtrl.text.trim(),
                        //   days: int.tryParse(_daysCtrl.text.trim()) ?? 0, 
                        //   // modelo: _modelCtrl.text.trim(),
                        //   // // year: int.tryParse(_yearCtrl.text.trim()) ?? 0,
                        //   // color: _colorCtrl.text.trim(),
                        //   // capacidad: int.tryParse(_capacityCtrl.text.trim()) ?? 0,
                        //   // equipaje: int.tryParse(_luggageCtrl.text.trim()) ?? 0,
                        //   // automatico: _automaticCtrl.text.trim().toLowerCase() == 'true',
                        //   // aire: _airCtrl.text.trim().toLowerCase() == 'true',
                        //   // precio: int.tryParse(_priceCtrl.text.trim()) ?? 0,
                        //   // imageUrl: _imageUrlCtrl.text.trim(),
                        // );






                        final currentUser = fb.FirebaseAuth.instance.currentUser;
                          if (currentUser == null) {
                            setState(() {
                              _error = 'Debes iniciar sesión para pagar una reserva.';
                              _loading = false;
                            });
                            return;
                          }

                          final newPayment = Payment(
                            id: '',     // se asigna automáticamente en Firestore
                            userId: currentUser.uid,
                            carId: reservation.carId,
                            reservationId: reservation.id,
                            amount: 0,
                            status: 'paid',
                            timestamp: '', // 👈 valor por defecto
                            // protection: _protectionCtrl.text.trim().toLowerCase() == 'true',
                            protection: selectedProtection!.name,
                            // wifi: _wifiCtrl.text.trim().toLowerCase() == 'true',
                            accesories: selectedAccesories!.name,
                          );



                        final err = await notifier.addPayment(newPayment);

                        setState(() => _loading = false);

                        if (err == null) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Pago realizado con éxito')),
                            );
                            // context.go('/home_screen');
                            // context.push('/final_screen');

                            final carDoc = await FirebaseFirestore.instance
                              .collection('cars')
                              .doc(reservation.carId)
                              .get();

                          final car = Car.fromFirestore(carDoc, null);

                            context.push(
                              '/final_screen',
                              extra: {
                                'car': car,       
                                'reservation': reservation,
                                'payment': newPayment,
                              },
                            );

                          }
                        } else {
                          setState(() => _error = err);
                        }
                      },
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text('Pagar'),
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
