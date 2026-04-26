import 'package:flutter/material.dart';

mixin StaggerMixin<T extends StatefulWidget> on State<T>, SingleTickerProviderStateMixin<T> {
  late AnimationController staggerController;

  @override
  void initState() {
    super.initState();
    staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) staggerController.forward();
    });
  }

  @override
  void dispose() {
    staggerController.dispose();
    super.dispose();
  }
}
