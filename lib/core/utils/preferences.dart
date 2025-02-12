import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static Future<void> setLanguage(String languageCulture) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCulture', languageCulture);
  }

  static Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('languageCulture');
  }
}
