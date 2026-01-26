import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:radiology_center_app/core/constant/app_color.dart';
import 'package:radiology_center_app/core/constant/text_style.dart';
import 'package:radiology_center_app/core/helper/snack_bar_helper.dart';
import 'package:radiology_center_app/core/services/cxr_api_service.dart';
import 'package:radiology_center_app/core/widgets/custom_app_bar.dart';
import 'package:radiology_center_app/core/widgets/green_button.dart';

class CxrScreen extends StatefulWidget {
  const CxrScreen({Key? key}) : super(key: key);

  @override
  State<CxrScreen> createState() => _CxrScreenState();
}

class _CxrScreenState extends State<CxrScreen> {
  File? _image;
  Uint8List? _webImageBytes;
  String? _result;
  double? _confidence;
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
          _confidence = null;
        });
      } else {
        setState(() {
          _image = File(picked.path);
          _webImageBytes = null;
          _result = null;
          _confidence = null;
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
      _confidence = null;
    });

    try {
      final response = await CxrApiService.analyzeXray(imageSource);
      setState(() {
        _result = response['prediction'];
        _confidence = response['confidence']?.toDouble();
      });
    } catch (e) {
      SnackBarHelper.showError(context, 'خطأ في التحليل: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildImagePreview() {
    if (kIsWeb && _webImageBytes != null) {
      return Image.memory(_webImageBytes!, fit: BoxFit.contain);
    } else if (_image != null) {
      return Image.file(_image!, fit: BoxFit.contain);
    } else {
      return Center(
        child: Text('اختر صورة أشعة للبدء', style: AppTextStyles.textStyle16),
      );
    }
  }

  Widget _buildResultBox() {
    if (_result == null || _loading) return const SizedBox();

    final isNormal = _result == 'NORMAL';
    final bgColor = isNormal
        ? AppColor.gradientGreen
        : AppColor.buttonBackground;
    final textColor = isNormal ? AppColor.buttonBackground : AppColor.xIcon;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'النتيجة: $_result',
            style: AppTextStyles.textStyle20.copyWith(color: textColor),
          ),
          if (_confidence != null)
            Text(
              'نسبة الثقة: ${_confidence!.toStringAsFixed(1)}%',
              style: AppTextStyles.textStyle16.copyWith(
                color: AppColor.subtitleColor,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'تحليل صورة أشعة الصدر'),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(child: _buildImagePreview()),
                    if (_loading) const CircularProgressIndicator(),
                    _buildResultBox(),
                    const SizedBox(height: 16),
                    GreenButton(
                      widget: const Text(
                        'اختيار صورة',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _pickImage,
                    ),
                    const SizedBox(height: 12),
                    GreenButton(
                      widget: const Text(
                        'تحليل',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed:
                          (_image == null && _webImageBytes == null) || _loading
                          ? null
                          : _analyze,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
