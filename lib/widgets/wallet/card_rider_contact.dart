import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/widgets/wallet/label_dark_wallet.dart';

class CardRiderContact extends StatelessWidget {
  const CardRiderContact({
    super.key,
    required this.motor,
    required this.rider,
    required this.riderImg,
    this.star,
    this.chat,
    this.comment,
    this.locations,
    this.bill,
    this.date,
  });

  final String riderImg, motor, rider;
  final int? star, chat, bill;
  final String? comment, date;
  final List<String>? locations;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 328.v,
      padding: EdgeInsets.only(
        top: 16.h,
        bottom: comment == null ? 16.h : 0,
        left: 12.v,
        right: 12.v,
      ),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: scheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 3,
            offset: Offset(0, 1),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Color(0x4C000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52.v,
                    height: 52.v,
                    decoration: ShapeDecoration(
                      image: DecorationImage(
                        image: NetworkImage(riderImg),
                        fit: BoxFit.fill,
                      ),
                      shape: OvalBorder(
                        side: BorderSide(
                            width: 1.v, color: scheme.outlineVariant),
                      ),
                    ),
                  ),
                  SizedBox(width: 7.v),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          motor,
                          style: TextStyle(
                            color: scheme.onSecondaryContainer,
                            fontSize: 16.fSize,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          rider,
                          style: TextStyle(
                            color: Color(0xFF456179),
                            fontSize: 14.fSize,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        star == null
                            ? Container()
                            : Container(
                                padding: EdgeInsets.symmetric(horizontal: 5.v),
                                height: 16.h,
                                decoration: ShapeDecoration(
                                  color: scheme.onPrimary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star_border,
                                      color: Color(0xFF11BE2C),
                                      size: 16.v,
                                    ),
                                    Text(
                                      star.toString(),
                                      style: TextStyle(
                                        color: scheme.shadow,
                                        fontSize: 11.fSize,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              bill == null
                  ? Row(
                      children: [
                        Container(
                          width: 48.v,
                          height: 48.v,
                          decoration: ShapeDecoration(
                            color: scheme.surfaceContainerHigh,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          child: Icon(
                            Icons.phone,
                            color: scheme.secondary,
                            size: 24.v,
                          ),
                        ),
                        SizedBox(width: 8.v),
                        chat == null
                            ? Container(
                                width: 48.v,
                                height: 48.v,
                                decoration: ShapeDecoration(
                                  color: scheme.surfaceContainerHigh,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16.adaptSize),
                                  ),
                                ),
                                child: Icon(
                                  Icons.email_outlined,
                                  color: scheme.secondary,
                                  size: 24.v,
                                ),
                              )
                            : Container(
                                width: 48.v,
                                height: 48.v,
                                child: FloatingActionButton(
                                  onPressed: () {},
                                  backgroundColor: scheme.primaryContainer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(16.adaptSize),
                                  ),
                                  child: Badge(
                                    label: Text(
                                      '1',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: scheme.onPrimary,
                                        fontSize: 11,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 0.50,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.email_outlined,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    )
                  : Column(
                      children: [
                        LabelDarkWallet(text: '${bill} Ar'),
                        SizedBox(height: 4.h),
                        Text(
                          date!,
                          style: TextStyle(
                            color: Color(0xFF456179),
                            fontSize: 12.fSize,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.40.v,
                          ),
                        )
                      ],
                    )
            ],
          ),
          if (comment != null)
            SizedBox(
              height: 2.h,
              child: Container(
                height: 29.h,
                width: 232.v,
                alignment: Alignment.center,
                // padding: EdgeInsets.symmetric(horizontal: 7.v),
                decoration: ShapeDecoration(
                  color: scheme.surfaceVariant,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                ),
                child: Text(
                  'Vous attend sur le point de départ',
                  maxLines: 1,
                  style: TextStyle(
                    color: scheme.primary,
                    fontSize: 14.fSize,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0.25.fSize,
                  ),
                ),
              ),
            ),
          Column(
            children: locations == null
                ? []
                : [
                    SizedBox(height: 20.h),
                    Container(
                      width: 280.v,
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            strokeAlign: BorderSide.strokeAlignCenter,
                            color: scheme.outlineVariant,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildLocationList(locations!),
                    ),
                    SizedBox(height: 14.h),
                  ],
          )
        ],
      ),
    );
  }

  List<Widget> buildLocationList(List<String> locations) {
    List<Widget> locationWidgets = [];

    for (int i = 0; i < locations.length; i++) {
      if (i == 0) {
        locationWidgets.add(Location(type: 'Départ', location: locations[i]));
        locationWidgets.add(SizedBox(height: 8.h));
      } else if (i == locations.length - 1) {
        locationWidgets.add(Location(type: 'Arrivée', location: locations[i]));
      } else {
        locationWidgets
            .add(Location(type: 'Pause ${i}', location: locations[i]));
        locationWidgets.add(SizedBox(height: 8.h));
      }
    }

    return locationWidgets;
  }
}

class Location extends StatelessWidget {
  const Location({
    super.key,
    required this.type,
    required this.location,
  });

  final String type;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          type,
          style: TextStyle(
            color: scheme.secondary,
            fontSize: 14.fSize,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25.v,
          ),
        ),
        Text(
          location,
          style: TextStyle(
            color: scheme.shadow,
            fontSize: 14.fSize,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
            letterSpacing: 0.25.v,
          ),
        ),
      ],
    );
  }
}
