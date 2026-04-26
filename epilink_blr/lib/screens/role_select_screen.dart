import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_card.dart';
import '../widgets/icon_container.dart';

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  Future<void> _selectRole(BuildContext context, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_role', role);
    
    if (context.mounted) {
      final authService = context.read<AuthService>();
      await authService.signInAnonymously();
      
      if (context.mounted) {
        if (role == 'CHW') {
          context.go('/chw/home');
        } else {
          context.go('/citizen/home');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Top Section (40% height)
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EPILINK BLR',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Community Health\nIntelligence',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 26,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Bengaluru disease surveillance network',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageH),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedCard(
                    delay: Duration.zero,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    onTap: () => _selectRole(context, 'CHW'),
                    child: Row(
                      children: [
                        const IconContainer(
                          icon: Icons.medical_services_rounded,
                          color: AppColors.primary,
                          bgColor: AppColors.primaryLight,
                          size: 48,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Health Worker', style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 4),
                              const Text(
                                'Log patient symptoms, scan mRDT test strips, and file field reports',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AnimatedCard(
                    delay: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    onTap: () => _selectRole(context, 'Citizen'),
                    child: Row(
                      children: [
                        const IconContainer(
                          icon: Icons.person_pin_circle_rounded,
                          color: AppColors.low,
                          bgColor: AppColors.lowBg,
                          size: 48,
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Citizen Reporter', style: Theme.of(context).textTheme.titleLarge),
                              const SizedBox(height: 4),
                              const Text(
                                'Report environmental hazards like stagnant water and open drains',
                                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Text(
              'Phase 2 Hackathon Deployment',
              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}
