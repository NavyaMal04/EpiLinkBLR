import 'package:flutter/material.dart';

/// A mock class to bypass Firebase on platforms where it's not supported (e.g., Windows with VS 2019)
class FirebaseMock {
  static Future<void> initializeApp() async {
    debugPrint('🛠️ Firebase Mock: Initialized (Compatibility Mode)');
  }
}

class FirebaseAuthMock {
  static FirebaseAuthMock get instance => FirebaseAuthMock();
  Future<void> signInAnonymously() async {
    debugPrint('🛠️ Firebase Auth Mock: Signed in anonymously');
  }
}

class FirebaseFirestoreMock {
  static FirebaseFirestoreMock get instance => FirebaseFirestoreMock();
  
  FirebaseFirestoreSettings settings = const FirebaseFirestoreSettings();

  CollectionReferenceMock collection(String path) => CollectionReferenceMock(path);
}

class FirebaseFirestoreSettings {
  final bool persistenceEnabled;
  const FirebaseFirestoreSettings({this.persistenceEnabled = true});
}

class CollectionReferenceMock {
  final String path;
  CollectionReferenceMock(this.path);

  DocumentReferenceMock doc(String id) => DocumentReferenceMock(id);
}

class DocumentReferenceMock {
  final String id;
  DocumentReferenceMock(this.id);

  Future<void> set(Map<String, dynamic> data) async {
    debugPrint('🛠️ Firestore Mock: Data set for $id');
  }
}
