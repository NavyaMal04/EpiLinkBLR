import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class MRDTResult {
  final String label;
  final double confidence;
  final bool isPositive;

  MRDTResult({
    required this.label,
    required this.confidence,
    required this.isPositive,
  });

  @override
  String toString() {
    return 'MRDTResult(label: $label, confidence: $confidence, isPositive: $isPositive)';
  }
}

class MRDTClassifier {
  Interpreter? _interpreter;
  final String _modelPath = 'assets/models/mrdt_classifier.tflite';

  Future<void> init() async {
    try {
      _interpreter = await Interpreter.fromAsset(_modelPath);
      print('TFLite model loaded successfully.');
    } catch (e) {
      print('Failed to load TFLite model: $e');
    }
  }

  Future<MRDTResult> classify(File imageFile) async {
    if (_interpreter == null) {
      return MRDTResult(label: 'unknown', confidence: 0.0, isPositive: false);
    }

    try {
      // Read image
      final bytes = await imageFile.readAsBytes();
      img.Image? originalImage = img.decodeImage(bytes);
      
      if (originalImage == null) {
        return MRDTResult(label: 'unknown', confidence: 0.0, isPositive: false);
      }

      // Resize to 224x224
      img.Image resizedImage = img.copyResize(originalImage, width: 224, height: 224);

      // Normalize pixel values to 0-1 and convert to List<List<List<List<double>>>>
      var input = List.generate(
        1,
        (i) => List.generate(
          224,
          (y) => List.generate(
            224,
            (x) {
              final pixel = resizedImage.getPixel(x, y);
              return [
                pixel.r / 255.0,
                pixel.g / 255.0,
                pixel.b / 255.0,
              ];
            },
          ),
        ),
      );

      // Output shape is [1, 1]
      var output = List.generate(1, (i) => List.filled(1, 0.0));

      // Run inference
      _interpreter!.run(input, output);

      double score = output[0][0];
      bool isPositive = score >= 0.35;
      String label = isPositive ? 'positive' : 'negative';

      return MRDTResult(
        label: label,
        confidence: score,
        isPositive: isPositive,
      );
    } catch (e) {
      print('Inference error: $e');
      return MRDTResult(label: 'unknown', confidence: 0.0, isPositive: false);
    }
  }

  void dispose() {
    _interpreter?.close();
  }
}
