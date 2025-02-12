import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/data/services/currency_service.dart';
import 'package:auth_app/core/di/injection.dart';

final currencyControllerProvider =
    StateNotifierProvider<CurrencyController, Map<String, double>>((ref) {
  return CurrencyController(ref.watch(currencyServiceProvider));
});

class CurrencyController extends StateNotifier<Map<String, double>> {
  final CurrencyService _currencyService;

  CurrencyController(this._currencyService) : super({});

  Future<void> fetchCurrencyRates() async {
    try {
      final rates = await _currencyService.getCurrencyRates();
      state = rates;
    } catch (e) {
      throw Exception('Failed to fetch currency rates: $e');
    }
  }
}
