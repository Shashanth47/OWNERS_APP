import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_card.dart';

class TurfRepairsQueriesScreen extends StatelessWidget {
  const TurfRepairsQueriesScreen({super.key});

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
          const SizedBox(height: 8), // Replaced the header with a small top margin if needed, or just let it start. Actually, the padding is 16, so let's just remove.


          Text(
            'Operational Overview',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track maintenance and customer inquiries',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          
          _SectionHeader(title: 'URGENT REPAIRS'),
          const SizedBox(height: 12),
          _StatusCard(
            title: 'Floodlight Repair - Pitch 2',
            subtitle: 'Reported 2 hours ago',
            status: 'Pending',
            statusColor: AppColors.secondaryAmber,
            icon: LucideIcons.lightbulb,
          ),
          const SizedBox(height: 12),
          _StatusCard(
            title: 'Net Replacement - Pitch 1',
            subtitle: 'Scheduled for tomorrow',
            status: 'Scheduled',
            statusColor: AppColors.accentBlue,
            icon: LucideIcons.utilityPole,
          ),
          
          const SizedBox(height: 32),
          _SectionHeader(title: 'CUSTOMER QUERIES'),
          const SizedBox(height: 12),
          _StatusCard(
            title: 'Corporate Booking Inquiry',
            subtitle: 'From: Rahul S. • 1 hour ago',
            status: 'New',
            statusColor: AppColors.primaryGreen,
            icon: LucideIcons.messageSquare,
          ),
          const SizedBox(height: 12),
          _StatusCard(
            title: 'Refund Request #1245',
            subtitle: 'From: Amit K. • 4 hours ago',
            status: 'In Review',
            statusColor: AppColors.secondaryAmber,
            icon: LucideIcons.helpCircle,
          ),
          
          const SizedBox(height: 100),
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
      title,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
        color: AppColors.textMuted,
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;
  final IconData icon;

  const _StatusCard({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (status == 'New' || status == 'Pending')
            BoxShadow(
              color: statusColor.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: -2,
            ),
        ],
      ),
      child: CustomCard(
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: statusColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: statusColor.withOpacity(0.2)),
              ),
              child: Text(
                status.toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
