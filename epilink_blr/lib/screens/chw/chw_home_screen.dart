import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../widgets/connectivity_banner.dart';
import '../../widgets/animated_card.dart';
import '../../widgets/icon_container.dart';
import '../../widgets/risk_badge.dart';
import '../../widgets/section_label.dart';
import '../../theme/app_theme.dart';
import '../../utils/stagger_mixin.dart';

class CHWHomeScreen extends StatefulWidget {
  const CHWHomeScreen({super.key});

  @override
  State<CHWHomeScreen> createState() => _CHWHomeScreenState();
}

class _CHWHomeScreenState extends State<CHWHomeScreen> with SingleTickerProviderStateMixin, StaggerMixin {
  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEEE, d MMM').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('EpiLink BLR'),
            Text(
              formattedDate,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/role-select'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            onPressed: () => context.push('/chw/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FadeTransition(
        opacity: staggerController,
        child: Column(
          children: [
            const ConnectivityBanner(),
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH, vertical: AppSpacing.pageV),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Alert Banner
                        AnimatedCard(
                          delay: Duration.zero,
                          backgroundColor: AppColors.criticalBg,
                          border: Border.all(color: const Color(0xFFFECACA)),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: AppColors.critical, size: 28),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Critical Alert: Bellandur Ward',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.critical, fontWeight: FontWeight.bold),
                                    ),
                                    const Text(
                                      'Risk score 100% · 47 predicted cases in 14 days',
                                      style: TextStyle(fontSize: 12, color: AppColors.critical),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SectionLabel(text: 'Quick Actions'),
                        
                        GridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.1,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            AnimatedCard(
                              delay: const Duration(milliseconds: 100),
                              padding: const EdgeInsets.all(AppSpacing.md),
                              onTap: () => context.push('/chw/symptom-log'),
                              child: _buildActionContent(
                                context,
                                icon: Icons.edit_note_rounded,
                                color: AppColors.primary,
                                bgColor: AppColors.primaryLight,
                                title: 'Log Symptoms',
                                subtitle: 'File patient report',
                              ),
                            ),
                            AnimatedCard(
                              delay: const Duration(milliseconds: 150),
                              padding: const EdgeInsets.all(AppSpacing.md),
                              onTap: () => context.push('/chw/mrdt-scanner'),
                              child: Stack(
                                children: [
                                  _buildActionContent(
                                    context,
                                    icon: Icons.document_scanner_rounded,
                                    color: AppColors.low,
                                    bgColor: AppColors.lowBg,
                                    title: 'Scan mRDT',
                                    subtitle: 'AI strip reader',
                                  ),
                                  const Positioned(
                                    top: 0,
                                    right: 0,
                                    child: RiskBadge(level: 'low', overrideText: 'AI READY'),
                                  ),
                                ],
                              ),
                            ),
                            AnimatedCard(
                              delay: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(AppSpacing.md),
                              onTap: () => context.push('/chw/risk-map'),
                              child: _buildActionContent(
                                context,
                                icon: Icons.map_rounded,
                                color: AppColors.medium,
                                bgColor: AppColors.mediumBg,
                                title: 'Risk Map',
                                subtitle: 'Outbreak heatmap',
                              ),
                            ),
                            AnimatedCard(
                              delay: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(AppSpacing.md),
                              onTap: () => context.push('/chw/sync-status'),
                              child: _buildActionContent(
                                context,
                                icon: Icons.sync_rounded,
                                color: const Color(0xFF7C3AED),
                                bgColor: const Color(0xFFF5F3FF),
                                title: 'Sync Status',
                                subtitle: 'Check queue',
                              ),
                            ),
                          ],
                        ),

                        const SectionLabel(text: 'Ward Risk Overview'),
                        
                        AnimatedCard(
                          delay: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('14-day prediction', style: Theme.of(context).textTheme.titleMedium),
                                  const RiskBadge(level: 'critical', overrideText: '2 CRITICAL'),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildRiskRow('Bellandur', 1.0, AppColors.critical),
                              _buildRiskRow('Whitefield', 0.94, AppColors.high),
                              _buildRiskRow('Mahadevapura', 0.55, AppColors.medium),
                              _buildRiskRow('KR Puram', 0.35, AppColors.low),
                              _buildRiskRow('Yelahanka', 0.21, AppColors.low),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionContent(BuildContext context, {
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String title,
    required String subtitle,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconContainer(icon: icon, color: color, bgColor: bgColor, size: 40),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11)),
      ],
    );
  }

  Widget _buildRiskRow(String name, double score, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 85,
            child: Text(name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(begin: 0, end: score),
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                    backgroundColor: AppColors.borderLight,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 8,
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 35,
            child: Text('${(score * 100).toInt()}%', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
