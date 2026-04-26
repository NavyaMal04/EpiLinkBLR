class MRDTResult {
  final String label;
  final double confidence;
  MRDTResult(this.label, this.confidence);
  bool get isPositive => label.toLowerCase() == 'positive';
}

class ClassifierService {
  Future<MRDTResult> classify(dynamic image) async {
    return MRDTResult('Negative', 0.98);
  }
}
