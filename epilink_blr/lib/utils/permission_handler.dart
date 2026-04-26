import 'package:permission_handler/permission_handler.dart';

class AppPermissions {
  static Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestLocation() async {
    final status = await Permission.location.request();
    return status == PermissionStatus.granted;
  }

  static Future<bool> requestStorage() async {
    final photos = await Permission.photos.request();
    final storage = await Permission.storage.request();
    return photos.isGranted || storage.isGranted;
  }

  static Future<void> requestAll() async {
    await [
      Permission.camera,
      Permission.location,
      Permission.photos,
      Permission.storage,
    ].request();
  }
}
