import 'package:flutter/material.dart';
import 'package:dentalcare_pro/theme/app_theme.dart';
import 'package:dentalcare_pro/services/auth_service.dart';
import 'package:dentalcare_pro/services/api_client.dart';
import 'reports_screen.dart';
import 'pharmacies_screen.dart';

class MoreOptionsScreen extends StatelessWidget {
  final AuthService auth;
  final HelianzApiClient api;
  const MoreOptionsScreen({super.key, required this.auth, required this.api});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            // Profile Header
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark],
                    begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                const CircleAvatar(radius: 36, backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 36, color: Colors.white)),
                const SizedBox(height: 12),
                Text(auth.displayName ?? 'Helianz User',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 4),
                Text('Clinic: ${auth.clinicNum ?? '—'}',
                    style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.8))),
                if (auth.userGroupNums != null && auth.userGroupNums!.isNotEmpty)
                  Text('Groups: ${auth.userGroupNums!.join(", ")}',
                      style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
              ]),
            ),
              _buildMenuGroup([
                if (auth.canViewReports)
                  _MenuItem(
                    icon: Icons.bar_chart_rounded,
                    label: 'Reports',
                    color: const Color(0xFFDBEAFE),
                    iconColor: const Color(0xFF2563EB),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ReportsScreen(api: api)),
                    ),
                  ),
                _MenuItem(
                  icon: Icons.image_rounded,
                  label: 'Patient Images',
                  color: const Color(0xFFF3E8FF),
                  iconColor: const Color(0xFF7C3AED),
                ),
                _MenuItem(
                  icon: Icons.local_pharmacy_rounded,
                  label: 'Pharmacies',
                  color: const Color(0xFFD1FAE5),
                  iconColor: const Color(0xFF059669),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PharmaciesScreen()),
                  ),
                ),
                _MenuItem(
                  icon: Icons.medical_services_rounded,
                  label: 'eRx',
                  color: const Color(0xFFFFEDD5),
                  iconColor: const Color(0xFFEA580C),
                ),
              ]),
              const SizedBox(height: 16),
              _buildMenuGroup([
                _MenuItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  color: const Color(0xFFF3F4F6),
                  iconColor: const Color(0xFF4B5563),
                ),
                _MenuItem(
                  icon: Icons.switch_account_rounded,
                  label: 'Switch User',
                  color: const Color(0xFFF3F4F6),
                  iconColor: const Color(0xFF4B5563),
                ),
                _MenuItem(
                  icon: Icons.info_rounded,
                  label: 'About',
                  color: const Color(0xFFF3F4F6),
                  iconColor: const Color(0xFF4B5563),
                ),
                _MenuItem(
                  icon: Icons.build_rounded,
                  label: 'Troubleshoot',
                  color: const Color(0xFFF3F4F6),
                  iconColor: const Color(0xFF4B5563),
                ),
              ]),
              const SizedBox(height: 16),
              _buildMenuGroup([
                _MenuItem(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  color: const Color(0xFFFEE2E2),
                  iconColor: const Color(0xFFDC2626),
                  textColor: AppColors.danger,
                  onTap: () => auth.logout(),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGroup(List<_MenuItem> items) {
    return Card(
      child: Column(
        children: items.asMap().entries.map((entry) {
          final item = entry.value;
          final isLast = entry.key == items.length - 1;
          return InkWell(
            onTap: item.onTap,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(entry.key == 0 ? 16 : 0),
              bottom: Radius.circular(isLast ? 16 : 0),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                border: isLast ? null : const Border(
                  bottom: BorderSide(color: AppColors.border),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item.icon, color: item.iconColor, size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: item.textColor ?? AppColors.text,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final Color? textColor;
  final VoidCallback? onTap;

  _MenuItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    this.textColor,
    this.onTap,
  });
}
