import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_card.dart';
import '../../core/data/turf_repository.dart';
import '../../core/models/turf_model.dart';
import 'widgets/kpi_card.dart';
import '../management/profile_screen.dart';
import 'owner_dashboard_screen.dart';
import '../analytics/revenue_history_screen.dart';
import '../analytics/daily_revenue_calendar_screen.dart';

class TurfSelectionScreen extends StatelessWidget {
  const TurfSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: TurfRepository(),
      builder: (context, child) {
        final turfs = TurfRepository().turfs;
        
        // If there's exactly one turf, skip the selector and show the dashboard immediately.
        if (turfs.length == 1) {
          return const OwnerDashboardScreen();
        }

        return Scaffold(
          backgroundColor: AppColors.backgroundBlack,
          floatingActionButton: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
              shape: BoxShape.circle,
            ),
            child: FloatingActionButton(
              onPressed: () => _showAddTurfDialog(context),
              backgroundColor: AppColors.primaryGreen,
              elevation: 0,
              child: const Icon(LucideIcons.plus, color: Colors.black),
            ),
          ),
          body: Stack(
            children: [
              // Background Glow Blobs for Glass Depth
              Positioned(
                top: -100,
                right: -50,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryGreen.withOpacity(0.08),
                  ),
                ),
              ),
              Positioned(
                top: 200,
                left: -100,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.secondaryAmber.withOpacity(0.05),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       // Header with Profile Icon
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Good Evening,',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textMuted,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                'Shashanth',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.textPrimary,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ProfileScreen()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.primaryGreen.withOpacity(0.5), width: 1),
                              ),
                              child: const CircleAvatar(
                                backgroundColor: AppColors.surfaceGlass,
                                radius: 20,
                                child: Icon(LucideIcons.user, color: AppColors.primaryGreen, size: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                       
                       // Aggregated KPIs
                       KpiCard(
                        title: 'This Month (Feb)',
                        value: '₹2,35,000',
                        subValue: 'On track to beat Jan (₹2.1L)',
                        isLarge: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RevenueHistoryScreen()),
                          );
                        },
                      ),
                       const SizedBox(height: 12),
                       Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: KpiCard(
                              title: 'Today\'s Revenue',
                              value: '₹20,650',
                              subValue: '+15% vs Last Monday',
                              accentColor: AppColors.primaryGreen,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const DailyRevenueCalendarScreen()),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            flex: 4,
                            child: KpiCard(
                              title: 'Occupancy',
                              value: '82%',
                              subValue: '4 Slots Empty',
                              accentColor: AppColors.amber,
                            ),
                          ),
                        ],
                      ),
    
                      const SizedBox(height: 48),
    
                      Text(
                        'Select Property',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You manage ${turfs.length} active turfs.',
                            style: GoogleFonts.inter(
                              color: AppColors.textMuted,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (turfs.isEmpty)
                             Text('No turfs found. Add one!', style: GoogleFonts.inter(color: AppColors.textMuted)),
                          ...turfs.map((turf) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _TurfCard(
                              name: turf.name,
                              revenue: turf.revenue,
                              location: turf.location,
                              onTap: () => _navigateToDashboard(context),
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

        );
      }
    );
  }

  void _navigateToDashboard(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const OwnerDashboardScreen()),
    );
  }

  void _showAddTurfDialog(BuildContext context) {
    // We navigate to Manage Screen or show a dialog.
    // For consistency with "Add" button here being a "Quick Add" or similar, 
    // let's stick to the dialog logic but hook it up to the repo if we want proper functionality,
    // OR just use the dialog to confirm and mock add. 
    // Since we built the full ManageTurfsScreen, we could use that logic, 
    // but the original dialog was simple.
    // I'll update it to act like the ManageTurfsScreen add dialog but simpler.
    
    // Actually, user might expect this FAB to add a turf. 
    // Let's implement the add logic here too or direct to Manage screen.
    // Given the context "skip if one turf", adding on this main screen makes sense.
    // I'll replicate the add logic from ManageTurfsScreen here quickly.
    
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
                 TurfRepository().addTurf(
                  // Use a simplified model import or full path if needed, 
                  // but we imported models/turf_model.dart via repo (indirectly? No, need direct import).
                  // I imported repo and model above.
                  // TurfModel is available.
                  // Wait, I need to make sure TurfModel is accessible. 
                  // Yes, `import '../../core/models/turf_model.dart';` was added in my imports block above.
                  // Wait, I need to instantiate it.
                  // Let's check imports in my ReplacementContent.
                   // Yes: import '../../core/models/turf_model.dart'; is missing in my replacement block imports?
                   // No, wait. I see `import '../../core/data/turf_repository.dart';`. 
                   // I should add `import '../../core/models/turf_model.dart';`
                   TurfModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    location: locationController.text,
                    revenue: '₹0', 
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
}

class _TurfCard extends StatelessWidget {
  final String name;
  final String revenue;
  final String location;
  final VoidCallback onTap;

  const _TurfCard({
    required this.name,
    required this.revenue,
    required this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(LucideIcons.mapPin, size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: GoogleFonts.inter(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
                Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2)),
                ),
                child: Text(
                  revenue,
                  style: GoogleFonts.inter(
                    color: AppColors.primaryGreen,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(LucideIcons.chevronRight, color: AppColors.textMuted, size: 20),
            ],
          )
        ],
      ),
    );
  }
}
