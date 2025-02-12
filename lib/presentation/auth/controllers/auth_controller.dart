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

import '../../../data/datasources/remote/auth_remote_data_source.dart';
import '../../../data/datasources/remote/auth_remote_data_source_impl.dart';
import '../../../data/repositories/auth_repository_impl.dart';
import '../../../core/network/dio_client.dart';
import '../../../presentation/home/home_page.dart';

final dioProvider = Provider<Dio>((ref) {
  return DioClient.getInstance(); // DioClient'dan instance al
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

final authControllerProvider =
    StateNotifierProvider<AuthController, SignupState>((ref) {
  return AuthController(
    ref.watch(authRepositoryProvider),
    ref.watch(uploadServiceProvider),
  );
});

class AuthController extends StateNotifier<SignupState> {
  final AuthRepository _authRepository;
  final UploadService _uploadService;

  AuthController(this._authRepository, this._uploadService)
      : super(SignupState.initial());

  Future<void> login(LoginParams params, BuildContext context) async {
    state = SignupState.loading();
    try {
      final result = await _authRepository.login(params);
      result.fold(
        (failure) {
          state = SignupState.error(failure.message);
        },
        (success) {
          state = SignupState.success();
          debugPrint('Login successful, username: ${success.name}');
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(user: success),
            ),
          );
        },
      );
    } catch (e) {
      state = SignupState.error(e.toString());
      debugPrint('Login error: $e');
    }
  }

  void logout() {
    state = SignupState.initial();
  }

  Future<void> uploadFilesAndRegister(RegisterData registerData) async {
    state = SignupState.loading();

    final uploadResult =
        await _uploadService.uploadFiles(registerData.fileUrls);
    uploadResult.fold(
      (failure) {
        state = SignupState.error(failure.message);
      },
      (fileUrls) async {
        final updatedRegisterData = registerData.copyWith(fileUrls: fileUrls);
        final registerResult = await _authRepository
            .register(updatedRegisterData.toRegisterParams());
        registerResult.fold(
          (failure) {
            state = SignupState.error(failure.message);
          },
          (_) {
            state = SignupState.success();
          },
        );
      },
    );
  }
}
