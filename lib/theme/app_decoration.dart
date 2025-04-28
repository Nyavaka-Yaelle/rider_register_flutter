import 'package:flutter/material.dart';
import '../core/app_export.dart';

class AppDecoration {
  static BoxDecoration get outlineGray400 => BoxDecoration(
        border: Border.all(color: appTheme.gray400, width: 1.h),
      );
  // Fill decorations
  static BoxDecoration get fillBlueGray =>
      BoxDecoration(color: scheme.secondaryContainer);
  static BoxDecoration get fillBluegray10004 =>
      BoxDecoration(color: appTheme.blueGray10004.withOpacity(0.2));
  static BoxDecoration get fillBluegray100041 =>
      BoxDecoration(color: appTheme.blueGray10004);
  static BoxDecoration get fillBluegray10005 =>
      BoxDecoration(color: scheme.secondaryContainer);
  static BoxDecoration get fillBluegray5001 =>
      BoxDecoration(color: scheme.surfaceContainerLow);
  static BoxDecoration get fillGray5001 =>
      BoxDecoration(color: theme.colorScheme.surface); // BOO
  static BoxDecoration get fillGray => BoxDecoration(color: appTheme.gray200);
  static BoxDecoration get fillGray10001 =>
      BoxDecoration(color: appTheme.gray10001);
  static BoxDecoration get fillGray30002 =>
      BoxDecoration(color: scheme.surfaceContainerHighest);
  static BoxDecoration get fillGray50 => BoxDecoration(color: appTheme.gray50);
  static BoxDecoration get fillGray5002 =>
      BoxDecoration(color: appTheme.gray5002);
  static BoxDecoration get fillGray90005 =>
      BoxDecoration(color: scheme.onPrimaryContainer);
  static BoxDecoration get fillGreen =>
      BoxDecoration(color: appTheme.green5001);
  static BoxDecoration get fillGreen50 =>
      BoxDecoration(color: scheme.surfaceContainerHigh);
  static BoxDecoration get fillLightGreen =>
      BoxDecoration(color: appTheme.lightGreen100);
  static BoxDecoration get fillLightgreen50 =>
      BoxDecoration(color: appTheme.lightGreen50);
  static BoxDecoration get fillOnPrimaryContainer =>
      BoxDecoration(color: theme.colorScheme.onPrimaryContainer.withOpacity(1));
  static BoxDecoration get fillPrimaryContainer =>
      BoxDecoration(color: theme.colorScheme.primaryContainer.withOpacity(1));
  static BoxDecoration get fillPrimaryContainer1 =>
      BoxDecoration(color: theme.colorScheme.primaryContainer);
  static BoxDecoration get fillTeal => BoxDecoration(color: appTheme.teal10001);
  static BoxDecoration get fillTeal20001 =>
      BoxDecoration(color: appTheme.teal20001);
  static BoxDecoration get fillTeal500 =>
      BoxDecoration(color: appTheme.teal500);
// Gradient decorations
  static BoxDecoration get gradientGrayToGray => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0, 0.5),
          end: const Alignment(1, 0.5),
          colors: [appTheme.gray700.withOpacity(0.42), appTheme.gray600],
        ),
      );
  static BoxDecoration get gradientOnPrimaryToOnPrimary => BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.5, 0),
          end: const Alignment(0.5, 1),
          colors: [theme.colorScheme.onPrimary, theme.colorScheme.onPrimary],
        ),
      );
