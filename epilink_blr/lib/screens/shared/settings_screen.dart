import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/chw/home');
            }
          },
        ),
      ),
      body: ListView(
        children: [
          const _SettingsHeader(title: 'Account'),
          const ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('CHW ID'),
            subtitle: Text('CHW-2024-0891'),
          ),
          const _SettingsHeader(title: 'Application'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Version'),
            subtitle: Text('1.2.0 (Stable)'),
          ),
          ListTile(
            leading: const Icon(Icons.delete_outline, color: Colors.red),
            title: const Text('Clear local data', style: TextStyle(color: Colors.red)),
            onTap: () => _showClearDataDialog(context),
          ),
          const _SettingsHeader(title: 'About'),
          const ListTile(
            title: Text('About EpiLink'),
            subtitle: Text('Epidemic Early Warning System for Bengaluru'),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all data?'),
        content: const Text('This will remove all local unsynced reports. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  final String title;
  const _SettingsHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(title, 
        style: TextStyle(color: Colors.blue.shade700, fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 1)),
    );
  }
}
