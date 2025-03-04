import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static Dio? _instance;

  static Dio getInstance() {
    _instance ??= _createDio();
    return _instance!;
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://testapi.allprox.com.tr/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
      print('DioClient initialized with baseUrl: ${dio.options.baseUrl}');
    }

    return dio;
  }
}
