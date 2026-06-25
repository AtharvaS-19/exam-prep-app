import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/constants/app_radius.dart';
import '../../../shared/constants/app_spacing.dart';
import '../../../shared/constants/app_strings.dart';

/// The Home screen — improved for Phase 1.5 (Navigation Shell).
///
/// Changes from prototype:
/// - Removed Scaffold (the shell's Scaffold wraps all tabs)
/// - Quick access cards now navigate to their respective tabs
/// - Typography and spacing tightened for better hierarchy
/// - Section label style aligned to the rest of the shell
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              AppSpacing.xl,
              AppSpacing.screenHorizontal,
              AppSpacing.xxl,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _HomeHeader(),
                const SizedBox(height: AppSpacing.xxl),
                const _ContinuePracticingCard(),
                const SizedBox(height: AppSpacing.xxl),
                const _SectionLabel('Quick access'),
                const SizedBox(height: AppSpacing.md),
                const _QuickAccessGrid(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ─────────────────────────────────────────────────────────────────────

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, Arjun 👋',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 20,
                      letterSpacing: -0.4,
                    ),
              ),
              const SizedBox(height: 3),
              Text(
                'Ready to solve some questions?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        const _Avatar(initial: 'A'),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial});
  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(11),
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

// ── Continue practicing card ───────────────────────────────────────────────────

class _ContinuePracticingCard extends StatelessWidget {
  const _ContinuePracticingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.radiusXl,
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          const _Badge(label: 'Physics · JEE Main'),
          const SizedBox(height: AppSpacing.sm),
          // Chapter title
          const Text(
            'Kinematics',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 3),
          const Text(
            '76 of 120 questions solved',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Progress
          ClipRRect(
            borderRadius: AppRadius.radiusFull,
            child: LinearProgressIndicator(
              value: 0.63,
              minHeight: 5,
              backgroundColor: Colors.white.withValues(alpha: 0.22),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '63% complete',
                style: TextStyle(fontSize: 12, color: Colors.white60),
              ),
              Text(
                '44 remaining',
                style: TextStyle(fontSize: 12, color: Colors.white60),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          // CTA
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.radiusMd,
                ),
              ),
              child: const Text(
                AppStrings.continueButton,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.1,
        ),
      ),
    );
  }
}

// ── Section label ──────────────────────────────────────────────────────────────

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

// ── Quick access grid ──────────────────────────────────────────────────────────

class _QuickAccessGrid extends StatelessWidget {
  const _QuickAccessGrid();

  @override
  Widget build(BuildContext context) {
    final items = <_QuickAccessItem>[
      _QuickAccessItem(
        label: AppStrings.subjects,
        subtitle: AppStrings.subjectsSubtitle,
        icon: Icons.grid_view_outlined,
        accentColor: AppColors.physicsAccent,
        onTap: () => context.go('/subjects'),
      ),
      _QuickAccessItem(
        label: AppStrings.bookmarks,
        subtitle: AppStrings.bookmarksSubtitle,
        icon: Icons.bookmark_outline_rounded,
        accentColor: AppColors.mathAccent,
        onTap: () => context.go('/bookmarks'),
      ),
      _QuickAccessItem(
        label: AppStrings.wrongQuestions,
        subtitle: AppStrings.wrongQuestionsSubtitle,
        icon: Icons.highlight_off_outlined,
        accentColor: AppColors.error,
        onTap: () => context.go('/mistakes'),
      ),
      _QuickAccessItem(
        label: AppStrings.progress,
        subtitle: AppStrings.progressSubtitle,
        icon: Icons.bar_chart_outlined,
        accentColor: AppColors.chemistryAccent,
        onTap: () => context.go('/progress'),
      ),
      _QuickAccessItem(
        label: AppStrings.books,
        subtitle: AppStrings.booksSubtitle,
        icon: Icons.menu_book_outlined,
        accentColor: AppColors.biologyAccent,
        onTap: () {},
      ),
    ];

    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      final isLastOdd = i + 1 >= items.length;
      rows.add(Row(
        children: [
          Expanded(child: _QuickAccessCard(item: items[i])),
          if (!isLastOdd) ...[
            const SizedBox(width: AppSpacing.cardGap),
            Expanded(child: _QuickAccessCard(item: items[i + 1])),
          ] else
            const Expanded(child: SizedBox()),
        ],
      ));
      if (i + 2 < items.length) {
        rows.add(const SizedBox(height: AppSpacing.cardGap));
      }
    }

    return Column(children: rows);
  }
}

class _QuickAccessItem {
  const _QuickAccessItem({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback onTap;
}

class _QuickAccessCard extends StatelessWidget {
  const _QuickAccessCard({required this.item});
  final _QuickAccessItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
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
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: item.accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(item.icon, size: 17, color: item.accentColor),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              item.label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                letterSpacing: -0.1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.subtitle,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppColors.textTertiary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}