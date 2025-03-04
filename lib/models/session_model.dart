import 'dart:convert';

class SessionModel {
  final String accessToken;
  final int userId;
  final int customerId;
  final int salesmanId;
  final bool customerType;
  final String loginType;

  SessionModel({
    required this.accessToken,
    this.userId = 0,
    this.customerId = 0,
    this.salesmanId = 0,
    this.customerType = false,
    this.loginType = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'accessToken': accessToken,
      'userId': userId,
      'customerId': customerId,
      'salesmanId': salesmanId,
      'customerType': customerType,
      'loginType': loginType,
    };
  }

  factory SessionModel.fromMap(Map<String, dynamic> map) {
    return SessionModel(
      accessToken: map['accessToken'] ?? '',
      userId: map['userId'] ?? 0,
      customerId: map['customerId'] ?? 0,
      salesmanId: map['salesmanId'] ?? 0,
      customerType: map['customerType'] ?? false,
      loginType: map['loginType'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory SessionModel.fromJson(String source) =>
      SessionModel.fromMap(json.decode(source));
}
