import 'package:dio/dio.dart';

class DioClient {
  static Dio? _instance;

  static const String _baseUrl = 'https://testapi.epic-soft.net';

  static Dio getInstance() {
    if (_instance == null) {
      _instance = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          validateStatus: (status) {
            return status! < 500;
          },
          headers: {
            'accept': '*/*',
            'Content-Type': 'application/json',
          },
        ),
      )..interceptors.add(
          LogInterceptor(
            request: true,
            requestHeader: true,
            requestBody: true,
            responseHeader: true,
            responseBody: true,
            error: true,
          ),
        );
    }
    return _instance!;
  }
}
