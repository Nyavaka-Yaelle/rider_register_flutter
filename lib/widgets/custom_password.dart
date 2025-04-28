import 'dart:math';

import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/utils/utils.dart';
import '../core/app_export.dart';
import 'custom_text_form_field.dart'; // ignore: must_be_immutable

// ignore_for_file: must_be_immutable
// ignore_for_file: must_be_immutable
class CustomPassword extends StatefulWidget {
  CustomPassword({
    Key? key,
    required this.controller,
    this.validator,
  }) : super(
          key: key,
        );
  TextEditingController? controller;
  FormFieldValidator<String>? validator;
  @override
  State<CustomPassword> createState() => _CustomPasswordState();
}

class _CustomPasswordState extends State<CustomPassword> {
  final _focusNode = FocusNode();
  final _pwdFocusNode = FocusNode();
  bool _hasFocus = false;
  bool _pwdHasFocus = false;
  bool _obscureText = true;

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
                hintText: "Votre mot de passe",
                obscureText: _obscureText,
                validator: widget.validator,
                width: 258.h,
                textInputType: TextInputType.text,
                borderDecoration: InputBorder.none,
                textStyle: TextStyle(
                  color: scheme.shadow,
                ),
                suffix: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                suffixConstraints: BoxConstraints(maxHeight: 40),
              ),
            ),
          )
        ],
      ),
    );
  }
}