// Outline decorations
  static BoxDecoration get outlineBlack => BoxDecoration(
        color: appTheme.teal700,
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.25),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(0, 4),
          )
        ],
      );
  static BoxDecoration get outlineBlack900 => BoxDecoration(
        color: appTheme.lightGreen50,
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.15),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(0, 1),
          )
        ],
      );
  static BoxDecoration get outlineBlack9001 => BoxDecoration(
        color: appTheme.gray200,
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.15),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(0, 1),
          )
        ],
      );
  static BoxDecoration get outlineBlack9002 => BoxDecoration(
        color: appTheme.gray10004,
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.3),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(0, 1),
          )
        ],
      );
  static BoxDecoration get outlineBlack9003 => BoxDecoration(
        color: appTheme.teal700,
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.25),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(0, 4),
          )
        ],
      );
  static BoxDecoration get outlineBlack9004 => BoxDecoration(
        border: Border.all(color: scheme.shadow, width: 3.h),
      );
  static BoxDecoration get outlineBlack9005 => BoxDecoration(
        color: appTheme.teal700,
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.3),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(0, 4),
          )
        ],
      );
  static BoxDecoration get outlineBlack9006 => const BoxDecoration();
  static BoxDecoration get outlineBlack9007 => BoxDecoration(
        color: scheme.onPrimaryContainer,
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.15),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(0, 2),
          )
        ],
      );
  static BoxDecoration get outlineBlack9008 => BoxDecoration(
        color: scheme.surfaceContainerLow,
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.3),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(0, 1),
          )
        ],
      );
  static BoxDecoration get outlineBlack9009 => BoxDecoration(
        color: appTheme.teal90001,
        boxShadow: [
          BoxShadow(
            color: scheme.shadow.withOpacity(0.15),
            spreadRadius: 2.h,
            blurRadius: 2.h,
            offset: const Offset(0, 1),
          )
        ],
      );
  static BoxDecoration get outlineBlueGray => BoxDecoration(
        color: scheme.secondaryContainer,
        border: Border.all(
          color: appTheme.blueGray10004,
          width: 1.h,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      );
  static BoxDecoration get outlineBluegray10004 => BoxDecoration(
        color: appTheme.gray10002,
        border: Border.all(
          color: appTheme.blueGray10004,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineBluegray100041 => BoxDecoration(
        color: appTheme.blueGray100,
        border: Border.all(
          color: appTheme.blueGray10004,
          width: 1.h,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      );
  static BoxDecoration get outlineBluegray100042 => BoxDecoration(
        color: appTheme.teal200,
        border: Border.all(
          color: appTheme.blueGray10004,
          width: 1.h,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      );
  static BoxDecoration get outlineBluegray100043 => BoxDecoration(
        color: appTheme.teal50,
        border: Border.all(
          color: appTheme.blueGray10004,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineBluegray100044 => BoxDecoration(
        color: appTheme.teal5001,
        border: Border.all(
          color: appTheme.blueGray10004,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineBluegray100045 => BoxDecoration(
        color: appTheme.gray10003,
        border: Border.all(
          color: appTheme.blueGray10004,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGray => BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
        border: Border.all(
          color: appTheme.gray90001,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGray40001 => BoxDecoration(
        color: scheme.surface, // BOO
        border: Border.all(
          color: scheme.outlineVariant,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGray400011 => BoxDecoration(
        border: Border.all(
          color: scheme.outlineVariant,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGray400012 => BoxDecoration(
        color: scheme.surfaceVariant,
        border: Border.all(
          color: scheme.outlineVariant,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineGray700 => BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
      );
  static BoxDecoration get outlineLightGreen => BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
        border: Border.all(
          color: appTheme.lightGreen50,
          width: 2.h,
          strokeAlign: BorderSide.strokeAlignOutside,
        ),
      );
  static BoxDecoration get outlinePrimary => BoxDecoration(
        color: theme.colorScheme.primaryContainer.withOpacity(1),
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 1.h,
        ),
      );
  static BoxDecoration get outlinePrimaryContainer => BoxDecoration(
        color: appTheme.gray300,
        border: Border.all(
          color: theme.colorScheme.primaryContainer.withOpacity(1),
          width: 1.h,
        ),
      );
  static BoxDecoration get outlineSecondaryContainer => BoxDecoration(
        border: Border.all(
          color: theme.colorScheme.secondaryContainer,
          width: 1.h,
        ),
      );
}

class BorderRadiusStyle {
  static BorderRadius get roundedBorder12 => BorderRadius.circular(12.h);
  // Circle borders
  static BorderRadius get circleBorder12 => BorderRadius.circular(12.h);
  static BorderRadius get circleBorder20 => BorderRadius.circular(20.h);
  static BorderRadius get circleBorder30 => BorderRadius.circular(30.h);
  static BorderRadius get circleBorder62 => BorderRadius.circular(62.h);
  // circleBorder18
  static BorderRadius get circleBorder18 => BorderRadius.circular(18.h);
// Custom borders
  static BorderRadius get customBorderBL24 => BorderRadius.only(
        topLeft: Radius.circular(16.h),
        topRight: Radius.circular(16.h),
        bottomLeft: Radius.circular(24.h),
        bottomRight: Radius.circular(24.h),
      );
  static BorderRadius get customBorderBL241 =>
      BorderRadius.vertical(bottom: Radius.circular(24.h));
  static BorderRadius get customBorderBL36 =>
      BorderRadius.vertical(bottom: Radius.circular(36.h));
  static BorderRadius get customBorderTL16 =>
      BorderRadius.vertical(top: Radius.circular(16.h));
  static BorderRadius get customBorderTL24 =>
      BorderRadius.vertical(top: Radius.circular(24.h));
  static BorderRadius get customBorderTL28 =>
      BorderRadius.vertical(top: Radius.circular(28.h));
  static BorderRadius get customBorderTL4 =>
      BorderRadius.vertical(top: Radius.circular(4.h));
  static BorderRadius get customBorderTL8 =>
      BorderRadius.only(topLeft: Radius.circular(8.h));
// Rounded borders
  static BorderRadius get roundedBorder16 => BorderRadius.circular(16.h);
  static BorderRadius get roundedBorder24 => BorderRadius.circular(24.h);
  static BorderRadius get roundedBorder4 => BorderRadius.circular(4.h);
  static BorderRadius get roundedBorder40 => BorderRadius.circular(40.h);
  static BorderRadius get roundedBorder51 => BorderRadius.circular(51.h);
  static BorderRadius get roundedBorder8 => BorderRadius.circular(8.h);
}
