import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../widgets/risk_badge.dart';
import '../../widgets/icon_container.dart';

class RiskMapScreen extends StatefulWidget {
  const RiskMapScreen({super.key});
  @override
  State<RiskMapScreen> createState() => _RiskMapScreenState();
}

class _RiskMapScreenState extends State<RiskMapScreen> {
  GoogleMapController? _mapController;

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
    if (score >= 0.8) return AppColors.critical;
    if (score >= 0.6) return AppColors.high;
    if (score >= 0.3) return AppColors.medium;
    return AppColors.low;
  }

  String _riskLevelStr(double score) {
    if (score >= 0.8) return 'critical';
    if (score >= 0.6) return 'high';
    if (score >= 0.3) return 'medium';
    return 'low';
  }

  Set<Circle> get _circles => _wardRisks.map((ward) {
    return Circle(
      circleId: CircleId(ward['name']),
      center: LatLng(ward['lat'], ward['lng']),
      radius: 1600,
      fillColor: _riskColor(ward['score']).withOpacity(0.35),
      strokeColor: _riskColor(ward['score']).withOpacity(0.8),
      strokeWidth: 2,
      consumeTapEvents: true,
      onTap: () => _showWardInfo(ward),
    );
  }).toSet();

  void _showWardInfo(Map<String, dynamic> ward) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            Row(children: [
              Text(ward['name'], style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 22)),
              const Spacer(),
              RiskBadge(level: _riskLevelStr(ward['score']), large: true),
            ]),
            const SizedBox(height: 16),
            _infoRow(Icons.analytics_rounded, 'Risk Score', '${(ward['score'] * 100).toStringAsFixed(0)}% Intensity'),
            const SizedBox(height: 12),
            _infoRow(Icons.groups_rounded, 'Predicted Cases', '${(ward['score'] * 50).toInt()} potential infections'),
            const SizedBox(height: 24),
            if (ward['score'] >= 0.8)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.criticalBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Row(children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.critical),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Critical cluster detected. Deployment of field team required.',
                    style: GoogleFonts.inter(color: AppColors.critical, fontSize: 13, fontWeight: FontWeight.w500))),
                ]),
              ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 12),
        Text('$label: ', style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 14)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 20),
              onPressed: () => context.pop(),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(12.96, 77.64),
              zoom: 12,
            ),
            circles: _circles,
            onMapCreated: (c) => _mapController = c,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            style: _mapStyle, // Using a minimal map style if available
          ),
          
          // Floating Search/Header
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 64,
            right: 16,
            child: _glassPanel(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: AppColors.textMuted, size: 20),
                    const SizedBox(width: 12),
                    Text('Search wards...', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                    const Spacer(),
                    const Icon(Icons.filter_list_rounded, color: AppColors.primary, size: 20),
                  ],
                ),
              ),
            ),
          ),

          // Legend Panel
          Positioned(
            bottom: 32,
            left: 16,
            child: _glassPanel(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LEGEND', style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(height: 12),
                    _legendItem(AppColors.low, 'Low Risk'),
                    _legendItem(AppColors.medium, 'Medium Risk'),
                    _legendItem(AppColors.high, 'High Risk'),
                    _legendItem(AppColors.critical, 'Critical Hotspot'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassPanel({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String label) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 12),
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
    ]),
  );

  final String? _mapStyle = null; // Can be a JSON string for minimal map style
}
