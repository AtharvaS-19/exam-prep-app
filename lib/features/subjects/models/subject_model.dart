import 'package:flutter/material.dart';

/// The two supported exam streams.
enum ExamStream {
  engineering,
  medical;

  String get label {
    return switch (this) {
      ExamStream.engineering => 'Engineering',
      ExamStream.medical => 'Medical',
    };
  }
}

/// A single subject belonging to an [ExamStream].
///
/// Immutable. All subject data is defined in [SubjectsData].
class SubjectModel {
  const SubjectModel({
    required this.id,
    required this.name,
    required this.stream,
    required this.icon,
    required this.accentColor,
    required this.totalQuestions,
    required this.examTags,
  });

  /// Unique identifier — used in navigation routes.
  final String id;

  final String name;
  final ExamStream stream;
  final IconData icon;
  final Color accentColor;
  final int totalQuestions;

  /// Short exam labels shown on the subject card (e.g. ['JEE Main', 'JEE Adv']).
  final List<String> examTags;

  /// Formatted question count for display.
  String get formattedQuestions {
    if (totalQuestions >= 1000) {
      final double k = totalQuestions / 1000;
      return '${k.toStringAsFixed(k.truncateToDouble() == k ? 0 : 1)}k questions';
    }
    return '$totalQuestions questions';
  }
}
