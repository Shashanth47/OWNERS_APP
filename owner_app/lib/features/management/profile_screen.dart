import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../core/constants/app_colors.dart';
import '../../core/data/turf_repository.dart';
import '../../core/widgets/custom_card.dart';
import '../auth/login_screen.dart';
import 'manage_turfs_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isTurfSpecific;
  const ProfileScreen({super.key, this.isTurfSpecific = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Mock local state for pitches added during customization
  final List<Map<String, String>> _pitches = [];


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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (Navigator.canPop(context) && !widget.isTurfSpecific)
                        Positioned(
                          left: 0,
                          child: IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary, size: 20),
                            tooltip: 'Back',
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ),
                      Center(
                        child: Text(
                          widget.isTurfSpecific ? 'TURF SETTINGS' : 'PROFILE & SETTINGS',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Avatar with Glow
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withOpacity(0.15),
                          blurRadius: 32,
                          spreadRadius: -4,
                        ),
                      ],
                    ),
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceGlass, 
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.2), width: 1),
                      ),
                      child: const Icon(LucideIcons.user, size: 45, color: AppColors.primaryGreen),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
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
                  const SizedBox(height: 4),
                  Text(
                    '+91 98765 43210',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textMuted,
                    ),
                  ),
                  
                  const SizedBox(height: 32),

                  // Turf Specific Section: Customize this Turf
                  if (widget.isTurfSpecific) ...[
                    _SectionHeaderLabel(title: 'TURF MANAGEMENT'),
                    const SizedBox(height: 12),
                    CustomCard(
                      padding: EdgeInsets.zero,
                      color: const Color.fromRGBO(255, 255, 255, 0.06),
                      child: Column(
                        children: [
                          _SettingsRow(
                            icon: LucideIcons.sliders, 
                            label: 'Customize this Turf', 
                            trailingText: 'Configure',
                            trailingColor: AppColors.primaryGreen,
                            onTap: () => _showCustomizeTurfDialog(context),
                          ),
                          if (_pitches.isNotEmpty) ...[
                            _Divider(),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CONFIGURED PITCHES',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textMuted,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  ..._pitches.map((p) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      children: [
                                        const Icon(LucideIcons.checkCircle2, size: 14, color: AppColors.primaryGreen),
                                        const SizedBox(width: 8),
                                        Text(
                                          '${p['name']} (${p['type']})',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Settings Card
                  _SectionHeaderLabel(title: 'ACCOUNT & APP'),
                  const SizedBox(height: 12),
                  CustomCard(
                    padding: EdgeInsets.zero,
                    color: const Color.fromRGBO(255, 255, 255, 0.06),
                    child: AnimatedBuilder(
                      animation: TurfRepository(),
                      builder: (context, _) {
                        return Column(
                          children: [
                            if (!widget.isTurfSpecific) ...[
                              _SettingsRow(
                                icon: LucideIcons.layoutGrid, 
                                label: 'My Turfs', 
                                trailingText: '${TurfRepository().turfs.length} Active',
                                trailingColor: AppColors.primaryGreen,
                                onTap: () => Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (_) => const ManageTurfsScreen())
                                ),
                              ),
                              _Divider(),
                            ],
                            const _SettingsRow(
                              icon: LucideIcons.star, 
                              label: 'Subscription Plan', 
                              trailingText: 'Pro',
                              trailingColor: AppColors.primaryGreen,
                            ),
                            _Divider(),
                            const _SettingsRow(
                              icon: LucideIcons.settings, 
                              label: 'App Settings',
                              showChevron: true,
                            ),
                          ],
                        );
                      }
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Log Out Action
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.red.withOpacity(0.5), width: 1),
                        foregroundColor: AppColors.red,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        backgroundColor: AppColors.red.withOpacity(0.02),
                      ),
                      child: Text(
                        'LOG OUT',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomizeTurfDialog(BuildContext context) {
    String selectedType = '5v5';
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => AlertDialog(
          backgroundColor: AppColors.backgroundBlack.withOpacity(0.95),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: AppColors.borderGlass),
          ),
          title: Text(
            'Add Pitch/Small Turf',
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Give your sub-turf a name and size',
                style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted, fontSize: 13),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                autofocus: true,
                style: const TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'e.g. Turf A',
                  labelStyle: const TextStyle(color: AppColors.textMuted),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'SELECT TYPE',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _TypeOption(
                    label: '5v5', 
                    isSelected: selectedType == '5v5',
                    onTap: () => setStateDialog(() => selectedType = '5v5'),
                  ),
                  const SizedBox(width: 12),
                  _TypeOption(
                    label: '7v7', 
                    isSelected: selectedType == '7v7',
                    onTap: () => setStateDialog(() => selectedType = '7v7'),
                  ),
                  const SizedBox(width: 12),
                  _TypeOption(
                    label: '11v11', 
                    isSelected: selectedType == '11v11',
                    onTap: () => setStateDialog(() => selectedType = '11v11'),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted)),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    _pitches.add({
                      'name': nameController.text,
                      'type': selectedType,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Okay'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeaderLabel extends StatelessWidget {
  final String title;
  const _SectionHeaderLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _TypeOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeOption({required this.label, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen.withOpacity(0.2) : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}


class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailingText;
  final Color? trailingColor;
  final bool showChevron;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.icon, 
    required this.label, 
    this.trailingText, 
    this.trailingColor, 
    this.showChevron = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56, // Listed item height 52-56px
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textPrimary.withOpacity(0.7)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText!,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: trailingColor ?? AppColors.textMuted,
                ),
              ),
            if (showChevron)
              Icon(LucideIcons.chevronRight, size: 16, color: AppColors.textMuted.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.white.withOpacity(0.08),
    );
  }
}
