import 'package:flutter/material.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/constants/app_radius.dart';
import '../../../shared/constants/app_spacing.dart';

/// Progress screen — placeholder for Phase 7.
///
/// Displays the structure of what will be tracked once data flows in.
/// Uses skeleton-style empty stat cards to communicate intent without fake data.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Progress'),
        backgroundColor: AppColors.background,
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
            vertical: AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your progress',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Solve questions to start tracking your accuracy and chapter completion.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              SizedBox(height: AppSpacing.xxl),
              _SectionLabel('Overview'),
              SizedBox(height: AppSpacing.sm),
              _StatCardRow(),
              SizedBox(height: AppSpacing.xxl),
              _SectionLabel('Subject accuracy'),
              SizedBox(height: AppSpacing.sm),
              _SubjectProgressList(),
              SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Sub-widgets ───────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textTertiary,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _StatCardRow extends StatelessWidget {
  const _StatCardRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Questions solved',
            value: '—',
            icon: Icons.check_circle_outline_rounded,
            accentColor: AppColors.primary,
          ),
        ),
        SizedBox(width: AppSpacing.cardGap),
        Expanded(
          child: _StatCard(
            label: 'Accuracy',
            value: '—',
            icon: Icons.track_changes_outlined,
            accentColor: AppColors.success,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: accentColor),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SubjectProgressList extends StatelessWidget {
  const _SubjectProgressList();

  static const List<_SubjectProgressItem> _items = [
    _SubjectProgressItem(
      subject: 'Physics',
      accentColor: AppColors.physicsAccent,
    ),
    _SubjectProgressItem(
      subject: 'Chemistry',
      accentColor: AppColors.chemistryAccent,
    ),
    _SubjectProgressItem(
      subject: 'Mathematics',
      accentColor: AppColors.mathAccent,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _items
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.cardGap),
                child: _SubjectProgressTile(item: item),
              ))
          .toList(),
    );
  }
}

class _SubjectProgressItem {
  const _SubjectProgressItem({
    required this.subject,
    required this.accentColor,
  });

  final String subject;
  final Color accentColor;
}

class _SubjectProgressTile extends StatelessWidget {
  const _SubjectProgressTile({required this.item});
  final _SubjectProgressItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppRadius.radiusLg,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: item.accentColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              item.subject,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          // Progress bar placeholder
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: AppRadius.radiusFull,
              child: LinearProgressIndicator(
                value: 0,
                minHeight: 5,
                backgroundColor: AppColors.progressTrack,
                valueColor: AlwaysStoppedAnimation<Color>(item.accentColor),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          const Text(
            '—',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
