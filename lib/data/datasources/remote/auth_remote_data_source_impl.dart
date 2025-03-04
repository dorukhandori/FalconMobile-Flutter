import 'package:dio/dio.dart';
import 'package:auth_app/core/network/dio_client.dart';
import 'package:auth_app/core/error/exceptions.dart';
import 'package:auth_app/data/datasources/remote/auth_remote_data_source.dart';
import 'package:auth_app/domain/models/user.dart';
import 'package:auth_app/domain/models/login_params.dart';
import 'package:auth_app/domain/models/register_params.dart';
import 'package:flutter/foundation.dart';
import 'package:auth_app/domain/models/banner.dart';
import 'package:auth_app/core/utils/jwt_utils.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<User> login(LoginParams params) async {
    try {
      final response = await dio.post(
        '/v1/Login/token',
        data: {
          'customerCode': params.customerCode,
          'password': params.password,
        },
        options: Options(
          headers: {
            'accept': '*/*',
            'xcmzkey': DioClient.xcmzKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      debugPrint('Login Response: ${response.data}');

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData['statusCode'] == 200 &&
            responseData['data'] != null &&
            responseData['data']['data'] != null) {
          final userData = responseData['data']['data'] as Map<String, dynamic>;
          final token = responseData['data']['accessToken'] as String;

          // JWT'yi çözümle
          Map<String, dynamic> decodedToken = JwtUtils.decodeJwt(token);
          final customerId = decodedToken['customerID'];
          final userId = decodedToken['userID'];

          // Debug logları
          debugPrint('Customer ID: $customerId');
          debugPrint('User ID: $userId');

          // User modelini oluştur
          final user = User.fromJson({
            'token': token,
            'customerCode': userData['code']?.toString() ?? '',
            'name': userData['name']?.toString() ?? '',
            'email': userData['email']?.toString() ?? '',
            'customerId': customerId,
            'userId': userId,
            'loginType': 1,
            'salesmanId': int.tryParse(
                    userData['authoritySalesman']?['salesmanId']?.toString() ??
                        '0') ??
                0,
            'languageId': 1,
            'customerType': userData['customerType'] == true ? 1 : 0,
            'isAccessories': 0,
            'isService': 0,
            'isAvm': 0,
            'isOil': 0,
            'isOto': 0,
            'isMarket': 0,
            'phone': userData['tel1']?.toString(),
            'taxOffice': userData['taxOffice']?.toString(),
            'taxNumber': null,
            'address': null,
            'address2': null,
            'country': null,
            'city': null,
            'region': null,
            'postalCode': null,
            'filePath1': null,
            'filePath2': null,
            'filePath3': null,
            'filePath4': null,
          });

          return user;
        } else {
          throw Exception('Invalid response structure');
        }
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      debugPrint('Login hatası: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<User> register(RegisterParams params) async {
    try {
      print('Register request data: ${params.toJson()}'); // Debug için

      final response = await dio.post(
        '/v1/Login/registerForm',
        data: params.toJson(),
        options: Options(
          headers: {
            'accept': '*/*',
            'xcmzkey': DioClient.xcmzKey,
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Register response: ${response.data}'); // Debug için

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData is Map<String, dynamic>) {
          return User.fromJson(responseData);
        } else {
          print('Invalid response format: $responseData'); // Debug için
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception(
            'Failed to register with status code: ${response.statusCode}');
      }
    } catch (e, stackTrace) {
      print('Register error: $e');
      print('Stack trace: $stackTrace'); // Debug için
      throw Exception('Failed to register: $e');
    }
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<void> someApiCall({Options? options}) async {
    final response = await dio.post(
      '/v1/someEndpoint', // Uygun endpoint'i buraya yazın
      options: options ?? Options(), // options parametresini kullan
    );
    // Yanıtı işleyin
  }

  @override
  Future<List<BannerModel>> fetchBanners() async {
    try {
      final response = await dio.post(
        '/Home/getAnnouncements/',
        data: {'languageId': '1'},
      );

      debugPrint('Raw API Response: ${response.data}');

      final List<dynamic> bannerList = response.data as List;
      final banners =
          bannerList.map((banner) => BannerModel.fromJson(banner)).toList();

      return banners;
    } catch (e, stackTrace) {
      debugPrint('Banner yükleme hatası: $e');
      debugPrint('Stack trace: $stackTrace');
      throw ServerException(message: e.toString());
    }
  }
}
