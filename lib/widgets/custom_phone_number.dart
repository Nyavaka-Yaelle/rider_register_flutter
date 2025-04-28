import 'dart:math';

import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:country_pickers/utils/utils.dart';
import '../core/app_export.dart';
import 'custom_text_form_field.dart'; // ignore: must_be_immutable

// ignore_for_file: must_be_immutable
// ignore_for_file: must_be_immutable
class CustomPhoneNumber extends StatefulWidget {
  CustomPhoneNumber({
    Key? key,
    required this.country,
    required this.onTap,
    required this.controller,
    this.validator,
  }) : super(
          key: key,
        );
  Country country;
  Function(Country) onTap;
  TextEditingController? controller;
  FormFieldValidator<String>? validator;

  @override
  State<CustomPhoneNumber> createState() => _CustomPhoneNumberState();
}

class _CustomPhoneNumberState extends State<CustomPhoneNumber> {
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
          InkWell(
            // onTap: () {
            //   _openCountryPicker(context);
            // },
            child: Container(
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest, // BOO
                borderRadius: BorderRadius.circular(
                  4.h,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(5.h, 9.v, 8.h, 11.v),
                child: Text(
                  "+${widget.country.phoneCode}",
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 16.h,
                right: 5.h,
              ),
              child: CustomTextFormField(
                focusNode: _focusNode,
                width: 258.h,
                controller: widget.controller,
                hintText: "Votre numéro mobile",
                validator: widget.validator,
                textInputType: TextInputType.phone,
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

  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          Container(
            margin: EdgeInsets.only(
              left: 10.h,
            ),
            width: 60.h,
            child: Text(
              "+${country.phoneCode}",
              style: TextStyle(fontSize: 14.fSize),
            ),
          ),
          const SizedBox(width: 8.0),
          Flexible(
            child: Text(
              country.name,
              style: TextStyle(fontSize: 14.fSize),
            ),
          )
        ],
      );

  void _openCountryPicker(BuildContext context) => showDialog(
        context: context,
        builder: (context) => CountryPickerDialog(
          searchInputDecoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(fontSize: 14.fSize),
          ),
          isSearchable: true,
          title: Text('Select your phone code',
              style: TextStyle(fontSize: 14.fSize)),
          onValuePicked: (Country country) => widget.onTap(country),
          itemBuilder: _buildDialogItem,
        ),
      );
}
