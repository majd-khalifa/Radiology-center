import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/core/services/cxr_api_service.dart';


class CxrScreen extends StatefulWidget {
  const CxrScreen({Key? key}) : super(key: key);

  @override
  State<CxrScreen> createState() => _CxrScreenState();
}

class _CxrScreenState extends State<CxrScreen> {
  File? _image;
  Uint8List? _webImageBytes;
  String? _result;
  bool _loading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      if (kIsWeb) {
        final bytes = await picked.readAsBytes();
        setState(() {
          _webImageBytes = bytes;
          _image = null;
          _result = null;
        });
      } else {
        setState(() {
          _image = File(picked.path);
          _webImageBytes = null;
          _result = null;
        });
      }
    }
  }

  Future<void> _analyze() async {
    final imageSource = kIsWeb ? _webImageBytes : _image;
    if (imageSource == null) return;

    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      final prediction = await CxrApiService.analyzeXray(imageSource);
      setState(() {
        _result = prediction;
      });
    } catch (e) {
      setState(() {
        _result = 'خطأ في التحليل: $e';
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildImagePreview() {
    if (kIsWeb && _webImageBytes != null) {
      return Image.memory(_webImageBytes!);
    } else if (_image != null) {
      return Image.file(_image!);
    } else {
      return const Center(child: Text('اختر صورة أشعة للبدء'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تحليل صورة أشعة الصدر')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: _buildImagePreview()),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (_result != null && !_loading)
              Text(
                'النتيجة: $_result',
                style: AppTextStyles.textStyle16,
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text('اختيار صورة'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_image == null && _webImageBytes == null) || _loading
                        ? null
                        : _analyze,
                    child: const Text('تحليل'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
