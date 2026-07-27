import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/features/preferences/model/preferences_model.dart';
import 'package:postly/features/preferences/view/widgets/preferences_actions.dart';
import 'package:postly/features/preferences/view/widgets/preferences_header.dart';
import 'package:postly/features/preferences/view/widgets/tone_selector.dart';
import 'package:postly/features/preferences/view/widgets/topic_chip.dart';
import 'package:postly/features/preferences/viewmodel/preferences_viewmodel.dart';

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<PreferencesViewmodel>();
    final bottomPadding = MediaQuery.viewInsetsOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradTop, AppColors.gradBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (vm.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0073B1)),
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      24,
                      28,
                      24,
                      bottomPadding + 16,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PreferencesHeader(),
                        const SizedBox(height: 32),
                        _SectionDivider(
                          icon: Icons.interests_rounded,
                          label: 'Topics',
                          color: const Color(0xFF0073B1),
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => TopicChipsGrid(
                            topics: PreferencesData.topics,
                            selected: vm.selectedTopics.toSet(),
                            onToggle: vm.toggleTopic,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _SectionDivider(
                          icon: Icons.edit_note_rounded,
                          label: 'Writing Tone',
                          color: const Color(0xFF7B1FA2),
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => ToneSelector(
                            selected: vm.selectedTone.value,
                            onChanged: vm.setTone,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                _BottomActionBar(vm: vm),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 17, color: color),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.5,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Divider(color: AppColors.glassBorder, thickness: 1),
        ),
      ],
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({required this.vm});

  final PreferencesViewmodel vm;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: Obx(
        () => PreferencesActions(
          canSave: vm.selectedTopics.isNotEmpty && !vm.isSaving.value,
          onSave: vm.saveAndContinue,
          onSkip: vm.skip,
        ),
      ),
    );
  }
}
