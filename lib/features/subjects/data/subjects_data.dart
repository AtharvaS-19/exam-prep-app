import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../../../shared/constants/app_colors.dart';

/// The static data source for all exam streams and their subjects.
///
/// This is intentionally a plain Dart class with static const data.
/// No repository, no service, no network — per Phase 2 requirements.
/// When Firestore is added in a later phase, this becomes the fallback
/// and the repository pattern slots in without touching the UI layer.
abstract final class SubjectsData {
  static const List<SubjectModel> all = [
    // ── Engineering ──────────────────────────────────────────────────────────
    SubjectModel(
      id: 'eng_physics',
      name: 'Physics',
      stream: ExamStream.engineering,
      icon: Icons.bolt_outlined,
      accentColor: AppColors.physicsAccent,
      totalQuestions: 1240,
      examTags: ['JEE Main', 'JEE Adv'],
    ),
    SubjectModel(
      id: 'eng_chemistry',
      name: 'Chemistry',
      stream: ExamStream.engineering,
      icon: Icons.science_outlined,
      accentColor: AppColors.chemistryAccent,
      totalQuestions: 1080,
      examTags: ['JEE Main', 'JEE Adv'],
    ),
    SubjectModel(
      id: 'eng_mathematics',
      name: 'Mathematics',
      stream: ExamStream.engineering,
      icon: Icons.functions_outlined,
      accentColor: AppColors.mathAccent,
      totalQuestions: 1360,
      examTags: ['JEE Main', 'JEE Adv'],
    ),

    // ── Medical ───────────────────────────────────────────────────────────────
    SubjectModel(
      id: 'med_physics',
      name: 'Physics',
      stream: ExamStream.medical,
      icon: Icons.bolt_outlined,
      accentColor: AppColors.physicsAccent,
      totalQuestions: 960,
      examTags: ['NEET'],
    ),
    SubjectModel(
      id: 'med_chemistry',
      name: 'Chemistry',
      stream: ExamStream.medical,
      icon: Icons.science_outlined,
      accentColor: AppColors.chemistryAccent,
      totalQuestions: 920,
      examTags: ['NEET'],
    ),
    SubjectModel(
      id: 'med_biology',
      name: 'Biology',
      stream: ExamStream.medical,
      icon: Icons.eco_outlined,
      accentColor: AppColors.biologyAccent,
      totalQuestions: 1100,
      examTags: ['NEET'],
    ),
  ];

  /// Returns all subjects for a given [stream].
  static List<SubjectModel> forStream(ExamStream stream) =>
      all.where((s) => s.stream == stream).toList();

  /// Finds a subject by its [id]. Returns null if not found.
  static SubjectModel? findById(String id) {
    try {
      return all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  // Prevent instantiation
  SubjectsData._();
}
