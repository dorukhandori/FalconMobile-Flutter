import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/data/services/auth_service.dart';
import 'package:auth_app/domain/models/register_params.dart';
import 'package:auth_app/core/di/injection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auth_app/presentation/auth/pages/login_page.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController taxOfficeController = TextEditingController();
  final TextEditingController taxNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  String selectedCustomerType = 'KURUMSAL'; // Default value
  String? selectedCity; // Default value set to null
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
  ]; // Türkiye'deki tüm şehirler
  List<String> activityAreas = [
    'Oto Aksesuar',
    'Servis',
    'AVM',
    'Akaryakıt',
    'Oto Yıkama',
    'Market'
  ];
  List<bool> selectedActivities = List.filled(6, false); // Checkbox durumları

  final ImagePicker _picker = ImagePicker();
  XFile? tradeRegistryFile;
  XFile? activityDocumentFile;
  XFile? taxCertificateFile;
  XFile? signatureDeclarationFile;

  void register() async {
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
        filePath1: tradeRegistryFile?.path ?? '',
        filePath2: activityDocumentFile?.path ?? '',
        filePath3: taxCertificateFile?.path ?? '',
        filePath4: signatureDeclarationFile?.path ?? '',
      );

      await authService.register(registerParams);

      // Başarılı kayıt sonrası işlemler
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kayıt işlemi başarılı!'),
          backgroundColor: Colors.green,
        ),
      );

      // Kullanıcıyı login ekranına yönlendir
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kayıt işlemi başarısız: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> pickFile(String type) async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (type == 'tradeRegistry') {
        tradeRegistryFile = pickedFile;
      } else if (type == 'activityDocument') {
        activityDocumentFile = pickedFile;
      } else if (type == 'taxCertificate') {
        taxCertificateFile = pickedFile;
      } else if (type == 'signatureDeclaration') {
        signatureDeclarationFile = pickedFile;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Input decoration için ortak tema
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Üye Oluştur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              TextField(
                controller: phoneController,
                decoration:
                    inputDecoration.copyWith(labelText: 'Telefon Numarası'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: taxOfficeController,
                decoration:
                    inputDecoration.copyWith(labelText: 'Vergi Dairesi'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: taxNumberController,
                decoration:
                    inputDecoration.copyWith(labelText: 'Vergi Numarası'),
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
                          onPressed: register,
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
            ],
          ),
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
