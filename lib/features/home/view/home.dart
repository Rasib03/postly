import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/features/home/view/widgets/draft_hero_card.dart';
import 'package:postly/features/home/view/widgets/home_bottom_nav.dart';
import 'package:postly/features/home/view/widgets/home_header.dart';
import 'package:postly/features/home/view/widgets/recent_activity_section.dart';
import 'package:postly/features/home/view/widgets/stats_row.dart';
import 'package:postly/features/home/viewmodel/home_viewmodel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _navIndex = 0;
  final HomeViewmodel _vm = Get.find<HomeViewmodel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
      floatingActionButton: _CustomPostFab(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradTop, AppColors.gradBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyHeaderDelegate(
                  child: Container(
                    color: AppColors.bgDeep,
                    padding: const EdgeInsets.fromLTRB(20, 7, 8, 12),
                    child: HomeHeader(vm: _vm),
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    DraftHeroCard(vm: _vm),
                    const SizedBox(height: 20),
                    const StatsRow(),
                    const SizedBox(height: 24),
                    const RecentActivitySection(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomPostFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {},
      backgroundColor: AppColors.accentSecondary,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: const Icon(Icons.add_rounded, size: 22),
      label: const Text(
        'Custom Post',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _StickyHeaderDelegate({required this.child});

  final Widget child;
  static const double _height = 72;

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final hasOverlap = overlapsContent || shrinkOffset > 0;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.bgDeep,
        boxShadow: hasOverlap
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: child,
    );
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) =>
      oldDelegate.child != child;
}
