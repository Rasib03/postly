import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/features/preferences/model/preferences_model.dart';

class TonePickerRow extends StatelessWidget {
  const TonePickerRow({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final WritingTone selected;
  final ValueChanged<WritingTone> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Writing Tone',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: WritingTone.values.map((tone) {
              final isSelected = tone == selected;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => onChanged(tone),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.accentSecondary
                          : AppColors.bgCard,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.accentSecondary
                            : AppColors.glassBorder,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected
                              ? AppColors.accentSecondary.withValues(alpha: 0.2)
                              : Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _emoji(tone),
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(width: 7),
                        Text(
                          tone.label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  String _emoji(WritingTone tone) {
    switch (tone) {
      case WritingTone.professional:
        return '🧑‍💼';
      case WritingTone.casual:
        return '😄';
      case WritingTone.storyteller:
        return '✍️';
    }
  }
}
