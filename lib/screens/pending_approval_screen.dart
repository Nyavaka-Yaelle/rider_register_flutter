import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/services/ad_mob_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../main.dart';
import 'home_finally_page/Accueille.dart';
import 'mydelivery_screen.dart';
import 'myprofile_screen.dart';

class PendingApprovalScreen extends StatefulWidget {
  const PendingApprovalScreen({super.key});

  @override
  State<PendingApprovalScreen> createState() => _PendingApprovalScreenState();
}

class _PendingApprovalScreenState extends State<PendingApprovalScreen> {
  BannerAd? _bannerAd;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      // size: AdSize.fullBanner,
      size: AdSize.banner,
      adUnitId: AdMobService.bannerRegistredAdUnitId!,
      listener: AdMobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      if (_currentIndex == 0) {
        //Delay for 500ms

        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Accueille()),
          );
        });
      }
      if (_currentIndex == 1) {
        //Delay for 500ms
        context.read<DeliveryData>().clear();

        Future.delayed(const Duration(milliseconds: 500), () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => MyDeliveryScreen()),
          // );
        });
      }
      if (_currentIndex == 4) {
        //Delay for 500ms
        context.read<DeliveryData>().clear();

        Future.delayed(const Duration(milliseconds: 500), () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => MyProfileScreen()),
          // );
        });
      }
      print('index: $_currentIndex');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.penddingApprovalAppBar,
          textAlign: TextAlign.center,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.penddingApprovalTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 48,
                ),
                Text(
                  AppLocalizations.of(context)!.penddingApprovalMessage,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Acceuil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining),
            label: 'Livraisons',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
