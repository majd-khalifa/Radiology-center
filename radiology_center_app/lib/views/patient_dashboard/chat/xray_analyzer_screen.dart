// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors, avoid_print, unnecessary_to_list_in_spreads

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:radiology_center_app/core/services/xray_analyzer_service.dart';

class XRayAnalyzerScreen extends StatefulWidget {
  @override
  _XRayAnalyzerScreenState createState() => _XRayAnalyzerScreenState();
}

class _XRayAnalyzerScreenState extends State<XRayAnalyzerScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  Map<String, dynamic>? _analysisResult;

  // 📸 اختيار صورة من المعرض
  Future<void> _pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
          _analysisResult = null; // مسح النتائج القديمة
        });
      }
    } catch (e) {
      _showSnackBar('Failed to pick image: $e', Colors.red);
    }
  }

  // 🔍 تحليل الصورة
  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      _showSnackBar('⚠️ Please select an image first!', Colors.orange);
      return;
    }

    setState(() {
      _isLoading = true;
      _analysisResult = null;
    });

    try {
      final result = await XRayAnalyzerService.analyzeXRay(_selectedImage!);
      print('📥 Received result: $result');

      setState(() {
        _analysisResult = result;
        _isLoading = false;
      });

      // ✅ نجاح
      if (result['Status'] == 'Success') {
        _showSnackBar('✅ Analysis completed!', Colors.green);
      }
      // ❌ خطأ
      else {
        _showSnackBar('❌ ${result['Message']}', Colors.red);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showSnackBar('❌ Failed to analyze: $e', Colors.red);
    }
  }

  // 💬 رسائل للمستخدم
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🩺 X-ray AI Analyzer'),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 📱 زر اختيار الصورة
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.photo_library),
              label: Text('📂 SELECT X-RAY IMAGE'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(16),
              ),
            ),
            SizedBox(height: 10),

            // 📸 عرض الصورة المحددة
            if (_selectedImage != null)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(_selectedImage!, fit: BoxFit.cover),
                ),
              ),

            SizedBox(height: 20),

            // 🔬 زر التحليل
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _analyzeImage,
              icon: _isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : Icon(Icons.search),
              label: Text(_isLoading ? '🔬 Analyzing...' : '🔬 ANALYZE X-RAY'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isLoading ? Colors.grey : Colors.blue[800],
                foregroundColor: Colors.white,
                padding: EdgeInsets.all(16),
              ),
            ),

            SizedBox(height: 20),

            // 📊 عرض النتائج
            if (_analysisResult != null) ...[
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _analysisResult!['Status'] == 'Success'
                      ? Colors.green[100]
                      : Colors.red[100],
                  border: Border.all(
                    color: _analysisResult!['Status'] == 'Success'
                        ? Colors.green
                        : Colors.red,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _analysisResult!['Status'] == 'Success'
                          ? '✅ ANALYSIS RESULT'
                          : '❌ ERROR',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _analysisResult!['Status'] == 'Success'
                            ? Colors.green[800]
                            : Colors.red[800],
                      ),
                    ),
                    SizedBox(height: 10),
                    ..._analysisResult!.entries
                        .where((e) => e.key != 'Status')
                        .map(
                          (e) => Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Text(
                              '• ${e.key}: ${e.value}',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                ),
              ),
            ],

            // ⏳ مؤشر التحميل
            if (_isLoading) ...[
              SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text(
                      'Analyzing X-ray...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
