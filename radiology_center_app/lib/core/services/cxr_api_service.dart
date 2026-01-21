import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;

class CxrApiService {
  static const String _baseUrl = 'http://192.168.1.5:8000';

  static Future<String> analyzeXray(dynamic imageSource) async {
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

    if (response.statusCode == 200) {
      var body = await response.stream.bytesToString();
      var jsonData = json.decode(body);
      return jsonData['prediction'];
    } else {
      throw Exception('فشل التحليل: ${response.statusCode}');
    }
  }
}
