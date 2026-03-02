import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../analytics/revenue_breakdown_screen.dart';
import '../analytics/slot_performance_screen.dart';
import '../management/turf_repairs_queries_screen.dart';
import 'views/dashboard_home_view.dart';

import '../management/profile_screen.dart';

class OwnerDashboardScreen extends StatefulWidget {
  const OwnerDashboardScreen({super.key});

  static OwnerDashboardScreenState? of(BuildContext context) {
    return context.findAncestorStateOfType<OwnerDashboardScreenState>();
  }

  @override
  State<OwnerDashboardScreen> createState() => OwnerDashboardScreenState();
}

class OwnerDashboardScreenState extends State<OwnerDashboardScreen> {
  int _currentIndex = 0;

  void setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const DashboardHomeView(),
      const RevenueBreakdownScreen(), 
      const TurfRepairsQueriesScreen(),
      const ProfileScreen(isTurfSpecific: true),

    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: pages,
        ),
      ),
      extendBody: true, // Allow body to draw behind nav bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: const Border(
            top: BorderSide(color: AppColors.borderGlass, width: 1.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16.0, sigmaY: 16.0),
            child: Container(
              color: AppColors.surfaceGlass,
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) => setState(() => _currentIndex = index),
                backgroundColor: Colors.transparent, // Transparent to show glass
                selectedItemColor: AppColors.primaryGreen,
                unselectedItemColor: AppColors.textMuted,
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                elevation: 0,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.bar_chart),
                    label: 'Revenue',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.build_circle_outlined),
                    label: 'Repairs',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
