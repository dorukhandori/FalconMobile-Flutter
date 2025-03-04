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
import 'package:auth_app/presentation/language/controllers/language_controller.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: false,
)
Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Riverpod ProviderContainer'ını kaydedelim
  getIt.registerSingleton<ProviderContainer>(ProviderContainer());

  // DioClient'ı yeni base URL ile oluştur
  final dio = DioClient.getInstance(
    encryptedCustomerId: 'your_encrypted_customer_id',
  );

  // Dio'yu GetIt'e kaydedin
  getIt.registerSingleton<Dio>(dio);

  // Remote Data Source
  final authRemoteDataSource = AuthRemoteDataSourceImpl(dio);
  getIt.registerSingleton<AuthRemoteDataSource>(authRemoteDataSource);

  // Services
  final authService = AuthService(authRemoteDataSource);
  getIt.registerSingleton<AuthService>(authService);

  getIt.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(getIt<AuthService>()));

  getIt.registerSingleton<LanguageService>(LanguageService(getIt<Dio>()));
  getIt.registerSingleton(CurrencyService(dio));

  // Upload Service kaydı
  getIt.registerSingleton<UploadService>(UploadService(dio));

  // LanguageController kaydı
  getIt.registerSingleton<LanguageController>(
      LanguageController.withService(getIt<LanguageService>()));

  // Diğer servis kayıtları...
}

@module
abstract class AppModule {
  @singleton
  Dio get dio => DioClient.getInstance(
        encryptedCustomerId: 'your_encrypted_customer_id',
      );

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
  final encryptedCustomerId =
      "your_encrypted_customer_id"; // Buraya uygun bir değer atayın
  return getDio(encryptedCustomerId);
});

final uploadServiceProvider = Provider<UploadService>((ref) {
  return UploadService(ref.watch(dioProvider));
});

Dio getDio(String encryptedCustomerId) {
  return DioClient.getInstance(encryptedCustomerId: encryptedCustomerId);
}
