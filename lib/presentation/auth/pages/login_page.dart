import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/presentation/auth/controllers/auth_controller.dart';
import 'package:auth_app/presentation/auth/controllers/auth_state.dart';
import 'package:auth_app/presentation/auth/pages/login_form.dart';
import 'package:auth_app/presentation/auth/pages/loading_indicator.dart';
import 'package:auth_app/presentation/auth/pages/home_redirect.dart';
import 'package:auth_app/presentation/auth/pages/error_view.dart';
import 'package:auth_app/presentation/auth/pages/signup_page.dart';
import 'package:auth_app/presentation/home/pages/home_page.dart';
import 'package:auth_app/presentation/common/widgets/app_bar.dart';
import 'package:auth_app/presentation/auth/controllers/signup_state.dart';
import 'package:auth_app/domain/models/login_params.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);

    ref.listen<SignupState>(authControllerProvider, (previous, current) {
      current.when(
        initial: () {},
        loading: () {},
        success: () {
          Navigator.pushReplacementNamed(context, '/home');
        },
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
      );
    });

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background_mountain.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black54,
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/epic_soft_logo.png',
                      height: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Hoş Geldiniz',
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    const LoginForm(),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => _showForgotPasswordDialog(context),
                      child: const Text('Şifremi Unuttum?'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (state == SignupState.loading()) const LoadingIndicator(),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Yeni Kayıt Oluştur',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Şifre Sıfırlama'),
          content: TextField(
            controller: emailController,
            decoration:
                const InputDecoration(labelText: 'E-posta adresinizi girin'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // TODO: Implement password reset logic
                Navigator.of(context).pop();
              },
              child: const Text('Gönder'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
          ],
        );
      },
    );
  }
}
