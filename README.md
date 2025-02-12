# B2B E-Commerce Flutter Uygulaması

Bu proje, B2B e-ticaret işlemleri için geliştirilmiş bir Flutter uygulamasıdır. Kullanıcıların kayıt olması, giriş yapması ve ürünleri yönetmesi gibi temel işlevleri içerir.

## Özellikler

- **Kullanıcı Kimlik Doğrulama**: Kayıt ve giriş işlemleri
- **Ürün Yönetimi**: Ürün ekleme, düzenleme ve silme
- **Sepet Yönetimi**: Kullanıcıların sepetlerini yönetme
- **Sipariş Takibi**: Siparişlerin durumunu takip etme
- **Dosya Yükleme**: Gerekli belgeleri yükleme
- **Döviz Yönetimi**: Güncel döviz kurlarını görüntüleme

## Kurulum

### 1. Projeyi Klonlayın
```bash
git clone https://github.com/dorukhandori/FalconMobile-Flutter.git
```

### 2. Gerekli Bağımlılıkları Yükleyin
```bash
cd your-repo-name
flutter pub get
```

### 3. Uygulamayı Çalıştırın
```bash
flutter run
```

## Kullanılan Teknolojiler

- **Flutter**: UI framework
- **Riverpod**: State management
- **Dio**: HTTP client
- **GetIt**: Dependency injection
- **Image Picker**: Dosya yükleme
- **Shared Preferences**: Kullanıcı ayarlarını saklama

## API Entegrasyonu

### Döviz Listesi
Döviz bilgilerini almak için aşağıdaki API kullanılır:
```bash
curl -X 'POST' \
  'https://testapi.epic-soft.net/v1/Login/getCurrencyList' \
  -H 'accept: */*' \
  -H 'xcmzkey: API_KEY' \
  -H 'Accept-Language: tr' \
  -d ''
```

### Kullanıcı Girişi
Kullanıcı girişi için aşağıdaki API kullanılır:
```bash
curl -X 'POST' \
  'https://testapi.epic-soft.net/v1/Login/token' \
  -H 'accept: */*' \
  -H 'xcmzkey: API_KEY' \
  -d '{"customerCode": "your_code", "password": "your_password"}'
```


## Katkıda Bulunma

Katkıda bulunmak için lütfen [CONTRIBUTING.md](CONTRIBUTING.md) dosyasını inceleyin.

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Daha fazla bilgi için [LICENSE](LICENSE) dosyasına bakın.
