import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/screens/profile/base_tds_screen.dart';
import 'package:rider_register/screens/profile/profile_account_screen.dart';
import 'package:rider_register/widgets/line.dart';

class ProfileAddressTypeScreen extends StatelessWidget {
  const ProfileAddressTypeScreen({
    super.key,
    required this.title,
    required this.desc,
    required this.sub,
    required this.children,
  });

  final String title, desc, sub;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return BaseTdsScreen(
      title: title,
      desc: desc,
      sub: sub,
      children: children,
    );
  }
}
