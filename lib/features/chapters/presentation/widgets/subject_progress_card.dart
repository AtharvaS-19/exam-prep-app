import 'package:flutter/material.dart';
import '../../models/chapter.dart';
import '../../../../../shared/constants/app_colors.dart';
import '../../../../../shared/constants/app_radius.dart';
import '../../../../../shared/constants/app_spacing.dart';

/// Displays the overall progress summary for a subject.
///
/// Derives all values from [chapters] — no external state needed.
/// Reusable across any screen that needs a subject-level progress overview.
class SubjectProgressCard extends StatelessWidget {
  const SubjectProgressCard({
    super.key,
    required this.chapters,
    required this.accentColor,
  });

  final List<Chapter> chapters;
  final Color accentColor;

  int get _totalQuestions =>
      chapters.fold(0, (sum, c) => sum + c.totalQuestions);

  int get _completedQuestions =>
      chapters.fold(0, (sum, c) => sum + c.completedQuestions);

  double get _overallProgress =>
      _totalQuestions == 0 ? 0.0 : _completedQuestions / _totalQuestions;

  int get _overallPercent => (_overallProgress * 100).round();

  int get _chaptersCompleted =>
      chapters.where((c) => c.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.radiusXl,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: percent + chapters done
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overall progress',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiary,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '$_overallPercent',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              color: accentColor,
                              letterSpacing: -1.5,
                              height: 1.0,
                            ),
                          ),
                          const TextSpan(
                            text: '%',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textTertiary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Stats column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StatBadge(
                    value: '$_completedQuestions / $_totalQuestions',
                    label: 'questions',
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  _StatBadge(
                    value: '$_chaptersCompleted / ${chapters.length}',
                    label: 'chapters done',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Progress bar
          ClipRRect(
            borderRadius: AppRadius.radiusFull,
            child: LinearProgressIndicator(
              value: _overallProgress,
              minHeight: 7,
              backgroundColor: AppColors.progressTrack,
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  const _StatBadge({required this.value, required this.label});
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: AppColors.textTertiary,
          ),
        ),
      ],
    );
  }
}