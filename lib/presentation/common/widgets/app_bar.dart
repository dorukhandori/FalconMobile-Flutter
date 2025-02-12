import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/presentation/language/controllers/language_controller.dart';
import 'package:auth_app/presentation/currency/controllers/currency_controller.dart';
import 'package:auth_app/domain/models/language.dart';

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
            _showCurrencyDialog(context, ref);
          },
        ),
      ],
    );
  }

  void _showLanguageDialog(
      BuildContext context, List<Language> languages, WidgetRef ref) {
    ref.read(languageControllerProvider.notifier).fetchLanguages();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Dil Seçin'),
          content: SizedBox(
            width: double.maxFinite,
            child: Consumer(
              builder: (context, ref, child) {
                final languages = ref.watch(languageControllerProvider);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: languages.length,
                      itemBuilder: (context, index) {
                        final language = languages[index];
                        return ListTile(
                          title: Text(language.name),
                          leading: Radio(
                            value: language.id,
                            groupValue: ref.watch(selectedLanguageProvider),
                            onChanged: (value) {
                              ref
                                  .read(selectedLanguageProvider.notifier)
                                  .state = value;
                            },
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final selectedLanguageId =
                            ref.read(selectedLanguageProvider);
                        if (selectedLanguageId != null) {
                          // Seçilen dilin languageCulture'ını al
                          final selectedLanguage = languages.firstWhere(
                              (lang) => lang.id == selectedLanguageId);
                          final languageCulture =
                              selectedLanguage.languageCulture;

                          // Burada dil değişikliği işlemlerini yapabilirsiniz
                          // Örneğin, dil ayarlarını kaydedebilir veya API isteklerinde kullanabilirsiniz
                          debugPrint(
                              'Selected Language Culture: $languageCulture');

                          // API isteklerinde kullanılacak dil ayarını kaydedin
                          // Örneğin, SharedPreferences kullanarak kaydedebilirsiniz

                          // Modalı kapat
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('Uygula'),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showCurrencyDialog(BuildContext context, WidgetRef ref) {
    ref.read(currencyControllerProvider.notifier).fetchCurrencies();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Döviz Seçin'),
          content: SizedBox(
            width: double.maxFinite,
            child: Consumer(
              builder: (context, ref, child) {
                final currencies = ref.watch(currencyControllerProvider);
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: currencies.length,
                  itemBuilder: (context, index) {
                    final currency = currencies[index];
                    return ListTile(
                      title: Text(currency.type),
                      subtitle: Text('Rate: ${currency.rate}'),
                      leading: Icon(Icons
                          .monetization_on), // İkonu burada kullanabilirsiniz
                      onTap: () {
                        // Seçilen döviz ile ilgili işlemleri burada yapabilirsiniz
                        Navigator.of(context).pop();
                      },
                    );
                  },
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
