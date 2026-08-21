import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/features/authentication/view/widgets/glow_orb.dart';

class AmbientBackground extends StatelessWidget {
  const AmbientBackground({super.key, required this.size});

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.gradTop, AppColors.gradBottom],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),

        Positioned(
          top: -60,
          left: -40,
          child: GlowOrb(
            size: 260,
            color: AppColors.accentPrimary.withValues(alpha: 0.18),
          ),
        ),

        Positioned(
          bottom: size.height * 0.1,
          right: -60,
          child: GlowOrb(
            size: 220,
            color: AppColors.accentSecondary.withValues(alpha: 0.2),
          ),
        ),
      ],
    );
  }
}
