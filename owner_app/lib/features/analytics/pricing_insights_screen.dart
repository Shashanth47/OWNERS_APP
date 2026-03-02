import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_card.dart';

class PricingInsightsScreen extends StatelessWidget {
  const PricingInsightsScreen({super.key});

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
                        'Suggestions',
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

                  const _PricingCard(
                    title: 'Increase Rate: Sat 6-7 PM',
                    currentPrice: '₹1,200',
                    suggestedPrice: '₹1,400',
                    columnLabel: 'SUGGESTED PRICE',
                    difference: '+₹200',
                    reason: 'Demand is consistently 100% for the last 4 Saturdays. Competitors charge ₹1,500.',
                    isIncrease: true,
                  ),
                  const SizedBox(height: 16),
                  const _PricingCard(
                    title: 'Discount: Tue 7-9 AM',
                    currentPrice: '₹800',
                    suggestedPrice: '₹600',
                    columnLabel: 'SUGGESTED PRICE',
                    difference: '-₹200',
                    reason: 'Occupancy is <10%. Lower price to attract morning fitness groups.',
                    isIncrease: false,
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

class _PricingCard extends StatelessWidget {
  final String title;
  final String currentPrice;
  final String suggestedPrice;
  final String difference;
  final String reason;
  final String? columnLabel;
  final bool isIncrease;

  const _PricingCard({
    required this.title,
    required this.currentPrice,
    required this.suggestedPrice,
    required this.difference,
    required this.reason,
    required this.isIncrease,
    this.columnLabel,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isIncrease ? AppColors.primaryGreen.withOpacity(0.2) : AppColors.amber.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  difference,
                  style: GoogleFonts.plusJakartaSans(
                    color: isIncrease ? AppColors.primaryGreen : AppColors.secondaryAmber,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _PriceColumn(label: 'Current', price: currentPrice),
              const SizedBox(width: 32),
              const Icon(Icons.arrow_forward, color: AppColors.textGray, size: 20),
              const SizedBox(width: 32),
              _PriceColumn(label: 'Suggested', price: suggestedPrice, isHighlight: true),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.dividerGray),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: AppColors.textGray, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  reason,
                  style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted, fontSize: 13, height: 1.4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceColumn extends StatelessWidget {
  final String label;
  final String price;
  final bool isHighlight;

  const _PriceColumn({required this.label, required this.price, this.isHighlight = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(color: AppColors.textGray, fontSize: 11, letterSpacing: 0.5),
        ),
        const SizedBox(height: 4),
        Text(
          price,
          style: GoogleFonts.plusJakartaSans(
            color: isHighlight ? AppColors.textPrimary : AppColors.textMuted,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
