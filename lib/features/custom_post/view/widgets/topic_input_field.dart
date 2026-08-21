import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';

class TopicInputField extends StatelessWidget {
  const TopicInputField({
    super.key,
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What do you want to post about?',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Describe your idea, share a thought, or paste a topic.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 12),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: focusNode.hasFocus
                  ? AppColors.accentSecondary.withValues(alpha: 0.6)
                  : AppColors.glassBorder,
              width: focusNode.hasFocus ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: focusNode.hasFocus
                    ? AppColors.accentSecondary.withValues(alpha: 0.07)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: focusNode.hasFocus ? 14 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            maxLines: 5,
            minLines: 5,
            maxLength: 500,
            textInputAction: TextInputAction.newline,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              height: 1.6,
              decoration: TextDecoration.none,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(16),
              border: InputBorder.none,
              hintText:
                  'e.g. "I just learned about async generators in Dart and '
                  'it changed how I think about streams…"',
              hintStyle: TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                decoration: TextDecoration.none,
              ),
              counterStyle: TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ),
        ),
      ],
    );
  }
}
