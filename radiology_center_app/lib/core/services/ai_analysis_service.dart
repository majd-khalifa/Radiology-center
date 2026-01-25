import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AiService {
  // 1. تأكد من وضع توكن جديد كلياً بصلاحية READ
  static const String _token = "hf_ضع_التوكن_الجديد_هنا";

  // 2. الرابط المحدث للموديل الشغال حالياً
  static const String _modelUrl =
      "https://router.huggingface.co/hf-inference/models/ianpan/pneumonia-cxr";

  Future<String> analyzeXRay(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final response = await http.post(
        Uri.parse(_modelUrl),
        headers: {
          "Authorization": "Bearer $_token",
          "Content-Type": "application/octet-stream",
          "x-wait-for-model":
              "true", // انتظار تحميل الموديل إذا كان في وضع الخمول
        },
        body: bytes,
      );

      final dynamic decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (decodedResponse is List && decodedResponse.isNotEmpty) {
          final topMatch = decodedResponse[0];
          return "التشخيص: ${_translate(topMatch['label'])}\nنسبة الدقة: ${(topMatch['score'] * 100).toStringAsFixed(2)}%";
        }
        return "تم التحليل، يرجى مراجعة طبيب مختص.";
      } else {
        // إدارة الأخطاء التي ظهرت في صورك (401, 410)
        if (response.statusCode == 401) return "خطأ: التوكن غير صالح أو منتهي.";
        if (response.statusCode == 410) return "خطأ: الموديل قديم جداً.";
        return "فشل السيرفر: ${decodedResponse['error'] ?? 'خطأ غير معروف'}";
      }
    } catch (e) {
      return "فشل الاتصال: تأكد من تفعيل الـ VPN واستقرار الإنترنت.";
    }
  }

  String _translate(String label) {
    if (label.toLowerCase().contains('pneumonia'))
      return 'احتمالية وجود التهاب رئوي';
    if (label.toLowerCase().contains('normal')) return 'الرئة تبدو سليمة';
    return label;
  }
}
