import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../db/local_database.dart';
import '../../services/location_service.dart';
import '../../services/sync_service.dart';
import '../../services/classifier_service.dart';
import '../../widgets/location_picker_widget.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_label.dart';
import '../../widgets/icon_container.dart';
import '../../widgets/risk_badge.dart';

class SymptomLoggerScreen extends StatefulWidget {
  const SymptomLoggerScreen({super.key});

  @override
  State<SymptomLoggerScreen> createState() => _SymptomLoggerScreenState();
}

class _SymptomLoggerScreenState extends State<SymptomLoggerScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  
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

    setState(() => _isSubmitting = true);
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
      chwId: const drift.Value('CHW-999'), // Default ID for demo
      synced: const drift.Value(0),
    ));

    await syncService.refresh();
    syncService.syncAll(); 

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report saved and syncing...')),
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
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(AppSpacing.pageH),
                children: [
                  const SectionLabel(text: 'Section 1 — Patient Info'),
                  DropdownButtonFormField<String>(
                    value: _selectedWardName,
                    decoration: const InputDecoration(labelText: 'Ward Name'),
                    items: [
                      'Yelahanka', 'KR Puram', 'Whitefield', 'Hebbal', 'Bommanahalli',
                      'Koramangala', 'HSR Layout', 'Bellandur', 'Mahadevapura', 'Rajajinagar'
                    ].map((w) => DropdownMenuItem(value: w, child: Text(w))).toList(),
                    onChanged: (val) => setState(() => _selectedWardName = val),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(labelText: 'Patient Age'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Text('Sex', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'Male', label: Text('Male')),
                      ButtonSegment(value: 'Female', label: Text('Female')),
                      ButtonSegment(value: 'Other', label: Text('Other')),
                    ],
                    selected: {_sex},
                    onSelectionChanged: (val) => setState(() => _sex = val.first),
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: AppColors.primaryLight,
                      selectedForegroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.border),
                    ),
                  ),

                  const SectionLabel(text: 'Section 2 — Symptoms'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _symptomsOptions.map((s) {
                      final isSelected = _selectedSymptoms.contains(s);
                      return FilterChip(
                        label: Text(s, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500)),
                        selected: isSelected,
                        onSelected: (val) {
                          setState(() {
                            val ? _selectedSymptoms.add(s) : _selectedSymptoms.remove(s);
                            _updateSuspectedDisease();
                          });
                        },
                        selectedColor: AppColors.primaryLight,
                        checkmarkColor: AppColors.primary,
                        side: BorderSide(color: isSelected ? AppColors.primaryMid : AppColors.border),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.pill)),
                        backgroundColor: AppColors.surface,
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      );
                    }).toList(),
                  ),
                  
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _suspectedDisease == 'None' || _suspectedDisease == 'General Viral' 
                      ? const SizedBox.shrink()
                      : Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.criticalBg,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                            border: Border.all(color: const Color(0xFFFECACA)),
                          ),
                          child: Row(
                            children: [
                              Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.critical, shape: BoxShape.circle)),
                              const SizedBox(width: 12),
                              Text(
                                'AI Suggestion: $_suspectedDisease suspected',
                                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.critical),
                              ),
                            ],
                          ),
                        ),
                  ),

                  const SectionLabel(text: 'Section 3 — mRDT Test'),
                  GestureDetector(
                    onTap: () async {
                      final result = await context.push<MRDTResult>('/chw/mrdt-scanner');
                      if (result != null) {
                        setState(() => _mrdtResult = result);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _mrdtResult != null ? (_mrdtResult!.isPositive ? AppColors.criticalBg : AppColors.lowBg) : AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: _mrdtResult != null ? (_mrdtResult!.isPositive ? AppColors.critical : AppColors.low) : AppColors.primaryMid,
                          style: BorderStyle.solid,
                          width: 1.5,
                        ),
                      ),
                      child: _mrdtResult == null 
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.document_scanner_rounded, color: AppColors.primary, size: 32),
                              const SizedBox(height: 8),
                              Text('Tap to scan test strip', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.primary)),
                              Text('AI-powered results in seconds', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11)),
                            ],
                          )
                        : Row(
                            children: [
                              Icon(
                                _mrdtResult!.isPositive ? Icons.warning_rounded : Icons.check_circle_rounded,
                                color: _mrdtResult!.isPositive ? AppColors.critical : AppColors.low,
                                size: 32,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _mrdtResult!.label.toUpperCase(),
                                      style: TextStyle(
                                        color: _mrdtResult!.isPositive ? AppColors.critical : AppColors.low,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text('Confidence: ${(_mrdtResult!.confidence * 100).toStringAsFixed(1)}%', style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                              const RiskBadge(level: 'low', overrideText: 'VERIFIED'),
                            ],
                          ),
                    ),
                  ),

                  const SectionLabel(text: 'Section 4 — Location'),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        IconContainer(
                          icon: Icons.location_on_rounded,
                          color: AppColors.low,
                          bgColor: AppColors.lowBg,
                          size: 36,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_location?.wardName ?? 'Detecting...', style: Theme.of(context).textTheme.titleMedium),
                              Text(
                                _location?.source == 'gps' ? 'GPS · Accurate' : 'Manual Entry',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final result = await Navigator.push(context, MaterialPageRoute(builder: (c) => const LocationPickerWidget()));
                            if (result is LocationResult) {
                              setState(() {
                                _location = result;
                                _selectedWardName = result.wardName;
                                _selectedWardId = result.wardId;
                              });
                            }
                          },
                          child: const Text('Change', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  PrimaryButton(
                    label: 'Submit Patient Report',
                    isLoading: _isSubmitting,
                    onPressed: _submit,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          _stepItem(1, 'Patient', isCompleted: true),
          _stepDivider(),
          _stepItem(2, 'Symptoms', isActive: true),
          _stepDivider(),
          _stepItem(3, 'Review'),
        ],
      ),
    );
  }

  Widget _stepItem(int num, String label, {bool isActive = false, bool isCompleted = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isCompleted ? AppColors.low : (isActive ? AppColors.primary : AppColors.borderLight),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isCompleted 
              ? const Icon(Icons.check, color: Colors.white, size: 14)
              : Text('$num', style: TextStyle(color: isActive ? Colors.white : AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: isActive || isCompleted ? AppColors.textPrimary : AppColors.textMuted, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
      ],
    );
  }

  Widget _stepDivider() {
    return Expanded(
      child: Container(
        height: 1,
        margin: const EdgeInsets.symmetric(horizontal: 8).copyWith(bottom: 14),
        color: AppColors.borderLight,
      ),
    );
  }
}
