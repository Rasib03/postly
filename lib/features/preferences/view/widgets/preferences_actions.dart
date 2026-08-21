import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';

class PreferencesActions extends StatelessWidget {
  const PreferencesActions({
    super.key,
    required this.onSave,
    required this.onSkip,
    required this.canSave,
  });

  final VoidCallback onSave;
  final VoidCallback onSkip;
  final bool canSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 54,
          child: AnimatedOpacity(
            opacity: canSave ? 1.0 : 0.55,
            duration: const Duration(milliseconds: 200),
            child: ElevatedButton(
              onPressed: canSave ? onSave : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0073B1),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF0073B1),
                elevation: canSave ? 4 : 0,
                shadowColor: const Color(0xFF0073B1).withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_rounded, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Save Preferences & Continue',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textMuted,
              padding: const EdgeInsets.symmetric(vertical: 12),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              ),
            ),
            child: const Text('Skip for now'),
          ),
        ),
      ],
    );
  }
}
