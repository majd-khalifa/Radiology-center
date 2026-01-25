import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:radiology_center_app/core/services/ai_analysis_service.dart';

class AiAnalysisScreen extends StatefulWidget {
  const AiAnalysisScreen({super.key});
  @override
  State<AiAnalysisScreen> createState() => _AiAnalysisScreenState();
}

class _AiAnalysisScreenState extends State<AiAnalysisScreen> {
  File? _selectedImage;
  String _analysisResult = "";
  bool _isLoading = false;
  final AiService _aiService = AiService();
  final ImagePicker _picker = ImagePicker();

  // داخل ملف ai_analysis_screen.dart

  Future<void> _pickImage() async {
    try {
      // تقليل الإعدادات لأدنى حد ممكن لضمان عدم انهيار الذاكرة (GPU)
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800, // تقليل العرض (مهم جداً لحل خطأ qdgralloc)
        maxHeight: 800, // تقليل الطول
        imageQuality: 50, // ضغط الجودة بنسبة 50%
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _analysisResult = "";
        });
      } else {
        // فحص البيانات المفقودة في حال انهيار الـ Activity (حل مشكلة NullPointerException)
        final LostDataResponse response = await _picker.retrieveLostData();
        if (response.file != null) {
          setState(() => _selectedImage = File(response.file!.path));
        }
      }
    } catch (e) {
      setState(() => _analysisResult = "خطأ تقني في معالجة الصورة: $e");
    }
  }

  void _processPickedFile(XFile file) {
    setState(() {
      _selectedImage = File(file.path);
      _analysisResult = "";
    });
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;
    setState(() {
      _isLoading = true;
      _analysisResult = "جاري الاتصال بسيرفر التحليل...";
    });

    try {
      final result = await _aiService.analyzeXRay(_selectedImage!);
      setState(() => _analysisResult = result);
    } catch (e) {
      setState(() => _analysisResult = "فشل التحليل بسبب مشكلة في الاتصال.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("مركز الأشعة الذكي")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: _selectedImage != null
                  ? Image.file(_selectedImage!, fit: BoxFit.contain)
                  : const Icon(Icons.add_a_photo, size: 50, color: Colors.blue),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _pickImage,
                    child: const Text("اختيار صورة"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_selectedImage == null || _isLoading)
                        ? null
                        : _analyzeImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "بدء التحليل",
                            style: TextStyle(color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
            if (_analysisResult.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(15),
                color: Colors.blue[50],
                child: Text(_analysisResult, textAlign: TextAlign.center),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
