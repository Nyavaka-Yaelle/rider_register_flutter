import 'package:flutter/material.dart';
import '../core/app_export.dart';

extension on TextStyle {
  TextStyle get roboto {
    return copyWith(
      fontFamily: 'Roboto',
    );
  }
}

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.
class CustomTextStyles {
// Title text style
  static get bodyMediumGray800 =>
      theme.textTheme.bodyMedium!.copyWith(color: appTheme.gray800);
// Title text style
  static get titleSmallTeal800 =>
      theme.textTheme.titleSmall!.copyWith(color: scheme.primary);
  // Body text style
  static get bodyLargeBlack900 =>
      theme.textTheme.bodyLarge!.copyWith(color: scheme.shadow);
  static get bodyLargeGray700 =>
      theme.textTheme.bodyLarge!.copyWith(color: appTheme.gray700);
  static get bodyLargeGray90003 =>
      theme.textTheme.bodyLarge!.copyWith(color: scheme.onSurface);
  static get bodyLargeOnPrimary =>
      theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onPrimary);
  static get bodyMediumGray700 =>
      theme.textTheme.bodyMedium!.copyWith(color: appTheme.gray700);
  static get bodyMediumTeal500 =>
      theme.textTheme.bodyMedium!.copyWith(color: appTheme.teal500);
// Headline text style
// Label text style
  static get labelLargeGray90001 =>
      theme.textTheme.labelLarge!.copyWith(color: appTheme.gray90001);
// Title text style
  static get titleMediumOnPrimary =>
      theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.onPrimary);
  static get titleMediumTeal500 =>
      theme.textTheme.titleMedium!.copyWith(color: appTheme.teal500);
  static get titleSmallGray700 =>
      theme.textTheme.titleSmall!.copyWith(color: appTheme.gray700);
  static get titleSmallGray70001 =>
      theme.textTheme.titleSmall!.copyWith(color: scheme.onPrimaryContainer);
  static get titleSmallGray70002 =>
      theme.textTheme.titleSmall!.copyWith(color: appTheme.gray70002);
  static get titleSmallGray90001 =>
      theme.textTheme.titleSmall!.copyWith(color: appTheme.gray90001);
  static get titleSmallGreen700 =>
      theme.textTheme.titleSmall!.copyWith(color: appTheme.green700);
}
