import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';

class LabelDarkWallet extends StatelessWidget {
  const LabelDarkWallet({
    this.text = 'Configurer un wallet',
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      padding: EdgeInsets.symmetric(
        horizontal: 6.v,
      ),
      decoration: ShapeDecoration(
        color: Color(0xFF00201C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 6,
            offset: Offset(0, 2),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Color(0x4C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.playlist_add_check_sharp,
            color: scheme.surfaceContainerLowest, // BOO
            size: 18.adaptSize,
          ),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(
              color: scheme.onPrimary,
              fontSize: 12.fSize,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    );
  }
}
