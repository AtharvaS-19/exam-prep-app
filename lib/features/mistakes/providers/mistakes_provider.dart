import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Model ─────────────────────────────────────────────────────────────────────

/// An immutable record of a question the student answered incorrectly.
///
/// Stored in-memory only — no persistence until a later phase.
class WrongAnswer {
  const WrongAnswer({
    required this.questionId,
    required this.subjectId,
    required this.chapterId,
    required this.chapterTitle,
    required this.attemptedAt,
  });

  final String questionId;
  final String subjectId;
  final String chapterId;
  final String chapterTitle;
  final DateTime attemptedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WrongAnswer && other.questionId == questionId;

  @override
  int get hashCode => questionId.hashCode;
}

// ── Notifier ──────────────────────────────────────────────────────────────────

/// Manages the in-memory list of wrong answers.
///
/// - [record]: adds a [WrongAnswer]; silently ignores duplicates by questionId.
/// - [remove]: removes the entry matching [questionId] (used when the student
///   later answers the same question correctly).
/// - [isWrong]: returns true when [questionId] is in the current list.
class MistakesNotifier extends StateNotifier<List<WrongAnswer>> {
  MistakesNotifier() : super(const []);

  /// Records a wrong answer. If an entry for [answer.questionId] already
  /// exists, the call is a no-op (no duplicate entries).
  void record(WrongAnswer answer) {
    if (state.any((w) => w.questionId == answer.questionId)) return;
    state = [...state, answer];
  }

  /// Removes the wrong-answer entry for [questionId], if it exists.
  /// Called when the student answers the same question correctly on a retry.
  void remove(String questionId) {
    state = state.where((w) => w.questionId != questionId).toList();
  }

  /// Returns true when [questionId] currently appears in the mistakes list.
  bool isWrong(String questionId) =>
      state.any((w) => w.questionId == questionId);
}

// ── Provider ──────────────────────────────────────────────────────────────────

/// The global provider for [MistakesNotifier].
///
/// Consumed by:
///  - [PracticeScreen._onSubmit] — records / removes entries on answer submit
///  - [MistakesScreen] — displays the full wrong-answers list
final mistakesProvider =
    StateNotifierProvider<MistakesNotifier, List<WrongAnswer>>(
  (_) => MistakesNotifier(),
);

/// Holds the question IDs for a retry session.
///
/// Set by [MistakesScreen] before navigating to the practice route.
/// Read and cleared by [PracticeScreen.initState]. This avoids passing
/// data through GoRouter (which drops extra/query on web).
final retryQuestionIdsProvider = StateProvider<List<String>?>((_) => null);

/// Holds the question ID that [PracticeScreen] should open first.
///
/// Written by [BookmarksScreen] and [MistakesScreen] before pushing the
/// practice route. Read and cleared in [PracticeScreen.initState].
/// Falls back to the first question when null or not found.
final initialQuestionIdProvider = StateProvider<String?>((_) => null);
