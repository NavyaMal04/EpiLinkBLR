import 'package:geolocator/geolocator.dart';

class LocationResult {
  final double? lat;
  final double? lng;
  final String source; // gps, places_api, manual
  final String? placesApiName;
  final String? wardId;
  final String? wardName;

  LocationResult({
    this.lat,
    this.lng,
    required this.source,
    this.placesApiName,
    this.wardId,
    this.wardName,
  });
}

class LocationService {
  Future<LocationResult?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return LocationResult(source: 'places_api');

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return LocationResult(source: 'places_api');
    }

    if (permission == LocationPermission.deniedForever) return LocationResult(source: 'places_api');

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      if (position.accuracy > 100) {
        return LocationResult(source: 'places_api');
      }

      final wardInfo = inferWardFromCoordinates(position.latitude, position.longitude);
      
      return LocationResult(
        lat: position.latitude,
        lng: position.longitude,
        source: 'gps',
        wardId: wardInfo['id'],
        wardName: wardInfo['name'],
      );
    } catch (e) {
      return LocationResult(source: 'places_api');
    }
  }

  Map<String, String> inferWardFromCoordinates(double lat, double lng) {
    // Rough bounding boxes for Bengaluru wards
    if (lat > 13.05 && lng < 77.60) return {'id': 'ward_001', 'name': 'Yelahanka'};
    if (lat > 13.00 && lng > 77.68) return {'id': 'ward_002', 'name': 'KR Puram'};
    if (lat > 12.95 && lat < 13.00 && lng > 77.70) return {'id': 'ward_003', 'name': 'Whitefield'};
    if (lat > 13.02 && lat < 13.05 && lng > 77.58 && lng < 77.62) return {'id': 'ward_004', 'name': 'Hebbal'};
    if (lat < 12.91 && lng > 77.60 && lng < 77.65) return {'id': 'ward_005', 'name': 'Bommanahalli'};
    if (lat > 12.92 && lat < 12.94 && lng > 77.61 && lng < 77.64) return {'id': 'ward_006', 'name': 'Koramangala'};
    if (lat > 12.90 && lat < 12.92 && lng > 77.63 && lng < 77.66) return {'id': 'ward_007', 'name': 'HSR Layout'};
    if (lat > 12.92 && lat < 12.95 && lng > 77.65 && lng < 77.69) return {'id': 'ward_008', 'name': 'Bellandur'};
    if (lat > 12.98 && lat < 13.02 && lng > 77.65 && lng < 77.70) return {'id': 'ward_009', 'name': 'Mahadevapura'};
    if (lat > 12.98 && lat < 13.01 && lng > 77.53 && lng < 77.56) return {'id': 'ward_010', 'name': 'Rajajinagar'};

    // Default or Fallback
    return {'id': 'ward_unknown', 'name': 'Outside Wards'};
  }
}
