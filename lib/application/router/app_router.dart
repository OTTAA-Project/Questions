import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:questions_by_ottaa/presentation/home/home_screen.dart';
import 'package:questions_by_ottaa/presentation/login/login_screen.dart';
import 'package:questions_by_ottaa/presentation/splash/splash_screen.dart';

class AppRouter {
  static final AppRouter _instance = AppRouter._();

  factory AppRouter() => _instance;

  AppRouter._();

  final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: "/splash",
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: "/login",
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: "/home",
        builder: (context, state) => const HomeScreen(),
      ),
    ],
    initialLocation: FirebaseAuth.instance.currentUser == null ? '/login' : '/splash',
  );
}
