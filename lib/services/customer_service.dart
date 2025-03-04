import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/city_model.dart';
import '../models/town_model.dart';
import '../models/customer_model.dart';

class CustomerService {
  static const String baseUrl = 'https://testapi.allprox.com.tr/v1';
  static const String xcmzkey =
      'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ';

  Future<List<CityModel>> getCityList(String token) async {
    final url = Uri.parse('$baseUrl/CustomerSelect/getCityList');

    if (kDebugMode) {
      print('Get City List Request');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'xcmzkey': xcmzkey,
      },
    );

    if (kDebugMode) {
      print('Get City List Response Status: ${response.statusCode}');
      print('Get City List Response Body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((city) => CityModel.fromMap(city)).toList();
    } else {
      throw Exception('Şehir listesi alınamadı: ${response.body}');
    }
  }

  Future<List<TownModel>> getTownList(String token, String city) async {
    final url = Uri.parse('$baseUrl/CustomerSelect/getTownList');

    final requestBody = {
      'city': city,
    };

    if (kDebugMode) {
      print('Get Town List Request: $requestBody');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'xcmzkey': xcmzkey,
      },
      body: jsonEncode(requestBody),
    );

    if (kDebugMode) {
      print('Get Town List Response Status: ${response.statusCode}');
      print('Get Town List Response Body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      return responseData.map((town) => TownModel.fromMap(town)).toList();
    } else {
      throw Exception('İlçe listesi alınamadı: ${response.body}');
    }
  }

  Future<List<CustomerModel>> getCustomerSelectData({
    required String token,
    required int salesmanId,
    required bool customerType,
    String codeOrName = '',
    String city = '',
    String town = '',
    bool basketType = false,
    int count = 24,
  }) async {
    final url = Uri.parse('$baseUrl/CustomerSelect/getCustomerSelectData');

    final requestBody = {
      'codeOrName': codeOrName,
      'city': city,
      'town': town,
      'basketType': basketType,
      'count': count,
      'customerType': customerType,
      'salesmanId': salesmanId,
    };

    if (kDebugMode) {
      print('Get Customer Select Data Request: $requestBody');
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        'xcmzkey': xcmzkey,
      },
      body: jsonEncode(requestBody),
    );

    if (kDebugMode) {
      print('Get Customer Select Data Response Status: ${response.statusCode}');
      print('Get Customer Select Data Response Body: ${response.body}');
    }

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> customerList = responseData['customerList'] ?? [];
      return customerList
          .map((customer) => CustomerModel.fromMap(customer))
          .toList();
    } else {
      throw Exception('Müşteri listesi alınamadı: ${response.body}');
    }
  }
}
