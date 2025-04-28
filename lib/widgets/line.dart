import 'package:flutter/material.dart';

import '../theme/theme_helper.dart';

class Line extends StatelessWidget {
  const Line({super.key, required this.width});
  final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignCenter,
            color: scheme.outlineVariant,
          ),
        ),
      ),
    );
  }
}
