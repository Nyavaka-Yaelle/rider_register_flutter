import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/screens/profile/base_tds_screen.dart';
import 'package:rider_register/screens/profile/profile_identity_screen.dart';
import 'package:rider_register/screens/profile/profile_phone_num_screen.dart';
import 'package:rider_register/screens/profile/profile_route.dart';

class ProfilePhoneNumEditNewScreen extends StatelessWidget {
  const ProfilePhoneNumEditNewScreen({super.key, required this.showChanged});

  final Function showChanged;

  @override
  Widget build(BuildContext context) {
    String title = 'Téléphone';
    final deliveryData = Provider.of<DeliveryData>(context, listen: true);
    deliveryData.setUserFire(deliveryData.userFire);
    return BaseTdsScreen(
      title: title,
      desc: 'Veuillez entrer votre nouveau numéro de téléphone',
      children: [
        SizedBox(height: 46.h),
        TextFieldIcon(
          labelText: title,
          icon: Icon(Icons.phone_outlined),
        ),
        SizedBox(height: 36.h),
        TextFilledButton(
          lab2: 'Mettre à jour',
          func2: () => Navigator.pushNamed(
            context,
            MPR.PHONE_NUM_OTP,
            arguments: {'showChanged': showChanged},
          ),
        ),
      ],
    );
  }
}
