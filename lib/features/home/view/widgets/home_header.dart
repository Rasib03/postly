import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/features/home/viewmodel/home_viewmodel.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.vm});

  final HomeViewmodel vm;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Obx(
          () => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accentPrimary, width: 2),
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.accentGlow,

              backgroundImage: vm.hasPicture
                  ? NetworkImage(vm.profilePicture)
                  : null,
              child: vm.hasPicture
                  ? null
                  : Text(
                      vm.initials.isEmpty ? '?' : vm.initials,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentPrimary,
                        decoration: TextDecoration.none,
                      ),
                    ),
            ),
          ),
        ),

        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  'Hello, ${vm.firstName.isEmpty ? 'there' : vm.firstName} 👋',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              _LinkedInChip(vm: vm),
            ],
          ),
        ),

        IconButton(
          onPressed: () {
            vm.settingsTapped();
          },
          icon: const Icon(
            CupertinoIcons.settings,
            color: AppColors.textSecondary,
            size: 22,
          ),
        ),
      ],
    );
  }
}

class _LinkedInChip extends StatelessWidget {
  const _LinkedInChip({required this.vm});

  final HomeViewmodel vm;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isConnected = vm.isConnected;

      final backgroundColor = isConnected
          ? const Color(0xFFE8F5E9)
          : const Color(0xFFFFEBEE);

      final borderColor = isConnected
          ? const Color(0xFFA5D6A7)
          : const Color(0xFFEF9A9A);

      final dotColor = isConnected
          ? const Color(0xFF43A047)
          : const Color(0xFFE53935);

      final textColor = isConnected
          ? const Color(0xFF2E7D32)
          : const Color(0xFFC62828);

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(radius: 4, backgroundColor: dotColor),
            const SizedBox(width: 5),
            Text(
              isConnected ? 'LinkedIn Connected' : 'LinkedIn Disconnected',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: textColor,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      );
    });
  }
}
