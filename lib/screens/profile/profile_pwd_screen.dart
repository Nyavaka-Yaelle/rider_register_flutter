import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/screens/profile/base_tds_screen.dart';
import 'package:rider_register/screens/profile/profile_account_screen.dart';
import 'package:rider_register/screens/profile/profile_phone_num_screen.dart';
import 'package:rider_register/screens/profile/profile_route.dart';

class ProfilePwdScreen extends StatefulWidget {
  const ProfilePwdScreen({super.key});

  @override
  State<ProfilePwdScreen> createState() => _ProfilePwdScreenState();
}

class _ProfilePwdScreenState extends State<ProfilePwdScreen> {
  bool hasChanged = false;

  @override
  Widget build(BuildContext context) {
    String title = 'Mot de passe';
    void showChanged() {
      setState(() {
        hasChanged = true;
      });
      final snackBar = SnackBar(
        content: const Text('Votre mot de passe a été modifié avec succès.'),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return BaseTdsScreen(
      title: title,
      desc:
          'Vos identifiants de connexion, en particulier votre mot de passe est confidentiel.',
      sub:
          'Ne jamais divulger votre mot de passe, afin de préserver\nl’intégrité et la sécurité de votre compte.',
      children: [
        SizedBox(height: 26.h),
        ListTileBase(
            item: MenuItem(
              icon: Icons.lock_outlined,
              label: 'MOT DE PASSE',
              description: '..............',
            ),
            hasTrailing: false),
        SizedBox(height: 36.h),
        hasChanged
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 106.v,
                    height: 40.h,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Terminer'),
                    ),
                  )
                ],
              )
            : TextFilledButton(
                lab2: "Modifier",
                func2: () => Navigator.pushNamed(
                  context,
                  MPR.VERIFY_USER,
                  arguments: {
                    'showChanged': showChanged,
                    'destination': MPR.PWD_EDIT_NEW,
                    'title': title,
                  },
                ),
              ),
      ],
    );
  }
}
