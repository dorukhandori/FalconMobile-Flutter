import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/models/currency.dart';
import '../../../data/datasources/remote/dio_client.dart';

final currencyControllerProvider =
    StateNotifierProvider<CurrencyController, List<Currency>>(
  (ref) => CurrencyController(),
);

class CurrencyController extends StateNotifier<List<Currency>> {
  CurrencyController() : super([]) {
    fetchCurrencies();
  }

  Future<void> fetchCurrencies() async {
    try {
      final dio = DioClient.getInstance();

      final headers = {
        'Content-Type': 'application/json',
        'xcmzkey':
            'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ',
      };

      final response = await dio.post(
        '/AdminLogin/getCurrencyList',
        options: Options(headers: headers),
      );

      if (kDebugMode) {
        print('Currency Response: $response');
        print('Currency Response Type: ${response.data.runtimeType}');
      }

      if (response.statusCode == 200) {
        List<dynamic> data = [];

        // API yanıtının yapısını kontrol et
        if (response.data is Map && response.data.containsKey('data')) {
          data = response.data['data'] ?? [];
        } else if (response.data is List) {
          data = response.data;
        }

        if (kDebugMode) {
          print('Currency Data: $data');
        }

        final currencies = data.map((item) => Currency.fromJson(item)).toList();

        // Varsayılan para birimleri yoksa örnek para birimleri ekleyelim
        if (currencies.isEmpty) {
          currencies.addAll([
            Currency(
                id: 1,
                code: 'TRY',
                name: 'Türk Lirası',
                type: 'TRY',
                symbol: '₺',
                rate: 1.0,
                isActive: true),
            Currency(
                id: 2,
                code: 'USD',
                name: 'Amerikan Doları',
                type: 'USD',
                symbol: '\$',
                rate: 0.03,
                isActive: true),
            Currency(
                id: 3,
                code: 'EUR',
                name: 'Euro',
                type: 'EUR',
                symbol: '€',
                rate: 0.028,
                isActive: true),
          ]);
        }

        state = currencies;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Currency Error: $e');
      }

      // Hata durumunda varsayılan para birimleri
      state = [
        Currency(
            id: 1,
            code: 'TRY',
            name: 'Türk Lirası',
            type: 'TRY',
            symbol: '₺',
            rate: 1.0,
            isActive: true),
        Currency(
            id: 2,
            code: 'USD',
            name: 'Amerikan Doları',
            type: 'USD',
            symbol: '\$',
            rate: 0.03,
            isActive: true),
        Currency(
            id: 3,
            code: 'EUR',
            name: 'Euro',
            type: 'EUR',
            symbol: '€',
            rate: 0.028,
            isActive: true),
      ];
    }
  }

  void setCurrency(Currency currency) {
    // Para birimi değiştirme işlemi
    if (kDebugMode) {
      print('Selected Currency: ${currency.name}');
    }
    // Burada para birimi değiştirme işlemleri yapılabilir
  }
}
