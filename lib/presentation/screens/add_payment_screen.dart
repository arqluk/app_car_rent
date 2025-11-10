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
    final accessories =
        PaymentPriceRules.accessoriesPrices[ui.accessories] ?? 0;

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
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    iconColor: colorScheme.primary,
                    collapsedIconColor: colorScheme.primary,
                    title: Text(
                      "Protección",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
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
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    iconColor: colorScheme.primary,
                    collapsedIconColor: colorScheme.primary,
                    title: Text(
                      "Accesorios",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
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
                      Text(
                        "Desglose del importe",
                        // style: Theme.of(context).textTheme.titleMedium),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: colorScheme.primary),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Precio base (${widget.reservation.days} días): \$${numberFormat.format(baseImporte)}",
                      ),
                      Text(
                        "Protección: \$${numberFormat.format(protectionImporte)}",
                      ),
                      Text(
                        "Accesorios: \$${numberFormat.format(accessoriesImporte)}",
                      ),
                      // const SizedBox(height: 12),
                      // Divider(color: colorScheme.primary),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 60),

              // ---------------- TOTAL A PAGAR ----------------
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
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
                              widget.reservation.id,
                              // widget.reservation.status,
                              "Pagado",
                            );

                        ref.read(PaymentUiNotifierProvider.notifier).reset();

                        if (!mounted) return;

                        context.push(
                          '/final_screen',
                          extra: {
                            'car': loadedCar,
                            'reservation': widget.reservation,
                            'payment': payment,
                          },
                        );
                      },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                  backgroundColor: colorScheme.primary,
                ),
                child: _loading
                    ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(
                          colorScheme.onPrimary,
                        ),
                      )
                    : Text(
                        "Pagar",
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: colorScheme.onPrimary,
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
