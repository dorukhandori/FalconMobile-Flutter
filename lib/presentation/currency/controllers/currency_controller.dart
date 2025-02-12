import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/data/services/currency_service.dart';
import 'package:auth_app/domain/models/currency.dart';

import '../../../core/di/injection.dart';

final currencyControllerProvider =
    StateNotifierProvider<CurrencyController, List<Currency>>((ref) {
  return CurrencyController(ref.watch(currencyServiceProvider));
});

class CurrencyController extends StateNotifier<List<Currency>> {
  final CurrencyService _currencyService;

  CurrencyController(this._currencyService) : super([]);

  Future<void> fetchCurrencies() async {
    try {
      final currencies = await _currencyService.getCurrencyList();
      state = currencies;
    } catch (e) {
      throw Exception('Failed to fetch currencies: $e');
    }
  }
}
