import 'package:flutter/material.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/features/home/model/post_history_item.dart';

// ── Mock data ─────────────────────────────────────────────────────────────────
const List<PostHistoryItem> _mockHistory = [
  PostHistoryItem(
    dateLabel: 'Yesterday at 9:00 AM',
    teaser:
        'The future of AI agents is here — and it\'s more collaborative than you think. '
        'Here\'s what OpenAI\'s latest paper really means for engineers...',
    status: PostStatus.published,
    linkedInUrl: 'https://linkedin.com',
  ),
  PostHistoryItem(
    dateLabel: 'Today at 2:30 PM',
    teaser:
        'Apple\'s Vision Pro SDK is quietly becoming the most interesting dev platform '
        'of 2026. 3 things I noticed this week 👇',
    status: PostStatus.scheduled,
    linkedInUrl: 'https://linkedin.com',
  ),
  PostHistoryItem(
    dateLabel: 'Jul 24 at 8:00 AM',
    teaser:
        'Rust in the kernel — 3 years later. What actually changed, what didn\'t, '
        'and why it matters more than the headlines suggest.',
    status: PostStatus.published,
    linkedInUrl: 'https://linkedin.com',
  ),
];

// ── Section ───────────────────────────────────────────────────────────────────
class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                decoration: TextDecoration.none,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.accentPrimary,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        // Feed items
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _mockHistory.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => _ActivityCard(item: _mockHistory[i]),
        ),
      ],
    );
  }
}

// ── Activity card ─────────────────────────────────────────────────────────────
class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.item});

  final PostHistoryItem item;

  @override
  Widget build(BuildContext context) {
    final isPublished = item.status == PostStatus.published;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: time + status tag ──────────────────────────────
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 13,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Text(
                item.dateLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  decoration: TextDecoration.none,
                ),
              ),
              const Spacer(),
              _StatusTag(isPublished: isPublished),
            ],
          ),

          const SizedBox(height: 10),

          // ── Teaser text ─────────────────────────────────────────────
          Text(
            item.teaser,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.5,
              decoration: TextDecoration.none,
            ),
          ),

          const SizedBox(height: 10),

          // ── View on LinkedIn ────────────────────────────────────────
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.open_in_new_rounded, size: 13),
              label: const Text('View on LinkedIn'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.accentSecondary,
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.none,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Status tag ────────────────────────────────────────────────────────────────
class _StatusTag extends StatelessWidget {
  const _StatusTag({required this.isPublished});

  final bool isPublished;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
      decoration: BoxDecoration(
        color: isPublished ? const Color(0xFFE8F5E9) : const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPublished
              ? const Color(0xFFA5D6A7)
              : const Color(0xFFFFE082),
        ),
      ),
      child: Text(
        isPublished ? '✅ Published' : '⏳ Scheduled',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isPublished
              ? const Color(0xFF2E7D32)
              : const Color(0xFFF57F17),
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}
