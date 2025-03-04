import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:auth_app/data/datasources/remote/auth_remote_data_source.dart';
import 'package:auth_app/data/datasources/remote/auth_remote_data_source_impl.dart';
import 'package:auth_app/core/network/dio_client.dart';
import 'package:auth_app/data/services/auth_service.dart';
import 'package:auth_app/domain/repositories/auth_repository.dart';
import 'package:auth_app/data/repositories/auth_repository_impl.dart';
import 'package:auth_app/domain/usecases/login_usecase.dart';
import 'package:auth_app/data/services/upload_service.dart';
import 'package:auth_app/presentation/auth/controllers/auth_controller.dart';

final encryptedCustomerIdProvider = Provider<String>((ref) {
  final authController = ref.read(authControllerProvider.notifier);
  return authController.getEncryptedCustomerId();
});

final encryptedUserIdProvider = Provider<String>((ref) {
  final authController = ref.read(authControllerProvider.notifier);
  return authController.getEncryptedUserId();
});

final dioProvider = Provider<Dio>((ref) {
  final encryptedCustomerId =
      "your_encrypted_customer_id"; // Buraya uygun bir değer atayın
  return DioClient.getInstance(encryptedCustomerId: encryptedCustomerId);
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
