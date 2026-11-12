import 'package:go_router/go_router.dart';
import '../features/splash/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/home/home_screen.dart';
import '../features/results/results_screen.dart';
final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
  path: '/results',
  builder: (context, state) => ResultsScreen(
    mode: state.uri.queryParameters['mode'] ?? 'sale',
    query: state.uri.queryParameters['q'] ?? '',
  ),
),
  ],
);