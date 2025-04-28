import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4031416549568892/1445535929';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4031416549568892/7502326748';
    }
    return null;
  }

  static String? get bannerAdUnitIdRegisterForm1 {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4031416549568892/9462349059';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4031416549568892/1651856387';
    }
    return null;
  }

  static String? get bannerAdUnitIdRegisterForm2 {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4031416549568892/1640517594';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4031416549568892/4538143678';
    }
    return null;
  }

  static String? get bannerAdUnitIdRegisterForm3 {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4031416549568892/7155464504';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4031416549568892/6912207334';
    }
    return null;
  }

  static String? get bannerAdUnitIdRegisterForm4 {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4031416549568892/4150312622';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4031416549568892/9362825443';
    }
    return null;
  }

  static String? get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4031416549568892/2629686706';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4031416549568892/2246543326';
    }
    return null;
  }

  static String? get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4031416549568892/3247386961';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4031416549568892/7502326748';
    }
    return null;
  }

  static String? get bannerRegistredAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4031416549568892/6844932764';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4031416549568892/1266549865';
    }
    return null;
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('ad loaded'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      // debugPrint("ad failed to load: $error");
      debugPrint("ad failed to load: ad_mob_service.dart");
    },
    onAdOpened: (ad) => debugPrint('ad opened'),
    onAdClosed: (ad) => debugPrint('ad closed'),
  );
}
