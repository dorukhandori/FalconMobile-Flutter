import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/presentation/common/widgets/allprox_logo.dart';
import 'package:dio/dio.dart';
import 'package:auth_app/data/datasources/remote/dio_client.dart';
import 'package:flutter/foundation.dart';
import 'package:auth_app/domain/models/user.dart';
import 'package:auth_app/presentation/home/pages/home_page.dart';
import 'package:auth_app/presentation/auth/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:auth_app/services/session_service.dart';

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
  String? _error;
  final SessionService _sessionService = SessionService();

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

  Future<void> _loadCustomers() async {
    if (kDebugMode) {
      print('_loadCustomers metodu başladı');
    }
    await _fetchCustomers();
    if (kDebugMode) {
      print('_loadCustomers metodu tamamlandı');
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
      _currentCount += 24;
    });

    // Provider'ı kullanarak istek at
    final params = {
      'token': widget.token,
      'codeOrName': _searchController.text,
      'city': _selectedCity,
      'town': _selectedTown,
      'basketType': _basketType,
      'count': _currentCount,
      'customerType': true,
      'salesmanId': widget.salesmanId,
    };

    if (kDebugMode) {
      print('customerListProvider parametreleri (loadMore): $params');
    }

    // Provider'ı yeniden yükle
    ref.refresh(customerListProvider(params));

    // Provider'dan gelen verileri dinle
    ref.listen<AsyncValue<List<Map<String, dynamic>>>>(
      customerListProvider(params),
      (previous, next) {
        next.when(
          data: (customers) {
            if (kDebugMode) {
              print(
                  'Müşteri listesi alındı (loadMore): ${customers.length} müşteri');
            }
            setState(() {
              _customers = customers;
              _isLoadingMore = false;
            });
          },
          loading: () {
            if (kDebugMode) {
              print('Müşteri listesi yükleniyor (loadMore)...');
            }
            // Burada _isLoadingMore zaten true olarak ayarlandı
          },
          error: (error, stackTrace) {
            if (kDebugMode) {
              print('Müşteri listesi alınamadı (loadMore): $error');
            }
            setState(() {
              _isLoadingMore = false;
              _error = 'Müşteri listesi alınamadı: $error';
            });
          },
        );
      },
    );
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

  Future<void> _fetchCustomers() async {
    if (kDebugMode) {
      print('_fetchCustomers metodu başladı');
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final session = await _sessionService.getSession();
      final token = session?.accessToken ?? '';

      if (token.isEmpty) {
        if (kDebugMode) {
          print('Token bulunamadı, widget.token kullanılıyor');
        }
        // Session'dan token alınamadıysa, widget'tan gelen token'ı kullan
        final token = widget.token;

        if (token.isEmpty) {
          setState(() {
            _isLoading = false;
            _error = 'Token bulunamadı. Lütfen tekrar giriş yapın.';
          });
          return;
        }
      }

      // Dio client'ı kullanarak istek at
      final dio = DioClient.getInstance();

      if (kDebugMode) {
        print('Dio client oluşturuldu');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
        'xcmzkey':
            'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ',
      };

      final requestBody = {
        'codeOrName': _searchController.text,
        'city': _selectedCity,
        'town': _selectedTown,
        'basketType': _basketType,
        'count': _currentCount,
        'customerType': true, // Burayı true olarak sabitledik
        'salesmanId': widget.salesmanId,
      };

      if (kDebugMode) {
        print(
            'Customer Select Request URL: /CustomerSelect/getCustomerSelectData');
        print('Customer Select Request Body: $requestBody');
      }

      if (kDebugMode) {
        print('HTTP isteği gönderiliyor...');
      }

      final response = await dio.post(
        '/CustomerSelect/getCustomerSelectData',
        options: Options(headers: headers),
        data: requestBody,
      );

      if (kDebugMode) {
        print('HTTP isteği tamamlandı');
        print('Customer Select Response Status: ${response.statusCode}');
        print('Customer Select Response Data: ${response.data}');
      }

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data is List ? response.data : [];
        setState(() {
          _customers =
              data.map((item) => item as Map<String, dynamic>).toList();
          _isLoading = false;
        });

        if (kDebugMode) {
          print('Müşteri listesi güncellendi: ${_customers.length} müşteri');
        }
      } else {
        setState(() {
          _isLoading = false;
          _error = 'Müşteri listesi alınamadı: ${response.statusCode}';
        });

        if (kDebugMode) {
          print('Müşteri listesi alınamadı: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('_fetchCustomers metodu hata ile sonlandı: $e');
      }
      setState(() {
        _isLoading = false;
        _error = 'Müşteri listesi alınamadı: $e';
      });
    }
  }

  void _listCustomers() {
    if (kDebugMode) {
      print('_listCustomers metodu çağrıldı');
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _customers = []; // Listeyi temizle
      _currentCount = 24; // Sayacı sıfırla
    });

    // Provider'ı kullanarak istek at
    final params = {
      'token': widget.token,
      'codeOrName': _searchController.text,
      'city': _selectedCity,
      'town': _selectedTown,
      'basketType': _basketType,
      'count': _currentCount,
      'customerType': true,
      'salesmanId': widget.salesmanId,
    };

    if (kDebugMode) {
      print('customerListProvider parametreleri: $params');
    }

    // Provider'ı yeniden yükle
    ref.refresh(customerListProvider(params));

    // Provider'dan gelen verileri dinle
    ref.listen<AsyncValue<List<Map<String, dynamic>>>>(
      customerListProvider(params),
      (previous, next) {
        next.when(
          data: (customers) {
            if (kDebugMode) {
              print('Müşteri listesi alındı: ${customers.length} müşteri');
            }
            setState(() {
              _customers = customers;
              _isLoading = false;
            });
          },
          loading: () {
            if (kDebugMode) {
              print('Müşteri listesi yükleniyor...');
            }
            setState(() {
              _isLoading = true;
            });
          },
          error: (error, stackTrace) {
            if (kDebugMode) {
              print('Müşteri listesi alınamadı: $error');
            }
            setState(() {
              _isLoading = false;
              _error = 'Müşteri listesi alınamadı: $error';
            });
          },
        );
      },
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
            onPressed: _listCustomers,
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
                              onPressed: () {
                                if (kDebugMode) {
                                  print('Listele butonuna tıklandı');
                                }
                                _listCustomers();
                              },
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
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _error != null
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(_error!,
                                      style:
                                          const TextStyle(color: Colors.red)),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: _listCustomers,
                                    child: const Text('Tekrar Dene'),
                                  ),
                                ],
                              ),
                            )
                          : _customers.isEmpty
                              ? const Center(child: Text('Müşteri bulunamadı'))
                              : ListView.builder(
                                  itemCount: _customers.length +
                                      (_isLoadingMore ? 1 : 1),
                                  itemBuilder: (context, index) {
                                    if (index == _customers.length) {
                                      // "Load More" button or loading indicator
                                      return Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Center(
                                          child: _isLoadingMore
                                              ? const CircularProgressIndicator()
                                              : ElevatedButton(
                                                  onPressed: _loadMore,
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF1B3E41),
                                                    foregroundColor:
                                                        Colors.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 16),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  child: const Text(
                                                      'Daha Fazla Göster'),
                                                ),
                                        ),
                                      );
                                    }

                                    // Müşteri kartını göster
                                    final customer = _customers[index];
                                    return Card(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'KOD: ${customer['code'] ?? ''}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    'AD: ${customer['name'] ?? ''}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        const Color(0xFF1B3E41),
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  child: const Text('Seçiniz'),
                                                ),
                                                const SizedBox(height: 8),
                                                OutlinedButton(
                                                  onPressed: () {
                                                    // Ziyaret işlevselliği
                                                  },
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  child: const Text('Ziyaret'),
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
