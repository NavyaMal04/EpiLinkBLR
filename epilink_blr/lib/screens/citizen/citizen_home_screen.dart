import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../widgets/connectivity_banner.dart';
import '../../widgets/animated_card.dart';
import '../../widgets/icon_container.dart';
import '../../widgets/section_label.dart';
import '../../theme/app_theme.dart';
import '../../utils/stagger_mixin.dart';

class CitizenHomeScreen extends StatefulWidget {
  const CitizenHomeScreen({super.key});

  @override
  State<CitizenHomeScreen> createState() => _CitizenHomeScreenState();
}

class _CitizenHomeScreenState extends State<CitizenHomeScreen> with SingleTickerProviderStateMixin, StaggerMixin {
  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('EEEE, d MMM').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('EpiLink Citizen'),
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH, vertical: AppSpacing.pageV),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Help Protect\nBengaluru',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28, height: 1.1),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Report health hazards in your neighborhood to prevent outbreaks.',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const SizedBox(height: 24),
                    
                    const SectionLabel(text: 'How can you help?'),
                    
                    AnimatedCard(
                      delay: const Duration(milliseconds: 100),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      onTap: () => context.push('/citizen/hazard-report'),
                      child: _buildActionRow(
                        context,
                        icon: Icons.report_problem_rounded,
                        color: AppColors.critical,
                        bgColor: AppColors.criticalBg,
                        title: 'Report a Hazard',
                        subtitle: 'Stagnant water, garbage, open drains',
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    AnimatedCard(
                      delay: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      onTap: () => context.push('/citizen/health-tips'),
                      child: _buildActionRow(
                        context,
                        icon: Icons.tips_and_updates_rounded,
                        color: AppColors.medium,
                        bgColor: AppColors.mediumBg,
                        title: 'Health Tips',
                        subtitle: 'Prevent dengue & malaria',
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    AnimatedCard(
                      delay: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      onTap: () => context.push('/citizen/risk-level'),
                      child: _buildActionRow(
                        context,
                        icon: Icons.analytics_rounded,
                        color: AppColors.primary,
                        bgColor: AppColors.primaryLight,
                        title: 'Current Risk Level',
                        subtitle: 'Check your ward\'s status',
                        hasGlow: true,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    AnimatedCard(
                      delay: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.all(AppSpacing.md),
                      onTap: () => debugPrint('History not implemented'),
                      child: _buildActionRow(
                        context,
                        icon: Icons.history_rounded,
                        color: const Color(0xFF7C3AED),
                        bgColor: const Color(0xFFF5F3FF),
                        title: 'My Reports',
                        subtitle: 'View your contribution history',
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    Center(
                      child: Text(
                        'EPILINK BLR CITIZEN PORTAL',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow(BuildContext context, {
    required IconData icon,
    required Color color,
    required Color bgColor,
    required String title,
    required String subtitle,
    bool hasGlow = false,
  }) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (hasGlow)
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            IconContainer(icon: icon, color: color, bgColor: bgColor, size: 40),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleLarge),
              Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11)),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, size: 18, color: AppColors.textMuted),
      ],
    );
  }
}
