import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart' as drift;
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../db/local_database.dart';
import '../../services/sync_service.dart';
import '../../widgets/location_picker_widget.dart';
import '../../services/location_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/section_label.dart';
import '../../widgets/icon_container.dart';
import '../../widgets/animated_card.dart';

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
  bool _isSubmitting = false;

  Future<void> _pickPhoto() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.camera_alt_rounded),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_rounded),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 12),
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
    setState(() => _isSubmitting = true);
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
      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.pageH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionLabel(text: 'What kind of hazard?'),
                  Row(
                    children: [
                      _buildHazardCard(
                        'Stagnant Water',
                        Icons.water_drop_rounded,
                        const Color(0xFF0EA5E9),
                      ),
                      const SizedBox(width: 8),
                      _buildHazardCard(
                        'Open Drain',
                        Icons.flood_rounded,
                        AppColors.medium,
                      ),
                      const SizedBox(width: 8),
                      _buildHazardCard(
                        'Garbage Dump',
                        Icons.delete_rounded,
                        AppColors.high,
                      ),
                    ],
                  ),
                  
                  const SectionLabel(text: 'Capture Evidence'),
                  GestureDetector(
                    onTap: _pickPhoto,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 160,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: AppColors.border,
                          width: 1.5,
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: _photoFile == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const IconContainer(
                                icon: Icons.add_a_photo_rounded,
                                color: AppColors.primary,
                                bgColor: AppColors.primaryLight,
                                size: 48,
                              ),
                              const SizedBox(height: 12),
                              Text('Tap to take photo', style: Theme.of(context).textTheme.titleMedium),
                              Text('or choose from gallery', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11)),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                            child: Image.file(_photoFile!, fit: BoxFit.cover, width: double.infinity),
                          ),
                    ),
                  ),

                  const SectionLabel(text: 'Location Detail'),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const IconContainer(
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
                              Text(_location?.wardName ?? 'Detecting Location...', style: Theme.of(context).textTheme.titleMedium),
                              Text(
                                _location?.placesApiName ?? 'Required for reporting',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final result = await Navigator.push(context, MaterialPageRoute(builder: (c) => const LocationPickerWidget()));
                            if (result is LocationResult) {
                              setState(() => _location = result);
                            }
                          },
                          child: const Text('Change', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  TextField(
                    controller: _descController,
                    style: const TextStyle(fontSize: 13),
                    decoration: const InputDecoration(
                      labelText: 'Description (Optional)',
                      hintText: 'e.g., Large pool of water near the gate',
                    ),
                    maxLength: 200,
                    maxLines: 3,
                  ),
                  
                  const SizedBox(height: 32),
                  PrimaryButton(
                    label: 'Submit Hazard Report',
                    color: AppColors.high,
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

  Widget _buildHazardCard(String type, IconData icon, Color color) {
    final bool isSelected = _selectedHazard == type;
    return Expanded(
      child: AnimatedCard(
        onTap: () => setState(() => _selectedHazard = type),
        backgroundColor: isSelected ? color.withOpacity(0.08) : AppColors.surface,
        border: Border.all(color: isSelected ? color : AppColors.border, width: isSelected ? 1.5 : 1),
        padding: const EdgeInsets.symmetric(vertical: 16),
        radius: AppRadius.md,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : AppColors.textMuted, size: 32),
            const SizedBox(height: 8),
            Text(
              type.split(' ').join('\n'),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : AppColors.textSecondary,
                height: 1.1,
              ),
            ),
          ],
        ),
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
          _stepItem(1, 'Report', isActive: true),
          _stepDivider(),
          _stepItem(2, 'Review'),
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
