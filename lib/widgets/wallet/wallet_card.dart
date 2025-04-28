import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rider_register/core/app_export.dart';

class WalletCard extends StatelessWidget {
  WalletCard({
    Key? key,
    this.onTap,
  }) : super(key: key);

  Function? onTap = null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        width: 328,
        height: 169,
        decoration: ShapeDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/w_c.png'),
            fit: BoxFit.fill,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: 9.h,
                      left: 23.v,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Solde',
                          style: TextStyle(
                            color: scheme.tertiary,
                            fontSize: 14.adaptSize,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Text(
                          '0.00 Ar',
                          style: TextStyle(
                            color: scheme.onPrimary,
                            fontSize: 22.adaptSize,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 32.h,
                      right: 15.v,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Dagô wallet',
                          style: TextStyle(
                            color: scheme.onPrimary,
                            fontSize: 12.adaptSize,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            height: 0.11,
                          ),
                        ),
                        SvgPicture.asset(
                          'assets/images/s_c.svg',
                          width: 62.adaptSize,
                          height: 62.adaptSize,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 24.h,
                left: 23.v,
                right: 29.v,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bema',
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontSize: 14,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '23/05',
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
