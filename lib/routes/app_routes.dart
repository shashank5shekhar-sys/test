// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/quiz_list_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/result_screen.dart';

class AppRoutes {
  static const String splash    = '/';
  static const String login     = '/login';
  static const String signup    = '/signup';
  static const String home      = '/home';
  static const String profile   = '/profile';
  static const String quizList  = '/quiz-list';
  static const String quiz      = '/quiz';
  static const String result    = '/result';

  static Map<String, WidgetBuilder> get routes => {
    splash:   (_) => const SplashScreen(),
    login:    (_) => const LoginScreen(),
    signup:   (_) => const SignupScreen(),
    home:     (_) => const HomeScreen(),
    profile:  (_) => const ProfileScreen(),
    quizList: (_) => const QuizListScreen(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case quiz:
        final args = settings.arguments as Map<String, dynamic>;
        return _fadeRoute(QuizScreen(
          quizId: args['quizId'],
          quizTitle: args['quizTitle'],
        ));
      case result:
        final args = settings.arguments as Map<String, dynamic>;
        return _fadeRoute(ResultScreen(
          score: args['score'],
          total: args['total'],
          quizTitle: args['quizTitle'],
        ));
      default:
        return null;
    }
  }

  static PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
