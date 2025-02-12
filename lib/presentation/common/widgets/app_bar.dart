import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/presentation/language/controllers/language_controller.dart';
import 'package:auth_app/presentation/currency/controllers/currency_controller.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languages = ref.watch(languageControllerProvider);
    final currencyRates = ref.watch(currencyControllerProvider);

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: const SizedBox.shrink(),
      actions: [
        IconButton(
          icon: const Icon(Icons.language, color: Colors.white),
          onPressed: () {
            _showLanguageDialog(context, languages, ref);
          },
        ),
        IconButton(
          icon: const Icon(Icons.currency_exchange, color: Colors.white),
          onPressed: () {
            _showCurrencyRatesDialog(context, currencyRates);
          },
        ),
      ],
    );
  }

  void _showLanguageDialog(
      BuildContext context, List<String> languages, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Dil Seçin'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(languages[index]),
                  onTap: () {
                    // Dil değiştirme işlemi
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showCurrencyRatesDialog(
      BuildContext context, Map<String, double> currencyRates) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Döviz Kurları'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: currencyRates.length,
              itemBuilder: (context, index) {
                final key = currencyRates.keys.elementAt(index);
                final value = currencyRates[key];
                return ListTile(
                  title: Text(key),
                  trailing: Text(value.toString()),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
