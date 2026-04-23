// lib/models/quiz_model.dart

class QuizModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final int totalQuestions;
  final String iconEmoji;

  QuizModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.totalQuestions,
    required this.iconEmoji,
  });

  factory QuizModel.fromMap(Map<String, dynamic> map) {
    return QuizModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      totalQuestions: map['total_questions'] ?? 5,
      iconEmoji: map['icon_emoji'] ?? '📚',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'total_questions': totalQuestions,
        'icon_emoji': iconEmoji,
      };
}
