import 'package:flutter/material.dart';
import 'package:rider_register/screens/home_finally_page/home_page.dart';
import 'package:rider_register/screens/myprofile_screen.dart';
import 'package:rider_register/screens/mydelivery_screen.dart';
import 'package:rider_register/screens/choice_screen.dart';
import 'package:rider_register/screens/notifs_screen.dart';
List<Widget> pages(
  int currentIndex,
  Function(bool) setIsShowBotNavBar,
  Function(int) changeTabIndex, // Added parameter
) =>
    <Widget>[
      HomePage(),
      MyDeliveryScreen(
               setIsShowBotNavBar: setIsShowBotNavBar,
        changeTabIndex: changeTabIndex, // Pass to MyProfileScreen
      ),
      NotifsScreen(    setIsShowBotNavBar: setIsShowBotNavBar,
        changeTabIndex: changeTabIndex,),
      MyProfileScreen(
        setIsShowBotNavBar: setIsShowBotNavBar,
        changeTabIndex: changeTabIndex, // Pass to MyProfileScreen
      ),
    ];