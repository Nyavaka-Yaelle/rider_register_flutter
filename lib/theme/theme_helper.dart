import 'package:flutter/material.dart';
import '../core/app_export.dart';

String _appTheme = "lightCode";
LightCodeColors get appTheme => ThemeHelper().themeColor();
ThemeData get theme => ThemeHelper().themeData();
MaterialScheme get scheme => ThemeHelper().scheme();

/// Helper class for managing themes and colors.
// ignore_for_file: must_be_immutable
// ignore_for_file: must_be_immutable
class ThemeHelper {
  // A map of custom color themes supported by the app
  final Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

  /// Changes the app theme to [_newTheme].
  void changeTheme(String _newTheme) {
    _appTheme = _newTheme;
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  MaterialScheme _getSheme() {
    return _appTheme == "lightCode" ? lightScheme() : lightScheme();
  }

  // scheme.surfaceContainer
  // scheme.surfaceContainer
  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(0XFF006B5F),
      surfaceTint: Color(0XFF006B5F),
      onPrimary: Color(0XFFFFFFFF),
      primaryContainer: Color(0XFF9FF2E2),
      onPrimaryContainer: Color(0XFF00201C),
      secondary: Color(0XFF4A635E),
      onSecondary: Color(0XFFFFFFFF),
      secondaryContainer: Color(0XFFCDE8E1),
      onSecondaryContainer: Color(0XFF06201C),
      tertiary: Color(0XFF456179),
      onTertiary: Color(0XFFFFFFFF),
      tertiaryContainer: Color(0XFFCBE6FF),
      onTertiaryContainer: Color(0XFF001E30),
      error: Color(0XFFBA1A1A),
      onError: Color(0XFFFFFFFF),
      errorContainer: Color(0XFFFFDAD6),
      onErrorContainer: Color(0XFF410002),
      background: Color(0XFFF4FBF8),
      onBackground: Color(0XFF171D1B),
      surface: Color(0XFFF4FBF8),
      onSurface: Color(0XFF171D1B),
      surfaceVariant: Color(0XFFDAE5E1),
      onSurfaceVariant: Color(0XFF3F4946),
      outline: Color(0XFF6F7976),
      outlineVariant: Color(0XFFBEC9C5),
      shadow: Color(0XFF000000),
      scrim: Color(0XFF000000),
      inverseSurface: Color(0XFF2B3230),
      inverseOnSurface: Color(0XFFECF2EF),
      inversePrimary: Color(0XFF83D5C6),
      primaryFixed: Color(0XFF9FF2E2),
      onPrimaryFixed: Color(0XFF00201C),
      primaryFixedDim: Color(0XFF83D5C6),
      onPrimaryFixedVariant: Color(0XFF005047),
      secondaryFixed: Color(0XFFCDE8E1),
      onSecondaryFixed: Color(0XFF06201C),
      secondaryFixedDim: Color(0XFFB1CCC6),
      onSecondaryFixedVariant: Color(0XFF334B47),
      tertiaryFixed: Color(0XFFCBE6FF),
      onTertiaryFixed: Color(0XFF001E30),
      tertiaryFixedDim: Color(0XFFACCAE5),
      onTertiaryFixedVariant: Color(0XFF2C4A60),
      surfaceDim: Color(0XFFD5DBD9),
      surfaceBright: Color(0XFFF4FBF8),
      surfaceContainerLowest: Color(0XFFFFFFFF),
      surfaceContainerLow: Color(0XFFEFF5F2),
      surfaceContainer: Color(0XFFE9EFEC),
      surfaceContainerHigh: Color(0XFFE3EAE7),
      surfaceContainerHighest: Color(0XFFDDE4E1),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: TextThemes.textTheme(colorScheme),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  /// Returns the current theme data.
  ThemeData _getThemeData() {
    return light();
  }

  /// Returns the lightCode colors for the current theme.
  LightCodeColors themeColor() => _getThemeColors();

  /// Returns the sheme
  MaterialScheme scheme() => _getSheme();

  /// Returns the current theme data.
  ThemeData themeData() => _getThemeData();
}

/// Class containing the supported text theme styles.
class TextThemes {
  static TextTheme textTheme(ColorScheme colorScheme) => TextTheme(
        bodyLarge: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontSize: 16.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: appTheme.gray700,
          fontSize: 14.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        displayMedium: TextStyle(
          color: scheme.shadow,
          fontSize: 45.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        headlineMedium: TextStyle(
          color: colorScheme.onPrimary,
          fontSize: 28.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: appTheme.gray700,
          fontSize: 12.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: scheme.onPrimaryContainer,
          fontSize: 11.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          color: appTheme.gray400,
          fontSize: 16.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: appTheme.gray700,
          fontSize: 14.fSize,
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w500,
        ),
      );
}

/// Class containing custom colors for a lightCode theme.
class LightCodeColors {
  Color get blueGray100 => const Color(0XFFD3D9D8);
  Color get blueGray10004 => const Color(0XFFD9D9D9);
  Color get blueGray4001 => const Color(0XFF6FA69D);
  Color get gray100 => const Color(0XFFF6F6F6);
  Color get gray10001 => const Color(0XFFF3F3F3);
  Color get gray10002 => const Color(0XFFF4F1F1);
  Color get gray10003 => const Color(0XFFF8F4F4);
  Color get gray10004 => const Color(0XFFF2F4F3);
  Color get gray200 => const Color(0XFFF2F1F1);
  Color get gray300 => const Color(0XFFD8E1D7);
  Color get gray400 => const Color(0XFFB6BBB9);
  Color get gray50 => const Color(0XFFFAFDFB);
  Color get gray500 => const Color(0XFF9DABA7);
  Color get gray5002 => const Color(0XFFF7FAF8);
  Color get gray600 => const Color(0XFF737373);
  Color get gray60082 => const Color(0X826F7976);
  Color get gray70 => const Color(0XFF6B6E72);
  Color get gray700 => const Color(0XFF556B65);
  Color get gray70002 => const Color(0XFF546B64);
  Color get gray800 => const Color(0XFF40453D);
  Color get gray90001 => const Color(0XFF131F0D);
  Color get gray9001e => const Color(0X1E1D1B20);
  Color get green5001 => const Color(0XFFE8EDDF);
  Color get green700 => const Color(0XFF1F8E3D);
  Color get lightGreen100 => const Color(0XFFD8E7CA);
  Color get lightGreen50 => const Color(0XFFF3F5EA);
  Color get teal10001 => const Color(0XFFA6E3DA);
  Color get teal200 => const Color(0XFF8BD2C8);
  Color get teal20001 => const Color(0XFF6CC0B6);
  Color get teal50 => const Color(0XFFD2EBE8);
  Color get teal500 => const Color(0XFF159B8B);
  Color get teal5001 => const Color(0XFFD2ECE8);
  Color get teal700 => const Color(0XFF0C816F);
  Color get tealA7003f => const Color(0X3F15B79F);
  Color get teal90001 => const Color(0XFF045144);
}

class MaterialScheme {
  const MaterialScheme({
    required this.brightness,
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inverseOnSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
  });

  final Brightness brightness;
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inverseOnSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;
}

extension MaterialSchemeUtils on MaterialScheme {
  ColorScheme toColorScheme() {
    return ColorScheme(
      brightness: brightness,
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      secondary: secondary,
      onSecondary: onSecondary,
      secondaryContainer: secondaryContainer,
      onSecondaryContainer: onSecondaryContainer,
      tertiary: tertiary,
      onTertiary: onTertiary,
      tertiaryContainer: tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer,
      error: error,
      onError: onError,
      errorContainer: errorContainer,
      onErrorContainer: onErrorContainer,
      background: background,
      onBackground: onBackground,
      surface: surface,
      onSurface: onSurface,
      surfaceVariant: surfaceVariant,
      onSurfaceVariant: onSurfaceVariant,
      outline: outline,
      outlineVariant: outlineVariant,
      shadow: shadow,
      scrim: scrim,
      inverseSurface: inverseSurface,
      onInverseSurface: inverseOnSurface,
      inversePrimary: inversePrimary,
    );
  }
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
