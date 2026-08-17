import 'package:flutter/material.dart';
import 'package:prima_dental_care/theme/app_theme.dart';

class PharmaciesScreen extends StatefulWidget {
  const PharmaciesScreen({super.key});

  @override
  State<PharmaciesScreen> createState() => _PharmaciesScreenState();
}

class _PharmaciesScreenState extends State<PharmaciesScreen> {
  bool showAllClinics = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pharmacies'),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Show for all clinics',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => showAllClinics = !showAllClinics),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 50,
                      height: 28,
                      decoration: BoxDecoration(
                        color: showAllClinics ? AppColors.success : AppColors.border,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: AnimatedAlign(
                        duration: const Duration(milliseconds: 300),
                        alignment: showAllClinics ? Alignment.centerRight : Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(2),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  _pharmacyTile(
                    icon: Icons.local_pharmacy_rounded,
                    name: 'Rite Aid',
                    location: 'Salem, OR',
                    color: const Color(0xFFD1FAE5),
                    iconColor: const Color(0xFF059669),
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  _pharmacyTile(
                    icon: Icons.storefront_rounded,
                    name: 'Fred Meyer',
                    location: 'Salem, OR',
                    color: const Color(0xFFDBEAFE),
                    iconColor: const Color(0xFF2563EB),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pharmacyTile({
    required IconData icon,
    required String name,
    required String location,
    required Color color,
    required Color iconColor,
  }) {
    return ListTile(
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(location, style: const TextStyle(color: AppColors.textMuted)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.textMuted),
    );
  }
}
