import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/presentation/common/widgets/app_bar.dart';
import 'package:auth_app/presentation/common/widgets/allprox_logo.dart';
import 'package:auth_app/presentation/language/controllers/language_controller.dart';
import 'package:auth_app/presentation/currency/controllers/currency_controller.dart';
import 'package:auth_app/data/services/auth_service.dart';
import 'package:auth_app/presentation/auth/controllers/auth_controller.dart';
import 'package:auth_app/presentation/auth/pages/login_page.dart';
import 'package:auth_app/presentation/product/pages/product_detail_page.dart';

import '../../core/di/injection.dart';
import '../../domain/models/currency.dart';
import '../../domain/models/language.dart';
import '../../core/utils/preferences.dart';
import 'package:auth_app/presentation/home/providers/announcement_provider.dart';

// Renk sabitleri
const Color primaryColor = Color(0xFF1B3E41); // Koyu yeşil-mavi
const Color accentColor = Color(0xFF4A90A4); // Açık mavi
const Color backgroundColor = Color(0xFFF5F6F8); // Açık gri arkaplan

// Kategori seçimi için state provider
final selectedCategoryProvider =
    StateProvider<String>((ref) => 'All categories');

// Filtre seçenekleri için state provider
final selectedFiltersProvider = StateProvider<List<String>>((ref) => []);
final searchQueryProvider = StateProvider<String>((ref) => '');

// Örnek ürün listesi oluşturalım (gerçek verilerle değiştirilecek)
final List<Map<String, dynamic>> products = [
  {
    'id': 'FA1-364',
    'name': 'MAGİC DOSE MULTİ SPRAY WILD FLOWER 350 ML-KIRÇİÇEĞ',
    'price': '115.00',
    'image': 'https://via.placeholder.com/150',
    'discount': 24,
  },
  {
    'id': 'FA1-365',
    'name': 'Başka Bir Ürün',
    'price': '99.99',
    'image': 'https://via.placeholder.com/150',
    'discount': 15,
  },
  // ... diğer ürünler
];

final filteredProductsProvider =
    StateProvider<List<Map<String, dynamic>>>((ref) {
  final selectedFilters = ref.watch(selectedFiltersProvider);
  if (selectedFilters.isEmpty) return products;

  return products.where((product) {
    if (selectedFilters.contains('discounted')) {
      return product['discount'] != null && product['discount'] > 0;
    }
    // Diğer filtre koşulları...
    return true;
  }).toList();
});

class HomePage extends ConsumerStatefulWidget {
  final String? userName;

