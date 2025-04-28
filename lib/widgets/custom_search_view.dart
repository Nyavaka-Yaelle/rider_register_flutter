import 'package:flutter/material.dart';
import 'package:rider_register/widgets/decorated_input_border.dart';
import '../core/app_export.dart';

class CustomSearchView extends StatelessWidget {
  CustomSearchView({
    Key? key,
    this.alignment = Alignment.topCenter,
    this.width,
    this.height = 50,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixIcon,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  final Alignment alignment;
  final double? width;
  final double height;
  final TextEditingController? scrollPadding;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool? autofocus;
  final TextStyle? textStyle;
  final TextInputType? textInputType;
  final int? maxLines;
  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefix;
  final BoxConstraints? prefixConstraints;
  final Widget? prefixIcon;
  final Widget? suffix;
  final BoxConstraints? suffixConstraints;
  final EdgeInsets? contentPadding;
  final InputBorder? borderDecoration;
  final Color? fillColor;
  final bool? filled;
  final FormFieldValidator<String>? validator;
  final Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      child: alignment != null
          ? Align(alignment: alignment, child: searchViewWidget(context))
          : searchViewWidget(context),
    );
  }

  Widget searchViewWidget(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          left: 10.v,
          right: 10.v,
        ),
        child: TextField(
          // replace this with the above code
          controller: controller,
          onChanged: (String value) {
            onChanged?.call(value);
          },
          decoration: decoration,
          // border
        ),
      );
  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? CustomTextStyles.titleSmallGray70001,
        // icon search
        suffixIcon: Icon(
          Icons.search,
          color: appTheme.teal500,
        ),
        border: DecoratedInputBorder(
          child: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            borderSide: BorderSide.none,
          ),
          shadow: BoxShadow(
            color: scheme.shadow.withOpacity(0.15),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: Offset(0, 2),
          ),
        ),
        filled: true,
        fillColor: Colors.white70,
        contentPadding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 16.v),
      );
}
