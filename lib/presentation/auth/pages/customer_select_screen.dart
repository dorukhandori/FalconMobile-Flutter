import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/presentation/common/widgets/allprox_logo.dart';
import 'package:dio/dio.dart';
import 'package:auth_app/data/datasources/remote/dio_client.dart';
import 'package:flutter/foundation.dart';
import 'package:auth_app/domain/models/user.dart';
import 'package:auth_app/presentation/home/pages/home_page.dart';
import 'package:auth_app/presentation/auth/pages/login_page.dart';

// Şehir listesi için provider
final cityListProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
  try {
    final dio = DioClient.getInstance();
    final headers = {
      'Content-Type': 'application/json',
      'xcmzkey':
          'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ',
    };

    final response = await dio.post(
      '/CustomerSelect/getCityList',
      options: Options(headers: headers),
    );

    if (kDebugMode) {
      print('City List Response: $response');
    }

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data is List ? response.data : [];
      return data.map((item) => item as Map<String, dynamic>).toList();
    }

    return [];
  } catch (e) {
    if (kDebugMode) {
      print('City List Error: $e');
    }
    return [];
  }
});

// İlçe listesi için provider
final townListProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, city) async {
  if (city.isEmpty) {
    return [];
  }

  try {
    final dio = DioClient.getInstance();
    final headers = {
      'Content-Type': 'application/json',
      'xcmzkey':
          'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ',
    };

    final data = {
      "city": city,
    };

    if (kDebugMode) {
      print('Town List Request: $data');
    }

    final response = await dio.post(
      '/CustomerSelect/getTownList',
      options: Options(headers: headers),
      data: data,
    );

    if (kDebugMode) {
      print('Town List Response: $response');
    }

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data is List ? response.data : [];
      return data.map((item) => item as Map<String, dynamic>).toList();
    }

    return [];
  } catch (e) {
    if (kDebugMode) {
      print('Town List Error: $e');
    }
    return [];
  }
});

// Müşteri listesi için provider
final customerListProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, Map<String, dynamic>>(
        (ref, params) async {
  try {
    final dio = DioClient.getInstance();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${params['token']}',
      'xcmzkey':
          'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ',
    };

    final data = {
      "codeOrName": params['codeOrName'] ?? "",
      "city": params['city'] ?? "",
      "town": params['town'] ?? "",
      "basketType": params['basketType'] ?? false,
      "count": params['count'] ?? 24,
      "customerType": params['customerType'] ?? true,
      "salesmanId": params['salesmanId'] ?? 1,
    };

    if (kDebugMode) {
      print('Customer List Request: $data');
    }

    final response = await dio.post(
      '/CustomerSelect/getCustomerSelectData',
      options: Options(headers: headers),
      data: data,
    );

    if (kDebugMode) {
      print('Customer List Response: $response');
    }

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data is List ? response.data : [];
      return data.map((item) => item as Map<String, dynamic>).toList();
    }

    return [];
  } catch (e) {
    if (kDebugMode) {
      print('Customer List Error: $e');
    }
    return [];
  }
});

class CustomerSelectScreen extends ConsumerStatefulWidget {
  final String token;
  final int salesmanId;
  final bool customerType;

  const CustomerSelectScreen({
    Key? key,
    required this.token,
    required this.salesmanId,
    required this.customerType,
  }) : super(key: key);

  @override
  ConsumerState<CustomerSelectScreen> createState() =>
      _CustomerSelectScreenState();
}

