import 'package:dio/dio.dart';
import 'package:auth_app/core/network/dio_client.dart';
import 'package:auth_app/domain/models/currency.dart';

class CurrencyService {
  final Dio _dio;

  CurrencyService(this._dio);

  Future<List<Currency>> getCurrencyList() async {
    try {
      final response = await _dio.post(
        '/v1/Login/getCurrencyList',
        options: Options(
          headers: {
            'accept': '*/*',
            'xcmzkey': DioClient.xcmzKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Currency.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load currency list');
      }
    } catch (e) {
      throw Exception('Failed to load currency list: $e');
    }
  }
}
