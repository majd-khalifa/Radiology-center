// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:radiology_center_app/core/errors/failur_request.dart';
import 'package:radiology_center_app/core/services/api/api_link.dart';

class ApiServices {
  // static User? currentUser;

  final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: ApiLink.baseUrl,
            connectTimeout: const Duration(seconds: 30),
            receiveTimeout: const Duration(seconds: 30),
            sendTimeout: const Duration(seconds: 30),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              print(
                "[${options.method}][${options.uri}] headers: ${options.headers}",
              );
              handler.next(options);
            },
            onResponse: (response, handler) {
              print("${response.data}");
              handler.next(response);
            },
            onError: (error, handler) {
              print("DIO ERROR: ${error.response?.data}");
              print("STATUS CODE: ${error.response?.statusCode}");
              handler.next(error);
            },
          ),
        );

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
        finalHeaders['Authorization'] = 'Token $token';
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

      // 🔥 إصلاح التوكن هنا أيضًا
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

  /// PUT
  Future putData({
    required String url,
    Map? body,
    Map<String, String>? headers,
    String? token,
    BuildContext? context,
  }) async {
    try {
      final finalHeaders = {...?headers};

      // 🔥 هذا كان سبب الـ 401 — تم إصلاحه
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
  Future deleteData({
    required String url,
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
        finalHeaders['Authorization'] =
            'Token $token'; // استخدمنا Token بناءً على ملف البوستمان
      }

      final response = await _dio.delete(
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
}
