import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';

class CircImgCam extends StatelessWidget {
  CircImgCam({
    super.key,
    required this.navigateTo,
    this.url,
  });
  VoidCallback navigateTo;
  String? url;

  @override
  Widget build(BuildContext context) {
    bool isEmpty = url == "";

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        isEmpty
            ? Icon(
                Icons.account_circle_outlined,
                size: 200.adaptSize,
              )
            : CustomImageView(
                imagePath: url,
                height: 150.v,
                width: 150.v,
                radius: BorderRadius.all(Radius.circular(150.v)),
                fit: BoxFit.cover,
              ),
        Positioned(
          bottom: isEmpty ? 30.adaptSize : 5,
          right: isEmpty ? 30.adaptSize : null,
          child: GestureDetector(
            onTap: () => navigateTo(),
            child: isEmpty
                ? Container(
                    decoration: ShapeDecoration(
                      color: scheme.secondaryContainer,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2.adaptSize),
                          child: Icon(
                            Icons.camera_alt,
                            size: 24.adaptSize,
                            color: scheme.shadow,
                          ),
                        ),
                      ],
                    ),
                  )
                : Icon(
                    Icons.camera_alt,
                    size: 24.adaptSize,
                    color: scheme.surfaceContainerLowest, // BOO
                  ),
          ),
        )
      ],
    );
  }
}
