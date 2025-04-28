import 'package:flutter/material.dart';
import '../core/app_export.dart';

/// A class that offers pre-defined button styles for customizing button appearance.
class CustomButtonStyles {
  // Filled button style
  static ButtonStyle get fillGrayE => ElevatedButton.styleFrom(
        backgroundColor: appTheme.gray9001e,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.h),
        ),
      );
  static ButtonStyle get fillTeal => ElevatedButton.styleFrom(
        backgroundColor: appTheme.teal500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.h),
        ),
      );
  static ButtonStyle get fillTealTL241 => ElevatedButton.styleFrom(
        backgroundColor: appTheme.teal500,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.h),
        ),
      );
// Outline button style
  static ButtonStyle get outlined => OutlinedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.h),
          side: BorderSide(
            color: appTheme.gray60082,
            width: 1,
          ),
        ),
        shadowColor: scheme.shadow.withOpacity(0.15),
        elevation: 1,
      );
// text button style
}
