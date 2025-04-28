import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/screens/profile/base_tds_screen.dart';
import 'package:rider_register/screens/profile/profile_phone_num_screen.dart';
import 'package:rider_register/utility/printanah.dart';
import 'package:rider_register/models/user.dart' as UserFire;

class VerifyUserScreen extends StatelessWidget {
  const VerifyUserScreen({
    super.key,
    required this.title,
    required this.func2,
  });

  final String title;
  final Function() func2;

  @override
  Widget build(BuildContext context) {
    final deliveryData = Provider.of<DeliveryData>(context, listen: true);
    deliveryData.setUserFire(deliveryData.userFire);
    final oldPwdCtrl = TextEditingController();
    UserRepository _userRepository = UserRepository();

    void next() {
      try {
        final user = FirebaseAuth.instance.currentUser;
        _userRepository
            .getUserById(user!.uid)
            .then((UserFire.User? result) async {
          if (result!.password == oldPwdCtrl.text)
            func2();
          else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Le mot de passe est incorrect")),
            );
          }
        });
      } catch (e) {
        printredinios(e.toString());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }

    return BaseTdsScreen(
      title: title,
      desc: 'Pour continuer, veuillez confirmer votre identité',
      children: [
        SizedBox(height: 46.h),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'Saisissez votre mot de passe',
            hintStyle: TextStyle(
              color: scheme.onSurface,
              fontSize: 16.fSize,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          ),
          controller: oldPwdCtrl,
        ),
        SizedBox(height: 36.h),
        TextFilledButton(lab2: "Suivant", func2: next),
      ],
    );
  }
}
