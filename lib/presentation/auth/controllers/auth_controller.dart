import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/domain/usecases/login_usecase.dart';
import 'package:auth_app/domain/models/login_params.dart';
import 'package:auth_app/presentation/auth/controllers/auth_state.dart';
import 'package:auth_app/domain/repositories/auth_repository.dart';
import 'package:auth_app/data/services/auth_service.dart';
import 'package:dio/dio.dart';

import '../../../data/repositories/auth_repository_impl.dart';
import '../../../core/network/dio_client.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioClient.getInstance(); // DioClient'dan instance al
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authServiceProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref.watch(loginUseCaseProvider));
});

class AuthController extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;

  AuthController(this._loginUseCase) : super(const AuthInitial());

  Future<void> login(String email, String password) async {
    try {
      print('AuthController login attempt');

      state = const AuthLoading();
      final result = await _loginUseCase(
        LoginParams(email: email, password: password),
      );

      state = result.fold(
        (failure) {
          print('Login failure: ${failure.message}');
          return AuthError(failure.message);
        },
        (user) {
          print('Login success: ${user.email}');
          return AuthSuccess(user);
        },
      );
    } catch (e) {
      print('AuthController error: $e');
      state = AuthError(e.toString());
    }
  }
}
