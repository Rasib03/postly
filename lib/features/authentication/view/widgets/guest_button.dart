import 'package:flutter/cupertino.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/app/app_strings.dart';
import 'package:postly/features/authentication/view/widgets/glass_container.dart';

class GuestButton extends StatelessWidget {
  const GuestButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: EdgeInsets.zero,
        borderRadius: 16,
        child: SizedBox(
          height: 52,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.play_rectangle,
                color: AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 10),
              const Text(
                AppStrings.continueAsGuest,
                style: TextStyle(
                  fontFamily: '.SF Pro Text',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
