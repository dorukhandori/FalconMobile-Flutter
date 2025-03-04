import 'package:flutter/material.dart';
import 'package:auth_app/domain/models/user.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final VoidCallback? onLanguagePressed;
  final VoidCallback? onCurrencyPressed;
  final VoidCallback? onLogoutPressed;
  final User? user;

  const CustomAppBar({
    super.key,
    this.title,
    this.onLanguagePressed,
    this.onCurrencyPressed,
    this.onLogoutPressed,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: title,
      actions: [
        if (onLanguagePressed != null)
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: onLanguagePressed,
            tooltip: 'Dil Seçimi',
          ),
        if (onCurrencyPressed != null)
          IconButton(
            icon: const Icon(Icons.currency_exchange),
            onPressed: onCurrencyPressed,
            tooltip: 'Para Birimi',
          ),
        if (onLogoutPressed != null)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogoutPressed,
            tooltip: 'Çıkış Yap',
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
