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
          'chwId': report.chwId,
        });

        // Task 1 — Wire email alert to symptom submission
        debugPrint('🔍 Checking sync report: ${report.id}, result: ${report.testResult}');
        if (report.testResult?.toLowerCase() == 'positive') {
          debugPrint('🚨 Positive case detected! Attempting to queue email alert...');
          try {
            final firestore = FirestoreInterface.instance;
            await firestore.collection('mail').add({
              'to': ['bbmp.healthalerts.mock@gmail.com'],
              'message': {
                'subject': '⚠️ EpiLink Alert: Positive ${report.diseaseSuspected} case in ${report.wardName}',
                'html': '''
                  <div style="font-family: Arial, sans-serif; max-width: 600px;">
                    <div style="background: #185FA5; padding: 24px; border-radius: 8px 8px 0 0;">
                      <h1 style="color: white; margin: 0; font-size: 20px;">
                        EpiLink BLR — Positive Case Alert
                      </h1>
                    </div>
                    <div style="background: #FEF2F2; border: 1px solid #FECACA;
                                border-radius: 0 0 8px 8px; padding: 24px;">
                      <h2 style="color: #991B1B; margin-top: 0;">
                        ${report.diseaseSuspected} confirmed in ${report.wardName}
                      </h2>
                      <table style="width: 100%; border-collapse: collapse;">
                        <tr>
                          <td style="padding: 8px 0; color: #64748B;">Ward</td>
                          <td style="padding: 8px 0; font-weight: bold;">${report.wardName}</td>
                        </tr>
                        <tr>
                          <td style="padding: 8px 0; color: #64748B;">Disease Suspected</td>
                          <td style="padding: 8px 0; color: #DC2626; font-weight: bold;">
                            ${report.diseaseSuspected}
                          </td>
                        </tr>
                        <tr>
                          <td style="padding: 8px 0; color: #64748B;">Test Result</td>
                          <td style="padding: 8px 0; font-weight: bold;">Positive</td>
                        </tr>
                        <tr>
                          <td style="padding: 8px 0; color: #64748B;">Location</td>
                          <td style="padding: 8px 0;">${report.wardName} Ward, Bengaluru</td>
                        </tr>
                        <tr>
                          <td style="padding: 8px 0; color: #64748B;">Filed by</td>
                          <td style="padding: 8px 0;">Community Health Worker · ${report.chwId}</td>
                        </tr>
                      </table>
                      <div style="margin-top: 20px; padding: 16px; background: white;
                                  border-radius: 8px; border-left: 4px solid #DC2626;">
                        <strong>Recommended Action:</strong> Deploy fogging units to
                        ${report.wardName} immediately. Stage medication at local PHC.
                        Increase CHW survey frequency in surrounding wards.
                      </div>
                      <p style="color: #94A3B8; font-size: 12px; margin-top: 20px;">
                        This alert was generated automatically by EpiLink BLR
                        disease surveillance system.
                      </p>
                    </div>
                  </div>
                ''',
              },
            });
            debugPrint('✅ Email alert queued for ${report.wardName} — ${report.diseaseSuspected}');
          } catch (e) {
            debugPrint('⚠️ Email alert failed (non-critical): $e');
          }
        }
        
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
