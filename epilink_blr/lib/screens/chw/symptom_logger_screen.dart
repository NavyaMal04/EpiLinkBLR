import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import 'package:go_router/go_router.dart';
import '../../db/local_database.dart';
import '../../services/location_service.dart';
import '../../services/sync_service.dart';
import '../../services/classifier_service.dart';
import '../../widgets/location_picker_widget.dart';

class SymptomLoggerScreen extends StatefulWidget {
  const SymptomLoggerScreen({super.key});

  @override
  State<SymptomLoggerScreen> createState() => _SymptomLoggerScreenState();
}

class _SymptomLoggerScreenState extends State<SymptomLoggerScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Form State
  String? _selectedWardId;
  String? _selectedWardName;
  final TextEditingController _ageController = TextEditingController();
  String _sex = 'Male';
  final List<String> _selectedSymptoms = [];
  String _suspectedDisease = 'None';
  MRDTResult? _mrdtResult;
  LocationResult? _location;

  final List<String> _symptomsOptions = [
    'Fever', 'Headache', 'Body ache', 'Chills', 
    'Vomiting', 'Rash', 'Joint pain', 'Fatigue'
  ];

  @override
  void initState() {
    super.initState();
    _fetchInitialLocation();
  }

  Future<void> _fetchInitialLocation() async {
    final locService = context.read<LocationService>();
    final result = await locService.getCurrentLocation();
    if (result != null) {
      setState(() {
        _location = result;
        _selectedWardId = result.wardId;
        _selectedWardName = result.wardName;
      });
    }
  }

  void _updateSuspectedDisease() {
    setState(() {
      final s = _selectedSymptoms.map((e) => e.toLowerCase()).toList();
      if (s.contains('fever') && s.contains('chills') && s.contains('headache')) {
        _suspectedDisease = 'Malaria';
      } else if (s.contains('fever') && s.contains('rash') && s.contains('joint pain')) {
        _suspectedDisease = 'Dengue';
      } else if (s.contains('fever') && s.contains('vomiting')) {
        _suspectedDisease = 'Leptospirosis';
      } else {
        _suspectedDisease = 'General Viral';
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final db = context.read<AppDatabase>();
    final syncService = context.read<SyncService>();

    final id = const Uuid().v4();
    
    await db.insertSymptomReport(SymptomReportsTableCompanion(
      id: drift.Value(id),
      wardId: drift.Value(_selectedWardId),
      wardName: drift.Value(_selectedWardName),
      timestamp: drift.Value(DateTime.now().millisecondsSinceEpoch),
      symptoms: drift.Value(_selectedSymptoms.join(', ')),
      testResult: drift.Value(_mrdtResult?.label),
      testConfidence: drift.Value(_mrdtResult?.confidence),
      diseaseSuspected: drift.Value(_suspectedDisease),
      lat: drift.Value(_location?.lat),
      lng: drift.Value(_location?.lng),
      locationSource: drift.Value(_location?.source),
      placesApiName: drift.Value(_location?.placesApiName),
      synced: const drift.Value(0),
    ));

    await syncService.refresh();
    syncService.syncAll(); 

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report saved to local database for syncing.')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Symptoms'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('Section 1 — Patient Info'),
            DropdownButtonFormField<String>(
              value: _selectedWardName,
              decoration: const InputDecoration(labelText: 'Ward Name'),
              items: [
                'Yelahanka', 'KR Puram', 'Whitefield', 'Hebbal', 'Bommanahalli',
                'Koramangala', 'HSR Layout', 'Bellandur', 'Mahadevapura', 'Rajajinagar'
              ].map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
              onChanged: (val) => setState(() => _selectedWardName = val),
            ),
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Patient Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text('Sex', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Male', label: Text('Male')),
                ButtonSegment(value: 'Female', label: Text('Female')),
                ButtonSegment(value: 'Other', label: Text('Other')),
              ],
              selected: {_sex},
              onSelectionChanged: (val) => setState(() => _sex = val.first),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Section 2 — Symptoms'),
            Wrap(
              spacing: 8,
              children: _symptomsOptions.map((s) {
                final isSelected = _selectedSymptoms.contains(s);
                return FilterChip(
                  label: Text(s),
                  selected: isSelected,
                  onSelected: (val) {
                    setState(() {
                      val ? _selectedSymptoms.add(s) : _selectedSymptoms.remove(s);
                      _updateSuspectedDisease();
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: Row(
                children: [
                  const Icon(Icons.psychology_alt_rounded, color: Colors.blue),
                  const SizedBox(width: 12),
                  Text('Suspected Disease: ', style: TextStyle(color: Colors.blue.shade900)),
                  Text(_suspectedDisease, style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const SizedBox(height: 24),
            _buildSectionHeader('Section 3 — mRDT Test'),
            ElevatedButton.icon(
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Scan Test Strip'),
              onPressed: () async {
                final result = await context.push<MRDTResult>('/chw/mrdt-scanner');
                if (result != null) {
                  setState(() => _mrdtResult = result);
                }
              },
            ),
            if (_mrdtResult != null) ...[
              const SizedBox(height: 12),
              Card(
                color: _mrdtResult!.isPositive ? Colors.red.shade50 : Colors.green.shade50,
                child: ListTile(
                  leading: Icon(
                    _mrdtResult!.isPositive ? Icons.warning_rounded : Icons.check_circle_rounded,
                    color: _mrdtResult!.isPositive ? Colors.red : Colors.green,
                  ),
                  title: Text(
                    'Result: ${_mrdtResult!.label.toUpperCase()}',
                    style: TextStyle(
                      color: _mrdtResult!.isPositive ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text('Confidence: ${(_mrdtResult!.confidence * 100).toStringAsFixed(1)}%'),
                ),
              ),
              if (_mrdtResult!.confidence < 0.6)
                const Padding(
                  padding: EdgeInsets.only(top: 8, left: 8),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Low confidence — consider manual verification', style: TextStyle(color: Colors.orange, fontSize: 12)),
                    ],
                  ),
                ),
            ],

            const SizedBox(height: 24),
            _buildSectionHeader('Section 4 — Location'),
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey.shade200)),
              child: ListTile(
                leading: const Icon(Icons.location_on_rounded, color: Colors.blue),
                title: Text(_location?.wardName ?? 'Location not set'),
                subtitle: Text('Source: ${_location?.source ?? "Scanning..."}'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (c) => const LocationPickerWidget()));
                  if (result is LocationResult) {
                    setState(() {
                      _location = result;
                      _selectedWardName = result.wardName;
                      _selectedWardId = result.wardId;
                    });
                  }
                },
              ),
            ),

            const SizedBox(height: 40),
            SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _submit,
                child: const Text('Submit Patient Report', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
    );
  }
}
