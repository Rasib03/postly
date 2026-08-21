import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/app/app_strings.dart';
import 'package:postly/features/authentication/view/widgets/glass_container.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GlassContainer(
          padding: const EdgeInsets.all(20),
          borderRadius: 28,
          child: ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [AppColors.accentPrimary, AppColors.accentSecondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: const Icon(
              CupertinoIcons.bolt_fill,
              size: 44,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 24),
        const Text(
          AppStrings.appName,
          style: TextStyle(
            fontFamily: '.SF Pro Display',
            fontSize: 34,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.5,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.accentGlow,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.accentPrimary.withValues(alpha: 0.25),
            ),
          ),
          child: const Text(
            AppStrings.appTagline,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: '.SF Pro Text',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.accentPrimary,
              letterSpacing: 0.1,
            ),
          ),
        ),
      ],
    );
  }
}
