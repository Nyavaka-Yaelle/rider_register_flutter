import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';

class CardRider extends StatelessWidget {
  const CardRider({
    super.key,
    required this.motor,
    required this.rider,
    required this.motorImg,
    required this.riderImg,
  });

  final String motorImg;
  final String riderImg;
  final String motor;
  final String rider;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 328.v,
      height: 72.h,
      padding: EdgeInsets.symmetric(horizontal: 16.v),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 48.v,
                height: 48.v,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(riderImg),
                    fit: BoxFit.fill,
                  ),
                  shape: OvalBorder(
                    side: BorderSide(width: 1, color: scheme.outlineVariant),
                  ),
                ),
              ),
              SizedBox(width: 7.v),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      motor,
                      style: TextStyle(
                        color: scheme.onSecondaryContainer,
                        fontSize: 14.fSize,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      rider,
                      style: TextStyle(
                        color: Color(0xFF456179),
                        fontSize: 12.fSize,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: ShapeDecoration(
              image: DecorationImage(
                image: NetworkImage(motorImg),
                fit: BoxFit.fill,
              ),
              shape: OvalBorder(),
            ),
          )
        ],
      ),
    );
  }
}
