import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseInterface {
  static Future<void> initializeApp() async {
    await Firebase.initializeApp();
  }
}

class FirestoreInterface {
  static FirestoreInterface get instance => FirestoreInterface();
  
  void setSettings(bool persistence) {
    FirebaseFirestore.instance.settings = Settings(persistenceEnabled: persistence);
  }
  
  CollectionReference collection(String path) => FirebaseFirestore.instance.collection(path);
}
