// lib/utils/constants.dart

class AppConstants {
  // Supabase credentials — replace with your actual values
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // Table names
  static const String profilesTable = 'profiles';
  static const String quizzesTable = 'quizzes';
  static const String questionsTable = 'questions';
  static const String resultsTable = 'quiz_results';

  // Storage bucket
  static const String avatarsBucket = 'avatars';

  // Pass percentage
  static const double passPercentage = 0.9;
}
