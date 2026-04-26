import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/classifier_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/icon_container.dart';

class MRDTScannerScreen extends StatefulWidget {
  const MRDTScannerScreen({super.key});

  @override
  State<MRDTScannerScreen> createState() => _MRDTScannerScreenState();
}

class _MRDTScannerScreenState extends State<MRDTScannerScreen> with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  bool _isAnalysing = false;
  MRDTResult? _result;
  File? _capturedImage;
  late AnimationController _scanController;

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  Future<void> _captureTestStrip() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 12),
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
        
        _scanController.repeat();

        final classifier = context.read<ClassifierService>();
        final result = await classifier.classify(imageFile);

        setState(() {
          _isAnalysing = false;
          _result = result;
        });
        _scanController.stop();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera error: $e')),
      );
      setState(() => _isAnalysing = false);
      _scanController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text('AI Strip Reader'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          // Background - Image or Placeholder
          Positioned.fill(
            child: _capturedImage == null 
              ? Container(
                  color: Colors.grey[900],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const IconContainer(
                          icon: Icons.camera_alt_rounded,
                          color: Colors.white,
                          bgColor: Colors.white24,
                          size: 80,
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Align strip within the frame',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Ensure good lighting for AI accuracy',
                          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                )
              : Image.file(_capturedImage!, fit: BoxFit.contain),
          ),

          // Scanning Animation Overlay
          if (_isAnalysing)
            AnimatedBuilder(
              animation: _scanController,
              builder: (context, child) {
                return Positioned(
                  top: MediaQuery.of(context).size.height * 0.2 + (MediaQuery.of(context).size.height * 0.5 * _scanController.value),
                  left: 40,
                  right: 40,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppColors.primaryMid,
                      boxShadow: [
                        BoxShadow(color: AppColors.primaryMid.withOpacity(0.5), blurRadius: 10, spreadRadius: 4),
                      ],
                    ),
                  ),
                );
              },
            ),

          // Capture Guide Frame
          if (_capturedImage == null && !_isAnalysing)
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.width * 0.4,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white.withOpacity(0.8), width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),

          // Bottom Action Button (Capture)
          if (_capturedImage == null && !_isAnalysing)
            Positioned(
              bottom: 48,
              left: 48,
              right: 48,
              child: PrimaryButton(
                label: 'Capture Test Strip',
                onPressed: _captureTestStrip,
              ),
            ),

          // Loading Overlay
          if (_isAnalysing)
            Positioned.fill(
              child: Container(
                color: Colors.black38,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      const SizedBox(height: 24),
                      Text(
                        'GEMINI AI ANALYSING...',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Result Card
          if (_result != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: TweenAnimationBuilder<Offset>(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                tween: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero),
                builder: (context, offset, child) {
                  return FractionalTranslation(
                    translation: offset,
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          IconContainer(
                            icon: _result!.isPositive ? Icons.warning_rounded : Icons.check_circle_rounded,
                            color: _result!.isPositive ? AppColors.critical : AppColors.low,
                            bgColor: _result!.isPositive ? AppColors.criticalBg : AppColors.lowBg,
                            size: 48,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _result!.label.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: _result!.isPositive ? AppColors.critical : AppColors.low,
                                  ),
                                ),
                                Text(
                                  'Confidence: ${(_result!.confidence * 100).toStringAsFixed(1)}%',
                                  style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                side: const BorderSide(color: AppColors.border),
                              ),
                              onPressed: _captureTestStrip,
                              child: const Text('Retake', style: TextStyle(color: AppColors.textPrimary)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: PrimaryButton(
                              label: 'Confirm Result',
                              onPressed: () => context.pop(_result),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
