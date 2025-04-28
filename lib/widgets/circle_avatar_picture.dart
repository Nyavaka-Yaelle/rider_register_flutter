import 'dart:io';

import 'package:flutter/material.dart';

class CircleAvatarPicture extends StatelessWidget {
  const CircleAvatarPicture(
      {super.key, required this.path, required this.image});

  final String path;
  final String image;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 100,
      child: ClipOval(
        child: (path == "")
            ? Image.asset(
                image,
                fit: BoxFit.cover,
                width: 500,
                height: 500,
              )
            : Image.file(
                File(path),
                fit: BoxFit.cover,
                width: 500,
                height: 500,
              ),
      ),
    );
  }
}
