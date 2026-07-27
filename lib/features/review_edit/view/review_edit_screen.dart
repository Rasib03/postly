import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/features/review_edit/model/draft_post.dart';
import 'package:postly/features/review_edit/view/widgets/ai_assist_bar.dart';
import 'package:postly/features/review_edit/view/widgets/post_action_bar.dart';
import 'package:postly/features/review_edit/view/widgets/post_editor_field.dart';
import 'package:postly/features/review_edit/view/widgets/source_banner.dart';

class ReviewEditScreen extends StatefulWidget {
  const ReviewEditScreen({super.key, this.draft});

  final DraftPost? draft;

  @override
  State<ReviewEditScreen> createState() => _ReviewEditScreenState();
}

class _ReviewEditScreenState extends State<ReviewEditScreen> {
  late final TextEditingController _bodyCtrl;
  late final FocusNode _focusNode;

  bool _isPublishing = false;

  DraftPost get _draft => widget.draft ?? DraftPostMock.sample;

  @override
  void initState() {
    super.initState();
    _bodyCtrl = TextEditingController(text: _draft.body);
    _focusNode = FocusNode();
    _focusNode.addListener(() => setState(() {}));
    _bodyCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _bodyCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onAiAction(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✨ Applying "$label"…',
          style: const TextStyle(decoration: TextDecoration.none),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.textPrimary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onPublish() {
    setState(() => _isPublishing = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isPublishing = false);
    });
  }

  void _onSaveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          '📋 Draft saved',
          style: TextStyle(decoration: TextDecoration.none),
        ),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF1B5E20),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onRegenerate() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _RegenerateSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final charCount = _bodyCtrl.text.length;

    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      resizeToAvoidBottomInset: true,
      appBar: _ReviewEditAppBar(onRegenerate: _onRegenerate),
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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SourceBanner(
                      sourceTag: _draft.sourceTag,
                      articleTitle: _draft.articleTitle,
                      articleUrl: _draft.articleUrl,
                      onOpenLink: () {},
                    ),
                    const SizedBox(height: 16),
                    PostEditorField(
                      controller: _bodyCtrl,
                      focusNode: _focusNode,
                      charCount: charCount,
                    ),
                    const SizedBox(height: 20),
                    AiAssistBar(onAction: _onAiAction),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            PostActionBar(
              isPublishing: _isPublishing,
              onPublish: _onPublish,
              onSaveDraft: _onSaveDraft,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewEditAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ReviewEditAppBar({required this.onRegenerate});

  final VoidCallback onRegenerate;

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
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.accentSecondary,
          size: 20,
        ),
      ),
      title: const Text(
        'Review & Edit Post',
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          decoration: TextDecoration.none,
        ),
      ),
      centerTitle: true,
      actions: [
        // Regenerate AI button
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: IconButton(
            onPressed: onRegenerate,
            tooltip: 'Regenerate with AI',
            icon: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.accentGlow,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.accentPrimary.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: AppColors.accentPrimary,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RegenerateSheet extends StatelessWidget {
  const _RegenerateSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: AppColors.glassBorder,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Container(
            width: 52,
            height: 52,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: AppColors.accentGlow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.accentPrimary,
              size: 26,
            ),
          ),
          const Text(
            'Regenerate Post?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This will replace your current draft with a new\n'
            'AI-generated version based on the same article.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'Yes, Regenerate',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  decoration: TextDecoration.none,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
