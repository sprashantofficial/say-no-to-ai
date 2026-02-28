import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ads/ad_service.dart';
import '../../../core/utils/iterable_ext.dart';
import '../../../core/services/local_stats_service.dart';
import '../../../shared/providers.dart';

class RevealScreen extends ConsumerWidget {
  const RevealScreen({super.key, required this.problemId});

  final String problemId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final problemsAsync = ref.watch(allProblemsProvider);
    final revealStep = ref.watch(revealStepProvider(problemId));
    final submission = ref.watch(submissionStateProvider)[problemId] as Map<String, dynamic>?;
    final statsService = ref.read(localStatsServiceProvider);
    final isPremium = statsService.readStats().isPremium;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reveal'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(submissionStateProvider.notifier).update((state) => {...state}..remove(problemId));
              ref.read(revealStepProvider(problemId).notifier).state = 0;
              Navigator.of(context).pop();
            },
            child: const Text('Reattempt'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: problemsAsync.when(
          data: (problems) {
            final problem = problems.where((p) => p.id == problemId).firstOrNull;
            if (problem == null || submission == null) {
              return const Center(child: Text('No submission found, please reattempt.'));
            }

            final canShowHint2 = revealStep >= 1;
            final canShowFinal = revealStep >= 2;
            final canShowCode = revealStep >= 3;

            return ListView(
              children: [
                const Text('Your Submitted Approach', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(submission['approach'] as String),
                const Divider(height: 28),
                _sectionCard('Hint 1', problem.hint1, visible: true),
                _sectionCard('Hint 2', problem.hint2, visible: canShowHint2),
                _sectionCard('Final Approach', problem.finalApproach, visible: canShowFinal),
                _sectionCard(
                  'Sample Java Code',
                  problem.sampleJavaCode,
                  visible: canShowCode,
                  monospace: true,
                ),
                const SizedBox(height: 20),
                if (revealStep < 3)
                  ElevatedButton(
                    onPressed: () async {
                      final needsAd = !isPremium && revealStep >= 0;
                      if (needsAd) {
                        final shown = await ref.read(adServiceProvider).showInterstitialIfAllowed();
                        if (!shown) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ad unavailable/session limit reached. Continuing...')),
                          );
                        }
                      }

                      if (revealStep <= 1) {
                        await statsService.incrementHintsUsed();
                        ref.read(submissionStateProvider.notifier).update((state) {
                          final current = Map<String, dynamic>.from(state[problemId] as Map);
                          current['hintsUsed'] = (current['hintsUsed'] as int) + 1;
                          return {...state, problemId: current};
                        });
                      }

                      ref.read(revealStepProvider(problemId).notifier).state = revealStep + 1;

                      final updatedHints = (ref.read(submissionStateProvider)[problemId] as Map<String, dynamic>)['hintsUsed'] as int;
                      if (revealStep == 2 && updatedHints == 0) {
                        await statsService.incrementIndependentSolve();
                      }
                    },
                    child: Text(revealStep == 0
                        ? 'Unlock Hint 2'
                        : revealStep == 1
                            ? 'Unlock Final Approach'
                            : 'Unlock Sample Java Code'),
                  )
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error: $e'),
        ),
      ),
    );
  }

  Widget _sectionCard(String title, String value, {required bool visible, bool monospace = false}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              visible ? value : 'Locked',
              style: monospace ? const TextStyle(fontFamily: 'monospace') : null,
            ),
          ],
        ),
      ),
    );
  }
}
