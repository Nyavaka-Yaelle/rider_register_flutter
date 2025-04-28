import 'package:flutter/material.dart';
import 'package:rider_register/core/app_export.dart';
import 'package:rider_register/widgets/dot.dart';

class YourPositionCard extends StatelessWidget {
  const YourPositionCard({
    Key? key,
    this.position = "Votre position",
    this.positiondepart = "Votre position de départ",
    this.right,
  }) : super(key: key);

  final String position;
  final String positiondepart;
  final Widget? right;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 332.v,
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: ShapeDecoration(
        color: scheme.secondaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPositionDetails(),
          _buildRightIcon(),
        ],
      ),
    );
  }

  Widget _buildPositionDetails() {
    return Container(
      width: 230.v,
      padding: EdgeInsets.only(left: 12.v),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPositionRow(
            icon: Icons.my_location_outlined,
            color: scheme.primary,
            text: positiondepart,
          ),
          SizedBox(height: 5.h),
          _buildDashedLine(),
          SizedBox(height: 5.h),
          _buildPositionRow(
            icon: Icons.location_on_outlined,
            color: scheme.error,
            text: position,
          ),
        ],
      ),
    );
  }

  Widget _buildPositionRow(
      {required IconData icon, required Color color, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20.adaptSize, color: color),
        SizedBox(width: 10.v),
        SizedBox(
          width: 180.v,
          child: Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12.fSize,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
              letterSpacing: 0.10.v,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashedLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.abc, size: 20.adaptSize, color: Colors.transparent),
        SizedBox(width: 10.v),
        DotWidget(
          totalWidth: 180.v,
          emptyWidth: 2.v,
          dashColor: scheme.outline,
          dashHeight: 1.h,
          dashWidth: 5.v,
        )
      ],
    );
  }

  Widget _buildRightIcon() {
    return Container(
      width: 100.v,
      padding: EdgeInsets.only(right: 12.v),
      alignment: Alignment.centerRight,
      child: right ??
          Icon(
            Icons.edit_location_alt_outlined,
            color: scheme.shadow,
            size: 20.adaptSize,
          ),
    );
  }
}
