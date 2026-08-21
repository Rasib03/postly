import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/app/app_strings.dart';
import 'package:postly/features/splash/viewmodel/splash_viewmodel.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  late final AnimationController _logoCtrl;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;

  late final AnimationController _titleCtrl;
  late final Animation<double> _titleSlide;
  late final Animation<double> _titleOpacity;

  late final AnimationController _taglineCtrl;
  late final Animation<double> _taglineOpacity;

  late final AnimationController _loaderCtrl;

  @override
  void initState() {
    super.initState();
    Get.find<SplashViewmodel>();
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoScale = CurvedAnimation(
      parent: _logoCtrl,
      curve: Curves.elasticOut,
    ).drive(Tween<double>(begin: 0.4, end: 1.0));
    _logoOpacity = CurvedAnimation(
      parent: _logoCtrl,
      curve: const Interval(0.0, 0.5),
    ).drive(Tween<double>(begin: 0.0, end: 1.0));

    _titleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _titleSlide = CurvedAnimation(
      parent: _titleCtrl,
      curve: Curves.easeOutCubic,
    ).drive(Tween<double>(begin: 18.0, end: 0.0));
    _titleOpacity = CurvedAnimation(
      parent: _titleCtrl,
      curve: Curves.easeIn,
    ).drive(Tween<double>(begin: 0.0, end: 1.0));

    _taglineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _taglineOpacity = CurvedAnimation(
      parent: _taglineCtrl,
      curve: Curves.easeIn,
    ).drive(Tween<double>(begin: 0.0, end: 1.0));

    _loaderCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _logoCtrl.forward().whenComplete(() {
      _titleCtrl.forward().whenComplete(() {
        _taglineCtrl.forward();
      });
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _titleCtrl.dispose();
    _taglineCtrl.dispose();
    _loaderCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return CupertinoPageScaffold(
      backgroundColor: AppColors.bgDeep,
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            _AmbientBg(size: size),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _logoCtrl,
                    builder: (_, __) => Opacity(
                      opacity: _logoOpacity.value,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: const _LogoBadge(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),
                  AnimatedBuilder(
                    animation: _titleCtrl,
                    builder: (_, __) => Opacity(
                      opacity: _titleOpacity.value,
                      child: Transform.translate(
                        offset: Offset(0, _titleSlide.value),
                        child: const Text(
                          AppStrings.appName,
                          style: TextStyle(
                            fontFamily: '.SF Pro Display',
                            fontSize: 38,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.8,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),
                  AnimatedBuilder(
                    animation: _taglineCtrl,
                    builder: (_, __) => Opacity(
                      opacity: _taglineOpacity.value,
                      child: const _TaglinePill(),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 64,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _taglineCtrl,
                builder: (_, __) => Opacity(
                  opacity: _taglineOpacity.value,
                  child: Center(child: _PulsingDots(controller: _loaderCtrl)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: AppColors.glassFill,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.glassBorder, width: 0.8),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentPrimary.withValues(alpha: 0.22),
                blurRadius: 40,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.accentPrimary, AppColors.accentSecondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: const Icon(
                CupertinoIcons.bolt_fill,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaglinePill extends StatelessWidget {
  const _TaglinePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accentGlow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accentPrimary.withValues(alpha: 0.25),
        ),
      ),
      child: const Text(
        AppStrings.appTagline,
        style: TextStyle(
          fontFamily: '.SF Pro Text',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.accentPrimary,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

class _PulsingDots extends StatelessWidget {
  const _PulsingDots({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        final offset = i / 3.0;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: AnimatedBuilder(
            animation: controller,
            builder: (_, __) {
              final phase = (controller.value + offset) % 1.0;
              final t = phase < 0.5 ? phase * 2 : (1.0 - phase) * 2;
              final scale = 0.6 + 0.4 * t;
              final opacity = 0.35 + 0.65 * t;
              return Opacity(
                opacity: opacity,
                child: Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentPrimary,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentPrimary.withValues(
                            alpha: 0.5 * t,
                          ),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _AmbientBg extends StatelessWidget {
  const _AmbientBg({required this.size});

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
          top: -80,
          left: -60,
          child: _Orb(
            size: 300,
            color: AppColors.accentPrimary.withValues(alpha: 0.14),
          ),
        ),
        Positioned(
          bottom: size.height * 0.08,
          right: -70,
          child: _Orb(
            size: 240,
            color: AppColors.accentSecondary.withValues(alpha: 0.18),
          ),
        ),
      ],
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size * 0.8,
            spreadRadius: size * 0.2,
          ),
        ],
      ),
    );
  }
}
