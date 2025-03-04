import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/presentation/auth/pages/login_page.dart';
import 'package:auth_app/domain/models/user.dart';
import 'package:auth_app/presentation/auth/controllers/auth_controller.dart';
import 'package:auth_app/presentation/home/controllers/banner_controller.dart';
import 'package:auth_app/presentation/home/providers/product_providers.dart';
import 'package:auth_app/presentation/common/widgets/app_bar.dart';
import 'package:auth_app/presentation/common/widgets/allprox_logo.dart';
import 'package:auth_app/presentation/language/controllers/language_controller.dart';
import 'package:auth_app/presentation/currency/controllers/currency_controller.dart';
import 'package:auth_app/presentation/product/pages/product_detail_page.dart';
import 'package:auth_app/domain/models/product.dart';
import 'package:auth_app/domain/models/language.dart';
import 'package:auth_app/domain/models/currency.dart';
import 'package:auth_app/presentation/home/providers/announcement_provider.dart';
import 'package:flutter/foundation.dart';

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

class HomePage extends ConsumerStatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentPage = 0;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    // initState'de provider'ları değiştirmek yerine,
    // WidgetsBinding.instance.addPostFrameCallback kullanarak
    // build işlemi tamamlandıktan sonra çağıralım
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    if (!_isInitialized) {
      await _loadBanners();
      await _fetchProducts();
      _startAutoPlay();
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        final bannersState = ref.read(bannerControllerProvider);

        if (bannersState.status == BannerStatus.loaded &&
            bannersState.banners.isNotEmpty) {
          final nextPage = (_currentPage + 1) % bannersState.banners.length;
          _pageController.animateToPage(
            nextPage.toInt(),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
          );
          _startAutoPlay();
        }
      }
    });
  }

  Future<void> _loadBanners() async {
    final bannerController = ref.read(bannerControllerProvider.notifier);
    await bannerController.loadBanners(token: widget.user.token);
  }

  Future<void> _fetchProducts() async {
    // Ürünleri getiren metod
    // Burada API'den ürünleri çekebilirsiniz
  }

  void _handleLogout(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showLanguageDialog(
      BuildContext context, List<Language> languages, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dil Seçimi'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: languages.length,
            itemBuilder: (context, index) {
              final language = languages[index];
              return ListTile(
                title: Text(language.name),
                onTap: () {
                  ref
                      .read(languageControllerProvider.notifier)
                      .setLanguage(language);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showCurrencyDialog(
      BuildContext context, List<Currency> currencies, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Para Birimi Seçimi'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: currencies.length,
            itemBuilder: (context, index) {
              final currency = currencies[index];
              return ListTile(
                title: Text(currency.name),
                onTap: () {
                  ref
                      .read(currencyControllerProvider.notifier)
                      .setCurrency(currency);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final languages = ref.watch(languageControllerProvider);
    final currencies = ref.watch(currencyControllerProvider);

    // Banner state'ini dinle
    final bannerState = ref.watch(bannerControllerProvider);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppBar(
        title: const AllproxLogo(height: 30),
        onLanguagePressed: () => _showLanguageDialog(context, languages, ref),
        onCurrencyPressed: () => _showCurrencyDialog(context, currencies, ref),
        onLogoutPressed: () => _handleLogout(context, ref),
        user: widget.user,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadBanners();
          await _fetchProducts();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Arama çubuğu
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Ürün ara...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () => _showFilterDialog(context, ref),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  onChanged: (value) {
                    ref.read(searchQueryProvider.notifier).state = value;
                  },
                ),
              ),

              // Banner slider
              _buildBannerSection(bannerState),

              // Bilgi kartları
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildInfoCard(
                      icon: Icons.local_shipping_outlined,
                      title: 'Ücretsiz Kargo',
                      subtitle: '250 TL ve üzeri',
                    ),
                    _buildInfoCard(
                      icon: Icons.support_agent_outlined,
                      title: 'Destek 24/7',
                      subtitle: 'Her zaman yanınızda',
                    ),
                    _buildInfoCard(
                      icon: Icons.security_outlined,
                      title: '100% Güvenli',
                      subtitle: 'Güvenli ödeme',
                    ),
                    _buildInfoCard(
                      icon: Icons.discount_outlined,
                      title: 'Sıcak Teklifler',
                      subtitle: '%90\'a varan indirimler',
                    ),
                  ],
                ),
              ),

              // Kategori seçimi
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoryChip('Tüm Kategoriler',
                          isSelected: selectedCategory == 'Tüm Kategoriler'),
                      _buildCategoryChip('Elektronik',
                          isSelected: selectedCategory == 'Elektronik'),
                      _buildCategoryChip('Giyim',
                          isSelected: selectedCategory == 'Giyim'),
                      _buildCategoryChip('Ev & Yaşam',
                          isSelected: selectedCategory == 'Ev & Yaşam'),
                      _buildCategoryChip('Kozmetik',
                          isSelected: selectedCategory == 'Kozmetik'),
                      _buildCategoryChip('Spor',
                          isSelected: selectedCategory == 'Spor'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Yeni ürünler
              _buildProductSection(
                title: 'Yeni Ürünler',
                productsProvider: newProductsProvider,
              ),

              const SizedBox(height: 16),

              // Kampanyalı ürünler
              _buildProductSection(
                title: 'Kampanyalı Ürünler',
                productsProvider: campaignProductsProvider,
              ),

              const SizedBox(height: 16),

              // Favori ürünler
              _buildProductSection(
                title: 'Favori Ürünler',
                productsProvider: favoriteProductsProvider,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSection(BannerState state) {
    if (kDebugMode) {
      print('Banner State: ${state.status}');
      if (state.status == BannerStatus.loaded) {
        print('Banner Count: ${state.banners.length}');
        if (state.banners.isNotEmpty) {
          print('First Banner: ${state.banners[0].toMap()}');
        }
      }
      if (state.status == BannerStatus.error) {
        print('Banner Error: ${state.errorMessage}');
      }
    }

    switch (state.status) {
      case BannerStatus.initial:
      case BannerStatus.loading:
        return const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        );

      case BannerStatus.loaded:
        if (state.banners.isEmpty) {
          return const SizedBox(
            height: 200,
            child: Center(child: Text('Banner bulunamadı')),
          );
        }

        return SizedBox(
          height: 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: state.banners.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = state.banners[index];
              if (kDebugMode) {
                print('Building banner at index $index: ${banner.picturePath}');
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    banner.picturePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      if (kDebugMode) {
                        print('Banner image error: $error');
                      }
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Text('Resim yüklenemedi: $error'),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        );

      case BannerStatus.error:
        return SizedBox(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hata: ${state.errorMessage}'),
                ElevatedButton(
                  onPressed: _loadBanners,
                  child: const Text('Tekrar Dene'),
                ),
              ],
            ),
          ),
        );
    }
  }

  Widget _buildProductSection({
    required String title,
    required AutoDisposeFutureProvider<List<Product>> productsProvider,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Tümünü gör
                },
                child: const Text('Tümünü Gör'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 280,
            child: ref.watch(productsProvider).when(
                  data: (products) {
                    if (products.isEmpty) {
                      return const Center(child: Text('Ürün bulunamadı'));
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _buildProductCard(product);
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text('Hata: $error'),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Icon(icon, size: 30, color: primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Container(
        width: 180,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ürün resmi
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  Image.network(
                    product.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 50),
                        ),
                      );
                    },
                  ),
                  if (product.discountRate > 0)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '%${product.discountRate.toInt()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: product.isFavorite ? Colors.red : Colors.white,
                      ),
                      onPressed: () {
                        // Favorilere ekleme/çıkarma
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Ürün bilgileri
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.productName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${product.netPrice.toStringAsFixed(2)} TL',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (product.discountRate > 0)
                        Text(
                          '${product.listPrice.toStringAsFixed(2)} TL',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                    ],
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

  Widget _buildCategoryChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // Kategori seçimi
        },
        backgroundColor: Colors.white,
        selectedColor: accentColor.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? primaryColor : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
