import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/iterable_ext.dart';
import '../../../shared/providers.dart';

class ProblemScreen extends ConsumerWidget {
  const ProblemScreen({super.key, required this.problemId});

  final String problemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final problemsAsync = ref.watch(allProblemsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Problem')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: problemsAsync.when(
          data: (problems) {
            final problem = problems.where((p) => p.id == problemId).firstOrNull;
            if (problem == null) {
              return const Center(child: Text('Problem not found'));
            }

            return ListView(
              children: [
                Text(problem.title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text('Difficulty: ${problem.difficulty}'),
                Text('Topic: ${problem.topic}'),
                const SizedBox(height: 16),
                Text(problem.description),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.push('/problem/$problemId/submission'),
                  child: const Text('Submit My Approach'),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
        ),
      ),
    );
  }
}
