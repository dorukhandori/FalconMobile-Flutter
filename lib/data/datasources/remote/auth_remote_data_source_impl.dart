import 'package:dio/dio.dart';
import 'package:auth_app/core/network/dio_client.dart';
import 'package:auth_app/data/datasources/remote/auth_remote_data_source.dart';
import 'package:auth_app/domain/models/user.dart';
import 'package:auth_app/domain/models/login_params.dart';
import 'package:auth_app/domain/models/register_params.dart';
import 'package:flutter/foundation.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<User> login(LoginParams params) async {
    try {
      final response = await _dio.post(
        '/v1/Login/token',
        data: {
          'customerCode': params.customerCode,
          'password': params.password,
        },
        options: Options(
          headers: {
            'accept': '*/*',
            'xcmzkey': DioClient.xcmzKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Login Response: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['statusCode'] == 200 &&
            responseData['data'] != null &&
            responseData['data']['data'] != null) {
          final userData = responseData['data']['data'] as Map<String, dynamic>;
          final token = responseData['data']['accessToken'] as String;

          // Debug logları
          debugPrint('Full userData: $userData');
          debugPrint('Name from API: ${userData['name']}');
          debugPrint('Code from API: ${userData['code']}');

          // User modelini oluştur
          final user = User.fromJson({
            'id': userData['id']?.toString(),
            'customerCode': userData['code']?.toString(),
            'name': userData['name']?.toString() ??
                userData['code']?.toString() ??
                'Kullanıcı',
            'email': userData['email']?.toString(),
            'token': token,
            'phone': userData['tel1']?.toString(),
            'taxOffice': userData['taxOffice']?.toString(),
          });

          // Debug log - oluşturulan user objesi
          debugPrint('Created User object name: ${user.name}');

          return user;
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      debugPrint('Login Error: $e');
      throw Exception('Failed to login: $e');
    }
  }

  @override
  Future<User> register(RegisterParams params) async {
    try {
      print('Register request data: ${params.toJson()}'); // Debug için

      final response = await _dio.post(
        '/v1/Login/registerForm',
        data: params.toJson(),
        options: Options(
          headers: {
            'accept': '*/*',
            'xcmzkey': DioClient.xcmzKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Register response: ${response.data}'); // Debug için

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          return User.fromJson(responseData);
        } else {
          print('Invalid response format: $responseData'); // Debug için
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
            'Failed to register with status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Register error: $e');
      print('Stack trace: $stackTrace'); // Debug için
      throw Exception('Failed to register: $e');
    }
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<void> someApiCall({Options? options}) async {
    final response = await _dio.post(
      '/v1/someEndpoint', // Uygun endpoint'i buraya yazın
      options: options ?? Options(), // options parametresini kullan
    );
    // Yanıtı işleyin
  }
}
