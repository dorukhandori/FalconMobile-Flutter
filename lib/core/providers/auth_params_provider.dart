import 'package:auth_app/presentation/auth/controllers/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authParamsProvider = Provider<Map<String, dynamic>>((ref) {
  final authState = ref.watch(authControllerProvider);
  return authState.maybeWhen(
    authenticated: (user, _) => {
      'customerId': user.customerId,
      'userId': user.userId,
      'loginType': user.loginType,
      'salesmanId': user.salesmanId,
      'languageId': user.languageId,
    },
    orElse: () => {
      'customerId': 0,
      'userId': 0,
      'loginType': 0,
      'salesmanId': 0,
      'languageId': 1,
    },
  );
});
