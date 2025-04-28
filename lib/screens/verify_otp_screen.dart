import 'package:flutter/material.dart';
import 'package:rider_register/widgets/app_bar/appbar_title.dart';
import '../core/app_export.dart';
import '../theme/custom_button_style.dart';
import '../widgets/app_bar/appbar_leading_iconbutton.dart';
import '../widgets/app_bar/custom_app_bar.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_pin_code_text_field.dart';

import 'package:flutterfire_ui/auth.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rider_register/screens/accueil_screen.dart';
import 'package:rider_register/screens/home_screen.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/models/user.dart' as UserFire;
import 'package:rider_register/screens/placeholder_screen.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import '../services/TwilioService.dart';

class VerifyScreen extends StatefulWidget {
  final String phoneNumber;
  final String displayname;
  final String firstName;
  final String lastName;
  final String password;
  final String verificationId;
  final String role;
  final String email;

  VerifyScreen({
    required this.phoneNumber,
    required this.verificationId,
    required this.displayname,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.email,
    required this.role,
  });

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  String _code = "";
  bool _isLoading = false;
  final UserRepository userRepository = UserRepository();
  final TwilioService twilioService = TwilioService();
  String errorMessage = '';
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: _buildAppbar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 16.h,
            vertical: 35.v,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Veuillez entrer le code envoyé au numéro",
                  style: CustomTextStyles.bodyLargeGray700,
                ),
                SizedBox(height: 9.v),
                Text(
                  widget.phoneNumber,
                  style: CustomTextStyles.bodyLargeBlack900,
                ),
                SizedBox(height: 35.v),
                CustomPinCodeTextField(
                  context: context,
                  onChanged: (value) => _code = value,
                ),
                if (errorMessage.isNotEmpty)
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                Spacer(flex: 73),
                CustomElevatedButton(
                  height: 52.v,
                  text: _isLoading ? 'Chargement ...' : 'Valider',
                  buttonStyle: CustomButtonStyles.fillTealTL241,
                  onPressed: _isLoading ? null : _verifyCode,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.v),
                  child: TextButton(
                    onPressed: _resendCode,
                    child: Text(
                      "Réenvoyer le code",
                      style: CustomTextStyles.bodyMediumTeal500,
                    ),
                  ),
                ),
                Spacer(flex: 26)
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Section Widget
  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return CustomAppBar(
      height: 100.v,
      leadingWidth: 56.h,
      leading: AppbarLeadingIconbutton(
        imagePath: ImageConstant.imgArrowLeft,
        margin: EdgeInsets.only(
          left: 16.h,
          top: 16.v,
          bottom: 44.v,
        ),
        onTap: () {
          onTapArrowleftone(context);
        },
      ),
      centerTitle: true,
      title: AppbarTitle(
        text: "Vérification",
        margin: EdgeInsets.only(
          top: 20.v,
          bottom: 46.v,
        ),
      ),
      styleType: Style.bgShadow,
    );
  }

  /// Navigates back to the previous screen.
  onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }

  void _verifyCode() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });
    bool otpVerified = await twilioService.verifyOtp(widget.phoneNumber, _code);

      bool isRider = widget.role == "Rider";
          if (otpVerified) {
               UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: "${widget.phoneNumber}@gmail.com",
          password: widget.password,
        );

      FirebaseAuth.instance
          .signInWithCredential(
            EmailAuthProvider.credential(
          email: "${widget.phoneNumber}@gmail.com",
          password: widget.password,
        )
        // PhoneAuthProvider.credential(
        //   verificationId: widget.verificationId,
        //   smsCode: _code,
        // ),
      )
          .then((value) {
        // AuthCredential credential = EmailAuthProvider.credential(
        //   email: "${widget.phoneNumber}@gmail.com",
        //   password: widget.password,
        // );

        // FirebaseAuth.instance.currentUser?.linkWithCredential(credential);

        if (value.user != null) {
          userRepository.addUser(
            value.user!.uid,
            UserFire.User(
              displayName: widget.displayname,
              phoneNumber: widget.phoneNumber,
              firstName: widget.firstName,
              lastName: widget.lastName,
              email: widget.email,
              isRider: isRider,
              password: widget.password,
            ),
          );

          userRepository
              .getUserById(value.user!.uid)
              .then((UserFire.User? result) {
            print("${result?.displayName} WTFFFF");
            SessionManager().set("user", result);

            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AccueilScreen()),
            );
          });
        }
      }).catchError((e) {
        print("ERROR OTP $e");
        setState(() {
          errorMessage = "ERROR OTP $e";
          _isLoading = false;
        });
      });
    }
    }
  }

  void _resendCode() {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        FirebaseAuth.instance.signInWithCredential(credential).then((value) {
          if (value.user != null) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          }
        });
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
      },
      codeSent: (String verificationId, int? resendToken) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => VerifyScreen(
              phoneNumber: widget.phoneNumber,
              displayname: widget.displayname,
              firstName: widget.firstName,
              lastName: widget.lastName,
              role: widget.role,
              email: widget.email,
              password: widget.password,
              verificationId: verificationId,
            ),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print(verificationId);
      },
      timeout: Duration(seconds: 60),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:flutterfire_ui/auth.dart';
