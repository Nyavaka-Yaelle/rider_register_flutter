import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/screens/profile/base_tds_screen.dart';
import 'package:rider_register/screens/profile/profile_account_screen.dart';
import 'package:rider_register/screens/profile/profile_route.dart';
import 'package:rider_register/utility/format.dart';

class ProfilePhoneNumScreen extends StatefulWidget {
  const ProfilePhoneNumScreen({super.key});

  @override
  State<ProfilePhoneNumScreen> createState() => _ProfilePhoneNumScreenState();
}

class _ProfilePhoneNumScreenState extends State<ProfilePhoneNumScreen> {
  bool hasChanged = false;

  @override
  Widget build(BuildContext context) {
    String title = 'Téléphone';
    final deliveryData = Provider.of<DeliveryData>(context, listen: true);

    void showChanged() {
      setState(() {
        hasChanged = true;
      });
      final snackBar = SnackBar(
        content: const Text('Votre numéro a été mis à jour avec succès'),
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
          'Votre numéro de téléphone contribue à la sécurité\nde votre compte.',
      sub:
          'Il ne sera pas utilisé lors de vos communications avec \nles livreurs et chauffeurs.',
      children: [
        SizedBox(height: 26.h),
        ListTileBase(
            item: MenuItem(
              icon: Icons.phone,
              label: 'TELEPHONE',
              description:
                  formatPhoneNumber(deliveryData.userFire!.phoneNumber!),
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
                    'destination': MPR.PHONE_NUM_EDIT_NEW,
                    'title': 'Téléphone'
                  },
                ),
              ),
      ],
    );
  }
}

class TextFilledButton extends StatelessWidget {
  const TextFilledButton({
    super.key,
    required this.func2,
    required this.lab2,
  });

  final VoidCallback func2;
  final String lab2;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 74.v,
          child: TextButton(
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                color: scheme.primary,
                fontSize: 14.fSize,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
        ),
        SizedBox(width: 24.v),
        SizedBox(
          width: 113.v,
          child: FilledButton(
            onPressed: func2,
            child: Text(lab2),
          ),
        ),
      ],
    );
  }
}
