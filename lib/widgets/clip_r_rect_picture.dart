import 'dart:io';

import 'package:flutter/material.dart';

class ClipRRectPicture extends StatelessWidget {
  const ClipRRectPicture({super.key, required this.path, required this.image});

  final String path;
  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      child: (path == "")
          ? Image.asset(
              image,
              fit: BoxFit.cover,
              width: 330,
              height: 200,
            )
          : Image.file(
              File(path),
              fit: BoxFit.cover,
              width: 330,
              height: 200,
            ),
    );
  }
}
