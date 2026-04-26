export 'firebase_stub.dart'
  if (dart.library.io) 'firebase_real.dart'
  if (dart.library.html) 'firebase_stub.dart';
