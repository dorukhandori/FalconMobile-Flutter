import 'package:auth_app/domain/models/user.dart';
import 'package:auth_app/domain/models/login_params.dart';
import 'package:auth_app/domain/models/register_params.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(LoginParams params);
  Future<User> register(RegisterParams params);
  Future<void> logout();
}
