import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../core/app_export.dart'; // ignore_for_file: must_be_immutable

// ignore_for_file: must_be_immutable
class CustomPinCodeTextField extends StatelessWidget {
  CustomPinCodeTextField(
      {Key? key,
      required this.context,
      required this.onChanged,
      this.alignment,
      this.controller,
      this.textStyle,
      this.hintStyle,
      this.validator})
      : super(
          key: key,
        );
  final Alignment? alignment;
  final BuildContext context;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  Function(String) onChanged;
  final FormFieldValidator<String>? validator;
  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: pinCodeTextFieldWidget)
        : pinCodeTextFieldWidget;
  }

  Widget get pinCodeTextFieldWidget => PinCodeTextField(
        appContext: context,
        controller: controller,
        length: 6,
        keyboardType: TextInputType.number,
        textStyle: textStyle,
        hintStyle: hintStyle,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        enableActiveFill: true,
        pinTheme: PinTheme(
          activeBoxShadow: [
            BoxShadow(
              color: appTheme.tealA7003f,
              spreadRadius: 2.h,
              blurRadius: 2.h,
              offset: Offset(0, 4),
            )
          ],
          inActiveBoxShadow: [
            BoxShadow(
              color: appTheme.tealA7003f,
              spreadRadius: 2.h,
              blurRadius: 2.h,
              offset: Offset(0, 4),
            )
          ],
          fieldHeight: 54.h,
          fieldWidth: 48.h,
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(8.h),
          inactiveColor: appTheme.blueGray10004,
          activeColor: appTheme.blueGray4001,
          inactiveFillColor: appTheme.gray100,
          activeFillColor: appTheme.gray100,
          selectedColor: appTheme.blueGray10004,
          selectedFillColor: appTheme.gray100,
        ),
        onChanged: (value) => onChanged(value),
        validator: validator,
      );
}
