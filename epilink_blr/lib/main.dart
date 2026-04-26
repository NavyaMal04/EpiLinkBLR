import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'db/local_database.dart';
import 'services/sync_service.dart';
import 'services/auth_service.dart';
import 'services/classifier_service.dart';
import 'services/location_service.dart';
import 'utils/permission_handler.dart';
import 'utils/firebase_proxy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  bool isMobile = !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  if (isMobile) {
    debugPrint('📱 Mobile platform detected. Using LIVE Firebase SDK.');
  } else {
    debugPrint('🚀 Running in Compatibility Mode (Windows/Web)');
  }
  
  // Initialize Firebase (Dynamic: Real on Mobile, Mock on Windows/Web)
  await FirebaseInterface.initializeApp();
  
  final db = AppDatabase();
  final syncService = SyncService(db);
  final authService = AuthService();
  final classifierService = ClassifierService();
  await classifierService.initialize();
  final locationService = LocationService();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: db),
        ChangeNotifierProvider<SyncService>.value(value: syncService),
        ChangeNotifierProvider<AuthService>.value(value: authService),
        Provider<ClassifierService>.value(value: classifierService),
        Provider<LocationService>.value(value: locationService),
      ],
      child: const EpiLinkApp(),
    ),
  );
}
