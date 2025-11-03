// import 'package:app_car_rental/domain/car.dart';
// 

// --------------------------------------------------------------------------------------

import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/reservation.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/reservationProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// class ReservationScreen extends ConsumerStatefulWidget {
//   // final Car car;
//   // final Car? car;
//   final String carId;
//   // const ReservationScreen({super.key, required this.car});
//   // const ReservationScreen({super.key});
//   const ReservationScreen({super.key, required this.carId});

//   @override
//   ConsumerState<ReservationScreen> createState() => _ReservationScreenState();
// }

// // class _ReservationScreenState extends ConsumerState<ReservationScreen>{

// //   @override
// //   Widget build(BuildContext context) {
// //     // return _ReservationScreenView(car: car);
// //     return _ReservationScreenView();
// //   }
// // }

// // class _ReservationScreenState extends ConsumerState<ReservationScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   final TextEditingController _daysController = TextEditingController(text: '1');
// //   String _selectedPayment = 'Tarjeta de crédito';
// //   bool _submitting = false;

// //   @override
// //   void dispose() {
// //     _daysController.dispose();
// //     super.dispose();
// //   }
// // }

//   class _ReservationScreenState extends ConsumerState<ReservationScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _daysController = TextEditingController(text: '1');
//   String _selectedPayment = 'Tarjeta de crédito';
//   bool _submitting = false;

//   @override
//   void dispose() {
//     _daysController.dispose();
//     super.dispose();
//   }

//   Future<void> _onSubmit() async {
//     if (!_formKey.currentState!.validate()) return;
//     setState(() => _submitting = true);

//     final user = FirebaseAuth.instance.currentUser;
//     if (user == null) return;

//     final newRes = Reservation(
//       id: '',
//       userId: user.uid,
//       carId: widget.carId,
//       days: int.parse(_daysController.text),
//       paymentMethod: _selectedPayment,
//       status: 'pending',
//       createdAt: DateTime.now(),
//     );

//     await ref.read(reservationProvider(user.uid).notifier).createReservation(newRes);

//     if (context.mounted) {
//       context.push('/payment_screen', extra: newRes);
//     }

//     setState(() => _submitting = false);
//   }


class ReservationScreen extends ConsumerStatefulWidget {
  final Car car;
  const ReservationScreen({super.key, required this.car});

  @override
  ConsumerState<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends ConsumerState<ReservationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _daysController = TextEditingController(text: '1');
  String _paymentMethod = 'tarjeta';
  bool _submitting = false;

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    // Aquí obtendrías el UID real del usuario logueado
    final uid = 'user123'; // ejemplo temporal

    final reservation = Reservation(
      id: '', // Firestore lo genera
      userId: uid,
      carId: widget.car.id,
      // startdate: DateTime.now().toIso8601String(),
      // endDate: DateTime.now()
      //     .add(Duration(days: int.parse(_daysController.text)))
      //     .toIso8601String(),
      days: int.parse(_daysController.text),
      paymentMethod: _paymentMethod,
      status: 'pending',
      // createdAt: Timestamp.fromDate(DateTime.now()),
      createdAt: DateTime.now(),
      // paymentId: _paymentMethod,
    );

    await ref.read(reservationProvider(uid).notifier).createReservation(reservation);

    setState(() => _submitting = false);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reserva creada correctamente')),
      );
      context.push('/payment', extra: reservation); // 👈 Ir a pantalla de pago
    }
  }









  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final car = widget.car;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Car Rent'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Auto: ${car.marca} ${car.modelo}'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _daysController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad de días (1–30)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              //   validator: (v) => (v == null || v.isEmpty) ? 'Ingrese su nombre' : null,
              // ),

                   validator: (v) {
                    final n = int.tryParse(v ?? '');
                    if (n == null || n < 1 || n > 30) {
                      return 'Ingrese entre 1 y 30 días';
                    }
                    return null;
                  },
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                // value: _selectedPayment,
                value: _paymentMethod,
                decoration: const InputDecoration(
                  labelText: 'Forma de pago',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'Tarjeta de crédito', child: Text('Tarjeta de crédito')),
                  DropdownMenuItem(value: 'Tarjeta de débito', child: Text('Tarjeta de débito')),
                  DropdownMenuItem(value: 'Transferencia bancaria', child: Text('Transferencia bancaria')),
                ],
                // onChanged: (v) => setState(() => _paymentMethod = v!),
                onChanged: (v) => setState(() => _paymentMethod = v ?? 'Tarjeta de crédito'),
              ),


              // TextFormField(
              //   controller: _emailController,
              //   decoration: const InputDecoration(
              //     labelText: 'Email',
              //     border: OutlineInputBorder(),
              //   ),
              //   keyboardType: TextInputType.emailAddress,
              //   validator: (v) {
              //     if (v == null || v.isEmpty) return 'Ingrese su email';
              //     if (!v.contains('@')) return 'Email inválido';
              //     return null;
              //   },
              // ),

              // //  const SizedBox(height: 12),
              // // TextFormField(
              // //   controller: _roleController,
              // //   decoration: const InputDecoration(
              // //     labelText: 'Rol',
              // //     border: OutlineInputBorder(),
              // //   ),
              // //   validator: (v) => (v == null || v.isEmpty) ? 'Ingrese rol' : null,
              // // ),

              // const SizedBox(height: 12),
              // TextFormField(
              //   controller: _documentController,
              //   decoration: const InputDecoration(
              //     labelText: 'Documento',
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (v) => (v == null || v.isEmpty) ? 'Ingrese documento' : null,
              // ),
              // const SizedBox(height: 12),
              // TextFormField(
              //   controller: _countryController,
              //   decoration: const InputDecoration(
              //     labelText: 'País',
              //     border: OutlineInputBorder(),
              //   ),
              //   validator: (v) => (v == null || v.isEmpty) ? 'Ingrese país' : null,
              // ),
              // const SizedBox(height: 12),
              // TextFormField(
              //   controller: _passwordController,
              //   decoration: const InputDecoration(
              //     labelText: 'Contraseña',
              //     border: OutlineInputBorder(),
              //   ),
              //   obscureText: true,
              //   validator: (v) => (v == null || v.length < 3) ? 'Mínimo 3 chars' : null,
              // ),
              // const SizedBox(height: 12),
              // TextFormField(
              //   controller: _confirmController,
              //   decoration: const InputDecoration(
              //     labelText: 'Confirmar contraseña',
              //     border: OutlineInputBorder(),
              //   ),
              //   obscureText: true,
              //   validator: (v) => v != _passwordController.text ? 'No coincide' : null,
              // ),
              const SizedBox(height: 18),
              FilledButton(
                // onPressed: _submitting ? null : _onSubmit,
                onPressed: _submitting ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _submitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(
                      'Cofirmar reserva', style: TextStyle(
                        color: colorScheme.onPrimary
                        )
                      ),
              ),
              // const SizedBox(height: 8),
              // TextButton(
              //   onPressed: () => context.push('/login_screen'),
              //   child: const Text('¿Ya tienes cuenta? Iniciar sesión'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}