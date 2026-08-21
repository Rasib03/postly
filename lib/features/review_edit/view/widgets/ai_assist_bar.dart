import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';

class _AiAction {
  const _AiAction({
    required this.emoji,
    required this.label,
    required this.accentColor,
    required this.bgColor,
  });

  final String emoji;
  final String label;
  final Color accentColor;
  final Color bgColor;
}

class AiAssistBar extends StatelessWidget {
  const AiAssistBar({super.key, required this.onAction});

  final ValueChanged<String> onAction;

  static const List<_AiAction> _actions = [
    _AiAction(
      emoji: '✨',
      label: 'Make shorter',
      accentColor: Color(0xFF7B1FA2),
      bgColor: Color(0xFFF3E5F5),
    ),
    _AiAction(
      emoji: '🔥',
      label: 'Add stronger hook',
      accentColor: Color(0xFFE64A19),
      bgColor: Color(0xFFFBE9E7),
    ),
    _AiAction(
      emoji: '🏷️',
      label: 'Add hashtags',
      accentColor: Color(0xFF00838F),
      bgColor: Color(0xFFE0F7FA),
    ),
    _AiAction(
      emoji: '💼',
      label: 'Professional tone',
      accentColor: AppColors.accentSecondary,
      bgColor: Color(0xFFE3F2FD),
    ),
    _AiAction(
      emoji: '📏',
      label: 'Make longer',
      accentColor: Color(0xFF388E3C),
      bgColor: Color(0xFFE8F5E9),
    ),
    _AiAction(
      emoji: '😊',
      label: 'Casual tone',
      accentColor: Color(0xFFF57C00),
      bgColor: Color(0xFFFFF3E0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Padding(
          padding: EdgeInsets.only(left: 2, bottom: 10),
          child: Row(
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 14,
                color: AppColors.accentPrimary,
              ),
              SizedBox(width: 6),
              Text(
                'AI ASSIST',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentPrimary,
                  letterSpacing: 0.8,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: _actions
                .map(
                  (action) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _AiChip(action: action, onTap: onAction),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _AiChip extends StatelessWidget {
  const _AiChip({required this.action, required this.onTap});

  final _AiAction action;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(action.label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: action.bgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: action.accentColor.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: action.accentColor.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(action.emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(
              action.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: action.accentColor,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
