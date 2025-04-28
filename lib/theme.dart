// theme.dart
import 'package:flutter/material.dart';

class DagoTheme {
  // Définir les couleurs globales de l'application
  static const Color outline = Color(0xFF6F7976); // Couleur #6F7976
  static const Color primary = Color(0xFF006B5F); // Couleur #6F7976
  static const Color secondary = Color(4283065182); // Couleur #6F7976
  static const Color onSurface = Color(0xFF171D1B); // Couleur #6F7976
  static const Color error = Color(0xFFBA1A1A); // Couleur #6F7976
}
class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static MaterialScheme lightScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4278217567),
      surfaceTint: Color(4278217567),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4288672482),
      onPrimaryContainer: Color(4278198300),
      secondary: Color(4283065182),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4291684577),
      onSecondaryContainer: Color(4278591516),
      tertiary: Color(4282737017),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4291553023),
      onTertiaryContainer: Color(4278197808),
      error: Color(4290386458),
      onError: Color(4294967295),
      errorContainer: Color(4294957782),
      onErrorContainer: Color(4282449922),
      background: Color(4294245368),
      onBackground: Color(4279704859),
      surface: Color(4294245368),
      onSurface: Color(4279704859),
      surfaceVariant: Color(4292535777),
      onSurfaceVariant: Color(4282337606),
      outline: Color(4285495670),
      outlineVariant: Color(4290693573),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020976),
      inverseOnSurface: Color(4293718767),
      inversePrimary: Color(4286830022),
      primaryFixed: Color(4288672482),
      onPrimaryFixed: Color(4278198300),
      primaryFixedDim: Color(4286830022),
      onPrimaryFixedVariant: Color(4278210631),
      secondaryFixed: Color(4291684577),
      onSecondaryFixed: Color(4278591516),
      secondaryFixedDim: Color(4289842374),
      onSecondaryFixedVariant: Color(4281551687),
      tertiaryFixed: Color(4291553023),
      onTertiaryFixed: Color(4278197808),
      tertiaryFixedDim: Color(4289514213),
      onTertiaryFixedVariant: Color(4281092704),
      surfaceDim: Color(4292205529),
      surfaceBright: Color(4294245368),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293916146),
      surfaceContainer: Color(4293521388),
      surfaceContainerHigh: Color(4293126887),
      surfaceContainerHighest: Color(4292732129),
    );
  }

  ThemeData light() {
    return theme(lightScheme().toColorScheme());
  }

  static MaterialScheme lightMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4278209603),
      surfaceTint: Color(4278217567),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4280910453),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4281288515),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4284512884),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4280829532),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4284184720),
      onTertiaryContainer: Color(4294967295),
      error: Color(4287365129),
      onError: Color(4294967295),
      errorContainer: Color(4292490286),
      onErrorContainer: Color(4294967295),
      background: Color(4294245368),
      onBackground: Color(4279704859),
      surface: Color(4294245368),
      onSurface: Color(4279704859),
      surfaceVariant: Color(4292535777),
      onSurfaceVariant: Color(4282074434),
      outline: Color(4283916638),
      outlineVariant: Color(4285758842),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020976),
      inverseOnSurface: Color(4293718767),
      inversePrimary: Color(4286830022),
      primaryFixed: Color(4280910453),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278216796),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4284512884),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4282933596),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4284184720),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4282539894),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292205529),
      surfaceBright: Color(4294245368),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293916146),
      surfaceContainer: Color(4293521388),
      surfaceContainerHigh: Color(4293126887),
      surfaceContainerHighest: Color(4292732129),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme lightHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.light,
      primary: Color(4278200354),
      surfaceTint: Color(4278217567),
      onPrimary: Color(4294967295),
      primaryContainer: Color(4278209603),
      onPrimaryContainer: Color(4294967295),
      secondary: Color(4279051810),
      onSecondary: Color(4294967295),
      secondaryContainer: Color(4281288515),
      onSecondaryContainer: Color(4294967295),
      tertiary: Color(4278265146),
      onTertiary: Color(4294967295),
      tertiaryContainer: Color(4280829532),
      onTertiaryContainer: Color(4294967295),
      error: Color(4283301890),
      onError: Color(4294967295),
      errorContainer: Color(4287365129),
      onErrorContainer: Color(4294967295),
      background: Color(4294245368),
      onBackground: Color(4279704859),
      surface: Color(4294245368),
      onSurface: Color(4278190080),
      surfaceVariant: Color(4292535777),
      onSurfaceVariant: Color(4280034852),
      outline: Color(4282074434),
      outlineVariant: Color(4282074434),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4281020976),
      inverseOnSurface: Color(4294967295),
      inversePrimary: Color(4289264876),
      primaryFixed: Color(4278209603),
      onPrimaryFixed: Color(4294967295),
      primaryFixedDim: Color(4278203181),
      onPrimaryFixedVariant: Color(4294967295),
      secondaryFixed: Color(4281288515),
      onSecondaryFixed: Color(4294967295),
      secondaryFixedDim: Color(4279775533),
      onSecondaryFixedVariant: Color(4294967295),
      tertiaryFixed: Color(4280829532),
      onTertiaryFixed: Color(4294967295),
      tertiaryFixedDim: Color(4279185221),
      onTertiaryFixedVariant: Color(4294967295),
      surfaceDim: Color(4292205529),
      surfaceBright: Color(4294245368),
      surfaceContainerLowest: Color(4294967295),
      surfaceContainerLow: Color(4293916146),
      surfaceContainer: Color(4293521388),
      surfaceContainerHigh: Color(4293126887),
      surfaceContainerHighest: Color(4292732129),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme().toColorScheme());
  }

  static MaterialScheme darkScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4286830022),
      surfaceTint: Color(4286830022),
      onPrimary: Color(4278204209),
      primaryContainer: Color(4278210631),
      onPrimaryContainer: Color(4288672482),
      secondary: Color(4289842374),
      onSecondary: Color(4280038704),
      secondaryContainer: Color(4281551687),
      onSecondaryContainer: Color(4291684577),
      tertiary: Color(4289514213),
      onTertiary: Color(4279513929),
      tertiaryContainer: Color(4281092704),
      onTertiaryContainer: Color(4291553023),
      error: Color(4294948011),
      onError: Color(4285071365),
      errorContainer: Color(4287823882),
      onErrorContainer: Color(4294957782),
      background: Color(4279112979),
      onBackground: Color(4292732129),
      surface: Color(4279112979),
      onSurface: Color(4292732129),
      surfaceVariant: Color(4282337606),
      onSurfaceVariant: Color(4290693573),
      outline: Color(4287206288),
      outlineVariant: Color(4282337606),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292732129),
      inverseOnSurface: Color(4281020976),
      inversePrimary: Color(4278217567),
      primaryFixed: Color(4288672482),
      onPrimaryFixed: Color(4278198300),
      primaryFixedDim: Color(4286830022),
      onPrimaryFixedVariant: Color(4278210631),
      secondaryFixed: Color(4291684577),
      onSecondaryFixed: Color(4278591516),
      secondaryFixedDim: Color(4289842374),
      onSecondaryFixedVariant: Color(4281551687),
      tertiaryFixed: Color(4291553023),
      onTertiaryFixed: Color(4278197808),
      tertiaryFixedDim: Color(4289514213),
      onTertiaryFixedVariant: Color(4281092704),
      surfaceDim: Color(4279112979),
      surfaceBright: Color(4281613113),
      surfaceContainerLowest: Color(4278783758),
      surfaceContainerLow: Color(4279704859),
      surfaceContainer: Color(4279902495),
      surfaceContainerHigh: Color(4280625962),
      surfaceContainerHighest: Color(4281349684),
    );
  }

  ThemeData dark() {
    return theme(darkScheme().toColorScheme());
  }

  static MaterialScheme darkMediumContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4287093451),
      surfaceTint: Color(4286830022),
      onPrimary: Color(4278196758),
      primaryContainer: Color(4283145873),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4290105546),
      onSecondary: Color(4278262294),
      secondaryContainer: Color(4286355088),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4289777386),
      onTertiary: Color(4278196264),
      tertiaryContainer: Color(4286026925),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294949553),
      onError: Color(4281794561),
      errorContainer: Color(4294923337),
      onErrorContainer: Color(4278190080),
      background: Color(4279112979),
      onBackground: Color(4292732129),
      surface: Color(4279112979),
      onSurface: Color(4294376697),
      surfaceVariant: Color(4282337606),
      onSurfaceVariant: Color(4291022281),
      outline: Color(4288390562),
      outlineVariant: Color(4286285186),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292732129),
      inverseOnSurface: Color(4280625962),
      inversePrimary: Color(4278211144),
      primaryFixed: Color(4288672482),
      onPrimaryFixed: Color(4278195473),
      primaryFixedDim: Color(4286830022),
      onPrimaryFixedVariant: Color(4278206006),
      secondaryFixed: Color(4291684577),
      onSecondaryFixed: Color(4278195473),
      secondaryFixedDim: Color(4289842374),
      onSecondaryFixedVariant: Color(4280433462),
      tertiaryFixed: Color(4291553023),
      onTertiaryFixed: Color(4278194977),
      tertiaryFixedDim: Color(4289514213),
      onTertiaryFixedVariant: Color(4279908687),
      surfaceDim: Color(4279112979),
      surfaceBright: Color(4281613113),
      surfaceContainerLowest: Color(4278783758),
      surfaceContainerLow: Color(4279704859),
      surfaceContainer: Color(4279902495),
      surfaceContainerHigh: Color(4280625962),
      surfaceContainerHighest: Color(4281349684),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme().toColorScheme());
  }

  static MaterialScheme darkHighContrastScheme() {
    return const MaterialScheme(
      brightness: Brightness.dark,
      primary: Color(4293656569),
      surfaceTint: Color(4286830022),
      onPrimary: Color(4278190080),
      primaryContainer: Color(4287093451),
      onPrimaryContainer: Color(4278190080),
      secondary: Color(4293656569),
      onSecondary: Color(4278190080),
      secondaryContainer: Color(4290105546),
      onSecondaryContainer: Color(4278190080),
      tertiary: Color(4294573055),
      onTertiary: Color(4278190080),
      tertiaryContainer: Color(4289777386),
      onTertiaryContainer: Color(4278190080),
      error: Color(4294965753),
      onError: Color(4278190080),
      errorContainer: Color(4294949553),
      onErrorContainer: Color(4278190080),
      background: Color(4279112979),
      onBackground: Color(4292732129),
      surface: Color(4279112979),
      onSurface: Color(4294967295),
      surfaceVariant: Color(4282337606),
      onSurfaceVariant: Color(4294180345),
      outline: Color(4291022281),
      outlineVariant: Color(4291022281),
      shadow: Color(4278190080),
      scrim: Color(4278190080),
      inverseSurface: Color(4292732129),
      inverseOnSurface: Color(4278190080),
      inversePrimary: Color(4278202410),
      primaryFixed: Color(4288935655),
      onPrimaryFixed: Color(4278190080),
      primaryFixedDim: Color(4287093451),
      onPrimaryFixedVariant: Color(4278196758),
      secondaryFixed: Color(4291948006),
      onSecondaryFixed: Color(4278190080),
      secondaryFixedDim: Color(4290105546),
      onSecondaryFixedVariant: Color(4278262294),
      tertiaryFixed: Color(4292078079),
      onTertiaryFixed: Color(4278190080),
      tertiaryFixedDim: Color(4289777386),
      onTertiaryFixedVariant: Color(4278196264),
      surfaceDim: Color(4279112979),
      surfaceBright: Color(4281613113),
      surfaceContainerLowest: Color(4278783758),
      surfaceContainerLow: Color(4279704859),
      surfaceContainer: Color(4279902495),
      surfaceContainerHigh: Color(4280625962),
      surfaceContainerHighest: Color(4281349684),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme().toColorScheme());
  }


  ThemeData theme(ColorScheme colorScheme) => ThemeData(
     useMaterial3: true,
     brightness: colorScheme.brightness,
     colorScheme: colorScheme,
     textTheme: textTheme.apply(
       bodyColor: colorScheme.onSurface,
       displayColor: colorScheme.onSurface,
     ),
     scaffoldBackgroundColor: colorScheme.background,
     canvasColor: colorScheme.surface,
  );


  List<ExtendedColor> get extendedColors => [
  ];
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
