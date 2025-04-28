import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/screens/profile/base_tds_screen.dart';
import 'package:rider_register/screens/profile/profile_identity_screen.dart';
import 'package:rider_register/screens/profile/profile_phone_num_screen.dart';
import 'package:rider_register/screens/profile/profile_route.dart';
import 'package:rider_register/utility/loading.dart';
import 'package:rider_register/utility/printanah.dart';
import 'package:rider_register/models/user.dart' as UserFire;

class ProfilePwdEditNewScreen extends StatelessWidget {
  const ProfilePwdEditNewScreen({super.key, required this.showChanged});

  final Function showChanged;

  @override
  Widget build(BuildContext context) {
    String title = 'Mot de passe';

    final newPwdCtrl = TextEditingController();
    final confirmPwdCtrl = TextEditingController();

    final deliveryData = Provider.of<DeliveryData>(context, listen: true);
    deliveryData.setUserFire(deliveryData.userFire);
    UserRepository _userRepository = UserRepository();

    void submitUpdate() async {
      try {
        FocusScope.of(context).unfocus();
        final user = FirebaseAuth.instance.currentUser;
        _userRepository
            .getUserById(user!.uid)
            .then((UserFire.User? result) async {
          if (newPwdCtrl.text == confirmPwdCtrl.text) {
            if (user != null && newPwdCtrl.text.isNotEmpty) {
              await _userRepository.updateuserpassword(
                  user.uid, newPwdCtrl.text);
              showChanged();
              Navigator.popUntil(
                context,
                (route) => route.settings.name == MPR.PWD,
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Le nouveau mot de passe et la confirmation ne correspondent pas')),
            );
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update password: $e')),
        );
      }
    }

    return BaseTdsScreen(
      title: title,
      desc: 'Veuillez entrer votre nouveau mot de passe',
      sub:
          'Nous vous conseillons de combiner des lettres, \ndes chiffres, des symboles.',
      children: [
        SizedBox(height: 26.h),
        TextFieldIcon(
          icon: const Icon(Icons.lock_outlined),
          labelText: 'Nouveau mot de passe',
          controller: newPwdCtrl,
          obscure: true,
        ),
        SizedBox(height: 20.h),
        TextFieldIcon(
          labelText: 'Confirmer votre nouveau mot de passe',
          controller: confirmPwdCtrl,
          obscure: true,
        ),
        SizedBox(height: 36.h),
        TextFilledButton(lab2: 'Modifier', func2: submitUpdate),
      ],
    );
  }
}