  const HomePage({
    super.key,
    this.userName,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final languages = ref.watch(languageControllerProvider);
    final currencies = ref.watch(currencyControllerProvider);
    final announcements = ref.watch(announcementsProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const AllproxLogo(),
        actions: [
          // Dil seçimi ikonu
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              _showLanguageDialog(context, languages, ref);
            },
          ),
          // Para birimi ikonu
          IconButton(
            icon: const Icon(Icons.currency_exchange),
            onPressed: () {
              ref.read(currencyControllerProvider.notifier).fetchCurrencies();
              _showCurrencyDialog(context, currencies, ref);
            },
          ),
          // Çıkış ikonu
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _handleLogout(context, ref),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Arama alanı
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: ref.watch(selectedFiltersProvider).isEmpty
                                ? 'Ne aramıştınız?'
                                : ref.watch(selectedFiltersProvider).join(', '),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(color: Colors.grey),
                          ),
                          onChanged: (value) {
                            ref.read(searchQueryProvider.notifier).state =
                                value;
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.grey),
                        onPressed: () {
                          _showFilterDialog(context, ref);
                        },
                      ),
                    ],
                  ),
                  if (ref.watch(selectedFiltersProvider).isNotEmpty)
                    Wrap(
                      spacing: 8,
                      children:
                          ref.watch(selectedFiltersProvider).map((filter) {
                        return Chip(
                          label: Text(filter),
                          onDeleted: () {
                            ref.read(selectedFiltersProvider.notifier).state =
                                ref
                                    .read(selectedFiltersProvider)
                                    .where((f) => f != filter)
                                    .toList();
                          },
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),

            // Banner slider
            Column(
              children: [
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: announcements.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image:
                                NetworkImage(announcements[index].picturePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                // Sayfa göstergesi
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: announcements.map((announcement) {
                    int index = announcements.indexOf(announcement);
                    return Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentPage == index ? primaryColor : Colors.grey,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            // Info Cards - Dikey çizgiler kaldırıldı
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.local_shipping_outlined,
                      title: 'Ücretsiz Kargo',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.support_agent,
                      title: 'Destek 24/7',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.security,
                      title: '100% Güvenli',
                    ),
                  ),
                  Expanded(
                    child: _buildInfoCard(
                      icon: Icons.local_offer,
                      title: 'Sıcak Teklifler',
                      subtitle: '%90\'a varan',
                    ),
                  ),
                ],
              ),
            ),

            // Categories - Seçilebilir yapıldı
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kategoriler',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildCategoryChip(
                          'All categories',
                          isSelected: selectedCategory == 'All categories',
                          onTap: () => ref
                              .read(selectedCategoryProvider.notifier)
                              .state = 'All categories',
                        ),
                        _buildCategoryChip(
                          'On Sale',
                          isSelected: selectedCategory == 'On Sale',
                          onTap: () => ref
                              .read(selectedCategoryProvider.notifier)
                              .state = 'On Sale',
                        ),
                        _buildCategoryChip(
                          'Man\'s',
                          isSelected: selectedCategory == 'Man\'s',
                          onTap: () => ref
                              .read(selectedCategoryProvider.notifier)
                              .state = 'Man\'s',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Products - Kategoriye göre filtreleme
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Popüler Ürünler',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: ref.watch(filteredProductsProvider).length,
                    itemBuilder: (context, index) {
                      final product =
                          ref.watch(filteredProductsProvider)[index];
                      return _buildProductCard(
                        category: selectedCategory,
                        context: context,
                        product: product,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(
      BuildContext context, List<Language> languages, WidgetRef ref) {
    // Dilleri yükle
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
                          leading: Radio<int>(
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
                      onPressed: () async {
                        final selectedLanguageId =
                            ref.read(selectedLanguageProvider);
                        if (selectedLanguageId != null) {
                          final selectedLanguage = languages.firstWhere(
                            (lang) => lang.id == selectedLanguageId,
                          );
                          await Preferences.setLanguage(
                              selectedLanguage.languageCulture);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
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

  void _showCurrencyDialog(
      BuildContext context, List<Currency> currencies, WidgetRef ref) {
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
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: currencies.length,
                      itemBuilder: (context, index) {
                        final currency = currencies[index];
                        return ListTile(
                          title: Text(currency.type),
                          subtitle: Text('Rate: ${currency.rate}'),
                          leading: Icon(Icons.monetization_on),
                          onTap: () {
                            // Currency seçimi işlemleri
                            Navigator.of(context).pop();
                          },
                        );
                      },
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

  Future<void> _handleLogout(BuildContext context, WidgetRef ref) async {
    try {
      // AuthController'ı kullanarak logout işlemini gerçekleştir
      ref.read(authControllerProvider.notifier).logout();

      if (context.mounted) {
        // Login sayfasına yönlendir
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Çıkış yapılırken bir hata oluştu'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Container(
      width: 80,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null)
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label,
      {bool isSelected = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        child: Chip(
          label: Text(label),
          backgroundColor: isSelected ? primaryColor : Colors.grey[200],
          labelStyle: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required String category,
    required BuildContext context,
    required Map<String, dynamic> product,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(productId: product['id']),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ürün Görseli
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(product['image']),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    if (product['discount'] != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '-${product['discount']}% OFF',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Ürün Bilgileri
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₺${product['price']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Sepete Ekle'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filtreleme dialog'u
  void _showFilterDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, _) {
          final selectedFilters = ref.watch(selectedFiltersProvider);

          return AlertDialog(
            title: const Text('Filtreler'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildFilterCheckbox('Yeni Ürünler', 'new', ref),
                  _buildFilterCheckbox('İndirimli Ürünler', 'discounted', ref),
                  _buildFilterCheckbox('Stokta Var', 'in_stock', ref),
                  _buildFilterCheckbox('Hızlı Teslimat', 'fast_delivery', ref),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('İptal'),
              ),
              TextButton(
                onPressed: () {
                  // Filtreleri uygula
                  _applyFilters(ref);
                  Navigator.pop(context);
                },
                child: const Text('Uygula'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterCheckbox(String label, String value, WidgetRef ref) {
    final selectedFilters = ref.watch(selectedFiltersProvider);

    return CheckboxListTile(
      title: Text(label),
      value: selectedFilters.contains(value),
      onChanged: (bool? isChecked) {
        final filters = List<String>.from(selectedFilters);
        if (isChecked ?? false) {
          filters.add(value);
        } else {
          filters.remove(value);
        }
        ref.read(selectedFiltersProvider.notifier).state = filters;
      },
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _applyFilters(WidgetRef ref) {
    final selectedFilters = ref.read(selectedFiltersProvider);
    // Burada seçili filtrelere göre ürünleri filtreleyebilirsiniz
    // Örnek:
    final filteredProducts = ref.read(filteredProductsProvider);

    // Filtrelenmiş ürünleri göster
    // Bu kısımda state management kullanarak UI'ı güncelleyebilirsiniz
  }
}
