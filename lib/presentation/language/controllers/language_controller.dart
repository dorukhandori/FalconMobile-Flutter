import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/models/language.dart';
import '../../../data/datasources/remote/dio_client.dart';

import '../../../core/di/injection.dart';

final languageControllerProvider =
    StateNotifierProvider<LanguageController, List<Language>>(
  (ref) => LanguageController(),
);

final selectedLanguageProvider =
    StateProvider<int?>((ref) => null); // Seçilen dil ID'si

class LanguageController extends StateNotifier<List<Language>> {
  LanguageController() : super([]) {
    fetchLanguages();
  }

  // Alternatif constructor - DI için
  LanguageController.withService(dynamic languageService) : super([]) {
    fetchLanguages();
  }

  Future<void> fetchLanguages() async {
    try {
      final dio = DioClient.getInstance();

      final headers = {
        'Content-Type': 'application/json',
        'xcmzkey':
            'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ',
      };

      final response = await dio.post(
        '/AdminLogin/getLanguageList',
        options: Options(headers: headers),
      );

      if (kDebugMode) {
        print('Language Response: $response');
      }

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data : [];
        final languages = data.map((item) => Language.fromJson(item)).toList();

        // Varsayılan diller yoksa örnek diller ekleyelim
        if (languages.isEmpty) {
          languages.addAll([
            Language(
                id: 1,
                code: 'tr',
                name: 'Türkçe',
                languageCulture: 'tr-TR',
                isActive: true),
            Language(
                id: 2,
                code: 'en',
                name: 'English',
                languageCulture: 'en-US',
                isActive: true),
            Language(
                id: 3,
                code: 'de',
                name: 'Deutsch',
                languageCulture: 'de-DE',
                isActive: true),
          ]);
        }

        state = languages;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Language Error: $e');
      }

      // Hata durumunda varsayılan diller
      state = [
        Language(
            id: 1,
            code: 'tr',
            name: 'Türkçe',
            languageCulture: 'tr-TR',
            isActive: true),
        Language(
            id: 2,
            code: 'en',
            name: 'English',
            languageCulture: 'en-US',
            isActive: true),
        Language(
            id: 3,
            code: 'de',
            name: 'Deutsch',
            languageCulture: 'de-DE',
            isActive: true),
      ];
    }
  }

  void setLanguage(Language language) {
    // Dil değiştirme işlemi
    if (kDebugMode) {
      print('Selected Language: ${language.name}');
    }
    // Burada dil değiştirme işlemleri yapılabilir
  }
}
