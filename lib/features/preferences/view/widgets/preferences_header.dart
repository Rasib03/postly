import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';

class PreferencesHeader extends StatelessWidget {
  const PreferencesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 1.0,
                  minHeight: 4,
                  backgroundColor: AppColors.glassBorder,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.accentSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Step 1 of 1',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),

        const SizedBox(height: 28),

        const Text(
          'Tailor Your Feed 🎯',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.4,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Select your tech interests so Postly can curate relevant '
          'LinkedIn draft posts for you.',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.55,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}
