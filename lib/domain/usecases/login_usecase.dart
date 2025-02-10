import 'package:dartz/dartz.dart';
import 'package:auth_app/core/errors/failure.dart';
import 'package:auth_app/domain/models/user.dart';
import 'package:auth_app/domain/models/login_params.dart';
import 'package:auth_app/domain/repositories/auth_repository.dart';
import 'package:auth_app/domain/usecases/usecase.dart';

class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(params);
  }
}
