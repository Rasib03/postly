import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/core/widgets/legal_sheet.dart';
import 'package:postly/features/settings/view/widgets/profile_card.dart';
import 'package:postly/features/settings/view/widgets/settings_footer.dart';
import 'package:postly/features/settings/view/widgets/settings_section.dart';
import 'package:postly/features/settings/viewmodel/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Get.find<SettingsViewmodel>();

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: _SettingsAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradTop, AppColors.gradBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
          children: [
            Obx(
              () => ProfileCard(
                name: vm.fullName,
                email: vm.email.value,
                initials: vm.initials,
                avatarUrl: vm.hasPicture ? vm.profilePictureUrl.value : null,
                isConnected: vm.isConnected.value,
              ),
            ),
            const SizedBox(height: 28),
            SettingsSection(
              title: 'Content Preferences',
              icon: Icons.tune_rounded,
              iconColor: AppColors.accentPrimary,
              children: [
                Obx(
                  () => SettingsNavTile(
                    icon: Icons.interests_rounded,
                    iconBg: AppColors.accentPrimary,
                    title: 'Topics & Interests',
                    subtitle: vm.topicsSummary,
                    onTap: vm.navigateToPreferences,
                  ),
                ),
                Obx(
                  () => SettingsNavTile(
                    icon: Icons.edit_note_rounded,
                    iconBg: const Color(0xFF7B1FA2),
                    title: 'Default Post Tone',
                    trailing: _ToneTrailing(tone: vm.selectedTone.value.label),
                    onTap: () => vm.openTonePicker(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SettingsSection(
              title: 'App Preferences',
              icon: CupertinoIcons.settings_solid,
              iconColor: AppColors.textSecondary,
              children: [
                Obx(
                  () => SettingsToggleTile(
                    icon: Icons.notifications_rounded,
                    iconBg: const Color(0xFFF57C00),
                    title: 'Daily Post Reminders',
                    subtitle: 'Get notified when your draft is ready',
                    value: vm.dailyReminders.value,
                    onChanged: vm.toggleDailyReminders,
                  ),
                ),
                SettingsNavTile(
                  icon: Icons.privacy_tip_rounded,
                  iconBg: const Color(0xFF1565C0),
                  title: 'Privacy Policy',
                  onTap: () => LegalSheet.showPrivacy(context),
                ),
                SettingsNavTile(
                  icon: Icons.gavel_rounded,
                  iconBg: const Color(0xFF558B2F),
                  title: 'Terms of Service',
                  onTap: () => LegalSheet.showTerms(context),
                ),
              ],
            ),
            const SizedBox(height: 36),
            SettingsFooter(onLogOut: () => _confirmLogOut(context, vm)),
          ],
        ),
      ),
    );
  }

  void _confirmLogOut(BuildContext context, SettingsViewmodel vm) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Log Out?',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            decoration: TextDecoration.none,
          ),
        ),
        content: const Text(
          'You will be signed out and returned to the sign-in screen.',
          style: TextStyle(
            color: AppColors.textSecondary,
            decoration: TextDecoration.none,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          Obx(
            () => TextButton(
              onPressed: vm.isLoading.value
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      vm.logOut();
                    },
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFE53935),
              ),
              child: vm.isLoading.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Log Out'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bgDeep,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black12,
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: () => Navigator.of(context).maybePop(),
        child: const Icon(
          CupertinoIcons.chevron_left,
          color: AppColors.accentSecondary,
          size: 22,
        ),
      ),
      title: const Text(
        'Settings',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          decoration: TextDecoration.none,
        ),
      ),
      centerTitle: true,
    );
  }
}

class _ToneTrailing extends StatelessWidget {
  const _ToneTrailing({required this.tone});

  final String tone;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 130),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF3E5F5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFCE93D8)),
          ),
          child: Text(
            tone,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7B1FA2),
              decoration: TextDecoration.none,
            ),
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textMuted,
          size: 20,
        ),
      ],
    );
  }
}