class _CustomerSelectScreenState extends ConsumerState<CustomerSelectScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCity = '';
  String _selectedTown = '';
  bool _basketType = false;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentCount = 24;
  List<Map<String, dynamic>> _cities = [];
  List<Map<String, dynamic>> _towns = [];
  List<Map<String, dynamic>> _customers = [];

  @override
  void initState() {
    super.initState();
    _loadCities();
    _loadCustomers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCities() async {
    try {
      final dio = DioClient.getInstance();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
        'xcmzkey':
            'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ',
      };

      final response = await dio.post(
        '/CustomerSelect/getCityList',
        options: Options(headers: headers),
      );

      if (kDebugMode) {
        print('City List Response: $response');
      }

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data : [];
        setState(() {
          _cities = data.map((item) => item as Map<String, dynamic>).toList();
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('City List Error: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şehir listesi yüklenemedi: $e')),
      );
    }
  }

  Future<void> _loadTowns() async {
    if (_selectedCity.isEmpty) {
      setState(() {
        _towns = [];
      });
      return;
    }

    try {
      final dio = DioClient.getInstance();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
        'xcmzkey':
            'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ',
      };

      final data = {
        "city": _selectedCity,
      };

      if (kDebugMode) {
        print('Town List Request: $data');
      }

      final response = await dio.post(
        '/CustomerSelect/getTownList',
        options: Options(headers: headers),
        data: data,
      );

      if (kDebugMode) {
        print('Town List Response: $response');
      }

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data : [];
        setState(() {
          _towns = data.map((item) => item as Map<String, dynamic>).toList();
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Town List Error: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('İlçe listesi yüklenemedi: $e')),
      );
    }
  }

  Future<void> _loadCustomers({bool isLoadMore = false}) async {
    if (isLoadMore) {
      setState(() {
        _isLoadingMore = true;
      });
    } else {
      setState(() {
        _isLoading = true;
        _currentCount = 24;
      });
    }

    try {
      final dio = DioClient.getInstance();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
        'xcmzkey':
            'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ',
      };

      final data = {
        "codeOrName": _searchController.text,
        "city": _selectedCity,
        "town": _selectedTown,
        "basketType": _basketType,
        "count": _currentCount,
        "customerType": widget.customerType,
        "salesmanId": widget.salesmanId,
      };

      if (kDebugMode) {
        print('Customer List Request: $data');
      }

      final response = await dio.post(
        '/CustomerSelect/getCustomerSelectData',
        options: Options(headers: headers),
        data: data,
      );

      if (kDebugMode) {
        print('Customer List Response: ${response.data}');
      }

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data : [];
        setState(() {
          if (isLoadMore) {
            _customers.addAll(
                data.map((item) => item as Map<String, dynamic>).toList());
          } else {
            _customers =
                data.map((item) => item as Map<String, dynamic>).toList();
          }
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Customer List Error: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Müşteri listesi yüklenemedi: $e')),
      );
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _listCustomers() {
    _loadCustomers();
  }

  void _loadMore() {
    setState(() {
      _currentCount += 24;
    });
    _loadCustomers(isLoadMore: true);
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCity = '';
      _selectedTown = '';
      _basketType = false;
    });
    _loadCustomers();
  }

  void _selectCustomer(Map<String, dynamic> customer) {
    // Müşteri seçildiğinde ana sayfaya yönlendir
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(
          user: User(
            token: widget.token,
            customerCode: customer['code'] ?? '',
            name: customer['name'] ?? '',
            email: '',
            customerId: int.tryParse(customer['id']?.toString() ?? '0') ?? 0,
            userId: 0,
            loginType: 1, // Salesman
            salesmanId: widget.salesmanId,
            languageId: 1,
            customerType: widget.customerType ? 1 : 0,
            isAccessories: 0,
            isService: 0,
            isAvm: 0,
            isOil: 0,
            isOto: 0,
            isMarket: 0,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Müşteri Seçimi'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCustomers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filtreler
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Image.asset(
                            'assets/images/epic_soft_logo.png',
                            height: 60,
                          ),
                        ),
                      ),

                      // Arama
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Müşteri Kodu veya Adı',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // İl seçimi
                      DropdownButtonFormField<String>(
                        value: _selectedCity.isEmpty ? null : _selectedCity,
                        decoration: const InputDecoration(
                          labelText: 'İl Seçiniz',
                          border: OutlineInputBorder(),
                        ),
                        hint: const Text('İl Seçiniz'),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem<String>(
                            value: '',
                            child: Text('Tüm İller'),
                          ),
                          ..._cities.map((city) {
                            return DropdownMenuItem<String>(
                              value: city['city'] ?? '',
                              child: Text(city['city'] ?? ''),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCity = value ?? '';
                            _selectedTown = '';
                          });
                          _loadTowns();
                        },
                      ),
                      const SizedBox(height: 16),

                      // İlçe seçimi
                      DropdownButtonFormField<String>(
                        value: _selectedTown.isEmpty ? null : _selectedTown,
                        decoration: InputDecoration(
                          labelText: 'İlçe Seçiniz',
                          border: const OutlineInputBorder(),
                          enabled: _selectedCity.isNotEmpty,
                        ),
                        hint: const Text('İlçe Seçiniz'),
                        isExpanded: true,
                        items: _selectedCity.isEmpty
                            ? []
                            : [
                                const DropdownMenuItem<String>(
                                  value: '',
                                  child: Text('Tüm İlçeler'),
                                ),
                                ..._towns.map((town) {
                                  return DropdownMenuItem<String>(
                                    value: town['town'] ?? '',
                                    child: Text(town['town'] ?? ''),
                                  );
                                }).toList(),
                              ],
                        onChanged: _selectedCity.isEmpty
                            ? null
                            : (value) {
                                setState(() {
                                  _selectedTown = value ?? '';
                                });
                              },
                      ),
                      const SizedBox(height: 16),

                      // Sepetinde ürün olanlar
                      CheckboxListTile(
                        title: const Text('Sepetinde Ürün Olanlar'),
                        value: _basketType,
                        onChanged: (value) {
                          setState(() {
                            _basketType = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 16),

                      // Butonlar
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _listCustomers,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1B3E41),
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Listele'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _clearFilters,
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Temizle'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Müşteri listesi
                Expanded(
                  child: _customers.isEmpty
                      ? const Center(child: Text('Müşteri bulunamadı'))
                      : ListView.builder(
                          itemCount: _customers.length +
                              1, // +1 for "Load More" button
                          itemBuilder: (context, index) {
                            if (index == _customers.length) {
                              // "Load More" button
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  onPressed: _isLoadingMore ? null : _loadMore,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1B3E41),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: _isLoadingMore
                                      ? const CircularProgressIndicator()
                                      : const Text('Daha Fazla Göster'),
                                ),
                              );
                            }

                            final customer = _customers[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'KOD: ${customer['code'] ?? ''}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                'AD: ${customer['name'] ?? ''}',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                  'İL: ${customer['city'] ?? ''}'),
                                              const SizedBox(height: 4),
                                              Text(
                                                  'İLÇE: ${customer['town'] ?? ''}'),
                                              const SizedBox(height: 4),
                                              Text(
                                                  'TEL: ${customer['tel1'] ?? ''}'),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            ElevatedButton(
                                              onPressed: () =>
                                                  _selectCustomer(customer),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    const Color(0xFF1B3E41),
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Seçiniz'),
                                            ),
                                            const SizedBox(height: 8),
                                            OutlinedButton(
                                              onPressed: () {
                                                // TODO: Implement visit functionality
                                              },
                                              style: OutlinedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Ziyaret'),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
