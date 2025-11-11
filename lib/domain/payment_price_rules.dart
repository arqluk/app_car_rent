import 'package:app_car_rental/domain/enums/payment_enums.dart';

class PaymentPriceRules {
  static const Map<Protection, int> protectionPrices = {
    Protection.todo_riesgo_sin_franquicia: 25,
    Protection.todo_riesgo_con_franquicia: 15,
    Protection.terceros: 8,
  };

  static const Map<Accesories, int> accessoriesPrices = {
    Accesories.wifi_y_auxilio_mecanico: 10,
    Accesories.wifi: 8,
    Accesories.auxilio_mecanico: 6,
  };
}
