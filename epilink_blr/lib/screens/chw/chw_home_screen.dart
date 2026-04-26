import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/connectivity_banner.dart';

class CHWHomeScreen extends StatelessWidget {
  const CHWHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHW Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/role-select'),
        ),
      ),
      body: Column(
        children: [
          const ConnectivityBanner(),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              children: [
                _HomeCard(
                  title: 'Log Symptoms',
                  icon: Icons.edit_note_rounded,
                  color: Colors.teal,
                  onTap: () => context.push('/chw/symptom-log'),
                ),
                _HomeCard(
                  title: 'MRDT Scanner',
                  icon: Icons.qr_code_scanner_rounded,
                  color: Colors.purple,
                  onTap: () => context.push('/chw/mrdt-scanner'),
                ),
                _HomeCard(
                  title: 'Sync Status',
                  icon: Icons.sync_rounded,
                  color: Colors.blue,
                  onTap: () => context.push('/chw/sync-status'),
                ),
                _HomeCard(
                  title: 'View Risk Map',
                  icon: Icons.map_rounded,
                  color: Colors.orange,
                  onTap: () => context.push('/chw/risk-map'),
                ),
                _HomeCard(
                  title: 'Settings',
                  icon: Icons.settings_rounded,
                  color: Colors.grey,
                  onTap: () => context.push('/chw/settings'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HomeCard({
    required this.title,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
