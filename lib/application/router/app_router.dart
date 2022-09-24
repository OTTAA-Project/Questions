import 'package:go_router/go_router.dart';

class AppRouter {
  static final AppRouter _instance = AppRouter._();

  factory AppRouter() => _instance;

  AppRouter._();

  final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: "/splash",
      ),
      GoRoute(
        path: "/login",
      ),
      GoRoute(
        path: "/main",
      ),
    ],
    initialLocation: "", //TODO: If has a token, go to splash, else go to login
  );
}
