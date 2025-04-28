import 'dart:math';

import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/utils/utils.dart';
import '../core/app_export.dart';
import 'custom_text_form_field.dart'; // ignore: must_be_immutable

// ignore_for_file: must_be_immutable
// ignore_for_file: must_be_immutable
class CustomTextField extends StatefulWidget {
  CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.validator,
  }) : super(
          key: key,
        );
  TextEditingController? controller;
  String hintText;
  FormFieldValidator<String>? validator; // Add this line

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final _focusNode = FocusNode();
  final _pwdFocusNode = FocusNode();
  bool _hasFocus = false;
  bool _pwdHasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _hasFocus = _focusNode.hasFocus;
      });
    });
    _pwdFocusNode.addListener(() {
      setState(() {
        _pwdHasFocus = _pwdFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _pwdFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: appTheme.gray100,
          borderRadius: BorderRadius.circular(
            4.h,
          ),
          border: _hasFocus
              ? widget.controller!.text.isEmpty
                  ? Border.all(
                      color: Colors.transparent,
                    )
                  : Border.all(
                      color: appTheme.blueGray4001,
                    )
              : widget.controller!.text.isEmpty
                  ? Border.all(
                      color: appTheme.gray60082,
                      width: 1.h,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    )
                  : Border.all(
                      color: appTheme.blueGray4001,
                    ),
          boxShadow: _hasFocus || widget.controller!.text.isNotEmpty
              ? [
                  BoxShadow(
                    color: appTheme.tealA7003f,
                    spreadRadius: 2.h,
                    blurRadius: 2.h,
                    offset: Offset(0, 4),
                  )
                ]
              : null),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.h,
                right: 5.h,
              ),
              child: CustomTextFormField(
                focusNode: _focusNode,
                controller: widget.controller,
                hintText: widget.hintText,
                validator: widget.validator,
                width: 258.h,
                textInputType: TextInputType.text,
                borderDecoration: InputBorder.none,
                textStyle: TextStyle(
                  color: scheme.shadow,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
