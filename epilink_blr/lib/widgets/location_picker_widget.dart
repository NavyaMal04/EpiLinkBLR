import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import '../services/location_service.dart';

class LocationPickerWidget extends StatefulWidget {
  const LocationPickerWidget({super.key});

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  LatLng _selectedPos = const LatLng(12.9716, 77.5946); // Bangalore center
  String? _placeName;
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _handlePlaceSelected(Prediction prediction) async {
    if (prediction.description != null) {
      try {
        List<Location> locations = await locationFromAddress(prediction.description!);
        if (locations.isNotEmpty) {
          setState(() {
            _selectedPos = LatLng(locations.first.latitude, locations.first.longitude);
            _placeName = prediction.description;
            _mapController?.animateCamera(CameraUpdate.newLatLng(_selectedPos));
          });
        }
      } catch (e) {
        debugPrint('Geocoding error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationService = context.read<LocationService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Select Location')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: _searchController,
                googleAPIKey: const String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: 'YOUR_KEY_HERE'),
                inputDecoration: const InputDecoration(
                  hintText: "Search for a landmark, area, or building",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                debounceTime: 800,
                countries: const ["in"], // Limit to India
                itemClick: (prediction) => _handlePlaceSelected(prediction),
                getPlaceDetailWithLatLng: (prediction) => _handlePlaceSelected(prediction),
              ),
            ),
            SizedBox(
              height: 200,
              width: double.infinity,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(target: _selectedPos, zoom: 14),
                onMapCreated: (controller) => _mapController = controller,
                markers: {
                  Marker(markerId: const MarkerId('selected'), position: _selectedPos),
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('Use this location'),
              onPressed: () {
                final wardInfo = locationService.inferWardFromCoordinates(_selectedPos.latitude, _selectedPos.longitude);
                Navigator.pop(context, LocationResult(
                  lat: _selectedPos.latitude,
                  lng: _selectedPos.longitude,
                  source: 'places_api',
                  placesApiName: _placeName,
                  wardId: wardInfo['id'],
                  wardName: wardInfo['name'],
                ));
              },
            ),
            const Divider(height: 40),
            const Text('Enter manually if no connectivity'),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Row(
                children: [
                  Expanded(child: TextField(decoration: InputDecoration(labelText: 'Lat'), keyboardType: TextInputType.number)),
                  SizedBox(width: 10),
                  Expanded(child: TextField(decoration: InputDecoration(labelText: 'Lng'), keyboardType: TextInputType.number)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
