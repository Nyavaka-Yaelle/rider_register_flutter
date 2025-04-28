import 'package:flutter/material.dart';

class SizedBoxHeight extends StatelessWidget {
  const SizedBoxHeight({super.key, required this.height});

  final String height;

  @override
  Widget build(BuildContext context) {
    int size = 0;
    switch (height) {
      case "md":
        {
          size = 28;
          break;
        }
      case "sm":
        {
          size = 16;
          break;
        }
      case "xsm":
        {
          size = 8;
          break;
        }
      case "l":
        {
          size = 46;
          break;
        }
      default:
        {
          break;
        }
    }
    return SizedBox(
      height: size.toDouble(),
    );
  }
}
