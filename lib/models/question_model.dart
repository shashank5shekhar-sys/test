// lib/models/question_model.dart

class QuestionModel {
  final String id;
  final String quizId;
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final int orderNum;

  QuestionModel({
    required this.id,
    required this.quizId,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.orderNum,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> map) {
    return QuestionModel(
      id: map['id'] ?? '',
      quizId: map['quiz_id'] ?? '',
      questionText: map['question_text'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctIndex: map['correct_index'] ?? 0,
      orderNum: map['order_num'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'quiz_id': quizId,
        'question_text': questionText,
        'options': options,
        'correct_index': correctIndex,
        'order_num': orderNum,
      };
}
