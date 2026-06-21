import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/constants/app_colors.dart';
import '../../../shared/constants/app_spacing.dart';
import '../../../shared/constants/app_strings.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/page_heading.dart';
import '../../../shared/widgets/primary_button.dart';

/// The Signup screen.
///
/// Phase 1 — UI only. No validation, no Firebase, no auth logic.
/// The create account button navigates directly to home.
class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onCreate() => context.go('/home');
  void _onLogin() => context.pop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: _BackButton(onTap: () => context.pop()),
        leadingWidth: 56,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenHorizontal,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              const PageHeading(
                title: AppStrings.signupTitle,
                subtitle: AppStrings.signupSubtitle,
              ),
              const SizedBox(height: AppSpacing.xxxl),
              CustomTextField(
                controller: _nameController,
                labelText: AppStrings.fullNameLabel,
                hintText: AppStrings.fullNameHint,
                keyboardType: TextInputType.name,
                prefixIcon: Icons.person_outline_rounded,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                controller: _emailController,
                labelText: AppStrings.emailLabel,
                hintText: AppStrings.emailHint,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.mail_outline_rounded,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                controller: _passwordController,
                labelText: AppStrings.passwordLabel,
                hintText: AppStrings.passwordHint,
                obscureText: true,
                prefixIcon: Icons.lock_outline_rounded,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: AppStrings.confirmPasswordLabel,
                hintText: AppStrings.confirmPasswordHint,
                obscureText: true,
                prefixIcon: Icons.lock_outline_rounded,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _onCreate(),
              ),
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(
                label: AppStrings.signupButton,
                onPressed: _onCreate,
              ),
              const SizedBox(height: AppSpacing.xxl),
              const _OrDivider(),
              const SizedBox(height: AppSpacing.xl),
              _LoginPrompt(onLogin: _onLogin),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Private sub-widgets ────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: AppSpacing.md),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          size: 18,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            AppStrings.orDivider,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt({required this.onLogin});
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          AppStrings.alreadyHaveAccount,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 4),
        TextButton(
          onPressed: onLogin,
          child: const Text(AppStrings.logInLink),
        ),
      ],
    );
  }
}