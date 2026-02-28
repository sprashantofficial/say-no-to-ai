import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/presentation/home_screen.dart';
import '../../features/problem/presentation/problem_screen.dart';
import '../../features/submission/presentation/submission_screen.dart';
import '../../features/reveal/presentation/reveal_screen.dart';

final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (_, __) => const HomeScreen(),
      ),
      GoRoute(
        path: '/problem/:id',
        name: 'problem',
        builder: (_, state) => ProblemScreen(problemId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/problem/:id/submission',
        name: 'submission',
        builder: (_, state) => SubmissionScreen(problemId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/problem/:id/reveal',
        name: 'reveal',
        builder: (_, state) => RevealScreen(problemId: state.pathParameters['id']!),
      ),
    ],
  ),
);
