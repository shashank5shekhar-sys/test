// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../supabase/auth_service.dart';
import '../routes/app_routes.dart';
import '../utils/theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    if (AuthService.isLoggedIn) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.accent, AppTheme.accentGlow],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accent.withOpacity(0.35),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.quiz_rounded, size: 52, color: Colors.white),
            )
                .animate()
                .scale(
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                )
                .fadeIn(),

            const SizedBox(height: 28),

            Text(
              'QUIZMASTER',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    letterSpacing: 3,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [AppTheme.accent, AppTheme.accentGlow],
                      ).createShader(
                        const Rect.fromLTWH(0, 0, 200, 50),
                      ),
                  ),
            )
                .animate(delay: 300.ms)
                .slideY(begin: 0.3, end: 0, curve: Curves.easeOut)
                .fadeIn(),

            const SizedBox(height: 8),

            Text(
              'Test Your Knowledge',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    letterSpacing: 1.5,
                    color: AppTheme.textSecondary,
                  ),
            )
                .animate(delay: 500.ms)
                .fadeIn(),

            const SizedBox(height: 60),

            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(
                  AppTheme.accent.withOpacity(0.6),
                ),
              ),
            ).animate(delay: 800.ms).fadeIn(),
          ],
        ),
      ),
    );
  }
}
