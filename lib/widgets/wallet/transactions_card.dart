import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';

class TransactionsCard extends StatelessWidget {
  const TransactionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 344.v,
          child: Text(
            'Historique des transactions',
            style: TextStyle(
              color: scheme.onSecondaryFixed,
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(
          height: 4.h,
        ),
        Container(
          width: 344.v,
          height: 136.h,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: scheme.surfaceBright,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: scheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Aucune historique',
                style: TextStyle(
                  color: scheme.onSecondaryFixedVariant,
                  fontSize: 14.adaptSize,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
