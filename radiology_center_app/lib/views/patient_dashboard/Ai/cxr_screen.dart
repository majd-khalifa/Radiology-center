// ignore_for_file: use_super_parameters, use_build_context_synchronously

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

  double? _xrayConfidence;
  Map<String, double>? _findings;

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
          _findings = null;
          _xrayConfidence = null;
        });
      } else {
        setState(() {
          _image = File(picked.path);
          _webImageBytes = null;
          _findings = null;
          _xrayConfidence = null;
        });
      }
    }
  }

  Future<void> _analyze() async {
    final imageSource = kIsWeb ? _webImageBytes : _image;
    if (imageSource == null) return;

    setState(() {
      _loading = true;
      _findings = null;
      _xrayConfidence = null;
    });

    try {
      final result = await CxrApiService.analyzeXray(imageSource);

      setState(() {
        _xrayConfidence = result["confidence"] != null
            ? (result["confidence"] as num).toDouble()
            : null;

        _findings = result["findings"] != null
            ? Map<String, double>.from(result["findings"])
            : null;
      });
    } catch (e) {
      SnackBarHelper.showError(context, 'Analysis error: $e');
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _buildImagePreview() {
    if (_webImageBytes == null && _image == null) {
      return Center(
        child: Text(
          'Select an X-ray image to begin',
          style: AppTextStyles.textStyle16,
        ),
      );
    }

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: kIsWeb
            ? Image.memory(_webImageBytes!, fit: BoxFit.cover)
            : Image.file(_image!, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildResultBox() {
    if (_findings == null || _loading) return const SizedBox();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_xrayConfidence != null) ...[
              Text(
                'Confidence that the image is an X-ray:',
                style: AppTextStyles.textStyle18.copyWith(
                  color: AppColor.titleColor,
                ),
              ),
              Text(
                '${_xrayConfidence!.toStringAsFixed(1)}%',
                style: AppTextStyles.textStyle20.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
            ],
            Text(
              'Detected Findings:',
              style: AppTextStyles.textStyle20.copyWith(
                color: AppColor.titleColor,
              ),
            ),
            const SizedBox(height: 12),
            ..._findings!.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key, style: AppTextStyles.textStyle16),
                    Text(
                      '${entry.value.toStringAsFixed(1)}%',
                      style: AppTextStyles.textStyle16.copyWith(
                        color: AppColor.subtitleColor,
                      ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3FFF8),
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(title: 'Chest X-ray Analysis'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildImagePreview(),
                    const SizedBox(height: 20),
                    if (_loading) const CircularProgressIndicator(),
                    _buildResultBox(),
                    const SizedBox(height: 20),
                    GreenButton(
                      widget: const Text(
                        'Choose Image',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: _pickImage,
                    ),
                    const SizedBox(height: 12),
                    GreenButton(
                      widget: const Text(
                        'Analyze',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed:
                          (_image == null && _webImageBytes == null) || _loading
                          ? null
                          : _analyze,
                    ),
                    const SizedBox(height: 30),
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
