// lib/screens/quiz_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../supabase/database_service.dart';
import '../models/quiz_model.dart';
import '../routes/app_routes.dart';
import '../utils/theme.dart';
import '../widgets/loading_widget.dart';
import '../widgets/quiz_tile.dart';

class QuizListScreen extends StatefulWidget {
  const QuizListScreen({super.key});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  List<QuizModel> _quizzes = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchQuizzes();
  }

  Future<void> _fetchQuizzes() async {
    try {
      final quizzes = await DatabaseService.fetchQuizzes();
      if (mounted) setState(() { _quizzes = quizzes; _loading = false; });
    } catch (e) {
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  void _openQuiz(QuizModel quiz) {
    // Show pre-quiz info dialog (name + phone)
    _showPreQuizDialog(quiz);
  }

  void _showPreQuizDialog(QuizModel quiz) {
    final nameCtrl  = TextEditingController();
    final phoneCtrl = TextEditingController();
    final formKey   = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Quiz info
              Row(
                children: [
                  Text(quiz.iconEmoji, style: const TextStyle(fontSize: 36)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(quiz.title,
                            style: Theme.of(ctx).textTheme.titleLarge),
                        Text('${quiz.totalQuestions} questions · ${quiz.category}',
                            style: Theme.of(ctx).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(color: AppTheme.border),
              const SizedBox(height: 20),

              Text('Before you start',
                  style: Theme.of(ctx).textTheme.headlineMedium),
              const SizedBox(height: 6),
              Text('Please enter your details to continue',
                  style: Theme.of(ctx).textTheme.bodyMedium),
              const SizedBox(height: 20),

              // Name
              TextFormField(
                controller: nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Your full name',
                  prefixIcon: Icon(Icons.person_outline_rounded,
                      color: AppTheme.textSecondary),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Name required' : null,
              ),
              const SizedBox(height: 14),

              // Phone
              TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Your phone number',
                  prefixIcon: Icon(Icons.phone_outlined,
                      color: AppTheme.textSecondary),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Phone required' : null,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    Navigator.pop(ctx);
                    Navigator.pushNamed(
                      context,
                      AppRoutes.quiz,
                      arguments: {
                        'quizId': quiz.id,
                        'quizTitle': quiz.title,
                        'participantName': nameCtrl.text.trim(),
                        'participantPhone': phoneCtrl.text.trim(),
                      },
                    );
                  },
                  child: const Text('Start Quiz 🚀'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a Quiz'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _loading
          ? const LoadingWidget(message: 'Loading quizzes...')
          : _error != null
              ? _errorState()
              : _quizzes.isEmpty
                  ? _emptyState()
                  : _quizList(),
    );
  }

  Widget _quizList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      itemCount: _quizzes.length,
      itemBuilder: (context, i) {
        return QuizTile(
          quiz: _quizzes[i],
          index: i,
          onTap: () => _openQuiz(_quizzes[i]),
        )
            .animate(delay: Duration(milliseconds: i * 80))
            .fadeIn()
            .slideX(begin: 0.1);
      },
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📭', style: TextStyle(fontSize: 60)),
          const SizedBox(height: 16),
          Text('No quizzes available yet',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 8),
          Text('Check back soon!',
              style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _errorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off_rounded,
                color: AppTheme.error, size: 52),
            const SizedBox(height: 16),
            Text('Failed to load quizzes',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(_error ?? '',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                setState(() { _loading = true; _error = null; });
                _fetchQuizzes();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
