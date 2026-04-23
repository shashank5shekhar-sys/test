// lib/supabase/database_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_init.dart';
import 'auth_service.dart';
import '../models/quiz_model.dart';
import '../models/question_model.dart';
import '../models/user_model.dart';
import '../utils/constants.dart';

class DatabaseService {
  static SupabaseClient get _client => SupabaseInit.client;

  // ── Update profile ──────────────────────────────────────────────────────────
  static Future<UserModel?> updateProfile({
    required String name,
    String? avatarUrl,
    String? phone,
  }) async {
    final userId = AuthService.currentUser?.id;
    if (userId == null) return null;

    final data = <String, dynamic>{'name': name};
    if (avatarUrl != null) data['avatar_url'] = avatarUrl;
    if (phone != null) data['phone'] = phone;

    final response = await _client
        .from(AppConstants.profilesTable)
        .update(data)
        .eq('id', userId)
        .select()
        .single();

    return UserModel.fromMap(response);
  }

  // ── Fetch all quizzes ───────────────────────────────────────────────────────
  static Future<List<QuizModel>> fetchQuizzes() async {
    final response = await _client
        .from(AppConstants.quizzesTable)
        .select()
        .order('created_at', ascending: true);

    return (response as List)
        .map((e) => QuizModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // ── Fetch questions for a quiz ──────────────────────────────────────────────
  static Future<List<QuestionModel>> fetchQuestions(String quizId) async {
    final response = await _client
        .from(AppConstants.questionsTable)
        .select()
        .eq('quiz_id', quizId)
        .order('order_num', ascending: true);

    return (response as List)
        .map((e) => QuestionModel.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  // ── Save quiz result ────────────────────────────────────────────────────────
  static Future<void> saveResult({
    required String quizId,
    required String quizTitle,
    required int score,
    required int total,
    required String participantName,
    required String participantPhone,
  }) async {
    final userId = AuthService.currentUser?.id;

    await _client.from(AppConstants.resultsTable).insert({
      'user_id': userId,
      'quiz_id': quizId,
      'quiz_title': quizTitle,
      'score': score,
      'total': total,
      'participant_name': participantName,
      'participant_phone': participantPhone,
      'passed': (score / total) >= AppConstants.passPercentage,
    });
  }
}
