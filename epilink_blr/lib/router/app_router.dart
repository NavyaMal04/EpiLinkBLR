import 'package:go_router/go_router.dart';
import '../screens/role_select_screen.dart';
import '../screens/chw/chw_home_screen.dart';
import '../screens/chw/symptom_logger_screen.dart';
import '../screens/chw/mrdt_scanner_screen.dart';
import '../screens/chw/risk_map_screen.dart';
import '../screens/chw/sync_status_screen.dart';
import '../screens/shared/settings_screen.dart';
import '../screens/citizen/citizen_home_screen.dart';
import '../screens/citizen/hazard_reporter_screen.dart';
import '../screens/citizen/health_tips_screen.dart';
import '../screens/citizen/current_risk_level_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/role-select',
  routes: [
    GoRoute(path: '/role-select', builder: (_, __) => const RoleSelectScreen()),
    GoRoute(path: '/chw/home', builder: (_, __) => const CHWHomeScreen()),
    GoRoute(path: '/chw/symptom-log', builder: (_, __) => const SymptomLoggerScreen()),
    GoRoute(path: '/chw/mrdt-scanner', builder: (_, __) => const MRDTScannerScreen()),
    GoRoute(path: '/chw/risk-map', builder: (_, __) => const RiskMapScreen()),
    GoRoute(path: '/chw/sync-status', builder: (_, __) => const SyncStatusScreen()),
    GoRoute(path: '/chw/settings', builder: (_, __) => const SettingsScreen()),
    GoRoute(path: '/citizen/home', builder: (_, __) => const CitizenHomeScreen()),
    GoRoute(path: '/citizen/hazard-report', builder: (_, __) => const HazardReporterScreen()),
    GoRoute(path: '/citizen/health-tips', builder: (_, __) => const HealthTipsScreen()),
    GoRoute(path: '/citizen/risk-level', builder: (_, __) => const CurrentRiskLevelScreen()),
  ],
);
