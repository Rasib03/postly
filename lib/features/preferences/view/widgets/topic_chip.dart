import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/features/preferences/model/preferences_model.dart';

class TopicChipsGrid extends StatelessWidget {
  const TopicChipsGrid({
    super.key,
    required this.topics,
    required this.selected,
    required this.onToggle,
  });

  final List<TopicItem> topics;
  final Set<String> selected;
  final ValueChanged<TopicItem> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Your Interests',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: selected.isEmpty
                  ? const SizedBox.shrink()
                  : Container(
                      key: ValueKey(selected.length),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentSecondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${selected.length}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
            ),
          ],
        ),

        const SizedBox(height: 14),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: topics
              .map(
                (t) => _TopicChip(
                  topic: t,
                  isSelected: selected.contains(t.label),
                  onTap: () => onToggle(t),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({
    required this.topic,
    required this.isSelected,
    required this.onTap,
  });

  final TopicItem topic;
  final bool isSelected;
  final VoidCallback onTap;

  static const _selectedBg = Color(0xFF0073B1);
  static const _selectedBorder = Color(0xFF005885);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _selectedBg : AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _selectedBorder : AppColors.glassBorder,
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: _selectedBg.withValues(alpha: 0.25),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(topic.emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 7),
            Text(
              topic.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                decoration: TextDecoration.none,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              const Icon(Icons.check_rounded, size: 14, color: Colors.white),
            ],
          ],
        ),
      ),
    );
  }
}
