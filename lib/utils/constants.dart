// lib/utils/constants.dart

class AppConstants {
  // Supabase credentials — replace with your actual values
  static const String supabaseUrl = 'https://supabase.com/dashboard/project/ahcswzvfxqzscohusihr';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFoY3N3enZmeHF6c2NvaHVzaWhyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY5NDE4MzcsImV4cCI6MjA5MjUxNzgzN30.SHjdAcHNQ80069KxK5qU_h9EY-zgVJ9iV975P5GQ_3o';

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
