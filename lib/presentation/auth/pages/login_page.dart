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

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authControllerProvider, (previous, current) {
      if (current is AuthSuccess) {
        // Başarılı giriş durumunda SnackBar göster
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Giriş başarılı!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Kısa bir gecikme sonrası ana sayfaya yönlendir
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => HomePage(user: current.user),
            ),
          );
        });
      } else if (current is AuthError) {
        // Hata durumunda SnackBar göster
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(current.message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent, // Arka planı şeffaf yap
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/background_mountain.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black54, // Arka planı karartmak için
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8), // Şeffaflık ekledik
                  borderRadius:
                      BorderRadius.circular(15), // Kenarları yuvarladık
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
                      height: 100, // Logo boyutunu ayarlayın
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
          Positioned(
            bottom:
                MediaQuery.of(context).size.height * 0.1, // Daha yukarı çektik
            left: MediaQuery.of(context).size.width * 0.1,
            right: MediaQuery.of(context).size.width * 0.1,
            child: Column(
              children: [
                const SizedBox(height: 30), // Butonlar arası boşluk
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()),
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
              ],
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
