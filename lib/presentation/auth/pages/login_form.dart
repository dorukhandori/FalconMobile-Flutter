import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/presentation/auth/controllers/auth_controller.dart';

class LoginForm extends ConsumerStatefulWidget {
  const LoginForm({super.key});

  @override
  ConsumerState<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? emailError;
  String? passwordError;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: 'E-posta',
            errorText: emailError,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Şifre',
            errorText: passwordError,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            setState(() {
              emailError = null;
              passwordError = null;

              if (emailController.text.isEmpty) {
                emailError = 'E-posta alanı boş bırakılamaz.';
                return;
              }
              if (passwordController.text.isEmpty) {
                passwordError = 'Şifre alanı boş bırakılamaz.';
                return;
              }
            });

            if (emailError == null && passwordError == null) {
              print(
                  'Form submitted with: ${emailController.text}'); // Debug için log
              ref.read(authControllerProvider.notifier).login(
                    emailController.text,
                    passwordController.text,
                  );
            }
          },
          child: const Text('Giriş Yap'),
        ),
      ],
    );
  }
}
