import 'package:flutter/material.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import '../theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/screens/accueil_screen.dart';

class NewPassword extends StatefulWidget {
    final String numero;

  const NewPassword({
    Key? key,
    this.numero = '', // Valeur par défaut
  }) : super(key: key);
  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  UserRepository userRepository = new UserRepository();
  Color appBarColor = MaterialTheme.lightScheme().surfaceContainerLowest; // Couleur par défaut
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    passwordController.addListener(_updateButtonState);
    confirmPasswordController.addListener(_updateButtonState);
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
      isButtonEnabled = RegExp(r'^.{6,}$').hasMatch(passwordController.text) && passwordController.text.compareTo(confirmPasswordController.text)==0;
    });
  }
  // void update password

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
                'Nouveau mot de passe',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  height: 1.33,
                  decoration: TextDecoration.none,
                ),
              ),
              SizedBox(height: 32.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,0),
                child: Text(
                  'Veuillez entrer votre nouveau mot de passe',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0,0,0,8),
                child: Text(
                  'Nous vous conseillons de combiner des lettres, \ndes chiffres, des symboles.',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    decoration: TextDecoration.none,
                    color: MaterialTheme.lightScheme().tertiary,
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
                            Icons.lock_outlined,
                            color: MaterialTheme.lightScheme().onSurface,
                            size: 24.0,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: CustomInput(
                          hintText: "Nouveau mot de passe",
                          labelText: "Nouveau mot de passe",
                          suffixIcon: Icons.visibility_off_outlined,
                          controller: passwordController,
                          isPassword: true,
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
                      SizedBox(height: 16.0),
                      Align(
                        alignment: Alignment.center,
                        child: CustomInput(
                          hintText: "Confirmer votre nouveau mot de passe",
                          labelText: "Confirmer votre nouveau mot de passe",
                          suffixIcon: Icons.visibility_off_outlined,
                          controller: confirmPasswordController,
                          isPassword: true,

                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32.0),
              CustomButton(
                label: "Réinitialiser",
                isDisabled: !isButtonEnabled,
                onPressed: isButtonEnabled
                  ? () async {
                  print("Button pressed!");
                  String? oldpassword = await userRepository.getPasswordByPhoneNumber(widget.numero);
                  User? user = FirebaseAuth.instance.currentUser;
                                      print(widget.numero + oldpassword!);

                  if (user != null) {

                    print('user is not null' + widget.numero);
                    AuthCredential credential = EmailAuthProvider.credential(
          email: widget.numero + '@gmail.com', // Use the email here
          password: oldpassword!, // Use the current password here
        );

                await user.reauthenticateWithCredential(credential);
                user.linkWithCredential(credential);
                await user.updatePassword(passwordController.text);
                await  userRepository.updateUserPasswordByPhoneNumber(widget.numero, passwordController.text);
                       userRepository.signOut().then((value) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => AccueilScreen(),
                            ),
                            (route) => false,
                          );
                        });
                      });
//navigate to 
                  }
                else {
                  await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: "${widget.numero}@gmail.com", password: oldpassword!);
                  user = FirebaseAuth.instance.currentUser;
                    print('user null' + widget.numero);
                    AuthCredential credential = EmailAuthProvider.credential(
          email: widget.numero + '@gmail.com', // Use the email here
          password: oldpassword!, // Use the current password here
        );

                await user?.reauthenticateWithCredential(credential);
                 user?.linkWithCredential(credential);
                await  user?.updatePassword(passwordController.text);
                await  userRepository.updateUserPasswordByPhoneNumber(widget.numero, passwordController.text);
                       userRepository.signOut().then((value) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => AccueilScreen(),
                            ),
                            (route) => false,
                          );
                        });
                      });
                }

        // Update the password
                  // update firebase password by phone number


                }: null,
                color: MaterialTheme.lightScheme().primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
