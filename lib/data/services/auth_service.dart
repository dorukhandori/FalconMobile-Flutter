import 'package:dio/dio.dart';
import 'package:auth_app/domain/models/login_params.dart';
import 'package:auth_app/domain/models/user.dart';
import 'package:auth_app/domain/models/register_params.dart';

class AuthService {
  final Dio _dio;
  static const String _xcmzKey =
      'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ';

  AuthService(this._dio);

  Future<User?> login(LoginParams params) async {
    try {
      print('Login attempt with: ${params.email}'); // Debug için log

      final response = await _dio.post(
        '/v1/Login/token',
        options: Options(
          headers: {
            'xcmzkey': _xcmzKey,
          },
        ),
        data: {
          "customerCode": params.email,
          "password": params.password,
        },
      );

      print('API Response: ${response.data}'); // Debug için log

      if (response.statusCode == 200) {
        return User(
          id: response.data['accessToken'] ?? '',
          email: params.email,
          name: response.data['name'] ?? 'User Name',
        );
      } else {
        print('Error status code: ${response.statusCode}'); // Debug için log
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Login error: $e'); // Debug için log
      rethrow;
    }
  }

  Future<void> register(RegisterParams params) async {
    try {
      final response = await _dio.post(
        '/v1/Login/registerForm',
        options: Options(
          headers: {
            'accept': '*/*',
            'xcmzkey': 'YOUR_API_KEY', // API anahtarınızı buraya ekleyin
            'Content-Type': 'application/json',
          },
        ),
        data: {
          "customerType": params.customerType,
          "fullName": params.fullName,
          "email": params.email,
          "phone": params.phone,
          "taxOffice": params.taxOffice,
          "taxNumber": params.taxNumber,
          "address": params.address,
          "city": params.city,
          "postalCode": params.postalCode,
          // Diğer alanlar...
        },
      );

      // Yanıtı işleyin
    } catch (e) {
      // Hata durumunu yönetin
      throw Exception('Kayıt işlemi başarısız: $e');
    }
  }
}
