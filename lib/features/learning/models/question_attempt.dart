/// Represents a single attempt at a question by the student.
///
/// This is the core data type of the Learning Engine (Phase 7).
/// Every future feature — Progress, Analytics, Continue Learning,
/// Firebase sync — will read from [QuestionAttempt] records.
///
/// Fields are intentionally flat (no nested objects) to simplify
/// serialisation when Firestore is introduced.
class QuestionAttempt {
  const QuestionAttempt({
    required this.questionId,
    required this.subjectId,
    required this.chapterId,
    required this.selectedOption,
    required this.correctOption,
    required this.isCorrect,
    required this.attemptedAt,
    required this.timeTaken,
    required this.attemptNumber,
  });

  /// Stable identifier from [Question.id]. Never an index.
  final String questionId;

  final String subjectId;
  final String chapterId;

  /// Index of the option the student selected (0–3).
  final int selectedOption;

  /// Index of the correct option (0–3) — denormalised for offline analytics.
  final int correctOption;

  final bool isCorrect;

  /// Wall-clock time when the student tapped "Submit answer".
  final DateTime attemptedAt;

  /// How long the student spent on this question before submitting.
  final Duration timeTaken;

  /// 1 for the first attempt, 2 for a retry, etc.
  /// Computed by [LearningNotifier] — callers never set this directly.
  final int attemptNumber;
}
