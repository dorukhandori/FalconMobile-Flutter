import 'package:auth_app/domain/models/user.dart';
import 'package:auth_app/domain/models/login_params.dart';
import 'package:auth_app/domain/models/register_params.dart';
import 'package:auth_app/data/datasources/remote/auth_remote_data_source.dart';
import 'package:auth_app/core/utils/preferences.dart';
import 'package:dio/dio.dart';

class AuthService {
  final AuthRemoteDataSource _remoteDataSource;

  AuthService(this._remoteDataSource);

  Future<User> login(LoginParams params) async {
    return await _remoteDataSource.login(params);
  }

  Future<User> register(RegisterParams params) async {
    return await _remoteDataSource.register(params);
  }

  Future<void> logout() async {
    await _remoteDataSource.logout();
  }

  Future<void> someApiCall() async {
    final languageCulture = await Preferences.getLanguage();
    final response = await _remoteDataSource.someApiCall(
      options: Options(
        headers: {
          'Accept-Language': languageCulture ?? 'en', // Varsayılan dil
        },
      ),
    );
    // ...
  }
}
