import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/sync_service.dart';
import '../theme/app_theme.dart';

class ConnectivityBanner extends StatefulWidget {
  const ConnectivityBanner({super.key});

  @override
  State<ConnectivityBanner> createState() => _ConnectivityBannerState();
}

class _ConnectivityBannerState extends State<ConnectivityBanner> with SingleTickerProviderStateMixin {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (mounted) setState(() => _connectionStatus = result);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final syncService = context.watch<SyncService>();
    final pending = syncService.pendingCount.value;

    Widget banner;

    if (_connectionStatus == ConnectivityResult.none) {
      banner = _buildBanner(
        key: const ValueKey('offline'),
        color: AppColors.highBg,
        dotColor: AppColors.high,
        text: 'Offline · $pending reports queued',
      );
    } else if (pending > 0) {
      banner = _buildBanner(
        key: const ValueKey('syncing'),
        color: AppColors.primaryLight,
        dotColor: AppColors.primary,
        text: 'Syncing $pending reports...',
        isPulsing: true,
      );
    } else {
      banner = _buildBanner(
        key: const ValueKey('online'),
        color: AppColors.lowBg,
        dotColor: AppColors.low,
        text: 'Live · Cloud Sync Active',
      );
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.3),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: banner,
    );
  }

  Widget _buildBanner({
    required Key key,
    required Color color,
    required Color dotColor,
    required String text,
    bool isPulsing = false,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isPulsing
              ? FadeTransition(
                  opacity: _pulseController,
                  child: _buildDot(dotColor),
                )
              : _buildDot(dotColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              color: dotColor.withOpacity(0.8),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
