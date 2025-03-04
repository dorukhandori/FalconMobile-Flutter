import 'package:auth_app/domain/models/product.dart';
import 'package:auth_app/presentation/auth/controllers/auth_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/core/providers/auth_params_provider.dart';
import 'package:auth_app/data/datasources/remote/product_remote_data_source.dart';
import 'package:flutter/foundation.dart';
import '../../../data/datasources/remote/dio_client.dart';

final newProductsProvider =
    FutureProvider.autoDispose<List<Product>>((ref) async {
  try {
    final dio = DioClient.getInstance();

    final headers = {
      'Content-Type': 'application/json',
      'xcmzkey':
          'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ',
    };

    final data = {
      "customerId": 2,
      "userId": 2,
      "loginType": 1,
      "salesmanId": 1,
      "languageId": 1
    };

    final response = await dio.post(
      '/Search/getNewProductList/',
      options: Options(headers: headers),
      data: data,
    );

    if (kDebugMode) {
      print('New Products Response: $response');
    }

    if (response.statusCode == 200) {
      final List<dynamic> productData =
          response.data is List ? response.data : [];
      return productData.map((item) => Product.fromJson(item)).toList();
    }

    return [];
  } catch (e) {
    if (kDebugMode) {
      print('New Products Error: $e');
    }
    return [];
  }
});

final campaignProductsProvider =
    FutureProvider.autoDispose<List<Product>>((ref) async {
  try {
    final dio = DioClient.getInstance();

    final headers = {
      'Content-Type': 'application/json',
      'xcmzkey':
          'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ',
    };

    final data = {
      "customerId": 2,
      "userId": 2,
      "loginType": 1,
      "salesmanId": 1,
      "languageId": 1
    };

    final response = await dio.post(
      '/Search/getCampaignList/',
      options: Options(headers: headers),
      data: data,
    );

    if (kDebugMode) {
      print('Campaign Products Response: $response');
    }

    if (response.statusCode == 200) {
      final List<dynamic> productData =
          response.data is List ? response.data : [];
      return productData.map((item) => Product.fromJson(item)).toList();
    }

    return [];
  } catch (e) {
    if (kDebugMode) {
      print('Campaign Products Error: $e');
    }
    return [];
  }
});

final favoriteProductsProvider =
    FutureProvider.autoDispose<List<Product>>((ref) async {
  // Favori ürünler için API endpoint'i eklenecek
  return [];
});

// Popüler ürün grupları provider
final popularProductGroupsProvider =
    FutureProvider.autoDispose<List<dynamic>>((ref) async {
  // Popüler ürün grupları için API endpoint'i eklenecek
  return [];
});

class FavoriteProductsNotifier extends StateNotifier<List<Product>> {
  FavoriteProductsNotifier() : super([]);

  void toggleFavorite(String productCode) {
    state = state.map((product) {
      if (product.productCode == productCode) {
        return product.copyWith(isFavorite: !product.isFavorite);
      }
      return product;
    }).toList();
  }
}
