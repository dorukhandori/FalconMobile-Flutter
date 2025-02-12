import 'package:dio/dio.dart';
import 'package:auth_app/core/network/dio_client.dart';

class LanguageService {
  final Dio _dio;

  LanguageService(this._dio);

  Future<List<String>> getLanguageList() async {
    try {
      final response = await _dio.post(
        '/v1/Home/getLanguageList',
        options: Options(
          headers: {
            'accept': '*/*',
            'xcmzkey': DioClient.xcmzKey,
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => e.toString()).toList();
      } else {
        throw Exception('Failed to load language list');
      }
    } catch (e) {
      throw Exception('Failed to load language list: $e');
    }
  }
}
