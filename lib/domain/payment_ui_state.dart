import 'package:app_car_rental/domain/enums/payment_enums.dart';

class PaymentUiState {
  final Protection protection;
  final Accesories accessories;

  const PaymentUiState({
    this.protection = Protection.todo_riesgo_sin_franquicia,
    this.accessories = Accesories.wifi_y_auxilio_mecanico,
  });

  PaymentUiState copyWith({Protection? protection, Accesories? accessories}) {
    return PaymentUiState(
      protection: protection ?? this.protection,
      accessories: accessories ?? this.accessories,
    );
  }
}
