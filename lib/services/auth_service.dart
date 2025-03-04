import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../models/session_model.dart';

class AuthService {
  static const String baseUrl = 'https://testapi.allprox.com.tr/v1';
  static const String xcmzkey =
      'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ';

  Future<SessionModel> customerLogin(
      String customerCode, String password) async {
    final url = Uri.parse('$baseUrl/Login/token');

    final requestBody = {
      'customerCode': customerCode,
      'password': password,
    };

    if (kDebugMode) {
      print('Customer Login Request: $requestBody');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'xcmzkey': xcmzkey,
      },
      body: jsonEncode(requestBody),
    );

    if (kDebugMode) {
      print('Customer Login Response Status: ${response.statusCode}');
      print('Customer Login Response Body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Response yapısını detaylı inceleyelim
      if (kDebugMode) {
        print('Response Data Keys: ${responseData.keys.toList()}');
        print('Response Data: $responseData');
      }

      // accessToken'ı farklı bir şekilde almayı deneyelim
      String accessToken = '';
      if (responseData.containsKey('accessToken')) {
        accessToken = responseData['accessToken'].toString();
        if (kDebugMode) {
          print('Access Token: $accessToken');
          print('Access Token Type: ${accessToken.runtimeType}');
        }
      } else if (responseData.containsKey('AccessToken')) {
        // Belki büyük harfle yazılmıştır
        accessToken = responseData['AccessToken'].toString();
      } else {
        // Belki iç içe bir objede olabilir
        responseData.forEach((key, value) {
          if (value is Map && value.containsKey('accessToken')) {
            accessToken = value['accessToken'].toString();
          }
        });
      }

      if (accessToken.isEmpty) {
        throw Exception('Token bulunamadı. Response: $responseData');
      }

      // JWT token'ı decode et
      try {
        final Map<String, dynamic> decodedToken =
            JwtDecoder.decode(accessToken);

        if (kDebugMode) {
          print('Decoded JWT Token: $decodedToken');
        }

        // JWT içinden gerekli bilgileri çıkar
        int userId = 0;
        int customerId = 0;

        if (decodedToken.containsKey('users')) {
          final users = decodedToken['users'];
          if (users is Map) {
            userId = users['id'] ?? 0;
            customerId = users['customerId'] ?? 0;
          }
        }

        return SessionModel(
          accessToken: accessToken,
          userId: userId,
          customerId: customerId,
          loginType: 'Customer',
        );
      } catch (e) {
        if (kDebugMode) {
          print('JWT Decode Error: $e');
        }
        throw Exception('Token ayrıştırılamadı: $e');
      }
    } else {
      throw Exception('Müşteri girişi başarısız: ${response.body}');
    }
  }

  Future<SessionModel> salesmanLogin(
      String salesmanCode, String password) async {
    final url = Uri.parse('$baseUrl/Login/token');

    final requestBody = {
      'customerCode': salesmanCode,
      'password': password,
      'loginType': 'Salesman',
    };

    if (kDebugMode) {
      print('Salesman Login Request: $requestBody');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'xcmzkey': xcmzkey,
      },
      body: jsonEncode(requestBody),
    );

    if (kDebugMode) {
      print('Salesman Login Response Status: ${response.statusCode}');
      print('Salesman Login Response Body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Response yapısını detaylı inceleyelim
      if (kDebugMode) {
        print('Response Data Keys: ${responseData.keys.toList()}');
        print('Response Data: $responseData');
      }

      // accessToken'ı farklı bir şekilde almayı deneyelim
      String accessToken = '';
      if (responseData.containsKey('accessToken')) {
        accessToken = responseData['accessToken'].toString();
      } else if (responseData.containsKey('AccessToken')) {
        // Belki büyük harfle yazılmıştır
        accessToken = responseData['AccessToken'].toString();
      } else {
        // Belki iç içe bir objede olabilir
        responseData.forEach((key, value) {
          if (value is Map && value.containsKey('accessToken')) {
            accessToken = value['accessToken'].toString();
          }
        });
      }

      if (accessToken.isEmpty) {
        throw Exception('Token bulunamadı. Response: $responseData');
      }

      // JWT token'ı decode et
      try {
        final Map<String, dynamic> decodedToken =
            JwtDecoder.decode(accessToken);

        if (kDebugMode) {
          print('Decoded JWT Token: $decodedToken');
        }

        // JWT içinden gerekli bilgileri çıkar
        int salesmanId = 0;
        bool customerType = false;

        if (decodedToken.containsKey('Salesman')) {
          try {
            final salesmanJson = decodedToken['Salesman'];
            final salesmanData = jsonDecode(salesmanJson);
            salesmanId = salesmanData['Id'] ?? 0;
            customerType = salesmanData['CustomerType'] ?? false;
          } catch (e) {
            if (kDebugMode) {
              print('Salesman verisi ayrıştırılamadı: $e');
            }
          }
        }

        return SessionModel(
          accessToken: accessToken,
          salesmanId: salesmanId,
          customerType: customerType,
          loginType: 'Salesman',
        );
      } catch (e) {
        if (kDebugMode) {
          print('JWT Decode Error: $e');
        }
        throw Exception('Token ayrıştırılamadı: $e');
      }
    } else {
      throw Exception('Satış temsilcisi girişi başarısız: ${response.body}');
    }
  }
}
