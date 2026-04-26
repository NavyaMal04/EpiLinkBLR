import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../services/sync_service.dart';

class SyncStatusScreen extends StatelessWidget {
  const SyncStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final syncService = context.watch<SyncService>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Status'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_sync, size: 48, color: Colors.blue),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pending Reports', style: TextStyle(fontSize: 16)),
                        Text('${syncService.pendingCount.value}', 
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await syncService.syncAll();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sync process completed')),
                  );
                },
                icon: const Icon(Icons.sync),
                label: const Text('Sync Now', style: TextStyle(fontSize: 18)),
              ),
            ),
            const Spacer(),
            Text('Last synced: Just now', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
