import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CurrentRiskLevelScreen extends StatelessWidget {
  const CurrentRiskLevelScreen({super.key});

  final List<Map<String, dynamic>> _wardRisks = const [
    {'name': 'Bellandur',     'score': 1.00},
    {'name': 'Whitefield',    'score': 0.94},
    {'name': 'Mahadevapura',  'score': 0.55},
    {'name': 'Bommanahalli',  'score': 0.45},
    {'name': 'HSR Layout',    'score': 0.42},
    {'name': 'Koramangala',   'score': 0.38},
    {'name': 'KR Puram',      'score': 0.35},
    {'name': 'Hebbal',        'score': 0.28},
    {'name': 'Yelahanka',     'score': 0.21},
    {'name': 'Rajajinagar',   'score': 0.19},
  ];

  Color _riskColor(double score) {
    if (score >= 0.8) return Colors.red;
    if (score >= 0.6) return Colors.orange;
    if (score >= 0.3) return Colors.amber;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bengaluru Risk Levels'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _wardRisks.length,
        itemBuilder: (context, index) {
          final ward = _wardRisks[index];
          final color = _riskColor(ward['score']);
          
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              title: Text(ward['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text('Predicted Cases: ${(ward['score'] * 50).toInt()}'),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color),
                ),
                child: Text('${(ward['score'] * 100).toInt()}%', 
                  style: TextStyle(color: color, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      ),
    );
  }
}
