import 'package:flutter/material.dart';

class IconContainer extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bgColor;
  final double size;

  const IconContainer({
    super.key,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: size * 0.45,
      ),
    );
  }
}
