import 'package:app_car_rental/domain/enums/payment_enums.dart';
import 'package:app_car_rental/domain/payment_ui_state.dart';
// import 'package:app_car_rental/presentation/screens/add_payment_screen.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
// import 'payment_ui_state.dart';

final PaymentUiNotifierProvider =
    StateNotifierProvider<PaymentUiNotifier, PaymentUiState>((ref) {
  return PaymentUiNotifier();
});

class PaymentUiNotifier extends StateNotifier<PaymentUiState> {
  PaymentUiNotifier() : super(const PaymentUiState());

  void setProtection(Protection value) {
    state = state.copyWith(protection: value);
  }

  void setAccessories(Accesories value) {
    state = state.copyWith(accessories: value);
  }

  void reset() {
    state = const PaymentUiState();
  }
}


