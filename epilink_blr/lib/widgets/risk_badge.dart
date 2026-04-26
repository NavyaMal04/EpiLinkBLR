import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RiskBadge extends StatelessWidget {
  final String level; // 'critical', 'high', 'medium', 'low'
  final bool large;
  final String? overrideText;

  const RiskBadge({
    super.key,
    required this.level,
    this.large = false,
    this.overrideText,
  });

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;
    Color border;
    String label;

    switch (level.toLowerCase()) {
      case 'critical':
        bg = AppColors.criticalBg;
        text = AppColors.critical;
        border = const Color(0xFFFECACA);
        label = 'Critical';
        break;
      case 'high':
        bg = AppColors.highBg;
        text = AppColors.high;
        border = const Color(0xFFFED7AA);
        label = 'High';
        break;
      case 'medium':
        bg = AppColors.mediumBg;
        text = AppColors.medium;
        border = const Color(0xFFFDE68A);
        label = 'Medium';
        break;
      case 'low':
      default:
        bg = AppColors.lowBg;
        text = AppColors.low;
        border = const Color(0xFFBBF7D0);
        label = 'Low';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 16 : 10,
        vertical: large ? 6 : 3,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: border),
      ),
      child: Text(
        (overrideText ?? label).toUpperCase(),
        style: TextStyle(
          color: text,
          fontSize: large ? 12 : 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
