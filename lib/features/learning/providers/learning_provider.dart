import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:exam_prep_app/features/learning/models/question_attempt.dart';

// ── Notifier ──────────────────────────────────────────────────────────────────

/// Manages the in-memory learning history for the current session.
///
/// Responsibilities:
/// - [record]: append a new [QuestionAttempt], computing [attemptNumber]
///   automatically from prior attempts for the same question.
/// - [attemptsFor]: retrieve all attempts for a given question ID.
/// - [latestAttemptFor]: retrieve the most recent attempt for a question,
///   or null if the question has never been attempted.
/// - [countFor]: return the total attempt count for a question.
///
/// This notifier does NOT calculate progress, accuracy, or analytics.
/// It stores raw learning events. Consumers derive meaning from them.
///
/// Persistence (Firestore) will be added in a later phase without changing
/// the public API of this notifier.
class LearningNotifier extends StateNotifier<List<QuestionAttempt>> {
  LearningNotifier() : super(const []);

  /// Records a new attempt.
  ///
  /// [attemptNumber] is derived here — callers supply all other fields
  /// except [attemptNumber], which is passed as the full [QuestionAttempt]
  /// with the computed value already set by [PracticeScreen._onSubmit].
  void record(QuestionAttempt attempt) {
    state = [...state, attempt];
  }

  /// Returns all attempts for [questionId] in chronological order.
  List<QuestionAttempt> attemptsFor(String questionId) =>
      state.where((a) => a.questionId == questionId).toList();

  /// Returns the most recent attempt for [questionId], or null if none.
  QuestionAttempt? latestAttemptFor(String questionId) {
    final attempts = attemptsFor(questionId);
    return attempts.isEmpty ? null : attempts.last;
  }

  /// Returns the total number of times [questionId] has been attempted.
  int countFor(String questionId) =>
      state.where((a) => a.questionId == questionId).length;
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// The global provider for [LearningNotifier].
///
/// Consumed by:
/// - [PracticeScreen._onSubmit] — records an attempt on every submission
/// - Future: ProgressScreen, Analytics, Continue Learning, Firebase sync
final learningProvider =
    StateNotifierProvider<LearningNotifier, List<QuestionAttempt>>(
  (_) => LearningNotifier(),
);
