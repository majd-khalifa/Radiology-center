// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/errors/failur_request.dart';
import 'package:radiology_center_app/core/services/api/api_link.dart';
import 'package:radiology_center_app/models/slots_model.dart';

class ApiServices {
  final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: ApiLink.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            // حل مشكلة الويب: لا تضع sendTimeout إذا كان التطبيق يعمل على المتصفح
            sendTimeout: kIsWeb ? null : const Duration(seconds: 30),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              print("[${options.method}][${options.uri}]");
              if (options.data != null) print("Body: ${options.data}");
              handler.next(options);
            },
            onResponse: (response, handler) {
              print("Response: ${response.data}");
              handler.next(response);
            },
            onError: (error, handler) {
              print("DIO ERROR: ${error.response?.data}");
              print("STATUS CODE: ${error.response?.statusCode}");
              handler.next(error);
            },
          ),
        );

  // تأكد أن هذه الدالة داخل ApiServices هي التي تخدم جميع الطلبات
  Map<String, String> _getHeaders(
    String? token,
    Map<String, String>? extraHeaders,
  ) {
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      ...?extraHeaders,
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Token $token'; // الحرف T كبير في Token
    }
    return headers;
  }

  /// GET
  Future getData({
    required String url,
    Map<String, String>? headers,
    String? token,
    BuildContext? context,
  }) async {
    try {
      final finalHeaders = {...?headers};
      if (token != null && token.isNotEmpty) {
        finalHeaders['Authorization'] =
            'Token $token'; // تم التغيير لـ Token حسب نظام Django عندك
      }

      final response = await _dio.get(
        url,
        options: Options(headers: finalHeaders),
      );

      if ([200, 201, 204].contains(response.statusCode)) {
        return response.data;
      } else {
        throw ServerFailure.fromResponse(response.statusCode);
      }
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    }
  }

  /// POST
  Future postData({
    required String url,
    Map? body,
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final finalHeaders = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        ...?headers,
      };

      if (token != null && token.isNotEmpty) {
        finalHeaders['Authorization'] = 'Token $token';
      }

      final response = await _dio.post(
        url,
        data: body,
        options: Options(headers: finalHeaders),
      );

      if ([200, 201, 204].contains(response.statusCode)) {
        return response.data;
      } else {
        throw ServerFailure.fromResponse(response.statusCode);
      }
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    }
  }

  /// PUT / UPDATE
  Future putData({
    required String url,
    Map? body,
    Map<String, String>? headers,
    String? token,
  }) async {
    try {
      final finalHeaders = {...?headers};
      if (token != null && token.isNotEmpty) {
        finalHeaders['Authorization'] = 'Token $token';
      }

      final response = await _dio.put(
        url,
        data: body,
        options: Options(headers: finalHeaders),
      );

      if ([200, 201, 204].contains(response.statusCode)) {
        return response.data;
      } else {
        throw ServerFailure.fromResponse(response.statusCode);
      }
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    }
  }

  /// DELETE
  Future deleteData({required String url, Map? body, String? token}) async {
    try {
      final response = await _dio.delete(
        url,
        data: body,
        options: Options(headers: _getHeaders(token, null)),
      );
      return response.data;
    } on DioException catch (e) {
      throw ServerFailure.fromDioError(e);
    }
  }

  Future<List<SlotModel>> getDeviceSlots({
    required int deviceId,
    required String token,
  }) async {
    final data = await getData(
      url: ApiLink.deviceAppointments(deviceId),
      token: token,
    );

    return (data as List).map((e) => SlotModel.fromJson(e)).toList();
  }
}
