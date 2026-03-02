import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_card.dart';
import '../../../../core/widgets/glance_effect.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subValue;
  final Color? accentColor;
  final bool isLarge;
  final bool isPrimary;
  final VoidCallback? onTap;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    this.subValue,
    this.accentColor,
    this.isLarge = false,
    this.isPrimary = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Parse value for animation
    // Regex matches: Group 1 (Prefix non-digits), Group 2 (Number with commas/dots), Group 3 (Suffix)
    final RegExp regExp = RegExp(r'([^0-9]*)([\d,.]+)(.*)');
    final match = regExp.firstMatch(value);
    
    // Check if we can animate
    final bool canAnimate = match != null;
    double endValue = 0;
    String prefix = '';
    String suffix = '';

    if (canAnimate) {
      prefix = match.group(1) ?? '';
      String numberStr = match.group(2) ?? '0';
      suffix = match.group(3) ?? '';
      // Remove commas to parse double
      endValue = double.tryParse(numberStr.replaceAll(',', '')) ?? 0.0;
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (isPrimary || accentColor != null)
            BoxShadow(
              color: (accentColor ?? AppColors.primaryGreen).withOpacity(0.12),
              blurRadius: 20,
              spreadRadius: -2,
            ),
        ],
      ),
      child: GlanceEffect(
        enabled: isPrimary,
        child: CustomCard(
          onTap: onTap,
          color: isPrimary ? const Color.fromRGBO(255, 255, 255, 0.07) : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
               Text(
                title.toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              canAnimate 
                ? TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: endValue),
                    duration: const Duration(seconds: 2),
                    curve: Curves.easeOutExpo,
                    builder: (context, val, child) {
                      final formatter = NumberFormat('#,###');
                      String formattedNum = formatter.format(val.toInt());
                      
                      return Text(
                        '$prefix$formattedNum$suffix',
                        style: GoogleFonts.plusJakartaSans(
                          color: accentColor ?? AppColors.textPrimary,
                          fontSize: isLarge ? 28 : 24,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      );
                    },
                  )
                : Text(
                    value,
                    style: GoogleFonts.plusJakartaSans(
                      color: accentColor ?? AppColors.textPrimary,
                      fontSize: isLarge ? 28 : 24, 
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
              if (subValue != null) ...[
                const SizedBox(height: 4),
                Text(
                  subValue!,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textGray,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
