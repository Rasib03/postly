import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/app/app_strings.dart';
import 'package:postly/features/authentication/view/widgets/feature_tile.dart';
import 'package:postly/features/authentication/view/widgets/glass_container.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key});

  static const List<FeatureItem> _features = [
    FeatureItem(
      icon: CupertinoIcons.sparkles,
      title: AppStrings.featureOneTitle,
      subtitle: AppStrings.featureOneSubtitle,
    ),
    FeatureItem(
      icon: CupertinoIcons.paperplane_fill,
      title: AppStrings.featureTwoTitle,
      subtitle: AppStrings.featureTwoSubtitle,
    ),
    FeatureItem(
      icon: CupertinoIcons.slider_horizontal_3,
      title: AppStrings.featureThreeTitle,
      subtitle: AppStrings.featureThreeSubtitle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      borderRadius: 24,
      child: Column(
        children: [
          for (int i = 0; i < _features.length; i++) ...[
            FeatureTile(feature: _features[i]),
            if (i < _features.length - 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Divider(
                  color: AppColors.glassBorder,
                  thickness: 0.5,
                  indent: 52,
                ),
              ),
          ],
        ],
      ),
    );
  }
}
