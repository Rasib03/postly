import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/features/authentication/view/widgets/action_buttons.dart';
import 'package:postly/features/authentication/view/widgets/ambient_background.dart';
import 'package:postly/features/authentication/view/widgets/app_header.dart';
import 'package:postly/features/authentication/view/widgets/feature_card.dart';
import 'package:postly/features/authentication/view/widgets/footer_links.dart';
import 'package:postly/features/authentication/viewmodel/sign_in_viewmodel.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<SignInViewmodel>();
    final size = MediaQuery.sizeOf(context);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.bgDeep,
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            AmbientBackground(size: size),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        size.height - MediaQuery.paddingOf(context).vertical,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(height: 48),
                      const AppHeader(),
                      const SizedBox(height: 40),
                      const FeatureCard(),
                      const SizedBox(height: 48),
                      ActionButtons(vm: vm),
                      const SizedBox(height: 28),
                      const FooterLinks(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            Obx(() {
              if (!vm.isLoading.value) return const SizedBox.shrink();
              return const _LoadingOverlay();
            }),
          ],
        ),
      ),
    );
  }
}

class _LoadingOverlay extends StatelessWidget {
  const _LoadingOverlay();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withValues(alpha: 0.72),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0073B1)),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Connecting to LinkedIn…',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Complete sign-in in the browser',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
