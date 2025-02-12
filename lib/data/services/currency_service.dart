import 'package:dio/dio.dart';
import 'package:auth_app/core/network/dio_client.dart';

class CurrencyService {
  final Dio _dio;

  CurrencyService(this._dio);

  Future<Map<String, double>> getCurrencyRates() async {
    try {
      final response = await _dio.get(
        '/v1/Home/getCurrencyRates',
        options: Options(
          headers: {
            'accept': '*/*',
            'xcmzkey': DioClient.xcmzKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        return data.map((key, value) => MapEntry(key, value as double));
      } else {
        throw Exception('Failed to load currency rates');
      }
    } catch (e) {
      throw Exception('Failed to load currency rates: $e');
    }
  }
}
