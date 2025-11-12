import 'package:app_car_rental/domain/car.dart';
import 'package:app_car_rental/domain/payment.dart';
import 'package:app_car_rental/domain/reservation.dart';
import 'package:app_car_rental/presentation/components/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';

class PaymentSummaryScreen extends StatelessWidget {
  final Car car;
  final Reservation reservation;
  final Payment payment;

  const PaymentSummaryScreen({
    super.key,
    required this.car,
    required this.reservation,
    required this.payment,
  });

  Widget _styledBox(BuildContext context, {required Widget child}) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.08),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    final user = fb.FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: const CustomAppBar(title: ' Operación exitosa'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // DATOS DEL USUARIO
            _styledBox(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '👤 Datos del Usuario',
                    style: textStyle.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _infoRow('Email', user?.email ?? 'No disponible'),
                ],
              ),
            ),

            // DATOS DEL AUTO
            _styledBox(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🚗 Datos del Auto',
                    style: textStyle.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _infoRow('Marca', car.marca),
                  _infoRow('Modelo', car.modelo),
                  _infoRow('Grupo', car.grupo),
                  _infoRow('Color', car.color),
                  _infoRow('Precio por día', '\$${car.precio}'),
                  _infoRow('Aire Acond.', car.aire ? 'Sí' : 'No'),
                  _infoRow('Automático', car.automatico ? 'Sí' : 'No'),
                ],
              ),
            ),

            // DATOS DE LA RESERVA
            _styledBox(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '📅 Datos de la Reserva',
                    style: textStyle.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _infoRow('ID Reserva', reservation.id),
                  _infoRow('Estado', reservation.status),
                  _infoRow('Método de pago', reservation.paymentMethod),
                  _infoRow('Días', reservation.days.toString()),
                ],
              ),
            ),

            // DATOS DEL PAGO
            _styledBox(
              context,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💳 Datos del Pago',
                    style: textStyle.titleMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _infoRow('ID Pago', payment.id),
                  _infoRow('Estado', payment.status),
                  _infoRow('Protección', payment.protection),
                  _infoRow('Accesorios', payment.accesories),
                  _infoRow('Monto', '\$${payment.amount}'),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // BOTÓN FINAL
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () =>
                    Navigator.of(context).popUntil((r) => r.isFirst),
                icon: const Icon(Icons.home),
                label: const Text('Volver al inicio'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    ),
  );
}
