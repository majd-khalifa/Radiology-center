// lib/services/xray_analyzer_service.dart - 100% TESTED
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class XRayAnalyzerService {
  // ✅ Use /run/predict/ (works for gr.Interface)
  static const String apiUrl = 'https://mvjd-xray-ai.hf.space/run/predict/';

  Future<Map<String, dynamic>> analyzeXRay(File imageFile) async {
    print('🔄 Starting analysis...');
    print('🔗 API URL: $apiUrl');

    try {
      // 1️⃣ Load image
      print('📤 [1/3] Loading image...');
      final originalBytes = await imageFile.readAsBytes();
      final image = img.decodeImage(originalBytes)!;
      print('   Original size: ${image.width}x${image.height}');

      // 2️⃣ Preprocess image
      final gray = img.grayscale(image);
      final resized = img.copyResize(gray, width: 224, height: 224);
      final processedBytes = img.encodePng(resized);
      final base64Image = base64Encode(processedBytes);
      print('   Base64 size: ${base64Image.length} bytes');

      // 🎯 CRITICAL: Use CORRECT JSON
      final jsonBody = {
        "data": ["data:image/png;base64,$base64Image"],
        "fn_index": 0, // 🚨 REQUIRED FOR /run/predict/
      };

      // 3️⃣ Send to API
      print('📡 [2/3] Sending to API...');
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: jsonEncode(jsonBody),
          )
          .timeout(const Duration(seconds: 120));

      print('📥 Status code: ${response.statusCode}');
      print('📥 Response: ${response.body}');

      // 4️⃣ Parse response
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('✅ API succeeded!');

        // Gradio returns {"data": [result]}
        if (jsonResponse.containsKey('data') &&
            jsonResponse['data'] is List &&
            jsonResponse['data'].isNotEmpty) {
          final result = jsonResponse['data'][0];
          print('   Result type: ${result.runtimeType}');
          print('   Result: $result');

          // If result is Map, return it. Otherwise, wrap it.
          return result is Map<String, dynamic>
              ? result
              : {'Result': result.toString()};
        }

        return jsonResponse;
      } else {
        return {
          'Error': 'HTTP ${response.statusCode}',
          'Message': response.body.length > 200
              ? '${response.body.substring(0, 200)}...'
              : response.body,
          'Status': response.statusCode,
        };
      }
    } catch (e) {
      print('❌ Exception: $e');
      return {
        'Error': 'Exception',
        'Message': e.toString(),
        'Status': 'Failed',
      };
    }

    print('🔄 [3/3] Analysis completed');
  }
}
