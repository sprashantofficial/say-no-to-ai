import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../core/ads/ad_service.dart';
import '../../../core/services/local_stats_service.dart';
import '../../../core/services/purchase_service.dart';
import '../../../shared/providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  BannerAd? _bannerAd;
  bool _bannerLoaded = false;

  @override
  void initState() {
    super.initState();
    Future<void>(() async {
      await ref.read(purchaseServiceProvider).init();
      final isPremium = ref.read(localStatsServiceProvider).readStats().isPremium;
      if (!isPremium) {
        _bannerAd = ref.read(adServiceProvider).createBannerAd(() {
          if (mounted) {
            setState(() => _bannerLoaded = true);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    ref.read(purchaseServiceProvider).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dailyAsync = ref.watch(dailyProblemProvider);
    final allProblemsAsync = ref.watch(allProblemsProvider);
    final stats = ref.watch(localStatsServiceProvider).readStats();

    return Scaffold(
      appBar: AppBar(title: const Text('No-AI Coding Gym')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: dailyAsync.when(
                  data: (daily) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Today\'s Daily Challenge', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(daily?.title ?? 'No problem available'),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: daily == null ? null : () => context.push('/problem/${daily.id}'),
                        child: const Text('Start Daily Challenge'),
                      ),
                    ],
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error: $e'),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text('Current Streak: ${stats.streak}'),
            Text('Total Attempts: ${stats.totalAttempts}'),
            const SizedBox(height: 16),
            const Text('All Problems', style: TextStyle(fontWeight: FontWeight.bold)),
            allProblemsAsync.when(
              data: (problems) => problems.isEmpty
                  ? const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('No problems found.')))
                  : Column(
                      children: problems
                          .map((problem) => ListTile(
                                title: Text(problem.title),
                                subtitle: Text('${problem.difficulty} • ${problem.topic}'),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () => context.push('/problem/${problem.id}'),
                              ))
                          .toList(),
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Unable to load problems: $e'),
            ),
            const SizedBox(height: 20),
            if (!stats.isPremium && _bannerLoaded && _bannerAd != null)
              SizedBox(height: 50, child: AdWidget(ad: _bannerAd!)),
            if (!stats.isPremium)
              OutlinedButton(
                onPressed: () => _handlePremium(context),
                child: const Text('Unlock Premium'),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePremium(BuildContext context) async {
    final purchaseService = ref.read(purchaseServiceProvider);
    final product = await purchaseService.loadPremiumProduct();
    if (product == null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Premium product unavailable right now.')),
      );
      return;
    }
    await purchaseService.buyPremium(product);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Purchase flow started.')),
    );
  }
}
