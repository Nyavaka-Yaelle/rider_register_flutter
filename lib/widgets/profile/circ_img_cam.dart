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
            ? 
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 10,
                  color: scheme.onSecondaryContainer,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 82,//56 , // Rayon de l'avatar
                child: Stack(
                  children: [
                    Positioned(
                      top: 0, // Positionnement de l'icône
                      left: -17,//-12,
                      child: Icon(
                        Icons.person_rounded,
                        color: scheme.onSecondaryContainer,
                        size: 200,//136
                      ),
                    )
                  ])
              ),
            )
           
              // Icon(
              //   Icons.account_circle_outlined,
              //   size: 200.adaptSize,
              // )
            : CustomImageView(
                imagePath: url,
                height: 150.v,
                width: 150.v,
                radius: BorderRadius.all(Radius.circular(150.v)),
                fit: BoxFit.cover,
              ),
        Positioned(
          bottom: 5,
          // right: isEmpty ? 30.adaptSize : null,
          child: GestureDetector(
            onTap: () => navigateTo(),
            child: Container(
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                    ),
                    child:Icon(
                    Icons.camera_alt,
                    size: 24.adaptSize,
                    color: scheme.surfaceContainerLowest, // BOO
                  )),
          ),
        )
      ],
    );
  }
}
