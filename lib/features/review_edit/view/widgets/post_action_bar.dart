import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';

class PostActionBar extends StatelessWidget {
  const PostActionBar({
    super.key,
    required this.onPublish,
    required this.onSaveDraft,
    this.isPublishing = false,
  });

  final VoidCallback onPublish;
  final VoidCallback onSaveDraft;
  final bool isPublishing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: const Border(top: BorderSide(color: AppColors.glassBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: OutlinedButton.icon(
              onPressed: isPublishing ? null : onSaveDraft,
              icon: const Icon(Icons.bookmark_border_rounded, size: 18),
              label: const Text(
                'Save Draft',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(
                  color: AppColors.glassBorder,
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: isPublishing ? null : onPublish,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0073B1),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(
                  0xFF0073B1,
                ).withValues(alpha: 0.6),
                elevation: isPublishing ? 0 : 4,
                shadowColor: const Color(0xFF0073B1).withValues(alpha: 0.4),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
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
