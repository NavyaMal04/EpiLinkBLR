import 'package:flutter/material.dart';
import '../db/local_database.dart';
import '../utils/firebase_proxy.dart';

class SyncService with ChangeNotifier {
  final AppDatabase db;
  
  SyncService(this.db) {
    _updatePendingCount();
  }
  
  final ValueNotifier<int> pendingCount = ValueNotifier<int>(0);

  Future<void> _updatePendingCount() async {
    final unsynced = await db.getUnsyncedSymptomReports();
    final hazards = await db.getUnsyncedCivicHazards();
    pendingCount.value = unsynced.length + hazards.length;
    notifyListeners();
  }
  
  Future<void> refresh() async {
    await _updatePendingCount();
  }
  
  Future<void> syncAll() async {
    await _updatePendingCount(); // Update count first so UI shows pending
    await syncSymptomReports();
    await syncCivicHazards();
    await _updatePendingCount(); // Update again to show remaining
  }

  Future<void> syncSymptomReports() async {
    final unsynced = await db.getUnsyncedSymptomReports();
    
    for (var report in unsynced) {
      try {
        // Use FirestoreInterface (Real on Mobile, Mock on Windows)
        await FirestoreInterface.instance.collection('symptom_reports').doc(report.id).set({
          'wardId': report.wardId,
          'wardName': report.wardName,
          'timestamp': report.timestamp,
          'symptoms': report.symptoms,
          'testResult': report.testResult,
          'testConfidence': report.testConfidence,
          'diseaseSuspected': report.diseaseSuspected,
          'lat': report.lat,
          'lng': report.lng,
          'locationSource': report.locationSource,
          'placesApiName': report.placesApiName,
        });
        
        await db.markSymptomReportSynced(report.id);
            
        debugPrint('✅ Synced ${report.id} to Firestore collection: symptom_reports');
      } catch (e) {
        debugPrint('❌ Failed to sync ${report.id}: $e');
      }
    }
  }

  Future<void> syncCivicHazards() async {
    final unsynced = await db.getUnsyncedCivicHazards();
    
    for (var hazard in unsynced) {
      try {
        // Use FirestoreInterface
        await FirestoreInterface.instance.collection('civic_hazards').doc(hazard.id).set({
          'hazardType': hazard.hazardType,
          'wardId': hazard.wardId,
          'wardName': hazard.wardName,
          'timestamp': hazard.timestamp,
          'lat': hazard.lat,
          'lng': hazard.lng,
          'photoPath': hazard.photoPath,
          'reporterType': hazard.reporterType,
          'locationSource': hazard.locationSource,
          'placesApiName': hazard.placesApiName,
        });
        
        await db.markCivicHazardSynced(hazard.id);
            
        debugPrint('✅ Synced hazard ${hazard.id} to Firestore collection: civic_hazards');
      } catch (e) {
        debugPrint('❌ Failed to sync hazard ${hazard.id}: $e');
      }
    }
  }
}
