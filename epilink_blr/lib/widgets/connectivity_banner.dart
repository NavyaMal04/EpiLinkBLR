import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import '../services/sync_service.dart';

class ConnectivityBanner extends StatefulWidget {
  const ConnectivityBanner({super.key});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  bool _showOnlineSuccess = false;

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (_connectionStatus == ConnectivityResult.none && result != ConnectivityResult.none) {
        // Back online
        setState(() => _showOnlineSuccess = true);
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _showOnlineSuccess = false);
        });
      }
      setState(() => _connectionStatus = result);
    });
  }

  @override
  Widget build(BuildContext context) {
    final syncService = context.watch<SyncService>();
    final pending = syncService.pendingCount.value;

    if (_connectionStatus == ConnectivityResult.none) {
      return Container(
        width: double.infinity,
        color: Colors.amber.shade700,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Text(
          'Offline — $pending pending reports',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (pending > 0) {
      return Container(
        width: double.infinity,
        color: Colors.blue.shade600,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Text(
          'Syncing $pending reports to cloud...',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (_showOnlineSuccess) {
      return Container(
        width: double.infinity,
        color: Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: const Text(
          'Connected — Cloud Sync Active',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
