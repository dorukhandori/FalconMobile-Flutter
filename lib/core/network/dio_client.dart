import 'package:dio/dio.dart';
import 'package:auth_app/core/network/logging_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/presentation/auth/controllers/auth_controller.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  static DioClient? _instance;
  final Dio dio;

  static const String xcmzKey =
      'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ';

  DioClient._internal(String baseUrl, String encryptedCustomerId)
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
            headers: {
              'Content-Type': 'application/json',
              'xcmzkey': xcmzKey,
              'X-Customer-ID': encryptedCustomerId,
            },
          ),
        ) {
    debugPrint('DioClient initialized with baseUrl: $baseUrl');

    dio.interceptors.add(LoggingInterceptor());
  }

  static Dio getInstance({required String encryptedCustomerId}) {
    _instance ??= DioClient._internal(
        'https://testapi.allprox.com.tr/v1', encryptedCustomerId);
    return _instance!.dio;
  }
}
