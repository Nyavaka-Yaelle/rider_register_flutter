import 'package:flutter/material.dart';
import '../../core/app_export.dart';

enum Style { bgStyle, bgShadow }

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  CustomAppBar(
      {Key? key,
      this.height,
      this.styleType,
      this.leadingWidth,
      this.leading,
      this.title,
      this.centerTitle,
      this.actions})
      : super(
          key: key,
        );
  final double? height;
  final Style? styleType;
  final double? leadingWidth;
  final Widget? leading;
  final Widget? title;
  final bool? centerTitle;
  final List<Widget>? actions;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: height ?? 64.v,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      flexibleSpace: _getStyle(),
      leadingWidth: leadingWidth ?? 0,
      leading: leading,
      title: title,
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size(
        SizeUtils.width,
        height ?? 64.v,
      );
  _getStyle() {
    switch (styleType) {
      case Style.bgStyle:
        return Container(
          height: 72.v,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: appTheme.teal700,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(28.h),
            ),
          ),
        );
      case Style.bgShadow:
        return Container(
          height: 100.v,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: appTheme.teal700,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16.h),
              bottomRight: Radius.circular(16.h),
            ),
            boxShadow: [
              BoxShadow(
                color: scheme.shadow.withOpacity(0.3),
                spreadRadius: 2.h,
                blurRadius: 2.h,
                offset: Offset(
                  0,
                  4,
                ),
              )
            ],
          ),
        );
      default:
        return null;
    }
  }
}
