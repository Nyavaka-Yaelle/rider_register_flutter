import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/screens/accueil_screen.dart';
import 'package:rider_register/screens/placeholder_screen.dart';
import 'package:rider_register/models/user.dart' as UserFire;
import 'package:rider_register/screens/register_screen.dart' as register;
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';

import 'package:rider_register/widgets/custom_password.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/theme/custom_button_style.dart';
import 'package:rider_register/widgets/app_bar/appbar_leading_iconbutton.dart';
import 'package:rider_register/widgets/app_bar/appbar_title.dart';
import 'package:rider_register/widgets/app_bar/custom_app_bar.dart';
import 'package:rider_register/widgets/custom_elevated_button.dart';
import 'package:rider_register/widgets/custom_phone_number.dart';
//
import 'package:flutter/material.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import '../components/horizontal_line.dart';
import '../components/account_text.dart';
import '../components/toast_util.dart';
// import './signup_screen.dart';
// import './splash_screen.dart';
import './forgot_password.dart';
import '../theme.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserRepository userRepository = UserRepository();

  Color appBarColor =
      MaterialTheme.lightScheme().surfaceContainerLowest; // Couleur par défaut
  bool isButtonEnabled = false;
  String loginError = '';
  bool isLogging = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    telController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      appBarColor = _scrollController.offset > 50
          ? MaterialTheme.lightScheme().surfaceContainerLowest
          : MaterialTheme.lightScheme().surfaceContainerLowest;
    });
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = telController.text.replaceAll(' ', '').length == 10 &&
          passwordController.text.length >= 6;
    });
  }

  void _onLoginPressed() {
    setState(() {
      isLogging = true;
    });

    String _phonenumber = telController.text.replaceFirst(RegExp(r'^0'), '+261');
    _phonenumber = _phonenumber.replaceAll(' ', '');
    String _password = passwordController.text;

    print("Button pressed!");
    print("Téléphone: $_phonenumber");
    print("Mot de passe: $_password");

    userRepository
        .getUserWitPhoneNumber(_phonenumber, _password)
        .then((UserFire.User? result) {
      print(result?.phoneNumber);
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: "${result?.phoneNumber}@gmail.com", password: _password)
          .then((value) {
        setState(() {
          isLogging = false;
        });
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => AccueilScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      }).catchError((error) {
        setState(() {
          isLogging = false;
        });
        if (error is FirebaseAuthException) {
          ToastUtil.showToast('Numéro ou mot de passe erroné');
          print("Firebase Authentication Error: ${error.message}");
        } else {
          print("Error: $error");
        }
      });
    }).catchError((error) {
      setState(() {
        isLogging = false;
      });
      print("Error: $error");
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
                    Navigator.pop(context);

          },
        ),
        backgroundColor: scheme.surfaceContainerLowest,//appBarColor, // Couleur dynamique
      ),
      body: Container(
        color: scheme.surfaceContainerLowest,
        height: double.infinity,
        child:Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController, // Ajout du ScrollController
            child: Container(
              padding: const EdgeInsets.fromLTRB(24.0, 0, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/logo_dago.png',
                      // 'assets/images/login_image.png',
                      height: 56.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'Connexion',
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
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                    child: Text(
                      'Accéder à dagô pour des services faites sur mesure pour vous.',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 16,
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
                      TableRow(
                        children: [
                          SizedBox(height: 16.0),
                          SizedBox(height: 16.0),
                        ],
                      ),
                      TableRow(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Container(
                              height: 56.0,
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.lock_outlined,
                                color: MaterialTheme.lightScheme().onSurface,
                                size: 24.0,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: CustomInput(
                              hintText: "Entrez votre mot de passe",
                              labelText: "Mot de passe",
                              suffixIcon: Icons.visibility_off_outlined,
                              controller: passwordController,
                              isPassword: true,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 4.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        print('Mot de passe oublié cliqué');
                                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()),
                    );
                      },
                      child: Text(
                        'Mot de passe oublié ?',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1,
                          color: MaterialTheme.lightScheme().secondary,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.0),
                  CustomButton(
                    label: "Connexion",
                    isDisabled: !isButtonEnabled,
                    onPressed: isButtonEnabled ? _onLoginPressed : null,
                    color: MaterialTheme.lightScheme().primary,
                  ),
                  SizedBox(height: 32.0),
                  HorizontalLine(
                    color: MaterialTheme.lightScheme().outlineVariant,
                    thickness: 1.0,
                  ),
                  SizedBox(height: 32.0),
                  Align(
                    alignment: Alignment.center,
                    child: AccountText(
                      message: "Vous n'avez pas encore de compte ?",
                      actionText: "Inscrivez-vous",
                      messageColor: MaterialTheme.lightScheme().onSurface,
                      actionTextColor: MaterialTheme.lightScheme().primary,
                      onActionTap: () {
                        print("Naviguer vers l'inscription");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLogging)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      )),
    );
  }
}