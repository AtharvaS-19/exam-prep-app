import 'package:exam_prep_app/features/learning/models/question_attempt.dart';

/// A snapshot of derived learning statistics for a set of [QuestionAttempt]s.
///
/// Constructed via [ProgressStats.fromAttempts] from any filtered slice of
/// the learning history (overall, per-chapter, per-subject). Keeps UI and
/// providers free of repeated derivation logic.
///
/// This is a value object — immutable, no behaviour beyond getters.
class ProgressStats {
  const ProgressStats({
    required this.totalAttempts,
    required this.correctAttempts,
    required this.incorrectAttempts,
    required this.overallAccuracy,
    required this.latestAttempt,
    required this.completedQuestionIds,
  });

  /// Derives stats from [attempts]. Safe to call with an empty list.
  factory ProgressStats.fromAttempts(List<QuestionAttempt> attempts) {
    if (attempts.isEmpty) {
      return const ProgressStats(
        totalAttempts: 0,
        correctAttempts: 0,
        incorrectAttempts: 0,
        overallAccuracy: 0.0,
        latestAttempt: null,
        completedQuestionIds: {},
      );
    }

    final correct = attempts.where((a) => a.isCorrect).length;
    final total = attempts.length;

    // A question is "completed" when it has at least one recorded attempt.
    // Consumers that require a stricter definition (e.g. answered correctly)
    // can filter the list before passing it to this constructor.
    final completed = attempts.map((a) => a.questionId).toSet();

    return ProgressStats(
      totalAttempts: total,
      correctAttempts: correct,
      incorrectAttempts: total - correct,
      overallAccuracy: correct / total,
      latestAttempt: attempts.last,
      completedQuestionIds: completed,
    );
  }

  /// Total number of submission events recorded.
  final int totalAttempts;

  /// Submissions where the selected option was correct.
  final int correctAttempts;

  /// Submissions where the selected option was wrong.
  final int incorrectAttempts;

  /// Fraction of correct submissions (0.0–1.0). 0.0 when no attempts.
  final double overallAccuracy;

  /// The most recent [QuestionAttempt] across the filtered set, or null.
  final QuestionAttempt? latestAttempt;

  /// IDs of all questions that have been attempted at least once.
  final Set<String> completedQuestionIds;

  /// Convenience — accuracy as an integer percentage (0–100).
  int get accuracyPercent => (overallAccuracy * 100).round();

  /// True when at least one question has been attempted.
  bool get hasActivity => totalAttempts > 0;
}
