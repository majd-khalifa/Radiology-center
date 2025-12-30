// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class XRayAnalyzerService {
  // 🔗 API endpoint - حط رابطك هنا
  static const String apiUrl = 'https://mvjd-xray-ai.hf.space/run/predict/';

  // 📦 تحويل الصورة لـ base64
  static String _convertImageToBase64(File imageFile) {
    try {
      List<int> imageBytes = imageFile.readAsBytesSync();
      return base64Encode(imageBytes);
    } catch (e) {
      print('❌ Failed to convert image to base64: $e');
      throw Exception('Image conversion failed: $e');
    }
  }

  // 🚀 إرسال الصورة للـ API
  static Future<Map<String, dynamic>> analyzeXRay(File imageFile) async {
    try {
      String base64Image = _convertImageToBase64(imageFile);

      print('🔗 API URL: $apiUrl');
      print('📤 Image base64 size: ${base64Image.length} chars');

      // 🎯 Request body
      final body = jsonEncode({
        'data': ['data:image/png;base64,$base64Image'],
        'fn_index': 0,
      });

      // 📤 Send HTTP POST
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: body,
          )
          .timeout(Duration(seconds: 30));

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      // ✅ نجاح الـ API
      if (response.statusCode == 200) {
        try {
          Map<String, dynamic> data = jsonDecode(response.body);

          // 🔍 تحقق من وجود data
          if (data['data'] == null || data['data'].isEmpty) {
            return {
              'Status': 'Error',
              'Message': 'API returned empty response',
            };
          }

          Map<String, dynamic> apiResult = data['data'][0];
          print('✅ API Result: $apiResult');

          return apiResult;
        } catch (e) {
          print('❌ JSON decode error: $e');
          return {'Status': 'Error', 'Message': 'Invalid JSON response'};
        }
      }
      // ❌ فشل الـ API
      else {
        print('❌ API failed: ${response.statusCode}');
        return {
          'Status': 'Error',
          'Message': 'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        };
      }
    } on http.ClientException catch (e) {
      print('❌ Network error: $e');
      return {'Status': 'Error', 'Message': 'Check your internet connection'};
    } on SocketException catch (e) {
      print('❌ Socket error: $e');
      return {'Status': 'Error', 'Message': 'Cannot reach the server'};
    } catch (e) {
      print('❌ Unknown error: $e');
      return {'Status': 'Error', 'Message': 'Unexpected error: $e'};
    }
  }
}
