import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Reusable page title + subtitle block used at the top of auth screens.
///
/// Renders a large [title] and a smaller [subtitle] below it.
class PageHeading extends StatelessWidget {
  const PageHeading({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            letterSpacing: -0.75,
            height: 1.2,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
  }
}