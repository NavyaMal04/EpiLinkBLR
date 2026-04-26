import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HealthTipsScreen extends StatelessWidget {
  const HealthTipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prevention Tips'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _TipCard(
            icon: Icons.water_drop_outlined,
            title: 'Remove stagnant water',
            desc: 'Check and empty flower pots, tires, and containers weekly to prevent mosquito breeding.',
          ),
          _TipCard(
            icon: Icons.bed_outlined,
            title: 'Use mosquito nets',
            desc: 'Sleep under insecticide-treated nets, especially for children and the elderly.',
          ),
          _TipCard(
            icon: Icons.checkroom_outlined,
            title: 'Wear protective clothing',
            desc: 'Wear full-sleeve shirts and long trousers during peak mosquito hours (dawn and dusk).',
          ),
          _TipCard(
            icon: Icons.report_problem_outlined,
            title: 'Report drain blockages',
            desc: 'Use the EpiLink app to report stagnant water or blocked drains in your neighborhood.',
          ),
          _TipCard(
            icon: Icons.medical_services_outlined,
            title: 'Seek early care',
            desc: 'If fever persists for more than 3 days, visit your nearest health center immediately.',
          ),
        ],
      ),
    );
  }
}

class _TipCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _TipCard({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.blue.shade50, shape: BoxShape.circle),
              child: Icon(icon, color: Colors.blue),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(desc, style: TextStyle(color: Colors.grey[700], height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
