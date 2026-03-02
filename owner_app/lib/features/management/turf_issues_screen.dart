import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_card.dart';

class TurfIssuesScreen extends StatelessWidget {
  const TurfIssuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        title: const Text('ISSUES', style: TextStyle(color: AppColors.textWhite)),
        backgroundColor: AppColors.surfaceBlack,
        iconTheme: const IconThemeData(color: AppColors.textWhite),
        elevation: 0,
      ),
      body: Container(
        color: AppColors.backgroundBlack,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
             Text(
                'MAINTENANCE & ISSUES',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textGray,
                    ),
              ),
              const SizedBox(height: 16),
             Text(
                'ACTIVE ISSUES',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGray,
                ),
              ),
              const SizedBox(height: 16),
              const _IssueCard(
                title: 'Floodlight Failure (Pole 3)',
                user: 'Reported by Manager',
                date: 'Today, 10:30 AM',
                status: 'Open',
                statusColor: AppColors.red,
              ),
              const SizedBox(height: 16),
               const _IssueCard(
                title: 'Netting damage near Goal A',
                user: 'Reported by Staff',
                date: 'Yesterday',
                status: 'In Progress',
                statusColor: AppColors.amber,
              ),
              
              const SizedBox(height: 32),

              Text(
                'RESOLVED',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textGray,
                ),
              ),
              const SizedBox(height: 16),
              const _IssueCard(
                title: 'Water cooler repair',
                user: 'Reported by Customer',
                date: '2 Feb 2026',
                status: 'Resolved',
                statusColor: AppColors.primaryGreen,
              ),
          ],
        ),
      ),
    );
  }
}

class _IssueCard extends StatelessWidget {
  final String title;
  final String user;
  final String date;
  final String status;
  final Color statusColor;

  const _IssueCard({
    required this.title,
    required this.user,
    required this.date,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: statusColor.withOpacity(0.5)),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
              Text(date, style: const TextStyle(color: AppColors.textGray, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(color: AppColors.textWhite, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 14, color: AppColors.textGray),
              const SizedBox(width: 4),
              Text(
                user,
                style: const TextStyle(color: AppColors.textGray, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
