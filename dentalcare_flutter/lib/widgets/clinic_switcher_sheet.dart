import 'package:flutter/material.dart';
import 'package:prima_dental_care/services/auth_service.dart';
import 'package:prima_dental_care/theme/app_theme.dart';

class ClinicSwitcherSheet extends StatelessWidget {
  final AuthService auth;
  final VoidCallback? onClinicChanged;

  const ClinicSwitcherSheet({
    super.key,
    required this.auth,
    this.onClinicChanged,
  });

  static Future<void> show(BuildContext context, AuthService auth, {VoidCallback? onClinicChanged}) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => ClinicSwitcherSheet(
        auth: auth,
        onClinicChanged: onClinicChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clinics = auth.availableClinics;
    final activeNum = auth.activeClinicNum;
    final canViewAll = !auth.clinicIsRestricted;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.local_hospital_rounded, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Clinic Branch',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    'Switch practice location view',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 8),

          // "All Clinics" option if unrestricted
          if (canViewAll) ...[
            _ClinicTile(
              title: 'All Clinics (HQ)',
              subtitle: 'Consolidated view across all branches',
              isSelected: activeNum == 0,
              icon: Icons.hub_rounded,
              onTap: () async {
                await auth.setActiveClinic(0, 'All Clinics');
                if (context.mounted) {
                  Navigator.pop(context);
                }
                onClinicChanged?.call();
              },
            ),
            const SizedBox(height: 6),
          ],

          // List of individual clinics
          if (clinics.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('No clinic branches available', style: TextStyle(color: AppColors.textMuted)),
              ),
            )
          else
            ...clinics.map((c) {
              final isSelected = activeNum == c.clinicNum;
              final address = [c.city, c.phone].where((s) => s != null && s.isNotEmpty).join(' · ');
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _ClinicTile(
                  title: c.description,
                  subtitle: address.isNotEmpty ? address : 'Branch ID #${c.clinicNum}',
                  isSelected: isSelected,
                  icon: Icons.store_mall_directory_rounded,
                  onTap: () async {
                    await auth.setActiveClinic(c.clinicNum, c.description);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                    onClinicChanged?.call();
                  },
                ),
              );
            }),
        ],
      ),
    );
  }
}

class _ClinicTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final IconData icon;
  final VoidCallback onTap;

  const _ClinicTile({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? AppColors.primary : AppColors.text,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 22)
            else
              const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
          ],
        ),
      ),
    );
  }
}
