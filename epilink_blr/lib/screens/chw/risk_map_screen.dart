import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';

class RiskMapScreen extends StatefulWidget {
  const RiskMapScreen({super.key});
  @override
  State<RiskMapScreen> createState() => _RiskMapScreenState();
}

class _RiskMapScreenState extends State<RiskMapScreen> {
  GoogleMapController? _mapController;

  // Hardcoded from BigQuery ward_risk_scores — Bellandur critical (1.0)
  final List<Map<String, dynamic>> _wardRisks = [
    {'name': 'Yelahanka',     'lat': 13.1007, 'lng': 77.5963, 'score': 0.21},
    {'name': 'KR Puram',      'lat': 13.0,    'lng': 77.695,  'score': 0.35},
    {'name': 'Whitefield',    'lat': 12.9698, 'lng': 77.7499, 'score': 0.94},
    {'name': 'Hebbal',        'lat': 13.035,  'lng': 77.597,  'score': 0.28},
    {'name': 'Bommanahalli',  'lat': 12.895,  'lng': 77.624,  'score': 0.45},
    {'name': 'Koramangala',   'lat': 12.935,  'lng': 77.624,  'score': 0.38},
    {'name': 'HSR Layout',    'lat': 12.911,  'lng': 77.640,  'score': 0.42},
    {'name': 'Bellandur',     'lat': 12.926,  'lng': 77.678,  'score': 1.00},
    {'name': 'Mahadevapura',  'lat': 12.990,  'lng': 77.714,  'score': 0.55},
    {'name': 'Rajajinagar',   'lat': 12.991,  'lng': 77.552,  'score': 0.19},
  ];

  Color _riskColor(double score) {
    if (score >= 0.8) return Colors.red;
    if (score >= 0.6) return Colors.orange;
    if (score >= 0.3) return Colors.amber;
    return Colors.green;
  }

  String _riskLabel(double score) {
    if (score >= 0.8) return 'CRITICAL';
    if (score >= 0.6) return 'HIGH';
    if (score >= 0.3) return 'MEDIUM';
    return 'LOW';
  }

  Set<Circle> get _circles => _wardRisks.map((ward) {
    return Circle(
      circleId: CircleId(ward['name']),
      center: LatLng(ward['lat'], ward['lng']),
      radius: 1800,
      fillColor: _riskColor(ward['score']).withOpacity(0.45),
      strokeColor: _riskColor(ward['score']),
      strokeWidth: 2,
      consumeTapEvents: true,
      onTap: () => _showWardInfo(ward),
    );
  }).toSet();

  void _showWardInfo(Map<String, dynamic> ward) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text(ward['name'],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _riskColor(ward['score']).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _riskColor(ward['score'])),
                ),
                child: Text(_riskLabel(ward['score']),
                  style: TextStyle(
                    color: _riskColor(ward['score']),
                    fontWeight: FontWeight.bold,
                  )),
              ),
            ]),
            const SizedBox(height: 12),
            Text('Risk Score: ${(ward['score'] * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text('Predicted cases (14 days): ${(ward['score'] * 50).toInt()}',
              style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            if (ward['score'] >= 0.8)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: const Row(children: [
                  Icon(Icons.warning_amber, color: Colors.red),
                  SizedBox(width: 8),
                  Expanded(child: Text('Immediate intervention recommended',
                    style: TextStyle(color: Colors.red))),
                ]),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outbreak Risk Map'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(12.97, 77.59),
              zoom: 11,
            ),
            circles: _circles,
            onMapCreated: (c) => _mapController = c,
            myLocationButtonEnabled: false,
          ),
          // Legend
          Positioned(
            bottom: 24, left: 16,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _legendItem(Colors.green, 'Low'),
                  _legendItem(Colors.amber, 'Medium'),
                  _legendItem(Colors.orange, 'High'),
                  _legendItem(Colors.red, 'Critical'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(children: [
      Container(width: 14, height: 14,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 8),
      Text(label, style: const TextStyle(fontSize: 12)),
    ]),
  );
}
