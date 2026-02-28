import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'core/theme/app_theme.dart';
import 'core/utils/app_router.dart';
import 'core/services/local_stats_service.dart';
import 'core/ads/ad_service.dart';
import 'core/services/purchase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();

  final localStatsService = await LocalStatsService.create();
  final purchaseService = await PurchaseService.create(localStatsService.preferences);

  runApp(
    ProviderScope(
      overrides: [
        localStatsServiceProvider.overrideWithValue(localStatsService),
        purchaseServiceProvider.overrideWithValue(purchaseService),
      ],
      child: const NoAiCodingGymApp(),
    ),
  );
}

class NoAiCodingGymApp extends ConsumerWidget {
  const NoAiCodingGymApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'No-AI Coding Gym',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
