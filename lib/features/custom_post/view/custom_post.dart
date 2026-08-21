import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/features/custom_post/view/widgets/custom_post_appbar.dart';
import 'package:postly/features/custom_post/view/widgets/generate_button.dart';
import 'package:postly/features/custom_post/view/widgets/generated_preview_card.dart';
import 'package:postly/features/custom_post/view/widgets/tone_picker_row.dart';
import 'package:postly/features/custom_post/view/widgets/topic_input_field.dart';
import 'package:postly/features/custom_post/viewmodel/custom_post_viewmodel.dart';
import 'package:postly/features/preferences/model/preferences_model.dart';

class CustomPost extends StatefulWidget {
  const CustomPost({super.key});

  @override
  State<CustomPost> createState() => _CustomPostState();
}

class _CustomPostState extends State<CustomPost> {
  late final CustomPostViewmodel _vm;
  late final TextEditingController _topicCtrl;
  late final TextEditingController _outputCtrl;
  late final FocusNode _topicFocus;
  late final FocusNode _outputFocus;

  WritingTone _selectedTone = WritingTone.professional;

  @override
  void initState() {
    super.initState();
    _vm = Get.find<CustomPostViewmodel>();
    _topicCtrl = TextEditingController();
    _outputCtrl = TextEditingController();
    _topicFocus = FocusNode()..addListener(() => setState(() {}));
    _outputFocus = FocusNode()..addListener(() => setState(() {}));

    _topicCtrl.addListener(() => setState(() {}));
    _outputCtrl.addListener(() => setState(() {}));

    ever(_vm.generatedPost, (String text) {
      if (text.isNotEmpty) {
        _outputCtrl.text = text;
        _outputCtrl.selection = TextSelection.collapsed(offset: text.length);
      }
    });
  }

  @override
  void dispose() {
    _topicCtrl.dispose();
    _outputCtrl.dispose();
    _topicFocus.dispose();
    _outputFocus.dispose();
    super.dispose();
  }

  void _onGenerate() {
    FocusScope.of(context).unfocus();
    _vm.generate(topic: _topicCtrl.text.trim(), tone: _selectedTone);
  }

  void _onPublish() {
    _vm.publish(postText: _outputCtrl.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      appBar: const CustomPostAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.gradTop, AppColors.gradBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TopicInputField(
                      controller: _topicCtrl,
                      focusNode: _topicFocus,
                    ),

                    const SizedBox(height: 28),

                    TonePickerRow(
                      selected: _selectedTone,
                      onChanged: (t) => setState(() => _selectedTone = t),
                    ),

                    const SizedBox(height: 28),

                    Obx(
                      () => GenerateButton(
                        isGenerating: _vm.isGenerating.value,
                        canGenerate: _topicCtrl.text.trim().length >= 10,
                        onTap: _onGenerate,
                      ),
                    ),

                    const SizedBox(height: 28),

                    Obx(() {
                      if (_vm.generatedPost.value.isEmpty &&
                          !_vm.isGenerating.value) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          const _SectionDivider(),
                          const SizedBox(height: 20),
                          GeneratedPreviewCard(
                            controller: _outputCtrl,
                            focusNode: _outputFocus,
                            charCount: _outputCtrl.text.length,
                          ),
                          const SizedBox(height: 20),
                          _PublishBar(
                            isPublishing: _vm.isPublishing.value,
                            canPublish: _outputCtrl.text.trim().isNotEmpty,
                            onPublish: _onPublish,
                          ),
                        ],
                      );
                    }),

                    SizedBox(height: bottomPadding + 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.glassBorder, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.accentGlow,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accentPrimary.withValues(alpha: 0.25),
              ),
            ),
            child: const Text(
              'Generated Post',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.accentPrimary,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.glassBorder, thickness: 1)),
      ],
    );
  }
}

class _PublishBar extends StatelessWidget {
  const _PublishBar({
    required this.isPublishing,
    required this.canPublish,
    required this.onPublish,
  });

  final bool isPublishing;
  final bool canPublish;
  final VoidCallback onPublish;

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(16, 14, 16, bottomPadding + 14),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: (canPublish && !isPublishing) ? onPublish : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0073B1),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(
                  0xFF0073B1,
                ).withValues(alpha: 0.5),
                elevation: canPublish ? 4 : 0,
                shadowColor: const Color(0xFF0073B1).withValues(alpha: 0.35),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isPublishing
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Publish to LinkedIn',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text('🚀', style: TextStyle(fontSize: 14)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
