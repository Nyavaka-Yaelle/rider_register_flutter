import 'package:flutter/material.dart';
import '../core/app_export.dart';
import 'base_button.dart';
import '../theme.dart';

class CustomElevatedButton extends BaseButton {
  CustomElevatedButton(
      {Key? key,
      this.decoration,
      this.leftIcon,
      this.rightIcon,
      EdgeInsets? margin,
      VoidCallback? onPressed,
      ButtonStyle? buttonStyle,
      Alignment? alignment,
      TextStyle? buttonTextStyle,
      bool? isDisabled,
      double? height,
      double? width,
      required String text})
      : super(
          text: text,
          onPressed: onPressed,
          buttonStyle: buttonStyle,
          isDisabled: isDisabled,
          buttonTextStyle: buttonTextStyle,
          height: height,
          width: width,
          alignment: alignment,
          margin: margin,
        );
  final BoxDecoration? decoration;
  final Widget? leftIcon;
  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildElevatedButtonWidget(context))
        : buildElevatedButtonWidget(context);
  }

  Widget buildElevatedButtonWidget(BuildContext context) {
    final defaultButtonStyle = ElevatedButton.styleFrom(
      primary: MaterialTheme.lightScheme().primary,
    );

    return Container(
      height: this.height ?? 52.h,
      width: this.width ?? double.maxFinite,
      margin: margin,
      decoration: decoration,
      child: ElevatedButton(
        style: buttonStyle ?? defaultButtonStyle,
        onPressed: isDisabled ?? false ? null : onPressed ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leftIcon ?? const SizedBox.shrink(),
            Text(
              text,
              style: buttonTextStyle ?? CustomTextStyles.titleMediumOnPrimary,
            ),
            rightIcon ?? const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}