import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/reservation.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:app_car_rental/presentation/providers/reservations_provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum PaymentMethod { creditCard, debitCard, bankTransfer, cash }

class AddReservationScreen extends ConsumerStatefulWidget {
  final Car car;

  const AddReservationScreen(this.car, {super.key});

  @override
  ConsumerState<AddReservationScreen> createState() =>
      _AddReservationScreenState();
}

class _AddReservationScreenState extends ConsumerState<AddReservationScreen> {
  final _formKey = GlobalKey<FormState>();

  PaymentMethod? selectedPaymentMethod = PaymentMethod.creditCard;
  int? selectedDays = 1;
  bool _loading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return Scaffold(
      appBar: const CustomAppBar(title: ' Seleccioná items'),

      body: Padding(
        padding: const EdgeInsets.all(20),
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
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).shadowColor.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      iconColor: Theme.of(context).colorScheme.primary,
                      collapsedIconColor: Theme.of(context).colorScheme.primary,

                      title: Text(
                        'Método de Pago',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
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
                          onChanged: (value) =>
                              setState(() => selectedPaymentMethod = value),
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                        RadioListTile(
                          title: const Text('Tarjeta de Débito'),
                          value: PaymentMethod.debitCard,
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) =>
                              setState(() => selectedPaymentMethod = value),
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                        RadioListTile(
                          title: const Text('Transferencia Bancaria'),
                          value: PaymentMethod.bankTransfer,
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) =>
                              setState(() => selectedPaymentMethod = value),
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                        RadioListTile(
                          title: const Text('Efectivo'),
                          value: PaymentMethod.cash,
                          groupValue: selectedPaymentMethod,
                          onChanged: (value) =>
                              setState(() => selectedPaymentMethod = value),
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
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).shadowColor.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(
                      context,
                    ).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      iconColor: Theme.of(context).colorScheme.primary,
                      collapsedIconColor: Theme.of(context).colorScheme.primary,

                      title: Text(
                        'Cantidad de días',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
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
                                activeColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
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

                        final currentUser =
                            fb.FirebaseAuth.instance.currentUser;
                        if (currentUser == null) {
                          setState(() {
                            _error =
                                'Debes iniciar sesión para reservar un auto.';
                            _loading = false;
                          });
                          return;
                        }

                        final notifier = ref.read(
                          ReservationNotifierProvider.notifier,
                        );

                        final newReservation = Reservation(
                          id: '',
                          userId: currentUser.uid,
                          carId: car.id,
                          status: 'pending',
                          paymentMethod: selectedPaymentMethod!.name,
                          days: selectedDays ?? 0,
                        );

                        final err = await notifier.addReservation(
                          newReservation,
                        );

                        setState(() => _loading = false);

                        if (err == null) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Reserva realizada con éxito'),
                              ),
                            );
                            context.push(
                              '/add_payment_screen',
                              extra: newReservation,
                            );
                          }
                        } else {
                          setState(() => _error = err);
                        }
                      },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
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
