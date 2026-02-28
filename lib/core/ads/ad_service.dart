import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final adServiceProvider = Provider<AdService>((_) => AdService());

class AdService {
  static const _bannerUnitId = 'ca-app-pub-3940256099942544/6300978111';
  static const _interstitialUnitId = 'ca-app-pub-3940256099942544/1033173712';

  int _sessionInterstitialCount = 0;

  BannerAd createBannerAd(VoidCallback onLoaded) {
    final ad = BannerAd(
      adUnitId: _bannerUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(onAdLoaded: (_) => onLoaded()),
    );
    ad.load();
    return ad;
  }

  Future<bool> showInterstitialIfAllowed() async {
    if (_sessionInterstitialCount >= 3) {
      return false;
    }

    InterstitialAd? ad;
    await InterstitialAd.load(
      adUnitId: _interstitialUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (loadedAd) {
          ad = loadedAd;
        },
        onAdFailedToLoad: (_) {},
      ),
    );

    if (ad == null) {
      return false;
    }

    final completer = Future<bool>.value(true);
    _sessionInterstitialCount += 1;
    ad!.show();
    ad!.dispose();
    return completer;
  }
}
