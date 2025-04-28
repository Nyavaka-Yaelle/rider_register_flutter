import 'package:flutter/material.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import './new_password.dart';
import './otp_screen.dart';
import '../theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import '../services/TwilioService.dart';

class ForgotPassword extends StatefulWidget {
   
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController telController = TextEditingController();
  final TwilioService twilioService = TwilioService();

  Color appBarColor = MaterialTheme.lightScheme().surfaceContainerLowest; // Couleur par défaut
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    telController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Modifier la couleur selon la position de défilement
    setState(() {
      // appBarColor = MaterialTheme.lightScheme().surfaceContainerLowest;
      appBarColor = _scrollController.offset > 50
          ? MaterialTheme.lightScheme().surfaceContainerLowest
          : MaterialTheme.lightScheme().surfaceContainerLowest;
    });
  }
  void _updateButtonState() {
    setState(() {
      isButtonEnabled = RegExp(r'^\d{3} \d{2} \d{3} \d{2}$').hasMatch(telController.text);
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.0), // Flèche "Retour"
          onPressed: () {
            print("Retour à l'écran précédent");
            Navigator.pop(context); // Retour à l'écran précédent
          },
        ),
        backgroundColor: appBarColor, // Couleur dynamique
      ),
      body: SingleChildScrollView(
        controller: _scrollController, // Ajout du ScrollController
        child: Padding(
          // padding: const EdgeInsets.all(24.0),
          padding: const EdgeInsets.fromLTRB(24.0, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Align(
              //   alignment: Alignment.centerLeft,
              //   child: Image.asset(
              //     'assets/images/login_image.png',
              //     height: 56.0,
              //     fit: BoxFit.contain,
              //   ),
              // ),
              SizedBox(height: 12.0),
              Text(
                'Vous avez oublié votre\nMot de passe ?',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 12.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,8),
                child: Text(
                  'Aucune inquiétude cela peut arriver. \nVeuillez entrer le numéro de téléphone associé à votre compte.',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              Table(
                columnWidths: {
                  0: FlexColumnWidth(0.1),
                  1: FlexColumnWidth(0.9),
                },
                children: [
                  TableRow(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 56.0,
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.call_outlined,
                            color: MaterialTheme.lightScheme().onSurface,
                            size: 24.0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CustomInput(
                          hintText: "Téléphone",
                          labelText: "Téléphone",
                          controller: telController,
                          isNumero: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
               SizedBox(height: 32.0),
            Row(
  mainAxisSize: MainAxisSize.min,
  mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Container(
      width: 140.0,
      child: CustomButton(
        label: "SMS",
        isDisabled: !isButtonEnabled,
        onPressed: isButtonEnabled
            ? () async {
                print("Button pressed!");
                String _phoneNumber = telController.text.replaceFirst(RegExp(r'^0'), '+261');
                _phoneNumber = _phoneNumber.replaceAll(' ', '');

                bool otpSent = await twilioService.sendOtp(_phoneNumber, 'sms');

                if (otpSent) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OtpScreen(
                        numero: _phoneNumber,
                        verificationId: "test",
                      ),
                    ),
                  );
                } else {
                  // Handle OTP sending failure
                  print('Failed to send OTP');
                }
              }
            : null,
        color: MaterialTheme.lightScheme().primary,
      ),
    ),
        SizedBox(width:20.0), // Adjust the width to reduce the space between buttons

    Container(
      width: 140.0,
      child: CustomButton(
        label: "Whatsapp",
        isDisabled: true,
        onPressed: isButtonEnabled
            ? () async {
                print("WhatsApp button pressed!");
                String _phoneNumber = telController.text.replaceFirst(RegExp(r'^0'), '+261');
                _phoneNumber = _phoneNumber.replaceAll(' ', '');

                // Use the sendOtp method with 'whatsapp' as the channel.
                bool otpSent = await twilioService.sendOtp(_phoneNumber, 'whatsapp');

                if (otpSent) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OtpScreen(
                        numero: _phoneNumber,
                        verificationId: "test",
                      ),
                    ),
                  );
                } else {
                  // Handle OTP sending failure
                  print('Failed to send OTP via WhatsApp');
                }
              }
            : null,
        color: MaterialTheme.lightScheme().primary,
      ),
    ),
  ],
),
            ],
          ),
        ),
      ),
    );
  }
}
