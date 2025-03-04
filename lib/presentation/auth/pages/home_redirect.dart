import 'package:flutter/material.dart';
import 'package:auth_app/domain/models/user.dart';
import 'package:auth_app/presentation/home/pages/home_page.dart';
import 'package:auth_app/presentation/auth/pages/login_page.dart';

class HomeRedirect extends StatelessWidget {
  final User? user;

  const HomeRedirect({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      return HomePage(user: user!);
    } else {
      return const LoginPage();
    }
  }
}
