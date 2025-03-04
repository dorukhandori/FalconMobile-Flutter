import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  final String accessToken;
  final int userId;
  final int customerId;

  Session({
    required this.accessToken,
    required this.userId,
    required this.customerId,
  });
}

class SessionService {
  static const String _tokenKey = 'access_token';
  static const String _userIdKey = 'user_id';
  static const String _customerIdKey = 'customer_id';

  Future<void> saveSession(Session session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, session.accessToken);
    await prefs.setInt(_userIdKey, session.userId);
    await prefs.setInt(_customerIdKey, session.customerId);
  }

  Future<Session?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userId = prefs.getInt(_userIdKey);
    final customerId = prefs.getInt(_customerIdKey);

    if (token == null || userId == null || customerId == null) {
      return null;
    }

    return Session(
      accessToken: token,
      userId: userId,
      customerId: customerId,
    );
  }

  Future<bool> isLoggedIn() async {
    // Her seferinde giriş ekranına yönlendirmek için false döndür
    return false;

    // Eski kod:
    // final session = await getSession();
    // return session != null;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_customerIdKey);
  }
}
