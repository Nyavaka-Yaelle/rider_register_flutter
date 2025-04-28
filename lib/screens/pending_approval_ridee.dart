import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rider_register/screens/mydelivery_screen.dart';
import 'package:rider_register/screens/restaurants_screen.dart';
import 'package:rider_register/services/ad_mob_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'home_finally_page/Accueille.dart';
import 'destination1_screen.dart';
import 'myprofile_screen.dart';
import '../../../core/app_export.dart';
import '../main.dart';
import 'package:provider/provider.dart';

class PendingApprovalRidee extends StatefulWidget {
  const PendingApprovalRidee({super.key});

  @override
  State<PendingApprovalRidee> createState() => _PendingApprovalRideeState();
}

class _PendingApprovalRideeState extends State<PendingApprovalRidee> {
  BannerAd? _bannerAd;
  int _currentIndex = 0;
  int livraisonbadge = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_currentIndex == 0) {
      setState(() {
        _currentIndex = 0;
      });
      context.read<DeliveryData>().clear();
      Future.delayed(const Duration(milliseconds: 200), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Accueille()),
        );
      });
    }
    if (_currentIndex == 1) {
      setState(() {
        _currentIndex = 0;
      });
      context.read<DeliveryData>().clear();
      Future.delayed(const Duration(milliseconds: 200), () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => MyDeliveryScreen()),
        // );
      });
    }
    if (_currentIndex == 2) {
      setState(() {
        _currentIndex = 0;
      });
    }
    if (_currentIndex == 3) {
      setState(() {
        _currentIndex = 0;
      });
      context.read<DeliveryData>().clear();
      Future.delayed(const Duration(milliseconds: 200), () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => MyProfileScreen()),
        // );
      });
    }
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
        Future.delayed(const Duration(milliseconds: 500), () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => MyDeliveryScreen()),
          // );
        });
      }
      if (_currentIndex == 4) {
        //Delay for 500ms
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Write your code here
          Future.delayed(Duration(milliseconds: 500), () {
            //Navigate to the pending approval screen
            // Navigator.pushAndRemoveUntil(
            //   context,
            //   MaterialPageRoute(builder: (context) => MyDeliveryScreen()),
            //   (route) => false,
            // );
          });
          return true;
        },
        child: Scaffold(
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
                      // an image at the center
                      const Image(
                        image: AssetImage('assets/logo/link.png'),
                        height: 200,
                      ),
                      Text(
                        "En attente du confirmation par le Rider",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                      Text(
                        "Merci d'avoir utilisé nos services, un Rider viendra bientôt vous chercher.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: NavigationBar(
              backgroundColor: scheme.surfaceContainer,
              onDestinationSelected: _onItemTapped,
              selectedIndex: _currentIndex,
              destinations: <NavigationDestination>[
                const NavigationDestination(
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(Icons.home_outlined),
                  label: 'Accueil',
                ),
                NavigationDestination(
                  icon: IconNotif(badge: livraisonbadge),
                  selectedIcon: IconNotif(
                      badge: livraisonbadge, icon: Icons.delivery_dining),
                  label: 'Mes Livraisons',
                ),
                const NavigationDestination(
                  selectedIcon: Icon(Icons.favorite),
                  icon: Icon(Icons.notifications),
                  label: 'Notifications',
                ),
                const NavigationDestination(
                  selectedIcon: Icon(Icons.person),
                  icon: Icon(Icons.person_outline),
                  label: 'Profile',
                ),
              ],
            )));
  }
}
