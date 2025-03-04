import 'package:auth_app/domain/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:auth_app/core/di/providers.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> getNewProducts(Map<String, dynamic> params);
  Future<List<Product>> getCampaignProducts(Map<String, dynamic> params);
  Future<List<Product>> getFavoriteProducts(Map<String, dynamic> params);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<Product>> getNewProducts(Map<String, dynamic> params) async {
    final response = await dio.post(
      '/v1/Search/getNewProductList/',
      data: params,
    );
    return (response.data as List).map((e) => Product.fromJson(e)).toList();
  }

  @override
  Future<List<Product>> getCampaignProducts(Map<String, dynamic> params) async {
    final response = await dio.post(
      '/v1/Search/getCampaignList/',
      data: params,
    );
    return (response.data as List).map((e) => Product.fromJson(e)).toList();
  }

  @override
  Future<List<Product>> getFavoriteProducts(Map<String, dynamic> params) async {
    final response = await dio.post(
      '/v1/Search/getFavorites/',
      data: params,
    );
    return (response.data as List).map((e) => Product.fromJson(e)).toList();
  }
}

final productRemoteDataSourceProvider =
    Provider<ProductRemoteDataSource>((ref) {
  return ProductRemoteDataSourceImpl(ref.watch(dioProvider));
});
