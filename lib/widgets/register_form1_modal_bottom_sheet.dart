import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/theme_helper.dart';

class RegisterForm1ModalBottomSheet extends StatelessWidget {
  const RegisterForm1ModalBottomSheet(
      {super.key, required this.openImagePicker});

  final Function openImagePicker;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50, top: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            child: Icon(
              Icons.camera,
              color: scheme.onPrimary,
              size: 40,
            ),
            onPressed: () {
              openImagePicker(ImageSource.camera);
            },
          ),
          ElevatedButton(
            child: Icon(
              Icons.image,
              color: scheme.onPrimary,
              size: 40,
            ),
            onPressed: () {
              openImagePicker(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }
}
