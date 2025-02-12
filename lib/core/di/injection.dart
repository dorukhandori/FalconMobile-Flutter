import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:auth_app/core/network/dio_client.dart';
import 'package:auth_app/domain/repositories/auth_repository.dart';
import 'package:auth_app/data/repositories/auth_repository_impl.dart';
import 'package:auth_app/data/services/auth_service.dart';
import 'package:auth_app/data/services/language_service.dart';
import 'package:auth_app/data/services/currency_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:auth_app/data/datasources/remote/auth_remote_data_source.dart';
import 'package:auth_app/data/datasources/remote/auth_remote_data_source_impl.dart';
import 'package:auth_app/data/services/upload_service.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  final dio = await DioClient.getInstance();

  // Remote Data Source
  final authRemoteDataSource = AuthRemoteDataSourceImpl(dio);
  getIt.registerSingleton<AuthRemoteDataSource>(authRemoteDataSource);

  // Services
  final authService = AuthService(authRemoteDataSource);
  getIt.registerSingleton<AuthService>(authService);

  getIt.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(getIt<AuthService>()));

  getIt.registerSingleton(LanguageService(dio));
  getIt.registerSingleton(CurrencyService(dio));

  // Upload Service kaydı
  getIt.registerSingleton<UploadService>(UploadService(dio));
}

@module
abstract class AppModule {
  @singleton
  Dio get dio => DioClient.getInstance();

  @singleton
  AuthRemoteDataSource get authRemoteDataSource =>
      AuthRemoteDataSourceImpl(dio);

  @singleton
  AuthService get authService => AuthService(authRemoteDataSource);

  @singleton
  SharedPreferences get prefs =>
      throw UnimplementedError(); // Async olarak initialize edilmeli

  @lazySingleton
  AuthRepository get authRepository => AuthRepositoryImpl(getIt<AuthService>());

  @lazySingleton
  LanguageService get languageService => LanguageService(getIt<Dio>());

  @lazySingleton
  CurrencyService get currencyService => CurrencyService(getIt<Dio>());
}

// Providers
final languageServiceProvider = Provider<LanguageService>((ref) {
  return getIt<LanguageService>();
});

final currencyServiceProvider = Provider<CurrencyService>((ref) {
  return getIt<CurrencyService>();
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(ref.watch(dioProvider));
});

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(ref.watch(authRemoteDataSourceProvider));
});

final dioProvider = Provider<Dio>((ref) {
  return DioClient.getInstance();
});

final uploadServiceProvider = Provider<UploadService>((ref) {
  return UploadService(ref.watch(dioProvider));
});
