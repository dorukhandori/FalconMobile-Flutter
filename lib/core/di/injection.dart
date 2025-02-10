import 'package:injectable/injectable.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:auth_app/core/network/dio_client.dart';
import 'package:auth_app/domain/repositories/auth_repository.dart';
import 'package:auth_app/data/repositories/auth_repository_impl.dart';
import 'package:auth_app/data/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
Future<void> configureDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Diğer bağımlılıkları kaydet
  getIt.registerSingleton(DioClient.getInstance());
  getIt.registerSingleton(AuthService(getIt<Dio>()));
  getIt.registerSingleton<AuthRepository>(
      AuthRepositoryImpl(getIt<AuthService>()));
}

@module
abstract class AppModule {
  @singleton
  Dio get dio => DioClient.getInstance();

  @singleton
  AuthService get authService => AuthService(dio);

  @singleton
  SharedPreferences get prefs =>
      throw UnimplementedError(); // Async olarak initialize edilmeli

  @lazySingleton
  AuthRepository get authRepository => AuthRepositoryImpl(getIt<AuthService>());
}
