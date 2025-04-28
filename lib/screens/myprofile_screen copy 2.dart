import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/models/user.dart' as UserFire;
import 'package:rider_register/screens/accueil_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyProfileScreen extends StatelessWidget {
  final newPasswordController = TextEditingController();
// Add two more TextEditingControllers for the old password and password confirmation
  final oldPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final deliveryData = Provider.of<DeliveryData>(context, listen: true);
    deliveryData.setUserFire(deliveryData.userFire);
    UserRepository _userRepository = UserRepository();
    final textController =
        TextEditingController(text: deliveryData.userFire!.displayName ?? "");
    double ps = 124.v,
        w = MediaQuery.of(context).size.width,
        t = (96 - AppBar().preferredSize.height).h,
        b = 47.h,
        c = (173 - AppBar().preferredSize.height).h;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appTheme.green5001,
        shadowColor: Colors.transparent,
        foregroundColor: scheme.shadow,
      ),
      body: SafeArea(
        child: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              deliveryData.setMyProfileIsEditing(false);
              return false;
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: b / 2),
                        width: w,
                        height: c,
                        decoration: BoxDecoration(color: appTheme.green5001),
                      ),
                      Positioned(
                          top: t,
                          // half width of the screen
                          left: w / 2 - ps / 2,
                          child: Container(
                              width: ps,
                              height: ps,
                              decoration: ShapeDecoration(
                                shape: OvalBorder(),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://via.placeholder.com/124x124"),
                                    fit: BoxFit.fill),
                              ))),
                    ],
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.02),
                    child: Row(
                      children: [
                        // 8 h
                        SizedBox(height: 8.h),
                        Text(
                          'Mes informations',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            deliveryData.setMyProfileIsEditing(
                              !deliveryData.myProfileIsEditing,
                            );
                            if (!deliveryData.myProfileIsEditing) {
                              deliveryData.userFire!.displayName =
                                  textController.text;
                              deliveryData
                                  .updateUserFire(deliveryData.userFire);
                            }
                            print(textController.text);
                          },
                          child: Icon(
                            deliveryData.myProfileIsEditing
                                ? Icons.save
                                : Icons.edit,
                            color: Colors.black54,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.02),
                    child: deliveryData.myProfileIsEditing
                        ? Column(
                            children: <Widget>[
                              // Existing TextField for username
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                child: TextField(
                                  controller: textController,
                                  decoration: InputDecoration(
                                    labelText: "Nom d'utilisateur",
                                  ),
                                ),
                              ),
                              // New TextField for password
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                child: TextField(
                                  controller: oldPasswordController,
                                  decoration: InputDecoration(
                                    labelText: "Ancien mot de passe",
                                  ),
                                  obscureText: true,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                child: TextField(
                                  controller: newPasswordController,
                                  decoration: InputDecoration(
                                    labelText: "Nouveau mot de passe",
                                  ),
                                  obscureText: true,
                                ),
                              ),
                              // Button to submit password change
                              // New TextField for old password

                              // New TextField for password confirmation
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width * 0.02,
                                ),
                                child: TextField(
                                  controller: confirmPasswordController,
                                  decoration: InputDecoration(
                                    labelText:
                                        "Confirmer le nouveau mot de passe",
                                  ),
                                  obscureText: true,
                                ),
                              ),
                              // Button to submit password change
                              TextButton(
                                  child: Text("Changer le mot de passe"),
                                  onPressed: () async {
                                    try {
                                      // Get current user
                                      final user =
                                          FirebaseAuth.instance.currentUser;

                                      _userRepository
                                          .getUserById(user!.uid)
                                          .then((UserFire.User? result) async {
                                        //compare the password
                                        if (result!.password ==
                                            oldPasswordController.text) {
                                          final credential =
                                              EmailAuthProvider.credential(
                                            email: user.email!,
                                            password:
                                                oldPasswordController.text,
                                          );
                                          await user
                                              .reauthenticateWithCredential(
                                                  credential);

                                          if (newPasswordController.text ==
                                              confirmPasswordController.text) {
                                            // Update password
                                            if (user != null &&
                                                newPasswordController
                                                    .text.isNotEmpty) {
                                              await _userRepository
                                                  .updateuserpassword(
                                                      user.uid,
                                                      newPasswordController
                                                          .text);
                                              await user.updatePassword(
                                                  newPasswordController.text);

                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Mot de passe mis à jour')),
                                              );
                                              deliveryData
                                                  .setMyProfileIsEditing(
                                                !deliveryData
                                                    .myProfileIsEditing,
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Le nouveau mot de passe et la confirmation ne correspondent pas')),
                                            );
                                          }
                                        } else {
                                          print("password is incorrect");
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Le mot de passe est incorrect')),
                                          );
                                        }
                                        // Check if new password and confirmation match
                                      });
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Échec de la mise à jour du mot de passe: $e')),
                                      );
                                    }
                                  }),
                            ],
                          )
                        : Text(
                            "${deliveryData.userFire == null ? 'Chargement ...' : deliveryData.userFire!.displayName}",
                            style: TextStyle(
                              color: Color(0xFF131F0D),
                              fontSize: 22.fSize,
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                  ),
                  SizedBox(height: 8),
                  if (!deliveryData.myProfileIsEditing)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02),
                      child: Text(
                        "${deliveryData.userFire == null ? 'Chargement ...' : deliveryData.userFire!.email}",
                        style: TextStyle(
                          color: Color(0xFF556B65),
                          fontSize: 14.fSize,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            )),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 56.0, // Adjust the height as needed
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  deliveryData.setMyProfileIsFetching(true);
                  _userRepository.signOut().then((value) {
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => AccueilScreen(),
                        ),
                        (route) => false,
                      );
                    });
                  });
                  deliveryData.setMyProfileIsFetching(false);
                  deliveryData.setMyProfileIsEditing(false);
                },
                icon: Icon(Icons.power_settings_new),
                label: Text("Se déconnecter"),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage(BuildContext context) async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      Provider.of<DeliveryData>(context, listen: true)
          .setMyProfileImage(pickedImage);
    }
  }
}
