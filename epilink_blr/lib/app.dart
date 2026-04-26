import 'package:flutter/material.dart';
import 'router/app_router.dart';

class EpiLinkApp extends StatelessWidget {
  const EpiLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EpiLink BLR',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
