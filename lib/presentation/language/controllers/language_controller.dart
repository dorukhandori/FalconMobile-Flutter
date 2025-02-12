import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/data/services/language_service.dart';
import 'package:auth_app/core/di/injection.dart';

final languageControllerProvider =
    StateNotifierProvider<LanguageController, List<String>>((ref) {
  return LanguageController(ref.watch(languageServiceProvider));
});

class LanguageController extends StateNotifier<List<String>> {
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
