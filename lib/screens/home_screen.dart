import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/screens/register_form1_screen.dart';
import 'package:rider_register/services/ad_mob_service.dart';
import 'package:rider_register/widgets/dropdown_button_language.dart';
import 'package:rider_register/widgets/sized_box_height.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;
  UserRepository userRepository = UserRepository();
  String? currentid;
  User? user;
  @override
  void initState() {
    currentid = userRepository.getCurrentUser()?.phoneNumber;

    super.initState();
    if (Platform.isAndroid || Platform.isIOS) _createBannerAd();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      // size: AdSize.fullBanner,
      size: AdSize.banner,
      adUnitId: AdMobService.bannerAdUnitId!,
      listener: AdMobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(currentid.toString()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logo.png', scale: 5),
            const SizedBoxHeight(height: "sm"),
            const DropdownButtonLanguage(),
            const SizedBoxHeight(height: "sm"),
            ElevatedButton(
              child: Text(AppLocalizations.of(context)!.beginRegister),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RegisterForm1Screen()),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bannerAd == null
          ? Container()
          : Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 52,
              child: AdWidget(ad: _bannerAd!),
            ),
    );
  }
}
