import 'package:flutter/material.dart';
// import 'package:project1/screens/login_screen.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import '../components/horizontal_line.dart';
import '../components/account_text.dart';
import './login_screen.dart';
import './otp_screen.dart';
import '../theme.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/screens/verify_otp_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rider_register/main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:rider_register/screens/PdfViewerScreen.dart';
import '../services/TwilioService.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final UserRepository userRepository = UserRepository();
  final TwilioService twilioService = TwilioService();
  bool termsAccepted = false;

  Color appBarColor = MaterialTheme.lightScheme().surfaceContainerLowest; // Couleur par défaut
  Color bodyColor = MaterialTheme.lightScheme().surfaceContainerLowest; // Couleur par défaut
  bool isButtonEnabled = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Ajouter des écouteurs aux champs obligatoires
    nomController.addListener(_updateButtonState);
    prenomController.addListener(_updateButtonState);
    telController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
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
      isButtonEnabled = nomController.text.isNotEmpty &&
          prenomController.text.isNotEmpty &&
          telController.text.isNotEmpty &&
          passwordController.text.length>=6 &&
        termsAccepted;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: bodyColor, 
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.0, color: MaterialTheme.lightScheme().onSurfaceVariant,), // Flèche "Retour"
          onPressed: () {
            print("Retour à l'écran précédent");
            Navigator.pop(context); // Retour à l'écran précédent
          },
        ),
        backgroundColor: appBarColor, 
        elevation: 0, 
        title: Text(
          'Créer un compte',
          style: TextStyle(
            fontFamily: 'Roboto', // Exemple de font family, vous pouvez mettre celui que vous préférez
            fontSize: 21.0, // Exemple de taille de police (fontSize)
            color: MaterialTheme.lightScheme().onSurface
          ), // Couleur du texte (foregroundColor)
        ),
        foregroundColor: MaterialTheme.lightScheme().onSurface,        
      ),
      body: SingleChildScrollView(
        controller: _scrollController, // Ajout du ScrollController
        child: Padding(
          // padding: const EdgeInsets.all(24.0),
          padding: const EdgeInsets.fromLTRB(24.0, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SvgPicture.asset(
                  'assets/images/logo_dago.svg',
                  height: 48.0,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 16.0),
              Table(
                columnWidths: {
                  0: FlexColumnWidth(0.12),
                  1: FlexColumnWidth(0.88),
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
                            Icons.person_outlined,
                            color: MaterialTheme.lightScheme().onSurface,
                            size: 24.0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CustomInput(
                          hintText: "Nom",
                          labelText: "Nom",
                          controller: nomController,
                          isFacultatif: false,
                        ),
                      ),
                    ],
                  ),
                  TableRow( children: [ SizedBox(height: 16.0),SizedBox(height: 16.0)]),
                  TableRow(
                    children: [
                      SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.center,
                        child: CustomInput(
                          hintText: "Prénom",
                          labelText: "Prénom",
                          controller: prenomController,
                          isFacultatif: false,
                        ),
                      ),
                    ],
                  ),
                  TableRow( children: [ SizedBox(height: 16.0),SizedBox(height: 16.0)]),
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
                  TableRow( children: [ SizedBox(height: 16.0),SizedBox(height: 16.0)]),
                  TableRow(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          height: 56.0,
                          alignment: Alignment.centerLeft,
                          child: Icon(
                            Icons.email_outlined,
                            color: MaterialTheme.lightScheme().onSurface,
                            size: 24.0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CustomInput(
                          hintText: "Adresse mail (facultatif)",
                          labelText: "Adresse mail (facultatif)",
                          controller: emailController,
                          isEmail: true,
                          isFacultatif: true,
                        ),
                      ),
                    ],
                  ),
                  TableRow( children: [ SizedBox(height: 16.0),SizedBox(height: 16.0)]),
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
                          hintText: "Mot de passe",
                          labelText: "Mot de passe",
                          suffixIcon: Icons.visibility_off_outlined,
                          controller: passwordController,
                          isPassword: true,
                          isFacultatif: false,
                        ),
                      ),
                    ],
                  ),
                  // TableRow( children: [ SizedBox(height: 16.0),SizedBox(height: 16.0)]),
                  // TableRow(
                  //   children: [
                  //     SizedBox(height: 16.0),
                  //     Align(
                  //       alignment: Alignment.center,
                  //       child: CustomInput(
                  //         hintText: "Confirmer votre mot de passe",
                  //         labelText: "Confirmer votre mot de passe",
                  //         suffixIcon: Icons.visibility_off_outlined,
                  //         controller: confirmPasswordController,
                  //         isPassword: true,

                  //       ),
                  //     ),
                  //   ],
                  // ),
                ],
              ),
                SizedBox(height: 16.0),
            Row(
              children: [
                Checkbox(
                  value: termsAccepted,
                  onChanged: (value) {
                    setState(() {
                      termsAccepted = value!;
                      _updateButtonState();
                    });
                  },
                ),
                Expanded(
                  child: Text("J'ai lu et j'accepte les conditions générales de Dago"),
                ),
               GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfViewerScreen(
          pdfUrl: 'https://ia802901.us.archive.org/21/items/cgu-applis-et-acheteurs-1-241211-112824/CGU%20applis%20et%20acheteurs-1_241211_112824.pdf',
        ),
      ),
    );
  },
  child: Text(
    "Voir le document",
    style: TextStyle(
      color: MaterialTheme.lightScheme().primary,
      decoration: TextDecoration.underline,
    ),
  ),
),
              ],
            ),
            SizedBox(height: 8.0),
            
              SizedBox(height: 4.0),
              CustomButton(
                label: "S'inscrire",
                isDisabled: !isButtonEnabled,
                onPressed: isButtonEnabled
                    ? () {
                                       String _phoneNumber = telController.text.replaceFirst(RegExp(r'^0'), '+261');
                                         _phoneNumber = _phoneNumber.replaceAll(' ', '');
                                    String _displayname = nomController.text +
                                        " " +
                                        prenomController.text;
                                        String firstName = nomController.text;
                                        String lastName = prenomController.text;
                                        String trueMail = "";
                                        if(!emailController.text.isEmpty){
                                        trueMail = emailController.text;
                                        }
                                    String _email = _phoneNumber + "@gmail.com";
                                    String _password = passwordController.text;
                                    // print everything
                                    print("Nom: " + firstName);
                                    print("Prénom: " + lastName);
                                    print("Téléphone: " + _phoneNumber);
                                    print("Email: " + trueMail);
                                    print("Mot de passe: " + _password);
                                    print("Displayname: " + _displayname);


                                    FirebaseAuth.instance
                                        .fetchSignInMethodsForEmail(
                                            _phoneNumber + "@gmail.com")
                                        .then((methods) async {
                                      if (methods.isNotEmpty) {
                                        print(
                                            'User with this phone number already exists');
                                  
                                        Fluttertoast.showToast(
                                          msg:
                                              "Un utilisateur ayant ce numéro de téléphone existe déjà",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.red,
                                          textColor: scheme.onPrimary,
                                        );
                                      } else {
                                          bool otpSent = await twilioService.sendOtp(_phoneNumber, 'sms');
   if (otpSent) {
                      Future.delayed(
                                                const Duration(
                                                    milliseconds: 500), () {
                                             
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      VerifyScreen(
                                                    phoneNumber: _phoneNumber,
                                                    displayname: _displayname,
                                                    firstName: firstName,
                                                    lastName: lastName,
                                                    email: _email,
                                                    role: "false",
                                                    password: _password,
                                                    verificationId:
                                                        "verificationId",
                                                  ),
                                                ),
                                              );
                                                });
                } else {
                  // Handle OTP sending failure
                  print('Failed to send OTP');
                }
                                        // FirebaseAuth.instance.verifyPhoneNumber(
                                        //   phoneNumber: _phoneNumber,
                                        //   verificationCompleted:
                                        //       (PhoneAuthCredential
                                        //           credential) async {
                                        //     // await FirebaseAuth.instance
                                        //     //     .signInWithCredential(credential);
                                        //   },
                                        //   verificationFailed:
                                        //       (FirebaseAuthException e) {
                                        
                                        //     if (e.code ==
                                        //         'invalid-phone-number') {
                                        //       print(
                                        //           'The provided phone number is not valid.');
                                        //     }
                                        //   },
                                        //   codeSent: (String verificationId,
                                        //       int? resendToken) {
                                        //     Future.delayed(
                                        //         const Duration(
                                        //             milliseconds: 500), () {
                                             
                                        //       Navigator.of(context).push(
                                        //         MaterialPageRoute(
                                        //           builder: (context) =>
                                        //               VerifyScreen(
                                        //             phoneNumber: _phoneNumber,
                                        //             displayname: _displayname,
                                        //             firstName: firstName,
                                        //             lastName: lastName,
                                        //             email: _email,
                                        //             role: "false",
                                        //             password: _password,
                                        //             verificationId:
                                        //                 verificationId,
                                        //           ),
                                        //         ),
                                        //       );
                                        //     });
                                        //   },
                                        //   codeAutoRetrievalTimeout:
                                        //       (String verificationId) {},
                                        // );
                                      }
                                    });
                                 
                      }
                    : null,
                color: MaterialTheme.lightScheme().primary
              ),
              SizedBox(height: 32.0),
              HorizontalLine(
                color: MaterialTheme.lightScheme().outlineVariant,
                thickness: 1.0,
              ),
              SizedBox(height: 32.0),
               Align(
                alignment: Alignment.center,
                child:AccountText(
                  message: "Vous avez déjà un compte ?",
                  actionText: "Connectez-vous",
                  messageColor: MaterialTheme.lightScheme().onSurface,
                  actionTextColor: MaterialTheme.lightScheme().primary,
                  onActionTap: () {
                    print("Naviguer vers login");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                ),
               ),
            ],
          ),
        ),
      ),
    );
  }
}
