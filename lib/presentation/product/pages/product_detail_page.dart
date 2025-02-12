import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/presentation/common/widgets/app_bar.dart';

// Renk sabitleri
const Color primaryColor = Color(0xFF1B3E41); // Koyu yeşil-mavi
const Color accentColor = Color(0xFF4A90A4); // Açık mavi
const Color backgroundColor = Color(0xFFF5F6F8); // Açık gri arkaplan

class ProductDetailPage extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailPage({Key? key, required this.productId})
      : super(key: key);

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedImage =
      'https://cdn.epic-soft.net/files/ce592a48-7e72-4c1c-a36e-261d85ccdd64.jpg';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Detayı'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ana ürün görseli
            Image.network(
              selectedImage,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),

            // Alternatif ürün görselleri
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImage =
                              'https://cdn.epic-soft.net/files/ce592a48-7e72-4c1c-a36e-261d85ccdd64.jpg';
                        });
                      },
                      child: Container(
                        width: 80,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedImage ==
                                        'https://cdn.epic-soft.net/files/ce592a48-7e72-4c1c-a36e-261d85ccdd64.jpg' &&
                                    index == 0
                                ? primaryColor
                                : Colors.grey,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            'https://cdn.epic-soft.net/files/ce592a48-7e72-4c1c-a36e-261d85ccdd64.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Ürün bilgileri
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MAGİC DOSE MULTİ SPRAY WILD FLOWER 350 ML-KIRÇİÇEĞ',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('Ürün Kodu: FA1-364',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 16),
                  _buildInfoRow('Barkod', '00000000000'),
                  _buildInfoRow('Birim', 'ADET'),
                  _buildInfoRow('Liste Fiyat', '115.00 TL'),
                  _buildInfoRow('İskonto', '-'),
                  _buildInfoRow('Net Fiyat', '115.00 TL'),
                  _buildInfoRow('Kdv\'li Net Fiyat', '135.70 TL'),
                ],
              ),
            ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Açıklama'),
                Tab(text: 'Alternatifler'),
                Tab(text: 'Özellikler'),
                Tab(text: 'Stok Hareketleri'),
                Tab(text: 'Stok Hareketleri Toplu'),
              ],
            ),

            // Tab Bar View
            SizedBox(
              height: 300,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTabContent('Açıklama'),
                  _buildTabContent('Alternatifler'),
                  _buildTabContent('Özellikler'),
                  _buildTabContent('Stok Hareketleri'),
                  _buildTabContent('Stok Hareketleri Toplu'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // Sepete ekleme fonksiyonu
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Sepete Ekle',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTabContent(String title) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(title),
    );
  }
}
