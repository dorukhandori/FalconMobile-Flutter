import 'package:dartz/dartz.dart';
import 'package:auth_app/core/errors/failure.dart';
import 'package:auth_app/domain/models/user.dart';
import 'package:auth_app/domain/models/login_params.dart';
import 'package:auth_app/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Either<Failure, User>> call(LoginParams params) async {
    try {
      final result = await _authRepository.login(params);
      return result;
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
