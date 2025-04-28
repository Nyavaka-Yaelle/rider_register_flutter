import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/widgets/dot.dart';
import 'package:rider_register/widgets/wallet/label_wallet.dart';

class CardDarkWallet extends StatelessWidget {
  const CardDarkWallet({
    super.key,
    required this.date,
    required this.amount,
    this.labelWallet,
  });

  final LabelWallet? labelWallet;
  final String date;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84.h,
      width: 332.v,
      decoration: ShapeDecoration(
        color: Color(0xFF00201C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 6.v,
            offset: Offset(0.v, 2.h),
            spreadRadius: 2.v,
          ),
          BoxShadow(
            color: Color(0x4C000000),
            blurRadius: 2.v,
            offset: Offset(0.v, 1.h),
            spreadRadius: 0.v,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(top: 12.h, left: 16.v),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.fact_check_outlined,
                      color: scheme.surfaceContainerLowest, // BOO
                      size: 20.adaptSize,
                    ),
                    SizedBox(width: 7.v),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Montant de la course',
                          style: TextStyle(
                            color: scheme.onPrimary,
                            fontSize: 14.adaptSize,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.25.v,
                          ),
                        ),
                        Text(
                          date,
                          style: TextStyle(
                            color: scheme.onPrimary,
                            fontSize: 10.adaptSize,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w200,
                            letterSpacing: 0.50.v,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.h, right: 8.v),
                child: Text(
                  amount,
                  style: TextStyle(
                    color: scheme.onPrimary,
                    fontSize: 16.adaptSize,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.50.v,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Container(
            width: 200.v,
            child: DotWidget(
              totalWidth: 190.v,
              emptyWidth: 2.v,
              dashColor: scheme.outline,
              dashHeight: 1.h,
              dashWidth: 5.v,
            ),
          ),
          SizedBox(height: 7.h),
          labelWallet ?? LabelWallet(),
        ],
      ),
    );
  }
}
