import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key, required this.onLogOut});

  final VoidCallback onLogOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Postly v1.0.0',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton.icon(
            onPressed: onLogOut,
            icon: const Icon(
              Icons.logout_rounded,
              size: 18,
              color: Color(0xFFE53935),
            ),
            label: const Text(
              'Log Out',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE53935),
                decoration: TextDecoration.none,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFEF9A9A), width: 1.5),
              backgroundColor: const Color(0xFFFFEBEE),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
