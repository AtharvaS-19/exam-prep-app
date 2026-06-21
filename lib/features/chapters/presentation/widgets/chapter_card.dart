import 'package:flutter/material.dart';
import '../../models/chapter.dart';
import '../../../../../shared/constants/app_colors.dart';
import '../../../../../shared/constants/app_radius.dart';
import '../../../../../shared/constants/app_spacing.dart';

/// A card widget displaying individual chapter details, progress, and a CTA.
class ChapterCard extends StatelessWidget {
  const ChapterCard({
    super.key,
    required this.chapter,
    required this.accentColor,
    required this.index,
    required this.onTap,
  });

  final Chapter chapter;
  final Color accentColor;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final String formattedIndex = index.toString().padLeft(2, '0');

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.radiusXl,
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: AppRadius.radiusXl,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Index circle
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            formattedIndex,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: accentColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      // Title & progress label
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chapter.title,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxs),
                            Text(
                              chapter.remainingLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      // CTA Button / Arrow
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            chapter.ctaLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 16,
                            color: accentColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (chapter.isStarted) ...[
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: AppRadius.radiusFull,
                            child: LinearProgressIndicator(
                              value: chapter.progress,
                              minHeight: 4,
                              backgroundColor: AppColors.progressTrack,
                              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '${chapter.progressPercent}%',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
