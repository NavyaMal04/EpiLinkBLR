import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/connectivity_banner.dart';

class CitizenHomeScreen extends StatelessWidget {
  const CitizenHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EpiLink Citizen'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/role-select'),
        ),
      ),
      body: Column(
        children: [
          const ConnectivityBanner(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Help Protect Bengaluru',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text('Report health hazards in your neighborhood to help prevent disease outbreaks.'),
                  const SizedBox(height: 30),
                  _ActionCard(
                    title: 'Report a Hazard',
                    subtitle: 'Stagnant water, garbage, open drains',
                    icon: Icons.report_problem_rounded,
                    color: Colors.orange,
                    onTap: () => context.push('/citizen/hazard-report'),
                  ),
                  const SizedBox(height: 20),
                  _ActionCard(
                    title: 'Health Tips',
                    subtitle: 'How to stay safe from dengue & malaria',
                    icon: Icons.lightbulb_rounded,
                    color: Colors.amber,
                    onTap: () => context.push('/citizen/health-tips'),
                  ),
                  const SizedBox(height: 20),
                  _ActionCard(
                    title: 'Current Risk Level',
                    subtitle: 'Check your ward\'s status',
                    icon: Icons.health_and_safety_rounded,
                    color: Colors.green,
                    onTap: () => context.push('/citizen/risk-level'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
