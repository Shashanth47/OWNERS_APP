import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_card.dart';

class RevenueBreakdownScreen extends StatefulWidget {
  const RevenueBreakdownScreen({super.key});

  @override
  State<RevenueBreakdownScreen> createState() => _RevenueBreakdownScreenState();
}

class _RevenueBreakdownScreenState extends State<RevenueBreakdownScreen> {
  int _selectedPeriodIndex = 0; // 0: Today, 1: This Week, 2: This Month

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
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Text(
                      'REVENUE BREAKDOWN',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2, // 0.12em approx
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Segmented Control
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGlass,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.borderGlass),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(child: _SegmentTab(label: 'Today', isSelected: _selectedPeriodIndex == 0, onTap: () => setState(() => _selectedPeriodIndex = 0))),
                        Expanded(child: _SegmentTab(label: 'This Week', isSelected: _selectedPeriodIndex == 1, onTap: () => setState(() => _selectedPeriodIndex = 1))),
                        Expanded(child: _SegmentTab(label: 'This Month', isSelected: _selectedPeriodIndex == 2, onTap: () => setState(() => _selectedPeriodIndex = 2))),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
    
                  // Total Revenue
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'TOTAL REVENUE',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.0,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹12,450',
                          style: GoogleFonts.plusJakartaSans(
                            // fontSize: 32, // Removed duplicate
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
                            // tabular-nums usually handled by font features, Flutter supports via FontFeature
                            // fontFeatures: [FontFeature.tabularFigures()], 
                          ),
                        ),
                      ],
                    ),
                  ),
    
                  const SizedBox(height: 32),
    
                  // By Source
                  _SectionHeader(title: 'BY SOURCE'),
                  const SizedBox(height: 16),
                  const CustomCard(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _ProgressBarRow(label: 'Playo', amount: '₹7,500', percentage: 0.60, color: AppColors.primaryGreen),
                        SizedBox(height: 16),
                        _ProgressBarRow(label: 'Walk-ins', amount: '₹3,200', percentage: 0.25, color: AppColors.secondaryAmber),
                        SizedBox(height: 16),
                        _ProgressBarRow(label: 'District', amount: '₹1,750', percentage: 0.15, color: AppColors.accentBlue),
                      ],
                    ),
                  ),
    
                  const SizedBox(height: 24),
    
                  // By Turf
                  _SectionHeader(title: 'BY TURF'),
                  const SizedBox(height: 16),
                  const CustomCard(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _ProgressBarRow(label: 'Koramangala Arena', amount: '₹12,450', percentage: 0.65, color: AppColors.primaryGreen),
                        SizedBox(height: 16),
                        _ProgressBarRow(label: 'Indiranagar Sports Hub', amount: '₹8,200', percentage: 0.35, color: AppColors.accentBlue),
                      ],
                    ),
                  ),
    
                  const SizedBox(height: 24),
    
                  // This Week Trend
                  _SectionHeader(title: 'THIS WEEK TREND'),
                  const SizedBox(height: 16),
                  const CustomCard(
                     padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                     child: SizedBox(
                       height: 200,
                       child: _WeeklyTrendChart(),
                     ),
                  ),
                  
                  // Bottom padding for scroll
                  const SizedBox(height: 40),
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

class _SegmentTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SegmentTab({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? Colors.black : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class _ProgressBarRow extends StatelessWidget {
  final String label;
  final String amount;
  final double percentage;
  final Color color;

  const _ProgressBarRow({
    required this.label,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              amount,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                // fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.surfaceGlass,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth * percentage,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _WeeklyTrendChart extends StatelessWidget {
  const _WeeklyTrendChart();

  @override
  Widget build(BuildContext context) {
    // Mock Data for Mon-Sun
    final List<double> weeklyData = [4000, 6500, 3000, 8000, 11000, 14500, 12000];
    const double maxY = 16000;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => AppColors.surfaceGlass,
            tooltipPadding: const EdgeInsets.all(8),
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '₹${rod.toY.toInt()}',
                GoogleFonts.plusJakartaSans(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                if (value.toInt() >= 0 && value.toInt() < days.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      days[value.toInt()],
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              reservedSize: 30,
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: weeklyData.asMap().entries.map((entry) {
          final index = entry.key;
          final value = entry.value;
          final bool isHigh = index == 5; // Saturday is high/active

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                color: isHigh ? AppColors.primaryGreen : AppColors.graphMuted,
                width: 24, // Generous spacing implies narrower bars or wider chart. 24 is reasonable.
                borderRadius: BorderRadius.circular(4),
                gradient: isHigh
                    ? LinearGradient(
                        colors: [
                          AppColors.primaryGreen,
                          AppColors.primaryGreen.withOpacity(0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )
                    : null,
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY,
                  color: Colors.transparent, // Or very subtle glass if needed
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
