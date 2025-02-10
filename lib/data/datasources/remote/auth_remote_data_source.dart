import 'package:auth_app/domain/models/user.dart';
import 'package:auth_app/domain/models/login_params.dart';
import 'package:auth_app/domain/models/register_params.dart';

abstract class AuthRemoteDataSource {
  Future<User> login(LoginParams params);
  Future<User> register(RegisterParams params);
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<User> login(LoginParams params) async {
    // TODO: Implement actual API call
    return User(
      id: '1',
      email: params.email,
      name: 'Test User',
    );
  }

  @override
  Future<User> register(RegisterParams params) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }
}
