import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';

/// The brand mark for the app.
///
/// [size] controls the icon container size.
/// [showLabel] adds the app name below the mark.
/// [showTagline] adds the tagline below the name (only shown if [showLabel] is true).
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 56,
    this.showLabel = true,
    this.showTagline = false,
  });

  final double size;
  final bool showLabel;
  final bool showTagline;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LogoMark(size: size),
        if (showLabel) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.appName,
            style: TextStyle(
              fontSize: size * 0.45,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          if (showTagline) ...[
            const SizedBox(height: AppSpacing.xxs),
            const Text(
              AppStrings.appTagline,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ],
    );
  }
}

/// The square icon mark — a stylised "P" letterform on the brand blue.
class _LogoMark extends StatelessWidget {
  const _LogoMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: AppRadius.radiusMd,
      ),
      child: Center(
        child: Text(
          'P',
          style: TextStyle(
            fontSize: size * 0.50,
            fontWeight: FontWeight.w800,
            color: AppColors.textOnPrimary,
            letterSpacing: -1,
          ),
        ),
      ),
    );
  }
}