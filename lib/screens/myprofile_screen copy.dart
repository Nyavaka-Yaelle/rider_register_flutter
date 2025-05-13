import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/repository/user_repository.dart';
import 'package:rider_register/models/user.dart' as UserFire;
import 'package:rider_register/screens/accueil_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rider_register/theme/theme_helper.dart';

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

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text('Mon Profil'),
          ),
          body: WillPopScope(
              onWillPop: () async {
                Navigator.pop(context);
                deliveryData.setMyProfileIsEditing(
                  false,
                );
                return false;
              },
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // GestureDetector(
                    //   onTap: () {
                    //     if (deliveryData.myProfileIsEditing) {}
                    //   },
                    //   child: Stack(
                    //     alignment: Alignment.center,
                    //     children: [
                    //       // CircleAvatar(
                    //       //   backgroundImage: deliveryData.myProfileIsEditing
                    //       //       ? FadeInImage(
                    //       //           placeholder:
                    //       //               NetworkImage(_imageUrlController.text),
                    //       //           image: FileImage(
                    //       //               File(_imageUrlController.text)),
                    //       //         ).image
                    //       //       : NetworkImage(_imageUrlController.text),
                    //       //   radius: 50,
                    //       // ),
                    //       // deliveryData.myProfileImage == null
                    //       //     ? Text('null')
                    //       //     : Text('lol'),
                    //       ElevatedButton(
                    //         onPressed: () => _pickImage(context),
                    //         child: Text('Pick Image'),
                    //       ),
                    //       deliveryData.myProfileIsEditing
                    //           ? Positioned(
                    //               top: -5,
                    //               right: -5,
                    //               child: IconButton(
                    //                 icon: Icon(Icons.edit),
                    //                 onPressed: () {
                    //                   // Your code here
                    //                 },
                    //               ),
                    //             )
                    //           : Container(),
                    //     ],
                    //   ),
                    // ),
                    SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02),
                      child: Row(
                        children: [
                          Text(
                            'Mes informations',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
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
                                        MediaQuery.of(context).size.width *
                                            0.02,
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
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                  ),
                                  child: TextField(
                                    controller: oldPasswordController,
                                    decoration: InputDecoration(
                                      labelText: "Old Password",
                                    ),
                                    obscureText: true,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                  ),
                                  child: TextField(
                                    controller: newPasswordController,
                                    decoration: InputDecoration(
                                      labelText: "New Password",
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
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                  ),
                                  child: TextField(
                                    controller: confirmPasswordController,
                                    decoration: InputDecoration(
                                      labelText: "Confirm New Password",
                                    ),
                                    obscureText: true,
                                  ),
                                ),
// Button to submit password change
                                TextButton(
                                    child: Text("Change Password"),
                                    onPressed: () async {
                                      try {
                                        // Get current user
                                        final user =
                                            FirebaseAuth.instance.currentUser;

                                        _userRepository
                                            .getUserById(user!.uid)
                                            .then(
                                                (UserFire.User? result) async {
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
                                                confirmPasswordController
                                                    .text) {
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
                                                          'Password updated')),
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
                                                        'New password and confirmation do not match')),
                                              );
                                            }
                                          } else {
                                            print("password is incorrect");
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'password is incorrect')),
                                            );
                                          }
                                          // Check if new password and confirmation match
                                        });
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Failed to update password: $e')),
                                        );
                                      }
                                    }),
                              ],
                            )
                          : Text(
                              "Nom d'utilisateur : ${deliveryData.userFire == null ? 'Chargement ...' : deliveryData.userFire!.displayName}",
                            ),
                    ),
                    SizedBox(height: 8),
                    if (!deliveryData.myProfileIsEditing)
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.02),
                        child: Text(
                          "Email : ${deliveryData.userFire == null ? 'Chargement ...' : deliveryData.userFire!.email}",
                        ),
                      ),
                  ],
                ),
              )),
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
        ),
        if (deliveryData.myProfileIsFetching)
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Opacity(
              opacity: 0.1,
              child: ModalBarrier(dismissible: false, color: scheme.shadow),
            ),
          ),
        if (deliveryData.myProfileIsFetching)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
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
