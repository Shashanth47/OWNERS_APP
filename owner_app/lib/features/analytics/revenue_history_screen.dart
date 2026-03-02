import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';

class RevenueHistoryScreen extends StatelessWidget {
  const RevenueHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<RevenueData> revenueHistory = [
      RevenueData(month: 'February', year: 2026, revenue: 145000, growth: 12, isCurrent: true),
      RevenueData(month: 'January', year: 2026, revenue: 180000, growth: -5),
      RevenueData(month: 'December', year: 2025, revenue: 165000, growth: 8),
      RevenueData(month: 'November', year: 2025, revenue: 152000, growth: 10),
      RevenueData(month: 'October', year: 2025, revenue: 158000, growth: -2),
      RevenueData(month: 'September', year: 2025, revenue: 142000, growth: 15),
      RevenueData(month: 'August', year: 2025, revenue: 135000, growth: 5),
      RevenueData(month: 'July', year: 2025, revenue: 128000, growth: 12),
      RevenueData(month: 'June', year: 2025, revenue: 120000, growth: 8),
      RevenueData(month: 'May', year: 2025, revenue: 115000, growth: 4),
      RevenueData(month: 'April', year: 2025, revenue: 110000, growth: -3),
      RevenueData(month: 'March', year: 2025, revenue: 118000, growth: 10),
      RevenueData(month: 'February', year: 2025, revenue: 105000, growth: 5),
      RevenueData(month: 'January', year: 2025, revenue: 98000, growth: 12),
      RevenueData(month: 'December', year: 2024, revenue: 95000, growth: 8),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      extendBody: true,
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
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 420),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                const SizedBox(height: 16),

                
                // Back Button & Subtitle Row
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
                          'Financial Trends',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Tracking monthly revenue trends',
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
                const SizedBox(height: 32),
                
                // Timeline
                Expanded(
                  child: ListView.builder(
                    reverse: true, // Current month at bottom (index 0)
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: revenueHistory.length,
                    itemBuilder: (context, index) {
                      final item = revenueHistory[index];
                      // Show year divider when it's January (since we scroll UP, Jan is the first month of that year in the list)
                      // In a reversed list, if index 13 is Jan 2025, it will be above Feb 2025.
                      final bool isJanuary = item.month == 'January';
                      
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isJanuary) 
                           YearDivider(year: (item.year - 1).toString()),
                          
                          TimelineRow(
                            data: item,
                            isLast: index == revenueHistory.length - 1,
                            isFirst: index == 0,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  ),
);
  }
}

class RevenueData {
  final String month;
  final int year;
  final double revenue;
  final double growth;
  final bool isCurrent;

  RevenueData({
    required this.month,
    required this.year,
    required this.revenue,
    required this.growth,
    this.isCurrent = false,
  });
}

class TimelineRow extends StatelessWidget {
  final RevenueData data;
  final bool isLast;
  final bool isFirst;

  const TimelineRow({
    super.key,
    required this.data,
    this.isLast = false,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // Consistent spacing
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline gutter
          SizedBox(
            width: 24,
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // Line - anchored on left
                if (!isLast)
                  Positioned(
                    top: 10,
                    bottom: -10,
                    child: Container(
                      width: 1,
                      color: AppColors.timelineLine,
                    ),
                  ),
                // Node - circular
                Positioned(
                  top: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: data.isCurrent ? AppColors.primaryGreen : AppColors.timelineLine,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Card
          Expanded(
            child: RevenueMonthCard(data: data),
          ),
        ],
      ),
    );
  }
}

class RevenueMonthCard extends StatelessWidget {
  final RevenueData data;

  const RevenueMonthCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // Subtle feedback automatically handled by some widgets or we can add it
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceGlass,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: data.isCurrent 
                    ? Colors.white.withOpacity(0.15) 
                    : AppColors.borderGlass,
                width: 1,
              ),
              boxShadow: [
                if (data.isCurrent)
                  BoxShadow(
                    color: AppColors.primaryGreen.withOpacity(0.25),
                    blurRadius: 20,
                    spreadRadius: -2,
                  ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      data.month,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: data.isCurrent ? AppColors.textPrimary : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${data.revenue.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: data.isCurrent ? AppColors.primaryGreen : AppColors.textPrimary,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
                if (data.growth != 0)
                  Row(
                    children: [
                      Icon(
                        data.growth > 0 ? LucideIcons.trendingUp : LucideIcons.trendingDown,
                        color: AppColors.textMuted,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${data.growth > 0 ? '+' : ''}${data.growth.toInt()}%',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class YearDivider extends StatelessWidget {
  final String year;

  const YearDivider({super.key, required this.year});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          Expanded(child: Container(height: 1, color: AppColors.dividerGlass)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              year,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ),
          Expanded(child: Container(height: 1, color: AppColors.dividerGlass)),
        ],
      ),
    );
  }
}

