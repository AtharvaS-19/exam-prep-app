import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:exam_prep_app/features/bookmarks/providers/bookmark_provider.dart';
import 'package:exam_prep_app/features/mistakes/providers/mistakes_provider.dart';
import 'package:exam_prep_app/features/practice/data/dummy_questions.dart';
import 'package:exam_prep_app/features/practice/models/question.dart';
import 'package:exam_prep_app/features/practice/presentation/widgets/explanation_card.dart';
import 'package:exam_prep_app/features/practice/presentation/widgets/question_card.dart';
import 'package:exam_prep_app/features/practice/presentation/widgets/question_progress_bar.dart';
import '../../../../shared/constants/app_colors.dart';
import '../../../../shared/constants/app_spacing.dart';
import '../../../../shared/widgets/primary_button.dart';

/// The Practice Screen — Phase 4 core feature, extended in Phases 5 & 6.
///
/// Manages the full question-solving session for a given chapter:
/// - Loads questions from [DummyQuestions]
/// - Tracks selected option, submitted state, and session results
/// - Shows explanation after each submission
/// - Navigates to the result screen when all questions are answered
/// - Phase 5: bookmark toggle in AppBar via [bookmarkProvider]
/// - Phase 6: auto-records wrong answers to [mistakesProvider]; removes entry
///   when the student later answers the same question correctly
/// - [questionIds]: when provided (retry mode), only the listed question IDs
///   are included in the session, in the given order.
class PracticeScreen extends ConsumerStatefulWidget {
  const PracticeScreen({
    super.key,
    required this.subjectId,
    required this.chapterId,
    required this.chapterTitle,
  });

  final String subjectId;
  final String chapterId;
  final String chapterTitle;

  @override
  ConsumerState<PracticeScreen> createState() => _PracticeScreenState();
}

class _PracticeScreenState extends ConsumerState<PracticeScreen> {
  late final List<Question> _questions;

  int _currentIndex = 0;
  int? _selectedOptionIndex;
  bool _isSubmitted = false;

  /// Tracks correct/incorrect per question for the result screen.
  final Map<String, bool> _results = {};

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final all = DummyQuestions.forChapter(widget.chapterId);
    // Check for retry-mode IDs set by the Mistakes screen.
    final retryIds = ref.read(retryQuestionIdsProvider);
    // Clear the provider safely after the current build phase completes
    if (retryIds != null) {
      Future.microtask(
          () => ref.read(retryQuestionIdsProvider.notifier).state = null);
    }

