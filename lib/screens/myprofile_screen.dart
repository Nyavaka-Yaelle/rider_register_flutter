import 'package:flutter/material.dart';
import 'package:rider_register/screens/profile/profile_account_screen.dart';
import 'package:rider_register/screens/profile/profile_address_house_screen.dart';
import 'package:rider_register/screens/profile/profile_address_screen.dart';
import 'package:rider_register/screens/profile/profile_address_type_screen.dart';
import 'package:rider_register/screens/profile/profile_home_screen.dart';
import 'package:rider_register/screens/profile/profile_identity_screen.dart';
import 'package:rider_register/screens/profile/profile_phone_num_edit_new_screen.dart';
import 'package:rider_register/screens/profile/profile_phone_num_otp_screen.dart';
import 'package:rider_register/screens/profile/profile_phone_num_screen.dart';
import 'package:rider_register/screens/profile/profile_pic_screen.dart';
import 'package:rider_register/screens/profile/profile_pwd_edit_new_screen.dart';
import 'package:rider_register/screens/profile/profile_pwd_screen.dart';
import 'package:rider_register/screens/profile/profile_route.dart';
import 'package:rider_register/screens/profile/profile_story_screen.dart';
import 'package:rider_register/screens/profile/verify_user_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({
    Key? key,
    required this.setIsShowBotNavBar,
    required this.changeTabIndex,
    required this.lastTabIndex,

  }) : super(key: key);

  final Function(bool) setIsShowBotNavBar;
  final Function(int) changeTabIndex;
  final int lastTabIndex; // Ajout du paramètre pour le dernier onglet


  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  void onPressed(){
    widget.changeTabIndex(widget.lastTabIndex); 
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show the bottom navigation bar
        widget.setIsShowBotNavBar(true);
        // Navigate to the Accueil tab (index 0)
        widget.changeTabIndex(0);
        return false; // Prevent default back navigation
      },
      child: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;

          if (settings.name == MPR.MAIN) {
            builder = (BuildContext context) => ProfileHomeScreen(onPressed: onPressed);
          } else if (settings.name == MPR.ACCOUNT) {
            widget.setIsShowBotNavBar(false);
            builder = (BuildContext context) =>
                ProfileAccountScreen(setIsShowBotNavBar: widget.setIsShowBotNavBar);
          } else if (settings.name == MPR.IDENTITY) {
            builder = (BuildContext context) => const ProfileIdentityScreen();
          } else if (settings.name == MPR.PHONE_NUM) {
            builder = (BuildContext context) => const ProfilePhoneNumScreen();
          } else if (settings.name == MPR.VERIFY_USER) {
            final arguments = settings.arguments as Map;
            builder = (BuildContext context) => VerifyUserScreen(
                  title: arguments['title'],
                  func2: () => Navigator.pushNamed(
                    context,
                    arguments['destination'],
                    arguments: {'showChanged': arguments['showChanged']},
                  ),
                );
          } else if (settings.name == MPR.PHONE_NUM_EDIT_NEW) {
            final arguments = settings.arguments as Map;
            builder = (BuildContext context) => ProfilePhoneNumEditNewScreen(
                  showChanged: arguments['showChanged'],
                );
          } else if (settings.name == MPR.PWD_EDIT_NEW) {
            final arguments = settings.arguments as Map;
            builder = (BuildContext context) => ProfilePwdEditNewScreen(
                  showChanged: arguments['showChanged'],
                );
          } else if (settings.name == MPR.PICTURE) {
            widget.setIsShowBotNavBar(false);
            builder = (BuildContext context) =>
                ProfilePicScreen(setIsShowBotNavBar: widget.setIsShowBotNavBar);
          } else if (settings.name == MPR.PHONE_NUM_OTP) {
            final arguments = settings.arguments as Map;
            builder = (BuildContext context) => ProfilePhoneNumOtpScreen(
                  showChanged: arguments['showChanged'],
                );
          } else if (settings.name == MPR.PWD) {
            builder = (BuildContext context) => const ProfilePwdScreen();
          } else if (settings.name == MPR.ADDRESS) {
            builder = (BuildContext context) => const ProfileAddressScreen();
          } else if (settings.name == MPR.ADDRESS_HOUSE) {
            builder = (BuildContext context) => const ProfileAddressHouseScreen();
          } else if (settings.name == MPR.ADDRESS_TYPE) {
            final map = settings.arguments as Map;
            builder = (BuildContext context) => ProfileAddressTypeScreen(
                  title: map['title'],
                  desc: map['desc'],
                  sub: map['sub'],
                  children: map['children'] as List<Widget>,
                );
          } else if (settings.name == MPR.STORY) {
            widget.setIsShowBotNavBar(false);
            builder = (BuildContext context) => ProfileStoryScreen(
                  setIsShowBotNavBar: widget.setIsShowBotNavBar,
                );
          } else {
            throw Exception('Invalid route: ${settings.name}');
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }
}