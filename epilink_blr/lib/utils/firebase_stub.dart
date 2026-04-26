import 'package:flutter/foundation.dart';
import 'dart:io';

class FirebaseInterface {
  static Future<void> initializeApp() async {
    // Stub
  }
}

class FirestoreInterface {
  static FirestoreInterface get instance => FirestoreInterface();
  
  void setSettings(bool persistence) {}
  
  CollectionInterface collection(String path) => CollectionInterface(path);
}

class CollectionInterface {
  final String path;
  CollectionInterface(this.path);
  DocumentInterface doc(String id) => DocumentInterface(id);
  Future<void> add(Map<String, dynamic> data) async {
    debugPrint('🛠️ Firebase Stub: Data added to $path');
  }
}

class DocumentInterface {
  final String id;
  DocumentInterface(this.id);
  Future<void> set(Map<String, dynamic> data) async {
    debugPrint('🛠️ Firebase Stub: Data set for $id');
  }
}
