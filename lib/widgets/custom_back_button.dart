import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/widgets/custom_icon_button.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;
  final Color color;

  const CustomBackButton({
    Key? key,
    required this.onPressed,
    this.size = 40,
    this.color = scheme.shadow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      onTap: () => onPressed(),
      height: size.adaptSize,
      width: size.adaptSize,
      decoration: BoxDecoration(
        color: scheme.surface, // BOO
        borderRadius: BorderRadius.circular(20.h),
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.3),
            blurRadius: 2.h,
            offset: Offset(
              0,
              1,
            ),
          ),
          BoxShadow(
            color: scheme.shadow.withOpacity(0.15),
            spreadRadius: 2.h,
            blurRadius: 6.h,
            offset: Offset(
              0,
              2,
            ),
          ),
        ],
      ),
      child: Icon(
        Icons.arrow_back,
        color: scheme.shadow,
        size: 20.adaptSize,
      ),
    );
  }
}
