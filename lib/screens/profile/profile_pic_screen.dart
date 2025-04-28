import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/utility/file.dart';
import 'package:rider_register/utility/loading.dart';
import 'package:rider_register/utility/printanah.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePicScreen extends StatelessWidget {
  const ProfilePicScreen({
    super.key,
    required this.setIsShowBotNavBar,
  });

  final Function(bool) setIsShowBotNavBar;

  @override
  Widget build(BuildContext context) {
    final deliveryData = Provider.of<DeliveryData>(context, listen: true);
    bool isEmpty = deliveryData.userFire?.profilePicture == "";
    String mes = isEmpty
        ? 'Ajouter une photo de profil pour que vos livreurs et\nchauffeurs vous reconnaissent facilement et\nvivent une expérience plus personnelle.'
        : 'Votre photo de profile aide vos livreurs et\nvos chauffeurs à vous identifier facilement et \nà vous offrir une service encore plus adapté.';

    return Scaffold(
        backgroundColor: scheme.surface,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: scheme.shadow,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              setIsShowBotNavBar(true);
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              Padding(
                  padding: EdgeInsets.only(left: 16.v),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.h),
                        Text(
                          'Photo de profil',
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontSize: 24.fSize,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 42.h),
                        Text(
                          mes,
                          style: TextStyle(
                            color: Color(0xFF00201C),
                            fontSize: 14.fSize,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'L’image uploader ne doit pas dépasser les 16Mo.',
                          style: TextStyle(
                            color: Color(0xFF456179),
                            fontSize: 12.fSize,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ])),
              SizedBox(height: 40.h),
              Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isEmpty
                        ? Icon(
                            Icons.account_circle_outlined,
                            size: 200.adaptSize,
                          )
                        : CustomImageView(
                            imagePath: deliveryData.userFire!.profilePicture,
                            height: 150.v,
                            width: 150.v,
                            radius: BorderRadius.all(Radius.circular(150.v)),
                            fit: BoxFit.cover,
                          ),
                    SizedBox(height: 8.h),
                    Text(
                      deliveryData.userFire?.displayName ?? '',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: scheme.onBackground,
                        fontSize: 16.fSize,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ]))),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: 36.h),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: isEmpty
                  ? [
                      ButtonWidget(
                        label: 'Ajouter une photo',
                        icon: Icons.add,
                        width: 220.v,
                        onPressed: () => _pickImage(context, deliveryData),
                      )
                    ]
                  : [
                      ButtonWidget(
                          label: 'Supprimer',
                          icon: Icons.delete,
                          width: 156.v,
                          onPressed: () => _delImg(context)),
                      ButtonWidget(
                        label: 'Modifier',
                        icon: Icons.edit,
                        width: 156.v,
                        onPressed: () => _pickImage(context, deliveryData),
                      ),
                    ]),
        ));
  }
}

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.label,
    required this.icon,
    required this.width,
    required this.onPressed,
  });
  final String label;
  final IconData icon;
  final double width;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 40.h,
      child: FilledButton.tonalIcon(
          onPressed: onPressed,
          label: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: scheme.onTertiaryContainer,
              fontSize: 14.fSize,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: Icon(icon),
          style: FilledButton.styleFrom(
            backgroundColor: scheme.tertiaryContainer,
          )),
    );
  }
}

String getFileExtension(String path) {
  return path.split('.').last;
}

void _pickImage(BuildContext context, DeliveryData deliveryData) async {
  try {
    showLoadingScreen(context);
    ImagePicker imagePicker = ImagePicker();
    XFile? imageFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      final File originalFile = File(imageFile.path);
      final File compressedImage = await compressIt(originalFile);
      final FirebaseStorage storage = FirebaseStorage.instance;
      final String extension = getFileExtension(originalFile.path);
      final Reference storageRef = storage
          .ref()
          .child('user_client/profile/${DateTime.now()}.$extension');
      await storageRef.putFile(compressedImage);
      final String imageUrl = await storageRef.getDownloadURL();
      deliveryData.userFire!.profilePicture = imageUrl;
      deliveryData.updateUserFire(deliveryData.userFire);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Photo de profil mise à jour'),
        ),
      );
    }
  } catch (e) {
    printerror('Error: $e');
  } finally {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

void _delImg(BuildContext context) async {
  try {
    final deliveryData = Provider.of<DeliveryData>(context, listen: false);
    deliveryData.userFire!.profilePicture = "";
    deliveryData.updateUserFire(deliveryData.userFire);
  } catch (e) {
    printredinios('Error: $e');
  }
}
