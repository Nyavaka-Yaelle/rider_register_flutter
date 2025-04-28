import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/repository/livraison_repository.dart';
import 'package:rider_register/screens/home_finally_page/pages.dart';
import 'package:rider_register/screens/mydelivery_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:rider_register/screens/choice_screen.dart'; // Import ChoiceScreen

import '../../main.dart';
import '../../repository/appareiluser_repository.dart';
import '../../repository/user_repository.dart';

import '../../../core/app_export.dart';
// ignore_for_file: must_be_immutable

class Accueille extends StatefulWidget {
  const Accueille({Key? key}) : super(key: key);

  @override
  _AccueilleState createState() => _AccueilleState();
}

class _AccueilleState extends State<Accueille> {
  int _currentIndex = 0;
  bool isShowBotNavBar = true;
  AppareilUserRepository appareilUserRepository = AppareilUserRepository();
  String? currentid;
  LivraisonRepository livraisonRepository = LivraisonRepository();
  final UserRepository userRepository = UserRepository();
  int livraisonbadge = 0;

  @override
  void initState() {
    super.initState();
    currentid = userRepository.getCurrentUser()?.uid;
    if (currentid != null) {
      appareilUserRepository.addAppareilUser(currentid!);
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        int count = await livraisonRepository
            .getLivraisonsCanceledByIdUserCount(currentid!);
        setState(() {
          livraisonbadge = count;
        });
      });
    }
  }

  void _onItemTapped(int index) {
    final User? user = FirebaseAuth.instance.currentUser;

    if ((index == 1 || index == 2 || index == 3) && user == null) {
      // User is not authenticated, navigate to ChoiceScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChoiceScreen()),
      );
    } else {
      // User is authenticated or screen doesn't require authentication
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void setIsShowBotNavBar(bool value) {
    setState(() {
      isShowBotNavBar = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the list of pages based on the current index and authentication status
    List<Widget> currentPages =
        pages(_currentIndex, setIsShowBotNavBar, _onItemTapped);
    Widget currentPage = currentPages[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        elevation: 0,
        toolbarHeight: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: currentPage,
      bottomNavigationBar: isShowBotNavBar
          ? NavigationBarTheme(
              data: NavigationBarThemeData(
                labelTextStyle: MaterialStateProperty.all(
                  TextStyle(fontSize: 12.fSize), // Set the font size here
                ),
              ),
              child: NavigationBar(
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
                    selectedIcon: Icon(Icons.notifications),
                    icon: Icon(Icons.notifications),
                    label: 'Notifications',
                  ),
                  const NavigationDestination(
                    selectedIcon: Icon(Icons.person),
                    icon: Icon(Icons.person_outline),
                    label: 'Profile',
                  ),
                ],
              ),
            )
          : null,
    );
  }
}

class IconNotif extends StatelessWidget {
  const IconNotif({
    super.key,
    required this.badge,
    this.icon = Icons.delivery_dining,
  });

  final int badge;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Icon(icon),
        if (badge > 0)
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
              child: Text(
                badge.toString(),
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
