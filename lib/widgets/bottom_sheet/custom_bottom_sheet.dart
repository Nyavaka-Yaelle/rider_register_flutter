import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/widgets/chat/input_chat.dart';

Future<T?> showCustomBottomSheet<T>(
  BuildContext context, {
  required List<Widget> children,
  double? height,
  bool isFullHeight = false,
}) async {
  return await showModalBottomSheet<T>(
    isScrollControlled: true,
    context: context,
    enableDrag: false,
    elevation: 0,
    barrierColor: scheme.shadow.withAlpha(1),
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: height,
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 20.v,
        right: 20.v,
        top: 16.v,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: AppDecoration.fillBluegray5001.copyWith(
        borderRadius: BorderRadiusStyle.customBorderTL28,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: 4.v,
              width: 32.h,
              decoration: BoxDecoration(
                color: appTheme.gray600,
                borderRadius: BorderRadius.circular(
                  2.h,
                ),
              ),
            ),
          ),
          ...children,
        ],
      ),
    ),
  );
}

Future<T?> showChatBottomSheet<T>(
  BuildContext context, {
  required List<Widget> children,
  bool isFullHeight = false,
}) async {
  return await showModalBottomSheet<T>(
    isScrollControlled: true,
    context: context,
    elevation: 0,
    barrierColor: scheme.shadow.withAlpha(1),
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 60.h,
            decoration: AppDecoration.fillGray5001.copyWith(
              borderRadius: BorderRadiusStyle.customBorderTL28,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: null,
                      icon: Icon(
                        Icons.arrow_back,
                        color: appTheme.gray600,
                        size: 24.adaptSize,
                      ),
                    ),
                    SizedBox(width: 14.v),
                    Container(
                      width: 40.v,
                      height: 40.v,
                      decoration: ShapeDecoration(
                        image: DecorationImage(
                          image:
                              NetworkImage("https://via.placeholder.com/40x40"),
                          fit: BoxFit.fill,
                        ),
                        shape: OvalBorder(
                          side: BorderSide(
                            width: 1,
                            color: scheme.outlineVariant,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.v),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '7112 TBL',
                          style: TextStyle(
                            color: scheme.secondary,
                            fontSize: 14,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.10,
                          ),
                        ),
                        Text(
                          'Apeas Lance',
                          style: TextStyle(
                            color: scheme.secondary,
                            fontSize: 11,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.50,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgRideeTestGreen,
                  height: 17.v,
                  width: 25.h,
                  margin: EdgeInsets.only(right: 18.v),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.v),
            decoration: AppDecoration.fillBluegray5001,
            child: Column(
              children: [
                SizedBox(height: 60.h),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Container(
                    padding: EdgeInsets.all(12.adaptSize),
                    decoration: ShapeDecoration(
                      color: scheme.primaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Eto aminy arrêt bus za',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 14.fSize,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.25.v,
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 8.h),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Container(
                    padding: EdgeInsets.all(12.adaptSize),
                    decoration: ShapeDecoration(
                      color: scheme.secondaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Okay zoky ah',
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 14.fSize,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.25.v,
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputChat(
                      controller: TextEditingController(),
                      width: 284.v,
                      hintText: 'Message',
                    ),
                    SizedBox(width: 8.v),
                    FloatingActionButton(
                      onPressed: null,
                      child: Icon(
                        Icons.send_outlined,
                        color: scheme.tertiary,
                        size: 20.adaptSize,
                      ),
                      mini: true,
                      backgroundColor: scheme.surfaceContainerHigh,
                    ),
                  ],
                ),
                SizedBox(height: 27.h),
              ],
            ),
          ),
          ...children,
        ],
      ),
    ),
  );
}
