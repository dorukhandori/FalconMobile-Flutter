// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../data/datasources/remote/auth_remote_data_source.dart' as _i624;
import '../../data/services/auth_service.dart' as _i117;
import '../../data/services/currency_service.dart' as _i109;
import '../../data/services/language_service.dart' as _i1014;
import '../../domain/repositories/auth_repository.dart' as _i1073;
import 'injection.dart' as _i464;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt init(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final appModule = _$AppModule();
  gh.singleton<_i361.Dio>(() => appModule.dio);
  gh.singleton<_i624.AuthRemoteDataSource>(
      () => appModule.authRemoteDataSource);
  gh.singleton<_i117.AuthService>(() => appModule.authService);
  gh.singleton<_i460.SharedPreferences>(() => appModule.prefs);
  gh.lazySingleton<_i1073.AuthRepository>(() => appModule.authRepository);
  gh.lazySingleton<_i1014.LanguageService>(() => appModule.languageService);
  gh.lazySingleton<_i109.CurrencyService>(() => appModule.currencyService);
  return getIt;
}

class _$AppModule extends _i464.AppModule {}