    if (retryIds != null && retryIds.isNotEmpty) {
      final byId = <String, Question>{for (final q in all) q.id: q};
      final filtered = retryIds
          .where((id) => byId.containsKey(id))
          .map((id) => byId[id]!)
          .toList();
      _questions = filtered.isNotEmpty ? filtered : all;
    } else {
      _questions = all;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Question get _currentQuestion => _questions[_currentIndex];
  bool get _isLastQuestion => _currentIndex == _questions.length - 1;
  bool get _canSubmit => _selectedOptionIndex != null && !_isSubmitted;

  void _onOptionSelected(int index) {
    if (_isSubmitted) return;
    setState(() => _selectedOptionIndex = index);
  }

  void _onSubmit() {
    if (!_canSubmit) return;
    final bool correct = _currentQuestion.isCorrect(_selectedOptionIndex!);
    // Phase 6: update Riverpod state BEFORE setState so the provider
    // change is committed before the widget rebuild is scheduled.
    if (!correct) {
      ref.read(mistakesProvider.notifier).record(
            WrongAnswer(
              questionId: _currentQuestion.id,
              subjectId: widget.subjectId,
              chapterId: widget.chapterId,
              chapterTitle: widget.chapterTitle,
              attemptedAt: DateTime.now(),
            ),
          );
    } else {
      ref.read(mistakesProvider.notifier).remove(_currentQuestion.id);
    }
    setState(() {
      _isSubmitted = true;
      _results[_currentQuestion.id] = correct;
    });
  }

  void _onNext() {
    if (_isLastQuestion) {
      _goToResults();
      return;
    }
    setState(() {
      _currentIndex++;
      _selectedOptionIndex = null;
      _isSubmitted = false;
    });
    // Scroll back to top when moving to a new question
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _goToResults() {
    final int correct = _results.values.where((v) => v).length;
    context.pushReplacement(
      '/subjects/${widget.subjectId}/chapters/${widget.chapterId}/result',
      extra: <String, dynamic>{
        'chapterTitle': widget.chapterTitle,
        'total': _questions.length,
        'correct': correct,
      },
    );
  }

  void _toggleBookmark() {
    ref
        .read(bookmarkProvider.notifier)
        .toggle(_currentQuestion.id);
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const _EmptyQuestionsScreen();
    }

    // Watch the state list directly — this triggers a rebuild on every toggle.
    // ref.watch(bookmarkProvider.notifier) watches the notifier object, which
    // never changes, so it would NOT rebuild. Watching the provider itself
    // watches the List<String> state, which is replaced on every toggle().
    final isBookmarked = ref
        .watch(bookmarkProvider)
        .contains(_currentQuestion.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          widget.chapterTitle,
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          // ── Bookmark toggle ──────────────────────────────────────────────
          IconButton(
            tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark question',
            onPressed: _toggleBookmark,
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => ScaleTransition(
                scale: animation,
                child: child,
              ),
              child: Icon(
                isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_outline_rounded,
                key: ValueKey<bool>(isBookmarked),
                color: isBookmarked ? AppColors.primary : AppColors.iconSecondary,
                size: 22,
              ),
            ),
          ),
          // ── Questions answered counter ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Center(
              child: Text(
                '${_results.length} / ${_questions.length}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar — pinned
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.sm,
                AppSpacing.screenHorizontal,
                0,
              ),
              child: QuestionProgressBar(
                currentIndex: _currentIndex,
                total: _questions.length,
                sourceLabel: _currentQuestion.source.label,
                year: _currentQuestion.year,
              ),
            ),
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.xl,
                  AppSpacing.screenHorizontal,
                  AppSpacing.xxl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuestionCard(
                      question: _currentQuestion,
                      selectedIndex: _selectedOptionIndex,
                      isSubmitted: _isSubmitted,
                      onOptionSelected: _onOptionSelected,
                      isBookmarked: isBookmarked,
                    ),
                    if (_isSubmitted) ...[
                      const SizedBox(height: AppSpacing.xl),
                      ExplanationCard(
                        question: _currentQuestion,
                        selectedIndex: _selectedOptionIndex!,
                      ),
                    ],
                    // Space for the bottom action bar
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // Fixed bottom action bar
      bottomNavigationBar: _BottomActionBar(
        isSubmitted: _isSubmitted,
        canSubmit: _canSubmit,
        isLastQuestion: _isLastQuestion,
        onSubmit: _onSubmit,
        onNext: _onNext,
      ),
    );
  }
}

// ── Bottom action bar ─────────────────────────────────────────────────────────

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.isSubmitted,
    required this.canSubmit,
    required this.isLastQuestion,
    required this.onSubmit,
    required this.onNext,
  });

  final bool isSubmitted;
  final bool canSubmit;
  final bool isLastQuestion;
  final VoidCallback onSubmit;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        AppSpacing.md,
        AppSpacing.screenHorizontal,
        AppSpacing.md + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: !isSubmitted
          ? PrimaryButton(
              label: 'Submit answer',
              onPressed: canSubmit ? onSubmit : null,
            )
          : PrimaryButton(
              label: isLastQuestion ? 'See results' : 'Next question',
              onPressed: onNext,
              icon: isLastQuestion
                  ? Icons.bar_chart_rounded
                  : Icons.arrow_forward_rounded,
            ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyQuestionsScreen extends StatelessWidget {
  const _EmptyQuestionsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: AppColors.background),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.quiz_outlined, size: 40, color: AppColors.iconSecondary),
              SizedBox(height: AppSpacing.md),
              Text(
                'No questions available',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Questions for this chapter are being added.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}