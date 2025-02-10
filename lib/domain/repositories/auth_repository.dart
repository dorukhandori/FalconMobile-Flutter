import 'package:dartz/dartz.dart';
import 'package:auth_app/core/errors/failure.dart';
import 'package:auth_app/domain/models/user.dart';
import 'package:auth_app/domain/models/login_params.dart';
import 'package:auth_app/domain/models/register_params.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(LoginParams params);
  Future<Either<Failure, User>> register(RegisterParams params);
  Future<Either<Failure, void>> logout();
}