// import 'package:pin_code_fields/pin_code_fields.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:rider_register/screens/accueil_screen.dart';
// import 'package:rider_register/screens/home_screen.dart';
// import 'package:rider_register/repository/user_repository.dart';
// import 'package:rider_register/models/user.dart' as UserFire;
// import 'package:rider_register/screens/placeholder_screen.dart';
// import 'package:flutter_session_manager/flutter_session_manager.dart';

// class VerifyScreen extends StatefulWidget {
//   final String phoneNumber;
//   final String displayname;
//   final String password;
//   final String verificationId;
//   final String role;
//   final String email;

//   VerifyScreen({
//     // required this.phoneNumber,
//     // required this.verificationId,
//     // required this.displayname,
//     // required this.password,
//     // required this.email,
//     // required this.role,
//     this.phoneNumber = "",
//     this.verificationId = "",
//     this.displayname = "",
//     this.password = "",
//     this.email = "",
//     this.role = "",
//   });

//   @override
//   _VerifyScreenState createState() => _VerifyScreenState();
// }

// class _VerifyScreenState extends State<VerifyScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String _code = "";
//   bool _isLoading = false;
//   final UserRepository userRepository = UserRepository();
//   String errorMessage = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Form(
//             key: _formKey,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text('Vérification ${widget.phoneNumber}'),
//                   SizedBox(height: 16.0),
//                   PinCodeTextField(
//                     appContext: context,
//                     length: 6,
//                     onChanged: (value) {
//                       _code = value;
//                     },
//                   ),
//                   if (errorMessage.isNotEmpty)
//                     Text(
//                       errorMessage,
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   SizedBox(height: 16.0),
//                   ElevatedButton(
//                     onPressed: _isLoading
//                         ? null
//                         : () {
//                             _verifyCode();
//                           },
//                     child: Text(_isLoading ? "Chargement ..." : "Valider"),
//                   ),
//                   SizedBox(height: 16.0),
//                   ElevatedButton(
//                     onPressed: _resendCode,
//                     child: const Text('Réenvoyer le code'),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _verifyCode() {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       setState(() {
//         _isLoading = true;
//       });

//       bool isRider = widget.role == "Rider";

//       FirebaseAuth.instance
//           .signInWithCredential(
//         PhoneAuthProvider.credential(
//           verificationId: widget.verificationId,
//           smsCode: _code,
//         ),
//       )
//           .then((value) {
//         AuthCredential credential = EmailAuthProvider.credential(
//           email: "${widget.phoneNumber}@gmail.com",
//           password: widget.password,
//         );

//         FirebaseAuth.instance.currentUser?.linkWithCredential(credential);

//         if (value.user != null) {
//           userRepository.addUser(
//             value.user!.uid,
//             UserFire.User(
//               displayName: widget.displayname,
//               phoneNumber: widget.phoneNumber,
//               email: widget.email,
//               isRider: isRider,
//               password: widget.password,
//             ),
//           );

//           userRepository
//               .getUserById(value.user!.uid)
//               .then((UserFire.User? result) {
//             print("${result?.displayName} WTFFFF");
//             SessionManager().set("user", result);

//             setState(() {
//               _isLoading = false;
//             });
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (context) => AccueilScreen()),
//             );
//           });
//         }
//       }).catchError((e) {
//         print("ERROR OTP $e");
//         setState(() {
//           errorMessage = "ERROR OTP $e";

//           _isLoading = false;
//         });
//       });
//     }
//   }

//   void _resendCode() {
//     FirebaseAuth.instance.verifyPhoneNumber(
//       phoneNumber: widget.phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) {
//         FirebaseAuth.instance.signInWithCredential(credential).then((value) {
//           if (value.user != null) {
//             Navigator.of(context).pushReplacement(
//               MaterialPageRoute(builder: (context) => HomeScreen()),
//             );
//           }
//         });
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         print(e.message);
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(
//             builder: (context) => VerifyScreen(
//               phoneNumber: widget.phoneNumber,
//               displayname: widget.displayname,
//               role: widget.role,
//               email: widget.email,
//               password: widget.password,
//               verificationId: verificationId,
//             ),
//           ),
//         );
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         print(verificationId);
//       },
//       timeout: Duration(seconds: 60),
//     );
//   }
// }

