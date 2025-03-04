import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/presentation/auth/controllers/auth_controller.dart';
import 'package:auth_app/presentation/auth/controllers/auth_state.dart';
import 'package:auth_app/presentation/auth/pages/loading_indicator.dart';
import 'package:auth_app/presentation/auth/pages/home_redirect.dart';
import 'package:auth_app/presentation/auth/pages/error_view.dart';
import 'package:auth_app/presentation/auth/pages/signup_page.dart';
import 'package:auth_app/presentation/home/pages/home_page.dart';
import 'package:auth_app/presentation/common/widgets/app_bar.dart';
import 'package:auth_app/presentation/auth/controllers/signup_state.dart';
import 'package:auth_app/domain/models/login_params.dart';
import 'package:auth_app/domain/models/user.dart';
import 'package:auth_app/presentation/common/widgets/allprox_logo.dart';
import 'package:auth_app/presentation/auth/pages/customer_select_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dio/dio.dart';
import 'package:auth_app/data/datasources/remote/dio_client.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

// Login tipi için enum
enum LoginType { customer, salesman }

// Login tipi için provider
final loginTypeProvider = StateProvider<LoginType>((ref) => LoginType.customer);

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final customerCodeController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    customerCodeController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final loginType = ref.read(loginTypeProvider);
    final customerCode = customerCodeController.text;
    final password = passwordController.text;

    if (customerCode.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dio = DioClient.getInstance();
      final headers = {
        'Content-Type': 'application/json',
        'xcmzkey':
            'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ',
      };

      final data = {
        'customerCode': customerCode,
        'password': password,
      };

      if (kDebugMode) {
        print('Login Request:');
        print('Customer Code: $customerCode');
        print('Password: $password');
        print(
            'Login Type: ${loginType == LoginType.customer ? 'Customer' : 'Salesman'}');
      }

      final response = await dio.post(
        '/Login/token',
        options: Options(headers: headers),
        data: data,
      );

      if (kDebugMode) {
        print('Login Response Status: ${response.statusCode}');
        print('Login Response Data: ${response.data}');
        print('Login Response Data Type: ${response.data.runtimeType}');

        // Yanıtın yapısını daha detaylı inceleyelim
        if (response.data is Map) {
          print(
              'Response is a Map. Keys: ${(response.data as Map).keys.toList()}');
        } else if (response.data is String) {
          print('Response is a String. Trying to parse as JSON...');
          try {
            final jsonData = jsonDecode(response.data as String);
            print('Parsed JSON: $jsonData');
            if (jsonData is Map) {
              print('Parsed JSON Keys: ${jsonData.keys.toList()}');
            }
          } catch (e) {
            print('Failed to parse response as JSON: $e');
          }
        }
      }

      if (response.statusCode == 200) {
        String accessToken = '';

        // Yanıt bir Map ise
        if (response.data is Map) {
          final responseData = response.data as Map;

          // Farklı anahtar adlarını kontrol edelim
          if (responseData.containsKey('accessToken')) {
            accessToken = responseData['accessToken'].toString();
          } else if (responseData.containsKey('AccessToken')) {
            accessToken = responseData['AccessToken'].toString();
          } else if (responseData.containsKey('access_token')) {
            accessToken = responseData['access_token'].toString();
          } else if (responseData.containsKey('token')) {
            accessToken = responseData['token'].toString();
          } else {
            // Belki iç içe bir objede olabilir
            responseData.forEach((key, value) {
              if (value is Map && value.containsKey('accessToken')) {
                accessToken = value['accessToken'].toString();
              }
            });
          }
        }
        // Yanıt bir String ise, JSON olarak parse etmeyi deneyelim
        else if (response.data is String) {
          try {
            final jsonData = jsonDecode(response.data as String);
            if (jsonData is Map) {
              if (jsonData.containsKey('accessToken')) {
                accessToken = jsonData['accessToken'].toString();
              } else if (jsonData.containsKey('AccessToken')) {
                accessToken = jsonData['AccessToken'].toString();
              } else if (jsonData.containsKey('access_token')) {
                accessToken = jsonData['access_token'].toString();
              } else if (jsonData.containsKey('token')) {
                accessToken = jsonData['token'].toString();
              }
            }
          } catch (e) {
            if (kDebugMode) {
              print('Failed to parse response as JSON: $e');
            }
          }
        }

        if (accessToken.isEmpty) {
          throw Exception('Token alınamadı. Yanıt: ${response.data}');
        }

        if (kDebugMode) {
          print('Access Token: $accessToken');
        }

        // JWT token'ı decode et
        final decodedToken = JwtDecoder.decode(accessToken);

        if (kDebugMode) {
          print('Decoded Token: $decodedToken');
          print('Decoded Token Type: ${decodedToken.runtimeType}');
          print('Decoded Token Keys: ${decodedToken.keys.toList()}');
        }

        if (loginType == LoginType.customer) {
          // Customer login
          int userId = 0;
          int customerId = 0;
          String name = '';
          String email = '';

          // Farklı anahtar adlarını kontrol edelim
          if (decodedToken.containsKey('userId')) {
            userId = int.tryParse(decodedToken['userId'].toString()) ?? 0;
          } else if (decodedToken.containsKey('UserId')) {
            userId = int.tryParse(decodedToken['UserId'].toString()) ?? 0;
          } else if (decodedToken.containsKey('user_id')) {
            userId = int.tryParse(decodedToken['user_id'].toString()) ?? 0;
          }

          if (decodedToken.containsKey('customerId')) {
            customerId =
                int.tryParse(decodedToken['customerId'].toString()) ?? 0;
          } else if (decodedToken.containsKey('CustomerId')) {
            customerId =
                int.tryParse(decodedToken['CustomerId'].toString()) ?? 0;
          } else if (decodedToken.containsKey('customer_id')) {
            customerId =
                int.tryParse(decodedToken['customer_id'].toString()) ?? 0;
          }

          if (decodedToken.containsKey('name')) {
            name = decodedToken['name']?.toString() ?? '';
          } else if (decodedToken.containsKey('Name')) {
            name = decodedToken['Name']?.toString() ?? '';
          }

          if (decodedToken.containsKey('email')) {
            email = decodedToken['email']?.toString() ?? '';
          } else if (decodedToken.containsKey('Email')) {
            email = decodedToken['Email']?.toString() ?? '';
          }

          if (kDebugMode) {
            print('User ID: $userId');
            print('Customer ID: $customerId');
            print('Name: $name');
            print('Email: $email');
          }

          // Ana sayfaya yönlendir
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(
                  user: User(
                    token: accessToken,
                    customerCode: customerCode,
                    name: name,
                    email: email,
                    customerId: customerId,
                    userId: userId,
                    loginType: 0, // Customer
                    salesmanId: 0,
                    languageId: 1,
                    customerType: 0,
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
        } else {
          // Salesman login
          var salesmanData = decodedToken['Salesman'];
          Map<String, dynamic> salesmanMap = {};

          if (salesmanData == null) {
            // Farklı anahtar adlarını kontrol edelim
            if (decodedToken.containsKey('salesman')) {
              salesmanData = decodedToken['salesman'];
            } else if (decodedToken.containsKey('SalesMan')) {
              salesmanData = decodedToken['SalesMan'];
            } else if (decodedToken.containsKey('sales_man')) {
              salesmanData = decodedToken['sales_man'];
            }
          }

          if (salesmanData is String) {
            // Eğer string ise, JSON olarak parse et
            try {
              salesmanMap = jsonDecode(salesmanData);
            } catch (e) {
              if (kDebugMode) {
                print('Salesman data parse error: $e');
              }
            }
          } else if (salesmanData is Map) {
            salesmanMap = Map<String, dynamic>.from(salesmanData);
          }

          int salesmanId = 0;
          bool customerType = false;

          // Farklı anahtar adlarını kontrol edelim
          if (salesmanMap.containsKey('Id')) {
            salesmanId = int.tryParse(salesmanMap['Id'].toString()) ?? 0;
          } else if (salesmanMap.containsKey('id')) {
            salesmanId = int.tryParse(salesmanMap['id'].toString()) ?? 0;
          } else if (salesmanMap.containsKey('ID')) {
            salesmanId = int.tryParse(salesmanMap['ID'].toString()) ?? 0;
          }

          if (salesmanMap.containsKey('CustomerType')) {
            customerType = salesmanMap['CustomerType'] == true ||
                salesmanMap['CustomerType'] == 'true';
          } else if (salesmanMap.containsKey('customerType')) {
            customerType = salesmanMap['customerType'] == true ||
                salesmanMap['customerType'] == 'true';
          } else if (salesmanMap.containsKey('customer_type')) {
            customerType = salesmanMap['customer_type'] == true ||
                salesmanMap['customer_type'] == 'true';
          }

          if (kDebugMode) {
            print('Salesman Map: $salesmanMap');
            print('Salesman ID: $salesmanId');
            print('Customer Type: $customerType');
          }

          // Müşteri seçim ekranına yönlendir
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CustomerSelectScreen(
                  token: accessToken,
                  salesmanId: salesmanId,
                  customerType: customerType,
                ),
              ),
            );
          }
        }
      } else {
        throw Exception('Login başarısız: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Login Error: $e');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Giriş başarısız: $e')),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final loginType = ref.watch(loginTypeProvider);

    ref.listen<AuthState>(authControllerProvider, (previous, state) {
      state.maybeMap(
        error: (state) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        ),
        orElse: () {},
      );
    });

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_mountain.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 16),
                      Image.asset(
                        'assets/images/epic_soft_logo.png',
                        height: 80,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Hoş Geldiniz',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Login tipi seçimi
                      DropdownButtonFormField<LoginType>(
                        value: loginType,
                        decoration: const InputDecoration(
                          labelText: 'Giriş Tipi',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: LoginType.customer,
                            child: Text('Müşteri'),
                          ),
                          DropdownMenuItem(
                            value: LoginType.salesman,
                            child: Text('Satış Temsilcisi'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(loginTypeProvider.notifier).state = value;
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: customerCodeController,
                        decoration: InputDecoration(
                          labelText: loginType == LoginType.customer
                              ? 'Müşteri Kodu'
                              : 'Satış Temsilcisi Kodu',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Şifre',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : const Text(
                                  'Giriş Yap',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SignUpPage(),
                            ),
                          );
                        },
                        child: const Text('Yeni Kayıt'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
