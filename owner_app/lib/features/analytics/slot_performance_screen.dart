import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_card.dart';

class SlotPerformanceScreen extends StatelessWidget {
  const SlotPerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                const SizedBox(height: 16),


              // Back Button & Title Row
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary, size: 24),
                    tooltip: 'Back',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Occupancy Intelligence',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'Real-time demand visualization',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Intelligence Card
              CustomCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryAmber.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(LucideIcons.flame, color: AppColors.secondaryAmber, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Evening slots (6 PM - 10 PM) are 95% occupied. Consider dynamic pricing.',
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Morning Section
              _SectionHeader(title: 'MORNING (6 AM - 12 PM)'),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.2, // Reduced height
                children: const [
                  _SlotCard(time: '6-7 AM', percentage: 85, status: SlotStatus.high),
                  _SlotCard(time: '7-8 AM', percentage: 90, status: SlotStatus.high),
                  _SlotCard(time: '8-9 AM', percentage: 60, status: SlotStatus.medium),
                  _SlotCard(time: '9-10 AM', percentage: 20, status: SlotStatus.low),
                  _SlotCard(time: '10-11 AM', percentage: 10, status: SlotStatus.low),
                  _SlotCard(time: '11-12 PM', percentage: 15, status: SlotStatus.low),
                ],
              ),

              const SizedBox(height: 32),

              // Afternoon Section
              _SectionHeader(title: 'AFTERNOON (12 PM - 4 PM)'),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.2, // Reduced height
                children: const [
                  _SlotCard(time: '12-1 PM', percentage: 5, status: SlotStatus.low),
                  _SlotCard(time: '1-2 PM', percentage: 0, status: SlotStatus.low),
                  _SlotCard(time: '2-3 PM', percentage: 0, status: SlotStatus.low),
                  _SlotCard(time: '3-4 PM', percentage: 30, status: SlotStatus.medium),
                ],
              ),

              const SizedBox(height: 32),

              // Evening Section
              _SectionHeader(title: 'EVENING (4 PM - 11 PM)'),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.2, // Reduced height
                children: const [
                  _SlotCard(time: '4-5 PM', percentage: 65, status: SlotStatus.medium),
                  _SlotCard(time: '5-6 PM', percentage: 80, status: SlotStatus.high),
                  _SlotCard(time: '6-7 PM', percentage: 100, status: SlotStatus.peak),
                  _SlotCard(time: '7-8 PM', percentage: 100, status: SlotStatus.peak),
                ],
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title.toUpperCase(),
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: AppColors.textMuted,
      ),
    );
  }
}

enum SlotStatus { low, medium, high, peak }

class _SlotCard extends StatelessWidget {
  final String time;
  final int percentage;
  final SlotStatus status;

  const _SlotCard({
    required this.time,
    required this.percentage,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    Color borderColor;

    switch (status) {
      case SlotStatus.low:
        color = const Color(0xFF64748B);
        icon = LucideIcons.snowflake;
        borderColor = AppColors.borderGlass;
        break;
      case SlotStatus.medium:
        color = AppColors.secondaryAmber;
        icon = LucideIcons.clock;
        borderColor = AppColors.secondaryAmber.withOpacity(0.4);
        break;
      case SlotStatus.high:
        color = AppColors.primaryGreen;
        icon = LucideIcons.pieChart;
        borderColor = AppColors.primaryGreen.withOpacity(0.4);
        break;
      case SlotStatus.peak:
        color = AppColors.primaryGreen;
        icon = LucideIcons.flame;
        borderColor = AppColors.primaryGreen.withOpacity(0.6);
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceGlass,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
        boxShadow: [
          if (status == SlotStatus.high || status == SlotStatus.peak)
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: -2,
            ),
          if (status == SlotStatus.medium)
             BoxShadow(
              color: AppColors.secondaryAmber.withOpacity(0.15),
              blurRadius: 10,
              spreadRadius: -2,
            ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Icon(icon, color: color, size: 16),
            ],
          ),
          Text(
            '$percentage% Filled',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
