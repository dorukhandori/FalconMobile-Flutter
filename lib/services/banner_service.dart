import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../domain/models/banner_model.dart';
import '../services/session_service.dart';

class BannerService {
  final String baseUrl = 'https://testapi.allprox.com.tr/v1';
  final String xcmzkey =
      'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ';
  final SessionService _sessionService = SessionService();

  Future<List<BannerModel>> getBanners({String? token}) async {
    try {
      // Eğer token parametre olarak geldiyse onu kullan, yoksa session'dan al
      String accessToken = token ?? '';

      // Eğer token parametre olarak gelmediyse, session'dan almayı dene
      if (accessToken.isEmpty) {
        final session = await _sessionService.getSession();
        accessToken = session?.accessToken ?? '';
      }

      if (accessToken.isEmpty) {
        throw Exception('Token bulunamadı. Lütfen tekrar giriş yapın.');
      }

      // Doğru endpoint'i kullanıyoruz
      final url = Uri.parse('$baseUrl/Home/getAnnouncements/');

      if (kDebugMode) {
        print('Get Banners Request URL: $url');
        print('Get Banners Request Token: ${accessToken.substring(0, 20)}...');
      }

      // POST isteği yapıyoruz ve languageId parametresini gönderiyoruz
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'xcmzkey': xcmzkey,
        },
        body: jsonEncode({
          'languageId': '1',
        }),
      );

      if (kDebugMode) {
        print('Get Banners Response Status: ${response.statusCode}');
        print('Get Banners Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData
            .map((banner) => BannerModel.fromMap(banner))
            .toList();
      } else {
        throw Exception(
            'Banner listesi alınamadı: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Banner Service Error: $e');
      }
      throw Exception('Banner listesi alınamadı: $e');
    }
  }
}
