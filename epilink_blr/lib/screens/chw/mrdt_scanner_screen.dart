import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/classifier_service.dart';

class MRDTScannerScreen extends StatefulWidget {
  const MRDTScannerScreen({super.key});

  @override
  State<MRDTScannerScreen> createState() => _MRDTScannerScreenState();
}

class _MRDTScannerScreenState extends State<MRDTScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isAnalysing = false;
  MRDTResult? _result;
  File? _capturedImage;

  Future<void> _captureTestStrip() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    try {
      final XFile? photo = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear,
      );
      
      if (photo != null) {
        final File imageFile = File(photo.path);
        setState(() {
          _capturedImage = imageFile;
          _isAnalysing = true;
          _result = null;
        });

        final classifier = context.read<ClassifierService>();
        final result = await classifier.classify(imageFile);

        setState(() {
          _isAnalysing = false;
          _result = result;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera error: $e')),
      );
      setState(() => _isAnalysing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MRDT Scanner'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          if (_capturedImage == null && !_isAnalysing)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 24),
                  const Text('No image captured', style: TextStyle(fontSize: 18, color: Colors.grey)),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _captureTestStrip,
                    icon: const Icon(Icons.camera_enhance),
                    label: const Text('Scan Test Strip'),
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                  ),
                ],
              ),
            ),

          if (_capturedImage != null)
            Column(
              children: [
                Expanded(child: Image.file(_capturedImage!, fit: BoxFit.contain)),
                if (_result != null)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _result!.label.toUpperCase(),
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: _result!.isPositive ? Colors.red : Colors.green,
                          ),
                        ),
                        Text('Confidence: ${(_result!.confidence * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: _captureTestStrip,
                                child: const Text('Retake'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => context.pop(_result),
                                child: const Text('Confirm'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),

          if (_isAnalysing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 20),
                    Text('Analysing strip with Gemini AI...', 
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
