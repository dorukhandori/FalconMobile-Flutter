import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/data/services/auth_service.dart';
import 'package:auth_app/domain/models/register_params.dart';
import 'package:auth_app/core/di/injection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auth_app/presentation/auth/pages/login_page.dart';
import 'package:auth_app/presentation/auth/controllers/auth_controller.dart';
import 'package:auth_app/presentation/auth/controllers/signup_state.dart';
import 'package:auth_app/domain/models/register_data.dart';
import 'package:auth_app/presentation/common/formatters/phone_input_formatter.dart';
import 'package:flutter/services.dart';
import 'package:auth_app/data/services/upload_service.dart';

class SignUpPage extends ConsumerStatefulWidget {
  SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final inputDecoration = const InputDecoration(
    border: OutlineInputBorder(),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );

  String selectedCustomerType = 'KURUMSAL';
  String? selectedCity;
  List<String> customerTypes = ['KURUMSAL', 'BİREYSEL', 'GERÇEK KİŞİ'];
  List<String> cities = [
    'Adana',
    'Adıyaman',
    'Afyonkarahisar',
    'Ağrı',
    'Aksaray',
    'Amasya',
    'Ankara',
    'Antalya',
    'Ardahan',
    'Artvin',
    'Aydın',
    'Balıkesir',
    'Bilecik',
    'Bingöl',
    'Bitlis',
    'Bolu',
    'Burdur',
    'Bursa',
    'Çanakkale',
    'Çankırı',
    'Denizli',
    'Diyarbakır',
    'Düzce',
    'Edirne',
    'Elazığ',
    'Erzincan',
    'Erzurum',
    'Eskişehir',
    'Gaziantep',
    'Giresun',
    'Gümüşhane',
    'Hakkari',
    'Hatay',
    'Iğdır',
    'Isparta',
    'İstanbul',
    'İzmir',
    'Kahramanmaraş',
    'Karabük',
    'Kars',
    'Kastamonu',
    'Kayseri',
    'Kırıkkale',
    'Kırklareli',
    'Kırşehir',
    'Konya',
    'Kütahya',
    'Malatya',
    'Manisa',
    'Mardin',
    'Mersin',
    'Muğla',
    'Nevşehir',
    'Niğde',
    'Ordu',
    'Osmaniye',
    'Rize',
    'Sakarya',
    'Samsun',
    'Siirt',
    'Sinop',
    'Sivas',
    'Tekirdağ',
    'Tokat',
    'Trabzon',
    'Tunceli',
    'Şanlıurfa',
    'Uşak',
    'Van',
    'Yalova',
    'Yozgat',
    'Zonguldak'
  ];
  List<String> activityAreas = [
    'Oto Aksesuar',
    'Servis',
    'AVM',
    'Akaryakıt',
    'Oto Yıkama',
    'Market'
  ];
  List<bool> selectedActivities = List.filled(6, false);

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController taxOfficeController = TextEditingController();
  final TextEditingController taxNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  XFile? tradeRegistryFile;
  XFile? activityDocumentFile;
  XFile? taxCertificateFile;
  XFile? signatureDeclarationFile;
  String? tradeRegistryUrl;
  String? activityDocumentUrl;
  String? taxCertificateUrl;
  String? signatureDeclarationUrl;

