import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../dashboard/owner_dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    // Simulated delay for premium feel
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      // TODO: Replace with actual auth check
      // For now, go straight to Login (or Dashboard for dev speed)
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for Logo
            Icon(
              Icons.stadium,
              size: 80,
              color: AppColors.primaryGreen,
            ),
            const SizedBox(height: 24),
            Text(
              'NAMMA TURF',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                letterSpacing: 1.5,
                color: AppColors.textWhite,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'OWNER',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                letterSpacing: 4.0,
                color: AppColors.primaryGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
