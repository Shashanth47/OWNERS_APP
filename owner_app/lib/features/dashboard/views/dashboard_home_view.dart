import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/app_colors.dart';
import '../owner_dashboard_screen.dart';
import '../../management/profile_screen.dart';
import '../widgets/insight_card.dart';
import '../widgets/kpi_card.dart';
import '../widgets/quick_nav_card.dart';
import '../../../core/widgets/custom_card.dart';
import '../../../core/widgets/glance_effect.dart';
import '../../management/reports_screen.dart';
import '../../analytics/pricing_insights_screen.dart';
import '../../analytics/revenue_history_screen.dart';
import '../../analytics/slot_performance_screen.dart';
import '../../analytics/revenue_breakdown_screen.dart';
import '../../analytics/daily_revenue_calendar_screen.dart';

class DashboardHomeView extends StatelessWidget {
  const DashboardHomeView({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting Header
                  Row(
                    children: [
                      if (Navigator.canPop(context))
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary, size: 24),
                          tooltip: 'Back',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      if (Navigator.canPop(context)) const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Good Evening,',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textMuted,
                            ),
                          ),
                          Text(
                            'Shashanth',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Monthly Revenue Card (Hero, Full Width)
                  KpiCard(
                    title: 'THIS MONTH (FEB)',
                    value: '₹1,45,000',
                    subValue: 'On track to beat Jan (₹1.8L)',
                    isLarge: true,
                    isPrimary: true,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RevenueHistoryScreen()),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 12),

                  // Stats Grid
                  Row(
                    children: [
                      Expanded(
                        child: KpiCard(
                          title: 'TODAY\'S REVENUE',
                          value: '₹12,450',
                          subValue: '+15% vs Mon',
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
                        child: KpiCard(
                          title: 'OCCUPANCY',
                          value: '78%',
                          subValue: '6 Slots Empty',
                          accentColor: AppColors.secondaryAmber,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Insights Section
                  _SectionHeader(title: 'INTELLIGENCE INSIGHTS'),
                  const SizedBox(height: 12), 
                  
                  Column(
                    children: [
                      _InsightRow(
                        message: 'Peak slots (6-9 PM) are underpriced by ₹200.',
                        icon: LucideIcons.trendingUp,
                        iconColor: AppColors.primaryGreen,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PricingInsightsScreen()),
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      _InsightRow(
                        message: 'Playo contribution dropped 12% this week.',
                        icon: LucideIcons.alertTriangle,
                        iconColor: AppColors.secondaryAmber,
                        onTap: () {
                          // Switch to Revenue Tab (index 1)
                          OwnerDashboardScreen.of(context)?.setIndex(1);
                        },
                      ),

                    ],
                  ),
                  
                  const SizedBox(height: 32),

                  // Quick Actions
                  _SectionHeader(title: 'QUICK ACTIONS'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: QuickNavCard(
                          title: 'Reports',
                          icon: LucideIcons.fileText,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const ReportsScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: QuickNavCard(
                          title: 'Slots',
                          icon: LucideIcons.calendar,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SlotPerformanceScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: QuickNavCard(
                          title: 'Pricing Intelligence',
                          icon: LucideIcons.barChart2,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PricingInsightsScreen()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(child: SizedBox()),
                    ],
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
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: AppColors.textMuted,
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const _InsightRow({
    required this.message, 
    required this.icon, 
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlanceEffect(
      enabled: iconColor == AppColors.primaryGreen, // High priority insights have a glance
      child: CustomCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        color: const Color.fromRGBO(255, 255, 255, 0.04), // Lighter glass for rows
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20), // Slightly bigger icon
            ),
            const SizedBox(width: 12), // Reduced from 16 to move text left
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary,
                      fontSize: 14.5, // Increased from 13
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),

            Icon(LucideIcons.chevronRight, color: AppColors.textMuted.withOpacity(0.5), size: 16),
          ],
        ),
      ),
    );
  }
}
