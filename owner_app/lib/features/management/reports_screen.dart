import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_card.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

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
                      Text(
                        'Financial Reports',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _SectionHeader(title: 'MONTHLY STATEMENTS'),
                  const SizedBox(height: 16),
                  const _ReportItem(month: 'January 2026', revenue: '₹1,85,400', bookings: 142),
                  const SizedBox(height: 12),
                  const _ReportItem(month: 'December 2025', revenue: '₹2,10,000', bookings: 168),
                  const SizedBox(height: 12),
                  const _ReportItem(month: 'November 2025', revenue: '₹1,50,200', bookings: 120),

                  const SizedBox(height: 32),

                  _SectionHeader(title: 'TAX DOCUMENTS'),
                  const SizedBox(height: 16),
                  const _DocItem(title: 'Q4 2025 GST Report'),
                  const SizedBox(height: 12),
                  const _DocItem(title: 'Annual Tax Statement 2025'),
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
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        color: AppColors.textMuted,
      ),
    );
  }
}

class _ReportItem extends StatelessWidget {
  final String month;
  final String revenue;
  final int bookings;

  const _ReportItem({required this.month, required this.revenue, required this.bookings});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(month, style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 4),
              Text('$bookings Bookings', style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted)),
            ],
          ),
          Text(revenue, style: GoogleFonts.plusJakartaSans(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }
}

class _DocItem extends StatelessWidget {
  final String title;

  const _DocItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.picture_as_pdf, color: AppColors.red),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary))),
          const Icon(LucideIcons.download, color: AppColors.textMuted, size: 18),
        ],
      ),
    );
  }
}
