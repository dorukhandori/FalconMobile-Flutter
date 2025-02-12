import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/data/services/language_service.dart';
import 'package:auth_app/domain/models/language.dart';

import '../../../core/di/injection.dart';

final languageControllerProvider =
    StateNotifierProvider<LanguageController, List<Language>>((ref) {
  return LanguageController(ref.watch(languageServiceProvider));
});

final selectedLanguageProvider =
    StateProvider<int?>((ref) => null); // Seçilen dil ID'si

class LanguageController extends StateNotifier<List<Language>> {
  final LanguageService _languageService;

  LanguageController(this._languageService) : super([]);

  Future<void> fetchLanguages() async {
    try {
      final languages = await _languageService.getLanguageList();
      state = languages;
    } catch (e) {
      throw Exception('Failed to fetch languages: $e');
    }
  }
}
