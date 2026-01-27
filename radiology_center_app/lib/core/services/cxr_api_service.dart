import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class CxrApiService {
  static const String _baseUrl = 'http://192.168.1.5:8000';

  static Future<Map<String, dynamic>> analyzeXray(dynamic imageSource) async {
    var uri = Uri.parse('$_baseUrl/analyze-xray');
    var request = http.MultipartRequest('POST', uri);

    if (kIsWeb) {
      request.files.add(
        http.MultipartFile.fromBytes('file', imageSource, filename: 'xray.jpg'),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath('file', (imageSource as File).path),
      );
    }

    var response = await request.send();
    var body = await response.stream.bytesToString();
    var jsonData = json.decode(body);

    // حالة الصورة ليست X-ray
    if (response.statusCode == 422) {
      throw Exception(jsonData["error"] ?? "الصورة ليست أشعة صدر");
    }

    // حالة خطأ بالسيرفر
    if (response.statusCode == 500) {
      throw Exception(jsonData["error"] ?? "خطأ داخلي في السيرفر");
    }

    // حالة نجاح
    if (response.statusCode == 200 &&
        jsonData["success"] == true &&
        jsonData["positive_findings"] != null) {
      return {
        "confidence": (jsonData["xray_confidence"] as num).toDouble(),
        "findings": Map<String, double>.from(
          (jsonData["positive_findings"] as Map).map(
            (key, value) => MapEntry(key.toString(), (value as num).toDouble()),
          ),
        ),
      };
    }

    throw Exception("فشل التحليل");
  }
}
