import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';

class LabelWallet extends StatelessWidget {
  const LabelWallet({
    this.text,
    super.key,
  });

  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.h,
      padding: EdgeInsets.symmetric(horizontal: 8.v),
      decoration: ShapeDecoration(
        color: scheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet_outlined,
            color: scheme.secondary,
            size: 20.adaptSize,
          ),
          SizedBox(width: 4.v),
          Text(
            text ?? 'Configurer un wallet',
            style: TextStyle(
              color: scheme.secondary,
              fontSize: 14.adaptSize,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.25.v,
            ),
          ),
        ],
      ),
    );
  }
}
