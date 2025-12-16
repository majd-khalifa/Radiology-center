// lib/screens/xray_analyzer_screen.dart - SIMPLE AND WORKING
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:radiology_center_app/core/services/xray_analyzer_service.dart';

class XRayAnalyzerScreen extends StatefulWidget {
  const XRayAnalyzerScreen({Key? key}) : super(key: key);

  @override
  _XRayAnalyzerScreenState createState() => _XRayAnalyzerScreenState();
}

class _XRayAnalyzerScreenState extends State<XRayAnalyzerScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  Map<String, dynamic>? _analysisResult;

  // 🎯 Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) return;

    setState(() {
      _selectedImage = File(pickedFile.path);
      _analysisResult = null; // Clear previous result
    });
  }

  // 🎯 Analyze selected image
  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please select an image first!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await XRayAnalyzerService().analyzeXRay(_selectedImage!);
      print('📥 Received result: $result');

      setState(() {
        _analysisResult = result;
        _isLoading = false;
      });

      // Show error if exists
      if (result.containsKey('Error')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ ${result['Message']}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      print('❌ UI Error: $e');
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to analyze: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🩺 X-Ray Analyzer'),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 📱 Image picker button
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                '📂 SELECT X-RAY IMAGE',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),

            // 📸 Selected image preview
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

            const SizedBox(height: 20),

            // 🔬 Analyze button
            ElevatedButton(
              onPressed: _isLoading ? null : _analyzeImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isLoading ? Colors.grey : Colors.blue[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white),
                    )
                  : const Text(
                      '🔬 ANALYZE X-RAY',
                      style: TextStyle(fontSize: 16),
                    ),
            ),

            const SizedBox(height: 20),

            // 📊 Display results
            if (_analysisResult != null) ...[
              if (_analysisResult!.containsKey('Error'))
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '❌ ERROR',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${_analysisResult!['Error']}: ${_analysisResult!['Message']}',
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '✅ ANALYSIS RESULT',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Show all key-value pairs
                      ..._analysisResult!.entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: Text('• ${entry.key}: ${entry.value}'),
                        ),
                      ),
                    ],
                  ),
                ),
            ],

            // 📊 Loading indicator
            if (_isLoading == true) ...[
              const SizedBox(height: 20),
              const Center(child: CircularProgressIndicator()),
            ],
          ],
        ),
      ),
    );
  }
}
