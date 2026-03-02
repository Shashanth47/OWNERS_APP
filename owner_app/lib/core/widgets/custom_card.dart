import 'package:flutter/material.dart';
import 'dart:ui';
import '../constants/app_colors.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 0, 0.35),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          // backdrop-blur-md (approx 12px sigma)
          filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              // Inner highlight effect could be simulated with a gradient or inner shadow, 
              // but standard Container with Border is easier for now.
              // To enable "hover" effect effectively in Flutter web/desktop, we might need MouseRegion, 
              // but InkWell handles touch feedback.
              child: Container(
                width: double.infinity,
                padding: padding ?? const EdgeInsets.all(16), // Spec says 16-20px
                decoration: BoxDecoration(
                  color: color ?? AppColors.surfaceGlass,
                  border: Border.all(color: AppColors.borderGlass, width: 1.0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
