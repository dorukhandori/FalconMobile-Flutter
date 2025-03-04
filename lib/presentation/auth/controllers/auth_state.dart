import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:auth_app/domain/models/user.dart';

part 'auth_state.freezed.dart';
part 'auth_state.g.dart';

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user, String token) =
      _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;

  factory AuthState.fromJson(Map<String, dynamic> json) =>
      _$AuthStateFromJson(json);

  String? get token => whenOrNull(
        authenticated: (_, token) => token,
      );

  User? get user => whenOrNull(
        authenticated: (user, _) => user,
      );
}
