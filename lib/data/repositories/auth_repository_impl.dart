import 'package:dartz/dartz.dart';
import 'package:auth_app/core/errors/failure.dart';
import 'package:auth_app/domain/models/user.dart';
import 'package:auth_app/domain/models/login_params.dart';
import 'package:auth_app/domain/models/register_params.dart';
import 'package:auth_app/domain/repositories/auth_repository.dart';
import 'package:auth_app/data/services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl(this.authService);

  @override
  Future<Either<Failure, User>> login(LoginParams params) async {
    try {
      final user = await authService.login(params);
      if (user != null) {
        return Right(user);
      } else {
        return Left(ServerFailure('Kullanıcı bulunamadı.'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register(RegisterParams params) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authService.logout();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
