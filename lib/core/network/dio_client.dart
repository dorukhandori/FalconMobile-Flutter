import 'package:dio/dio.dart';
import 'package:auth_app/core/network/logging_interceptor.dart';

class DioClient {
  static const String xcmzKey =
      'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ';

  static final DioClient _instance = DioClient._internal();

  factory DioClient() {
    return _instance;
  }

  late final Dio _dio;

  DioClient._internal() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://testapi.epic-soft.net',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
    ));
    _dio.interceptors.add(LoggingInterceptor());
  }

  static Dio getInstance() {
    return _instance._dio;
  }
}
