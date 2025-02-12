import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint(
        '┌------------------------------------------------------------------------------');
    debugPrint('| Request: ${options.method} ${options.uri}');
    debugPrint('| Headers: ${options.headers}');
    debugPrint('| Data: ${options.data}');
    debugPrint(
        '└------------------------------------------------------------------------------');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        '┌------------------------------------------------------------------------------');
    debugPrint(
        '| Response: ${response.statusCode} ${response.requestOptions.uri}');
    debugPrint('| Headers: ${response.headers}');
    debugPrint('| Data: ${response.data}');
    debugPrint(
        '└------------------------------------------------------------------------------');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
        '┌------------------------------------------------------------------------------');
    debugPrint('| Error: ${err.type}');
    debugPrint('| Status: ${err.response?.statusCode}');
    debugPrint('| Message: ${err.message}');
    debugPrint('| Response Data: ${err.response?.data}');
    debugPrint('| Request: ${err.requestOptions.uri}');
    debugPrint('| Request Data: ${err.requestOptions.data}');
    debugPrint(
        '└------------------------------------------------------------------------------');
    super.onError(err, handler);
  }
}
