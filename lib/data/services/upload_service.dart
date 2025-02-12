import 'dart:io';

import 'package:dio/dio.dart';
import 'package:auth_app/core/network/dio_client.dart';
import 'package:auth_app/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class UploadService {
  final Dio _dio;
  static const int _maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> _allowedExtensions = [
    'jpg',
    'jpeg',
    'png',
    'pdf',
    'doc',
    'docx'
  ];
  static const String _baseUrl = 'https://testapi.epic-soft.net';
  static const String _xcmzkey =
      'NX3qKA25bqwquuFdOcckvNdWkZYIy0RF4tNw+hwgYS43jsm07rwosdpO0Meh1I/gzVXt580rIOGdYFMBDLwo3vBfFxeuOPvu6x0Fa+n2s/XPcHVaCiEnoL0mdN3pCOPLv4UnPBJZGtZdEYwo1//0qHdif7TcnvrWUCyGtJLUTR/eOLo4bY64d5tebRU/wovQ';

  UploadService(this._dio) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'xcmzkey': _xcmzkey,
    };
  }

  Future<Either<Failure, String>> uploadFile(String filePath) async {
    try {
      final file = File(filePath);

      // Dosyanın varlığını kontrol et
      if (!await file.exists()) {
        return Left(ServerFailure('Dosya bulunamadı: $filePath'));
      }

      // Dosya boyutunu kontrol et
      final fileSize = await file.length();
      if (fileSize > _maxFileSize) {
        return Left(ServerFailure('Dosya boyutu çok büyük (max: 10MB)'));
      }

      // Dosya uzantısını kontrol et
      final fileExtension =
          extension(filePath).toLowerCase().replaceAll('.', '');
      if (!_allowedExtensions.contains(fileExtension)) {
        return Left(ServerFailure(
            'Geçersiz dosya formatı. İzin verilen formatlar: ${_allowedExtensions.join(", ")}'));
      }

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          filePath,
          filename: basename(filePath),
        ),
      });

      final url = '/v1/upload';
      debugPrint('Upload Request URL: $url'); // URL'yi logla

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(
          headers: {
            'accept': '*/*',
            'xcmzkey': DioClient.xcmzKey,
            'Content-Type': 'multipart/form-data',
          },
          validateStatus: (status) {
            return status! < 500; // 500'den küçük tüm status kodlarını kabul et
          },
        ),
        onSendProgress: (int sent, int total) {
          if (total != -1) {
            final progress = (sent / total * 100).toStringAsFixed(2);
            debugPrint('Upload Progress: $progress%');
          }
        },
      );

      debugPrint(
          'Upload Response: ${response.statusCode}'); // Response status code'u logla

      if (response.statusCode == 200 && response.data != null) {
        final fileUrl = response.data['fileUrl'] as String?;
        if (fileUrl != null && fileUrl.isNotEmpty) {
          return Right(fileUrl);
        } else {
          return Left(ServerFailure('Dosya URL\'si alınamadı'));
        }
      } else {
        return Left(ServerFailure(
            'Dosya yükleme başarısız: ${response.statusCode} - ${response.statusMessage}'));
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint('Upload Error: ${e.message}');
        debugPrint('Request URL: ${e.requestOptions.uri}');
        debugPrint(
            'Response: ${e.response?.statusCode} - ${e.response?.statusMessage}');
      } else {
        debugPrint('Upload Error: $e');
      }
      return Left(ServerFailure('Dosya yükleme hatası: ${e.toString()}'));
    }
  }

  Future<Either<Failure, List<String>>> uploadFiles(
      List<String> filePaths) async {
    try {
      if (filePaths.isEmpty) {
        return const Right([]);
      }

      final formData = FormData();

      // Dosyaları ekle
      for (var path in filePaths) {
        if (await File(path).exists()) {
          formData.files.add(
            MapEntry(
              'files',
              await MultipartFile.fromFile(
                path,
                filename: basename(path),
              ),
            ),
          );
        }
      }

      final response = await _dio.post(
        '/v1/Upload/uploadFiles/',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'xcmzkey': _xcmzkey,
          },
          validateStatus: (status) {
            return status! < 500; // 400'leri de kabul et
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> filePaths = response.data['filePath'];
        return Right(filePaths.cast<String>());
      } else {
        debugPrint('Upload Error Response: ${response.data}');
        return Left(ServerFailure(
            'Dosya yükleme başarısız: ${response.statusCode} - ${response.data}'));
      }
    } catch (e) {
      debugPrint('Upload Exception: $e');
      return Left(ServerFailure('Dosya yükleme hatası: $e'));
    }
  }
}
