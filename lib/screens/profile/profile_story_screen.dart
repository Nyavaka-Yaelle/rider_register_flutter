import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/main.dart';
import 'package:rider_register/repository/user_repository.dart';

class ProfileStoryScreen extends StatelessWidget {
  const ProfileStoryScreen({
    super.key,
    required this.setIsShowBotNavBar,
  });

  final Function(bool) setIsShowBotNavBar;
  @override
  Widget build(BuildContext context) {
    final deliveryData = Provider.of<DeliveryData>(context, listen: true);
    deliveryData.setUserFire(deliveryData.userFire);
    UserRepository userRepository = UserRepository();

    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: scheme.shadow,
        title: const Text('Historique'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            setIsShowBotNavBar(true);
            Navigator.pop(context);
          },
        ),
        actions: [
          GestureDetector(
            onTap: () {
              print('Avatar tapped!');
            },
            child: CircleAvatar(
              backgroundImage:
                  NetworkImage('https://example.com/your-image.jpg'),
              radius: 10.adaptSize,
            ),
          ),
          SizedBox(width: 18.v),
        ],
      ),
      body: SafeArea(
        child: WillPopScope(
            onWillPop: () async {
              Navigator.pop(context);
              deliveryData.setMyProfileIsEditing(false);
              return false;
            },
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TileBase(
                    imagePath: 'https://example.com/your-image.jpg',
                    subTitle: '7112 TBL',
                    precise: 'Apeas Lance',
                    type: 'Ridee',
                    typeImgPath: ImageConstant.imgRideeTestGreen,
                  ),
                  TileBase(
                    imagePath: 'https://example.com/your-image.jpg',
                    subTitle: 'Pakopako',
                    precise: 'Byriani Akoho',
                    type: 'Foodee',
                    typeImgPath: ImageConstant.imgFoodee,
                  ),
                  TileBase(
                    imagePath: 'https://example.com/your-image.jpg',
                    subTitle: 'Ajout de fond',
                    precise: '20 000Ar',
                    type: 'Monee',
                    typeImgPath: ImageConstant.imgRideeTestGreen,
                  ),
                  TileBase(
                    imagePath: 'https://example.com/your-image.jpg',
                    subTitle: 'Pakopako',
                    precise: '2 Menus',
                    type: 'Foodee',
                    typeImgPath: ImageConstant.imgRideeTestGreen,
                  ),
                ],
              ),
            )),
      ),
    );
  }
}

class TileBase extends StatelessWidget {
  const TileBase({
    super.key,
    required this.imagePath,
    required this.subTitle,
    required this.type,
    required this.typeImgPath,
    required this.precise,
  });

  final String imagePath, subTitle, type, typeImgPath, precise;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        leading: Center(
          widthFactor: 1,
          child: CircleAvatar(
            backgroundImage: NetworkImage(imagePath),
            radius: 18.adaptSize,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subTitle,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 12.fSize,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w500,
                letterSpacing: 0.50.fSize,
              ),
            ),
            Text(
              precise,
              style: TextStyle(
                color: scheme.onBackground,
                fontSize: 16.fSize,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.50.fSize,
              ),
            ),
            Text(
              type,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 14.fSize,
                fontFamily: 'Roboto',
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25.fSize,
              ),
            )
          ],
        ),
        trailing: CustomImageView(
          imagePath: typeImgPath,
          height: 24.h,
        ),
      ),
    );
  }
}
