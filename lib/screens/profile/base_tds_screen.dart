import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/main.dart';

// Base Title, Description, and Subtitle Screen
class BaseTdsScreen extends StatelessWidget {
  const BaseTdsScreen({
    super.key,
    this.sub,
    required this.title,
    required this.desc,
    required this.children,
  });

  final String? sub;
  final String desc, title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final deliveryData = Provider.of<DeliveryData>(context, listen: true);
    bool isEmpty = deliveryData.userFire?.profilePicture == "";
    return Scaffold(
      backgroundColor: scheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        foregroundColor: scheme.shadow,
        actions: [
          GestureDetector(
            onTap: () {
              print('Avatar tapped!');
            },
            child: isEmpty
                ? Icon(
                    Icons.account_circle_outlined,
                    size: 20.adaptSize,
                  )
                : CustomImageView(
                    imagePath: deliveryData.userFire!.profilePicture,
                    height: 20.v,
                    width: 20.v,
                    radius: BorderRadius.all(Radius.circular(20.v)),
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
          ),
          SizedBox(width: 18.v),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.v),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4.h),
                Text(
                  title,
                  style: TextStyle(
                    color: scheme.onSurface,
                    fontSize: 24.fSize,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 42.h),
                Text(
                  desc,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Color(0xFF00201C),
                    fontSize: 14.fSize,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25.fSize,
                  ),
                ),
                SizedBox(height: 4.h),
                sub == null
                    ? Container()
                    : Text(
                        sub!,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Color(0xFF456179),
                          fontSize: 12.fSize,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.40.fSize,
                        ),
                      ),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
