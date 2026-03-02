import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/turf_repository.dart';
import '../../core/models/turf_model.dart';

class ManageTurfsScreen extends StatefulWidget {
  const ManageTurfsScreen({super.key});

  @override
  State<ManageTurfsScreen> createState() => _ManageTurfsScreenState();
}

class _ManageTurfsScreenState extends State<ManageTurfsScreen> {
  final _repository = TurfRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        title: Text('Manage Turfs', style: GoogleFonts.plusJakartaSans(color: AppColors.textWhite)),
        backgroundColor: AppColors.surfaceBlack,
        iconTheme: const IconThemeData(color: AppColors.textWhite),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTurfDialog,
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(LucideIcons.plus, color: Colors.black),
      ),
      body: AnimatedBuilder(
        animation: _repository,
        builder: (context, child) {
          if (_repository.turfs.isEmpty) {
            return Center(
              child: Text(
                'No turfs added yet.',
                style: GoogleFonts.inter(color: AppColors.textGray),
              ),
            );
          }
          
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _repository.turfs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final turf = _repository.turfs[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceBlack,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderGlass),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.tent, color: AppColors.primaryGreen, size: 20),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            turf.name,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            turf.location,
                            style: GoogleFonts.inter(
                              color: AppColors.textGray,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.trash2, color: AppColors.red, size: 20),
                      onPressed: () => _confirmDelete(turf),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddTurfDialog() {
    final nameController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundBlack.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderGlass),
        ),
        title: Text('Add New Turf', style: GoogleFonts.plusJakartaSans(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: AppColors.textWhite),
              decoration: const InputDecoration(
                labelText: 'Turf Name',
                labelStyle: TextStyle(color: AppColors.textGray),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textGray)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryGreen)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              style: const TextStyle(color: AppColors.textWhite),
              decoration: const InputDecoration(
                labelText: 'Location',
                labelStyle: TextStyle(color: AppColors.textGray),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.textGray)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primaryGreen)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.textGray)),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && locationController.text.isNotEmpty) {
                _repository.addTurf(
                  TurfModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    location: locationController.text,
                    revenue: '₹0', // Initial revenue
                  ),
                );
                Navigator.pop(context);
              }
            },
            child: Text('Add', style: GoogleFonts.inter(color: AppColors.primaryGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(TurfModel turf) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundBlack.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderGlass),
        ),
        title: Text('Delete Turf', style: GoogleFonts.plusJakartaSans(color: AppColors.textWhite, fontWeight: FontWeight.w600)),
        content: Text(
          'Are you sure you want to delete "${turf.name}"?',
          style: GoogleFonts.inter(color: AppColors.textGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.textGray)),
          ),
          TextButton(
            onPressed: () {
              _repository.removeTurf(turf.id);
              Navigator.pop(context);
            },
            child: Text('Delete', style: GoogleFonts.inter(color: AppColors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
