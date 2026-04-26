import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import 'package:go_router/go_router.dart';
import '../../db/local_database.dart';
import '../../services/sync_service.dart';
import '../../widgets/location_picker_widget.dart';
import '../../services/location_service.dart';

class HazardReporterScreen extends StatefulWidget {
  const HazardReporterScreen({super.key});

  @override
  State<HazardReporterScreen> createState() => _HazardReporterScreenState();
}

class _HazardReporterScreenState extends State<HazardReporterScreen> {
  String _selectedHazard = 'Stagnant Water';
  File? _photoFile;
  LocationResult? _location;
  final TextEditingController _descController = TextEditingController();

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (photo != null) {
      setState(() {
        _photoFile = File(photo.path);
      });
    }
  }

  Future<void> _submit() async {
    final db = context.read<AppDatabase>();
    final syncService = context.read<SyncService>();

    final id = const Uuid().v4();
    
    await db.insertCivicHazard(CivicHazardsTableCompanion(
      id: drift.Value(id),
      wardId: drift.Value(_location?.wardId),
      wardName: drift.Value(_location?.wardName),
      timestamp: drift.Value(DateTime.now().millisecondsSinceEpoch),
      hazardType: drift.Value(_selectedHazard),
      lat: drift.Value(_location?.lat),
      lng: drift.Value(_location?.lng),
      photoPath: drift.Value(_photoFile?.path),
      reporterType: const drift.Value('citizen'),
      locationSource: drift.Value(_location?.source),
      placesApiName: drift.Value(_location?.placesApiName),
      synced: const drift.Value(0),
    ));

    await syncService.refresh();
    syncService.syncAll(); 

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hazard report submitted!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Hazard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('What kind of hazard?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                _HazardTypeBtn(
                  label: 'Stagnant Water',
                  icon: Icons.water_drop_rounded,
                  isSelected: _selectedHazard == 'Stagnant Water',
                  onTap: () => setState(() => _selectedHazard = 'Stagnant Water'),
                ),
                _HazardTypeBtn(
                  label: 'Open Drain',
                  icon: Icons.waves_rounded,
                  isSelected: _selectedHazard == 'Open Drain',
                  onTap: () => setState(() => _selectedHazard = 'Open Drain'),
                ),
                _HazardTypeBtn(
                  label: 'Garbage Dump',
                  icon: Icons.delete_rounded,
                  isSelected: _selectedHazard == 'Garbage Dump',
                  onTap: () => setState(() => _selectedHazard = 'Garbage Dump'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Add Photo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            if (_photoFile != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    _photoFile!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            InkWell(
              onTap: _pickPhoto,
              child: Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200, style: BorderStyle.solid),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_rounded, size: 32, color: Colors.orange.shade700),
                    const SizedBox(height: 8),
                    Text(_photoFile == null ? 'Take Photo' : 'Retake Photo', 
                      style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Location', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey.shade200)),
              child: ListTile(
                leading: const Icon(Icons.location_on_outlined, color: Colors.blue),
                title: Text(_location?.wardName ?? 'Select ward location'),
                subtitle: Text(_location?.placesApiName ?? 'Required for reporting'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (c) => const LocationPickerWidget()));
                  if (result is LocationResult) {
                    setState(() => _location = result);
                  }
                },
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: 'Description (Optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: 'e.g., Large pool of water near the park gate',
              ),
              maxLength: 200,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _submit,
                child: const Text('Submit Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HazardTypeBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _HazardTypeBtn({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.orange : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSelected ? Colors.orange : Colors.grey.shade300),
                ),
                child: Icon(icon, color: isSelected ? Colors.white : Colors.grey),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
