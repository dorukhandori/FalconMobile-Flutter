import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/domain/models/banner_model.dart';
import 'package:auth_app/services/banner_service.dart';
import 'package:flutter/foundation.dart';

// Banner state için enum
enum BannerStatus {
  initial,
  loading,
  loaded,
  error,
}

// Banner state sınıfı
class BannerState {
  final BannerStatus status;
  final List<BannerModel> banners;
  final String? errorMessage;

  BannerState({
    required this.status,
    required this.banners,
    this.errorMessage,
  });

  // Başlangıç state'i
  factory BannerState.initial() {
    return BannerState(
      status: BannerStatus.initial,
      banners: [],
    );
  }

  // State'i kopyalama metodu
  BannerState copyWith({
    BannerStatus? status,
    List<BannerModel>? banners,
    String? errorMessage,
  }) {
    return BannerState(
      status: status ?? this.status,
      banners: banners ?? this.banners,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// Banner controller
class BannerController extends StateNotifier<BannerState> {
  final BannerService _bannerService;

  BannerController(this._bannerService) : super(BannerState.initial());

  // Banner'ları yükle
  Future<void> loadBanners({String? token}) async {
    try {
      // Loading state'ine geç
      state = state.copyWith(status: BannerStatus.loading);

      // Banner'ları getir
      final banners = await _bannerService.getBanners(token: token);

      // Loaded state'ine geç
      state = state.copyWith(
        status: BannerStatus.loaded,
        banners: banners,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Banner Error: $e');
      }
      // Error state'ine geç
      state = state.copyWith(
        status: BannerStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  // State'i sıfırla
  void reset() {
    state = BannerState.initial();
  }
}

// Banner controller provider
final bannerControllerProvider =
    StateNotifierProvider<BannerController, BannerState>((ref) {
  return BannerController(BannerService());
});
