import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';

class CardDetailWallet extends StatelessWidget {
  CardDetailWallet({
    Key? key,
    this.child,
  }) : super(key: key);

  Widget? child = null;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 324.v,
      height: 405.h,
      padding: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
        color: scheme.surfaceBright,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Color(0x4C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: child,
    );
  }
}
