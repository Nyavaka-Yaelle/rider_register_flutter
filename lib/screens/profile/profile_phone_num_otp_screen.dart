import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/screens/profile/profile_identity_screen.dart';
import 'package:rider_register/screens/profile/profile_route.dart';
import 'package:rider_register/utility/format.dart';
import 'package:rider_register/utility/printanah.dart';

class ProfilePhoneNumOtpScreen extends StatelessWidget {
  const ProfilePhoneNumOtpScreen({super.key, required this.showChanged});

  final Function showChanged;

  @override
  Widget build(BuildContext context) {
    final deliveryData = Provider.of<DeliveryData>(context, listen: true);
    return Scaffold(
      backgroundColor: scheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: scheme.secondaryContainer,
        shadowColor: Colors.transparent,
        foregroundColor: scheme.shadow,
        title: Text('Vérification'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 18.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 15.h),
                Text(
                  'Un code a été envoyé au numéro',
                  style: TextStyle(
                    color: scheme.secondary,
                    fontSize: 14.fSize,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  formatPhoneNumStars(deliveryData.userFire!.phoneNumber!),
                  style: TextStyle(
                    color: Color(0xFF00201C),
                    fontSize: 22,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(height: 37.h),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  enableActiveFill: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12.v),
                    fieldHeight: 48.v,
                    fieldWidth: 48.v,
                    activeColor: scheme.outlineVariant,
                    activeFillColor: scheme.surface, // BOO
                    inactiveColor: scheme.surfaceContainerHighest,
                    inactiveFillColor: scheme.surfaceContainerHighest,
                    selectedFillColor: scheme.surfaceContainerHighest,
                    selectedColor: scheme.surfaceContainerHighest,
                  ),
                  cursorColor: scheme.shadow,
                  // animationDuration: const Duration(milliseconds: 300),
                  // enableActiveFill: true,
                  // controller: TextEditingController(),
                  // onCompleted: (pin) {
                  //   print("complete: $pin");
                  // },
                  // onChanged: (value) {
                  //   print(value);
                  // },
                  // beforeTextPaste: (text) {
                  //   print("beforeTextPaste: $text");
                  //   return true;
                  // },
                ),
                SizedBox(height: 135.h),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      showChanged();
                      Navigator.popUntil(
                        context,
                        (route) => route.settings.name == MPR.PHONE_NUM,
                      );
                    },
                    child: const Text('Valider'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
