import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class MRDTResult {
  final String label;
  final double confidence;
  final bool isPositive;

  MRDTResult(this.label, this.confidence, this.isPositive);
}

class ClassifierService {
  Interpreter? _interpreter;
  double _threshold = 0.35;

  Future<void> initialize() async {
    try {
      // Load Metadata
      final metadataJson = await rootBundle.loadString('assets/models/model_metadata.json');
      final metadata = jsonDecode(metadataJson);
      _threshold = metadata['threshold'] ?? 0.35;

      // Load Interpreter
      _interpreter = await Interpreter.fromAsset('assets/models/mrdt_classifier.tflite');
      print('TFLite Model loaded successfully');
    } catch (e) {
      print('Error loading TFLite model: $e');
    }
  }

  Future<MRDTResult> classify(File imageFile) async {
    if (_interpreter == null) {
      return MRDTResult('Error', 0.0, false);
    }

    // Read image
    final imageBytes = await imageFile.readAsBytes();
    final oriImage = img.decodeImage(imageBytes);
    if (oriImage == null) return MRDTResult('Error', 0.0, false);

    // Resize to 224x224
    final resizedImage = img.copyResize(oriImage, width: 224, height: 224);

    // Normalize (0-255 to 0.0-1.0)
    var input = List.generate(
      1,
      (batch) => List.generate(
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

    // Output tensor [1, 1]
    var output = List.filled(1 * 1, 0.0).reshape([1, 1]);

    // Run inference
    _interpreter!.run(input, output);

    final double posScore = output[0][0];

    // Determine result
    bool isPositive = posScore >= _threshold;
    String label = isPositive ? 'positive' : 'negative';
    double confidence = isPositive ? posScore : (1.0 - posScore);

    return MRDTResult(label, confidence, isPositive);
  }

  void dispose() {
    _interpreter?.close();
  }
}
