import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class JwtUtils {
  static const String _encryptionKey = 'your-32-char-encryption-key';

  static Map<String, dynamic> decodeJwt(String token) {
    final jwt = JWT.verify(token, SecretKey('your-secret-key'));
    return jwt.payload;
  }

  static String encryptData(String data) {
    final key = encrypt.Key.fromUtf8(_encryptionKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  static String decryptData(String encryptedData) {
    final key = encrypt.Key.fromUtf8(_encryptionKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);
    return decrypted;
  }
}
