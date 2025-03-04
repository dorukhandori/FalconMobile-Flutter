import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/domain/usecases/login_usecase.dart';
import 'package:auth_app/domain/models/login_params.dart';
import 'package:auth_app/presentation/auth/controllers/auth_state.dart';
import 'package:auth_app/domain/repositories/auth_repository.dart';
import 'package:auth_app/data/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:auth_app/core/errors/failure.dart';
import 'package:auth_app/data/services/upload_service.dart';
import 'package:auth_app/domain/models/register_data.dart';
import 'package:auth_app/presentation/auth/controllers/signup_state.dart';
import 'package:flutter/material.dart';
import 'package:auth_app/domain/models/customer_info.dart';
import 'package:auth_app/core/di/providers.dart';
import 'package:auth_app/core/utils/jwt_utils.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:auth_app/services/session_service.dart';
import 'package:auth_app/presentation/home/controllers/banner_controller.dart';

import '../../../core/di/injection.dart';
import '../../../data/datasources/remote/auth_remote_data_source.dart';
import '../../../data/datasources/remote/auth_remote_data_source_impl.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../core/network/dio_client.dart';
import '../../../presentation/home/pages/home_page.dart';

final dioProvider = Provider<Dio>((ref) {
  final encryptedCustomerId =
      "your_encrypted_customer_id"; // Buraya uygun bir değer atayın
  return getDio(encryptedCustomerId);
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(dioProvider));
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(authRemoteDataSourceProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(authServiceProvider));
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final uploadServiceProvider = Provider<UploadService>((ref) {
  return UploadService(ref.watch(dioProvider));
});

final sessionServiceProvider = Provider<SessionService>((ref) {
  return SessionService();
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final authRepository = ref.watch(authRepositoryProvider);
    final uploadService = ref.watch(uploadServiceProvider);
    final sessionService = ref.watch(sessionServiceProvider);
    return AuthController(authRepository, uploadService, sessionService, ref);
  },
);

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final UploadService _uploadService;
  final SessionService _sessionService;
  final Ref ref;

  AuthController(
      this._authRepository, this._uploadService, this._sessionService, this.ref)
      : super(const AuthState.initial());

  Future<void> login(LoginParams params, BuildContext context) async {
    try {
      state = const AuthState.loading();
      final result = await _authRepository.login(params);

      result.fold(
        (failure) => state = AuthState.error(failure.message),
        (user) {
          final accessToken = user.token;
          final encryptedToken = JwtUtils.encryptData(accessToken);
          final customerId = JwtUtils.decodeJwt(accessToken)['customerID'];
          final userId = JwtUtils.decodeJwt(accessToken)['userID'];

          // Session'a token'ı kaydedelim
          _sessionService.saveSession(Session(
            accessToken:
                accessToken, // Şifrelemeden orijinal token'ı kaydediyoruz
            userId: int.parse(userId.toString()),
            customerId: int.parse(customerId.toString()),
          ));

          // Kullanıcı bilgilerini sakla
          saveUserSession(encryptedToken, userId, customerId);

          state = AuthState.authenticated(user, encryptedToken);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomePage(user: user)));
        },
      );
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    // Önce mevcut state'i saklayalım
    final currentState = state;

    // State'i loading olarak ayarlayalım
    state = const AuthState.loading();

    try {
      // Session'ı temizle
      await _sessionService.clearSession();

      // Banner controller'ı sıfırla
      ref.read(bannerControllerProvider.notifier).reset();

      // State'i unauthenticated olarak ayarla
      state = const AuthState.unauthenticated();
    } catch (e) {
      // Hata durumunda önceki state'e geri dön
      state = currentState;
      rethrow;
    }
  }

  Future<void> uploadFilesAndRegister(RegisterData registerData) async {
    state = const AuthState.loading();

    final uploadResult =
        await _uploadService.uploadFiles(registerData.fileUrls);
    uploadResult.fold(
      (failure) => state = AuthState.error(failure.message),
      (fileUrls) async {
        final updatedRegisterData = registerData.copyWith(fileUrls: fileUrls);
        final registerResult = await _authRepository
            .register(updatedRegisterData.toRegisterParams());
        registerResult.fold(
          (failure) => state = AuthState.error(failure.message),
          (user) => state = AuthState.authenticated(user, user.token),
        );
      },
    );
  }

  String? getToken() {
    return state.maybeMap(
      authenticated: (state) => state.token,
      orElse: () => null,
    );
  }

  CustomerInfo getCustomerInfo() {
    return state.maybeMap(
      authenticated: (state) => CustomerInfo(
        customerId: state.user.customerId,
        userId: state.user.userId,
        loginType: state.user.loginType,
        salesmanId: state.user.salesmanId,
        languageId: state.user.languageId,
      ),
      orElse: () => const CustomerInfo(
        customerId: 0,
        userId: 0,
        loginType: 0,
        salesmanId: 0,
        languageId: 1,
      ),
    );
  }

  void handleLoginResponse(String accessToken) {
    if (isTokenValid(accessToken)) {
      // Token geçerli, işlemlere devam edin
    } else {
      // Token geçersiz, kullanıcıyı bilgilendirin
      print('Geçersiz token.');
    }
  }

  bool isTokenValid(String token) {
    if (JwtDecoder.isExpired(token)) {
      print("Token süresi dolmuş.");
      return false;
    }
    return true;
  }

  String getEncryptedCustomerId() {
    final token = getToken();
    if (token != null) {
      final decodedToken = JwtUtils.decodeJwt(token);
      final customerId = decodedToken['customerID'];
      return JwtUtils.encryptData(customerId.toString());
    }
    return '';
  }

  String getEncryptedUserId() {
    final token = getToken();
    if (token != null) {
      final decodedToken = JwtUtils.decodeJwt(token);
      final userId = decodedToken['userID'];
      return JwtUtils.encryptData(userId.toString());
    }
    return '';
  }

  void someFunction() {
    final encryptedCustomerId = getEncryptedCustomerId();
    final dio = DioClient.getInstance(
      encryptedCustomerId: encryptedCustomerId,
    );

    // Dio ile istek yapabilirsiniz
  }

  void saveUserSession(
      String encryptedToken, String userId, String customerId) {
    // Kullanıcı oturum bilgilerini saklamak için gerekli işlemler
    // Örneğin, SharedPreferences kullanarak saklayabilirsiniz
  }
}
