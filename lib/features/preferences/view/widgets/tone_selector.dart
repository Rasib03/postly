import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/features/preferences/model/preferences_model.dart';

class ToneSelector extends StatelessWidget {
  const ToneSelector({
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
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'How should your LinkedIn posts sound?',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 14),
        Column(
          children: WritingTone.values
              .map(
                (tone) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ToneCard(
                    tone: tone,
                    isSelected: selected == tone,
                    onTap: () => onChanged(tone),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

extension _ToneMeta on WritingTone {
  String get emoji {
    switch (this) {
      case WritingTone.professional:
        return '🧑‍💼';
      case WritingTone.casual:
        return '😄';
      case WritingTone.storyteller:
        return '✍️';
    }
  }

  String get description {
    switch (this) {
      case WritingTone.professional:
        return 'Clear, data-backed, and authoritative. Great for B2B content.';
      case WritingTone.casual:
        return 'Conversational and relatable. Drives comments and reactions.';
      case WritingTone.storyteller:
        return 'Narrative-led, personal, and opinionated. Builds followers.';
    }
  }
}

class _ToneCard extends StatelessWidget {
  const _ToneCard({
    required this.tone,
    required this.isSelected,
    required this.onTap,
  });

  final WritingTone tone;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF0073B1).withValues(alpha: 0.06)
              : AppColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF0073B1) : AppColors.glassBorder,
            width: isSelected ? 1.8 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [

            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF0073B1).withValues(alpha: 0.12)
                    : AppColors.bgDeep,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(tone.emoji, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tone.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? const Color(0xFF0073B1)
                          : AppColors.textPrimary,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    tone.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                      height: 1.4,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0073B1)
                      : AppColors.glassBorder,
                  width: isSelected ? 0 : 1.5,
                ),
                color: isSelected
                    ? const Color(0xFF0073B1)
                    : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      size: 13,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
