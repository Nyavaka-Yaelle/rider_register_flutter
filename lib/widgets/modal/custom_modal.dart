import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/theme/custom_button_style.dart';
import 'package:rider_register/widgets/custom_elevated_button.dart';

void showAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return dialog content
      return AlertDialog(
        // title: Text('Alert Title'),
        // actions: [],
        backgroundColor: Colors.transparent, // Make background transparent
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: 320.v,
          child: Container(
            decoration: AppDecoration.outlineGray.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder12,
              color: appTheme.gray5002,
            ),
            padding: EdgeInsets.symmetric(vertical: 12.v),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 40.adaptSize,
                        width: 40.adaptSize,
                        margin: EdgeInsets.only(
                          top: 2.v,
                          bottom: 3.v,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            20.h,
                          ),
                          image: DecorationImage(
                            image: AssetImage(
                              ImageConstant.imgRectangle4999x136,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        width: 200.v,
                        child: Padding(
                          padding: EdgeInsets.only(left: 16.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Biriani akoho",
                                style: theme.textTheme.titleMedium,
                              ),
                              SizedBox(height: 10.v),
                              Text(
                                "Pakopako",
                                style: theme.textTheme.bodyMedium,
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 16.h),
                        child: Icon(
                          Icons.star,
                          color: appTheme.gray800,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 12.v),
                CustomImageView(
                  imagePath: ImageConstant.imgRectangle4999x136,
                  height: 177.v,
                  width: double.maxFinite,
                ),
                SizedBox(height: 19.v),
                Padding(
                  padding: EdgeInsets.only(left: 16.h),
                  child: Text(
                    "Byrianni Akoho",
                    style: theme.textTheme.bodyLarge,
                  ),
                ),
                SizedBox(height: 4.v),
                Padding(
                  padding: EdgeInsets.only(left: 16.h),
                  child: Text(
                    "Pakopako",
                    style: CustomTextStyles.bodyMediumGray800,
                  ),
                ),
                SizedBox(height: 32.v),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 16.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomElevatedButton(
                          width: 92.h,
                          text: "Détails",
                          buttonStyle: CustomButtonStyles.outlined,
                          buttonTextStyle: CustomTextStyles.titleSmallTeal800,
                        ),
                        CustomElevatedButton(
                          width: 126.h,
                          text: "Commander",
                          margin: EdgeInsets.only(left: 8.h),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2.v)
              ],
            ),
          ),
        ),
      );
    },
  );
}
