import 'package:flutter/material.dart';
import '../../../core/app_export.dart'; // ignore: must_be_immutable

// ignore_for_file: must_be_immutable
// ignore_for_file: must_be_immutable
class FoodItemWidget extends StatelessWidget {
  FoodItemWidget(
      {Key? key,
      required this.intro,
      required this.name,
      required this.image,
      required this.price,
      this.onTapUserprofile,
      this.onTapImgUserImage})
      : super(key: key);

  VoidCallback? onTapUserprofile;
  VoidCallback? onTapImgUserImage;
  String intro, image, name;
  double price;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapUserprofile?.call();
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 7.h,
          vertical: 6.v,
        ),
        decoration: AppDecoration.fillLightgreen50.copyWith(
          borderRadius: BorderRadiusStyle.roundedBorder16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageView(
              imagePath: image,
              height: 99.v,
              width: 136.h,
              radius: BorderRadius.vertical(top: Radius.circular(16.h)),
              onTap: () {
                onTapImgUserImage?.call();
              },
            ),
            SizedBox(height: 14.v),
            Container(
              width: 136.v,
              height: 14.h,
              child: Text(
                name.length > 18 ? "${name.substring(0, 18)}..." : name,
              ),
            ),
            // SizedBox(height: 7.v),
            // Container(
            //   width: 136.v,
            //   height: 14.h,
            //   child: Text(
            //     intro.length > 18 ? "${intro.substring(0, 18)}..." : intro,
            //   ),
            // ),
            SizedBox(height: 7.v),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$price Ar",
                  style: CustomTextStyles.titleSmallGreen700,
                ),
                CustomImageView(
                  imagePath: ImageConstant.imgFichier11,
                  height: 12.v,
                  width: 21.h,
                )
              ],
            ),
            SizedBox(height: 2.v)
          ],
        ),
      ),
    );
  }
}
