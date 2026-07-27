import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';

class PostEditorField extends StatelessWidget {
  const PostEditorField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.charCount,
    this.maxChars = 3000,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final int charCount;
  final int maxChars;

  Color _counterColor() {
    final ratio = charCount / maxChars;
    if (ratio >= 0.95) return const Color(0xFFE53935);
    if (ratio >= 0.80) return const Color(0xFFF57C00);
    return AppColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                ? AppColors.accentSecondary.withValues(alpha: 0.08)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: focusNode.hasFocus ? 14 : 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            maxLines: null,
            minLines: 10,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.textPrimary,
              height: 1.6,
              decoration: TextDecoration.none,
            ),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              border: InputBorder.none,
              hintText: 'Your AI-generated post appears here…',
              hintStyle: TextStyle(
                color: AppColors.textMuted,
                fontSize: 15,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                // Word count
                Icon(
                  Icons.text_fields_rounded,
                  size: 13,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  '${_wordCount(controller.text)} words',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    decoration: TextDecoration.none,
                  ),
                ),
                const Spacer(),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _counterColor(),
                    decoration: TextDecoration.none,
                  ),
                  child: Text('$charCount / $maxChars chars'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static int _wordCount(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return 0;
    return trimmed.split(RegExp(r'\s+')).length;
  }
}
