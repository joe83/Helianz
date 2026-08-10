import 'package:flutter/material.dart';
import 'package:dentalcare_pro/theme/app_theme.dart';

class TimeSlot extends StatelessWidget {
  final String time;
  final String? patientName;
  final String? procedure;
  final String? status;
  final String? providerName;
  final String? note;
  final bool isAvailable;

  const TimeSlot({
    super.key,
    required this.time,
    this.patientName,
    this.procedure,
    this.status,
    this.providerName,
    this.note,
    this.isAvailable = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = const Color(0xFFFEE2E2);
    Color borderColor = AppColors.danger;

    if (status?.toLowerCase() == 'confirmed') {
      bgColor = const Color(0xFFD1FAE5);
      borderColor = AppColors.success;
    } else if (status?.toLowerCase() == 'scheduled') {
      bgColor = const Color(0xFFDBEAFE);
      borderColor = const Color(0xFF3B82F6);
    } else if (status?.toLowerCase() == 'broken') {
      bgColor = const Color(0xFFF3F4F6);
      borderColor = AppColors.textMuted;
    }

    final isCanceled = status?.toLowerCase() == 'broken';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(
              time,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isCanceled ? AppColors.textMuted : AppColors.textSecondary,
                decoration: isCanceled ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          if (isAvailable)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Available',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border(left: BorderSide(color: borderColor, width: 4)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patientName ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            decoration: isCanceled ? TextDecoration.lineThrough : null,
                            color: isCanceled ? AppColors.textMuted : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(children: [
                          if (providerName != null && providerName!.isNotEmpty) ...[
                            Text(providerName!,
                              style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.w500)),
                            const Text(' · ', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                          Text(procedure ?? '',
                            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        ]),
                        const SizedBox(height: 2),
                        Row(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: borderColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(status ?? '', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: borderColor)),
                          ),
                          if (note != null && note!.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.notes_rounded, size: 11, color: AppColors.textMuted),
                            const SizedBox(width: 3),
                            Expanded(child: Text(note!, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontStyle: FontStyle.italic))),
                          ],
                        ]),
                      ],
                    ),
                  ),
                  if (isCanceled)
                    const Positioned.fill(
                      child: Center(
                        child: Icon(Icons.close, size: 48, color: Color(0x33EF4444)),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
