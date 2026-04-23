// lib/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../supabase/database_service.dart';
import '../models/question_model.dart';
import '../routes/app_routes.dart';
import '../utils/theme.dart';
import '../widgets/loading_widget.dart';

class QuizScreen extends StatefulWidget {
  final String quizId;
  final String quizTitle;

  const QuizScreen({
    super.key,
    required this.quizId,
    required this.quizTitle,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuestionModel> _questions = [];
  bool _loading = true;
  int _currentIndex = 0;
  int? _selectedOption;
  bool _answered = false;
  int _score = 0;

  // Passed from route args (set in build via ModalRoute)
  String _participantName  = '';
  String _participantPhone = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _participantName  = args['participantName']  ?? '';
      _participantPhone = args['participantPhone'] ?? '';
    }
    if (_loading) _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      final qs = await DatabaseService.fetchQuestions(widget.quizId);
      if (mounted) setState(() { _questions = qs; _loading = false; });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedOption = index;
      _answered = true;
      if (index == _questions[_currentIndex].correctIndex) _score++;
    });
  }

  Future<void> _next() async {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedOption = null;
        _answered = false;
      });
    } else {
      // Save result then navigate
      try {
        await DatabaseService.saveResult(
          quizId: widget.quizId,
          quizTitle: widget.quizTitle,
          score: _score,
          total: _questions.length,
          participantName: _participantName,
          participantPhone: _participantPhone,
        );
      } catch (_) {}
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.result,
        arguments: {
          'score': _score,
          'total': _questions.length,
          'quizTitle': widget.quizTitle,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: LoadingWidget(message: 'Loading questions...'));
    }
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.quizTitle)),
        body: const Center(child: Text('No questions found for this quiz.')),
      );
    }

    final q    = _questions[_currentIndex];
    final prog = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quizTitle),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => _confirmExit(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Progress ──────────────────────────────────────────────────
              Row(
                children: [
                  Text(
                    'Q ${_currentIndex + 1} / ${_questions.length}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  Text(
                    'Score: $_score',
                    style: TextStyle(
                      color: AppTheme.success,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: prog,
                  backgroundColor: AppTheme.border,
                  color: AppTheme.accent,
                  minHeight: 6,
                ),
              ),

              const SizedBox(height: 32),

              // ── Question ──────────────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.accent.withOpacity(0.15),
                              AppTheme.accentGlow.withOpacity(0.06),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppTheme.accent.withOpacity(0.25)),
                        ),
                        child: Text(
                          q.questionText,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                height: 1.5,
                                fontSize: 18,
                              ),
                        ),
                      ).animate(key: ValueKey(_currentIndex)).fadeIn().slideY(begin: -0.05),

                      const SizedBox(height: 24),

                      // ── Options ───────────────────────────────────────────
                      ...List.generate(q.options.length, (i) {
                        return _optionTile(i, q.options[i], q.correctIndex);
                      }),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // ── Next / Submit button ──────────────────────────────────────
              if (_answered)
                AnimatedSlide(
                  offset: Offset.zero,
                  duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentIndex < _questions.length - 1
                            ? AppTheme.accent
                            : AppTheme.success,
                      ),
                      child: Text(
                        _currentIndex < _questions.length - 1
                            ? 'Next Question →'
                            : 'View Results 🎯',
                      ),
                    ),
                  ).animate().fadeIn().slideY(begin: 0.3),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _optionTile(int index, String option, int correctIndex) {
    Color borderColor = AppTheme.border;
    Color bgColor     = AppTheme.surface;
    Color textColor   = AppTheme.textPrimary;
    IconData? icon;

    if (_answered) {
      if (index == correctIndex) {
        borderColor = AppTheme.success;
        bgColor     = AppTheme.success.withOpacity(0.12);
        textColor   = AppTheme.success;
        icon        = Icons.check_circle_rounded;
      } else if (index == _selectedOption) {
        borderColor = AppTheme.error;
        bgColor     = AppTheme.error.withOpacity(0.12);
        textColor   = AppTheme.error;
        icon        = Icons.cancel_rounded;
      }
    } else if (_selectedOption == index) {
      borderColor = AppTheme.accent;
      bgColor     = AppTheme.accent.withOpacity(0.1);
    }

    return GestureDetector(
      onTap: () => _selectOption(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            // Option letter
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: borderColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  String.fromCharCode(65 + index), // A, B, C, D
                  style: TextStyle(
                    color: borderColor == AppTheme.border
                        ? AppTheme.textSecondary
                        : borderColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                option,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: _answered && index == correctIndex
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
            if (icon != null) Icon(icon, color: textColor, size: 22),
          ],
        ),
      )
          .animate(
            key: ValueKey('${_currentIndex}_$index'),
            delay: Duration(milliseconds: 60 * index),
          )
          .fadeIn()
          .slideX(begin: 0.08),
    );
  }

  void _confirmExit() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Quit Quiz?'),
        content: const Text('Your progress will be lost if you exit now.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Stay', style: TextStyle(color: AppTheme.accent)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Exit', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }
}
