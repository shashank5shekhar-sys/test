// lib/screens/result_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../routes/app_routes.dart';
import '../utils/theme.dart';
import '../utils/constants.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final String quizTitle;

  const ResultScreen({
    super.key,
    required this.score,
    required this.total,
    required this.quizTitle,
  });

  bool get _passed => (score / total) >= AppConstants.passPercentage;
  double get _percentage => total > 0 ? score / total : 0;

  @override
  Widget build(BuildContext context) {
    final passed = _passed;
    final pct    = (_percentage * 100).toStringAsFixed(0);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Result icon ───────────────────────────────────────────────
              _buildResultIcon(passed),

              const SizedBox(height: 28),

              // ── Pass / Fail text ──────────────────────────────────────────
              Text(
                passed ? '🎉 Congratulations!' : 'Better Luck Next Time',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: passed ? AppTheme.success : AppTheme.error,
                    ),
                textAlign: TextAlign.center,
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2),

              const SizedBox(height: 10),

              Text(
                passed
                    ? 'You PASSED the quiz with excellence!'
                    : 'You need 90% to pass. Keep practising!',
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppTheme.textSecondary),
                textAlign: TextAlign.center,
              ).animate(delay: 400.ms).fadeIn(),

              const SizedBox(height: 36),

              // ── Score card ────────────────────────────────────────────────
              _buildScoreCard(context, passed, pct),

              const SizedBox(height: 28),

              // ── Quiz title tag ────────────────────────────────────────────
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceAlt,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.quiz_outlined,
                        color: AppTheme.textSecondary, size: 16),
                    const SizedBox(width: 8),
                    Text(quizTitle,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ).animate(delay: 500.ms).fadeIn(),

              const SizedBox(height: 40),

              // ── Action buttons ────────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.home, (_) => false),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text('Back to Home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: passed ? AppTheme.success : AppTheme.accent,
                  ),
                ),
              ).animate(delay: 600.ms).fadeIn().slideY(begin: 0.2),

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.quizList, (_) => false),
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Try Another Quiz'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.border),
                    foregroundColor: AppTheme.textPrimary,
                  ),
                ),
              ).animate(delay: 700.ms).fadeIn(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultIcon(bool passed) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: (passed ? AppTheme.success : AppTheme.error).withOpacity(0.12),
        border: Border.all(
          color: passed ? AppTheme.success : AppTheme.error,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: (passed ? AppTheme.success : AppTheme.error).withOpacity(0.3),
            blurRadius: 32,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Text(
          passed ? '🏆' : '📚',
          style: const TextStyle(fontSize: 64),
        ),
      ),
    )
        .animate()
        .scale(
          duration: 700.ms,
          curve: Curves.elasticOut,
        )
        .fadeIn();
  }

  Widget _buildScoreCard(
      BuildContext context, bool passed, String pct) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: (passed ? AppTheme.success : AppTheme.error).withOpacity(0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: (passed ? AppTheme.success : AppTheme.error).withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Big score
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: TextStyle(
                  color: passed ? AppTheme.success : AppTheme.error,
                  fontSize: 72,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  ' / $total',
                  style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 28,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ).animate(delay: 200.ms).fadeIn().scale(begin: const Offset(0.8, 0.8)),

          const SizedBox(height: 16),

          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: _percentage),
              duration: const Duration(milliseconds: 900),
              curve: Curves.easeOut,
              builder: (_, val, __) => LinearProgressIndicator(
                value: val,
                backgroundColor: AppTheme.border,
                color: passed ? AppTheme.success : AppTheme.error,
                minHeight: 10,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Percentage + pass badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$pct% scored',
                  style: Theme.of(context).textTheme.bodyMedium),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: (passed ? AppTheme.success : AppTheme.error)
                      .withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  passed ? '✓ PASS' : '✗ FAIL',
                  style: TextStyle(
                    color: passed ? AppTheme.success : AppTheme.error,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(color: AppTheme.border),
          const SizedBox(height: 16),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _stat(context, '$score', 'Correct', AppTheme.success),
              _stat(context, '${total - score}', 'Wrong', AppTheme.error),
              _stat(context, '$total', 'Total', AppTheme.accent),
              _stat(context, '90%', 'Pass Mark', AppTheme.warning),
            ],
          ),
        ],
      ),
    ).animate(delay: 200.ms).fadeIn().slideY(begin: 0.1);
  }

  Widget _stat(BuildContext context, String val, String label, Color color) {
    return Column(
      children: [
        Text(val,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            )),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }
}
