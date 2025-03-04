import 'package:dio/dio.dart';
import 'package:auth_app/core/network/dio_client.dart';
import 'package:auth_app/domain/models/language.dart';
import 'package:flutter/foundation.dart';

class LanguageService {
  final Dio dio;

  LanguageService(this.dio);

  Future<List<Language>> getLanguageList() async {
    try {
      final response = await dio.post(
        '/v1/Login/getLanguageList',
        options: Options(
          headers: {
            'accept': '*/*',
            'xcmzkey': DioClient.xcmzKey,
          },
        ),
      );

      debugPrint('Language List Response: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Language.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load language list');
      }
    } catch (e) {
      debugPrint('Error fetching language list: $e');
      throw Exception('Failed to load language list: $e');
    }
  }
}