  Future<void> register() async {
    try {
      final authService = getIt<AuthService>();
      final registerParams = RegisterParams(
        customerType: selectedCustomerType == 'KURUMSAL' ? 1 : 2,
        fullName: fullNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        taxOffice: taxOfficeController.text,
        taxNumber: taxNumberController.text,
        isAccessories: selectedActivities[0],
        isService: selectedActivities[1],
        isAvm: selectedActivities[2],
        isOil: selectedActivities[3],
        isOto: selectedActivities[4],
        isMarket: selectedActivities[5],
        address: addressController.text,
        address2: streetController.text,
        country: 'Türkiye',
        city: selectedCity ?? '',
        region: '',
        postalCode: postalCodeController.text,
        filePath1: tradeRegistryUrl ?? '',
        filePath2: activityDocumentUrl ?? '',
        filePath3: taxCertificateUrl ?? '',
        filePath4: signatureDeclarationUrl ?? '',
      );

      await authService.register(registerParams);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> pickFile(String type) async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final uploadService = getIt<UploadService>();
        final result = await uploadService.uploadFiles([pickedFile.path]);

        result.fold(
          (failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Dosya yükleme hatası: ${failure.message}')),
            );
          },
          (urls) {
            if (urls.isNotEmpty) {
              setState(() {
                switch (type) {
                  case 'tradeRegistry':
                    tradeRegistryFile = pickedFile;
                    tradeRegistryUrl = urls.first;
                    break;
                  case 'activityDocument':
                    activityDocumentFile = pickedFile;
                    activityDocumentUrl = urls.first;
                    break;
                  case 'taxCertificate':
                    taxCertificateFile = pickedFile;
                    taxCertificateUrl = urls.first;
                    break;
                  case 'signatureDeclaration':
                    signatureDeclarationFile = pickedFile;
                    signatureDeclarationUrl = urls.first;
                    break;
                }
              });
            }
          },
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Dosya seçme hatası: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signupState = ref.watch(authControllerProvider);
    final authController = ref.read(authControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Üye Oluştur'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedCustomerType,
              items: customerTypes.map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCustomerType = value!;
                });
              },
              decoration: inputDecoration.copyWith(labelText: 'Müşteri Tipi'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: fullNameController,
              decoration: inputDecoration.copyWith(labelText: 'Tam Ad'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: inputDecoration.copyWith(labelText: 'E-posta'),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: phoneController,
              decoration: inputDecoration.copyWith(
                labelText: 'Telefon Numarası',
                hintText: '5xx xxx xx xx',
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [PhoneInputFormatter()],
              validator: (value) {
                if (value == null || value.isEmpty || value == '+90 ') {
                  return 'Telefon numarası gerekli';
                }
                final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
                if (digitsOnly.length != 12) {
                  // 90 + 10 rakam
                  return 'Geçerli bir telefon numarası girin';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: taxOfficeController,
              decoration: inputDecoration.copyWith(labelText: 'Vergi Dairesi'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: taxNumberController,
              decoration: inputDecoration.copyWith(labelText: 'Vergi Numarası'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: addressController,
              decoration: inputDecoration.copyWith(labelText: 'Adres'),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedCity,
              items: cities.map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCity = value!;
                });
              },
              decoration: inputDecoration.copyWith(labelText: 'Şehir'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: streetController,
              decoration: inputDecoration.copyWith(labelText: 'Cadde/Sokak'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: postalCodeController,
              decoration: inputDecoration.copyWith(labelText: 'Posta Kodu'),
            ),
            const SizedBox(height: 20),
            const Text('Faaliyet Alanı'),
            ...List.generate(activityAreas.length, (index) {
              return CheckboxListTile(
                title: Text(activityAreas[index]),
                value: selectedActivities[index],
                onChanged: (bool? value) {
                  setState(() {
                    selectedActivities[index] = value!;
                  });
                },
              );
            }),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Gerekli Belgeler',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFileUploadButton(
                    'Ticaret Sicili Gazetesi',
                    Icons.business,
                    () => pickFile('tradeRegistry'),
                    tradeRegistryFile != null,
                  ),
                  const SizedBox(height: 12),
                  _buildFileUploadButton(
                    'Faaliyet Belgesi',
                    Icons.description,
                    () => pickFile('activityDocument'),
                    activityDocumentFile != null,
                  ),
                  const SizedBox(height: 12),
                  _buildFileUploadButton(
                    'Vergi Levhası',
                    Icons.receipt_long,
                    () => pickFile('taxCertificate'),
                    taxCertificateFile != null,
                  ),
                  const SizedBox(height: 12),
                  _buildFileUploadButton(
                    'İmza Beyanı',
                    Icons.draw,
                    () => pickFile('signatureDeclaration'),
                    signatureDeclarationFile != null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            await register();

                            // Başarılı kayıt sonrası işlemler
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Kayıt işlemi başarılı!'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Login sayfasına yönlendir
                            Navigator.of(context).pushReplacementNamed('/');
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Kayıt işlemi başarısız: $e'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Kayıt Ol',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // Formu sıfırlama işlemi
                          fullNameController.clear();
                          emailController.clear();
                          phoneController.clear();
                          taxOfficeController.clear();
                          taxNumberController.clear();
                          addressController.clear();
                          streetController.clear();
                          postalCodeController.clear();
                          selectedCity = null;
                          selectedActivities.fillRange(
                              0, selectedActivities.length, false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.black87,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Formu Sıfırla',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            signupState.maybeMap(
              error: (state) =>
                  Text('Kayıt işlemi başarısız: ${state.message}'),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileUploadButton(
    String title,
    IconData icon,
    VoidCallback onPressed,
    bool isFileSelected,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: isFileSelected ? Colors.green : Colors.grey[600],
          size: 24,
        ),
        label: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.black87,
                fontWeight:
                    isFileSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isFileSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
              ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isFileSelected ? 2 : 1,
        ),
      ),
    );
  }
}
