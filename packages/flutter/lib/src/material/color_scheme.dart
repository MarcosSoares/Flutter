// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'theme_data.dart';

/// A set of colors based on the
/// [Material spec](https://m3.material.io/styles/color/the-color-system/color-roles)
/// that can be used to configure the color properties of most components.
///
/// The [Theme] has a color scheme, [ThemeData.colorScheme], which is constructed
/// with [ColorScheme.fromSwatch].
@immutable
class ColorScheme with Diagnosticable {
  /// Create a ColorScheme instance.
  const ColorScheme({
    required this.primary,
    required this.onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    required this.error,
    required this.onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? outline,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    Color? surfaceVariant,
    Color? onSurfaceVariant,
    Color? inverseSurface,
    Color? inverseOnSurface,
    Color? inversePrimary,
    Color? shadow,
    required this.brightness,
    @Deprecated(
      'Use primary or primaryContainer instead. '
      'This feature was deprecated after v2.6.0-0.0.pre.'
    )
    Color? primaryVariant,
    @Deprecated(
      'Use secondary or secondaryContainer instead. '
      'This feature was deprecated after v2.6.0-0.0.pre.'
    )
    Color? secondaryVariant,
  }) : assert(primary != null),
       assert(secondary != null),
       assert(surface != null),
       assert(background != null),
       assert(error != null),
       assert(onPrimary != null),
       assert(onSecondary != null),
       assert(onSurface != null),
       assert(onBackground != null),
       assert(onError != null),
       assert(brightness != null),
       _primaryContainer = primaryContainer,
       _onPrimaryContainer = onPrimaryContainer,
       _secondaryContainer = secondaryContainer,
       _onSecondaryContainer = onSecondaryContainer,
       _tertiary = tertiary,
       _onTertiary = onTertiary,
       _tertiaryContainer = tertiaryContainer,
       _onTertiaryContainer = onTertiaryContainer,
       _errorContainer = errorContainer,
       _onErrorContainer = onErrorContainer,
       _outline = outline,
       _surfaceVariant = surfaceVariant,
       _onSurfaceVariant = onSurfaceVariant,
       _inverseSurface = inverseSurface,
       _inverseOnSurface = inverseOnSurface,
       _inversePrimary = inversePrimary,
       _shadow = shadow,
       _primaryVariant = primaryVariant,
       _secondaryVariant = secondaryVariant;

  /// Create a ColorScheme based on a purple primary color that matches the
  /// [baseline Material color scheme](https://material.io/design/color/the-color-system.html#color-theme-creation).
  const ColorScheme.light({
    this.primary = const Color(0xff6200ee),
    this.onPrimary = Colors.white,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    this.secondary = const Color(0xff03dac6),
    this.onSecondary = Colors.black,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    this.error = const Color(0xffb00020),
    this.onError = Colors.white,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? outline,
    this.background = Colors.white,
    this.onBackground = Colors.black,
    this.surface = Colors.white,
    this.onSurface = Colors.black,
    Color? surfaceVariant,
    Color? onSurfaceVariant,
    Color? inverseSurface,
    Color? inverseOnSurface,
    Color? inversePrimary,
    Color? shadow,
    this.brightness = Brightness.light,
    @Deprecated(
      'Use primary or primaryContainer instead. '
      'This feature was deprecated after v2.6.0-0.0.pre.'
    )
    Color? primaryVariant = const Color(0xff3700b3),
    @Deprecated(
      'Use secondary or secondaryContainer instead. '
      'This feature was deprecated after v2.6.0-0.0.pre.'
    )
    Color? secondaryVariant = const Color(0xff018786),
  }) : assert(primary != null),
       assert(secondary != null),
       assert(surface != null),
       assert(background != null),
       assert(error != null),
       assert(onPrimary != null),
       assert(onSecondary != null),
       assert(onSurface != null),
       assert(onBackground != null),
       assert(onError != null),
       assert(brightness != null),
       _primaryContainer = primaryContainer,
       _onPrimaryContainer = onPrimaryContainer,
       _secondaryContainer = secondaryContainer,
       _onSecondaryContainer = onSecondaryContainer,
       _tertiary = tertiary,
       _onTertiary = onTertiary,
       _tertiaryContainer = tertiaryContainer,
       _onTertiaryContainer = onTertiaryContainer,
       _errorContainer = errorContainer,
       _onErrorContainer = onErrorContainer,
       _outline = outline,
       _surfaceVariant = surfaceVariant,
       _onSurfaceVariant = onSurfaceVariant,
       _inverseSurface = inverseSurface,
       _inverseOnSurface = inverseOnSurface,
       _inversePrimary = inversePrimary,
       _shadow = shadow,
       _primaryVariant = primaryVariant,
       _secondaryVariant = secondaryVariant;

  /// Create the recommended dark color scheme that matches the
  /// [baseline Material color scheme](https://material.io/design/color/dark-theme.html#ui-application).
  const ColorScheme.dark({
    this.primary = const Color(0xffbb86fc),
    this.onPrimary = Colors.black,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    this.secondary = const Color(0xff03dac6),
    this.onSecondary = Colors.black,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    this.error = const Color(0xffcf6679),
    this.onError = Colors.black,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? outline,
    this.background = const Color(0xff121212),
    this.onBackground = Colors.white,
    this.surface = const Color(0xff121212),
    this.onSurface = Colors.white,
    Color? surfaceVariant,
    Color? onSurfaceVariant,
    Color? inverseSurface,
    Color? inverseOnSurface,
    Color? inversePrimary,
    Color? shadow,
    this.brightness = Brightness.dark,
    @Deprecated(
      'Use primary or primaryContainer instead. '
      'This feature was deprecated after v2.6.0-0.0.pre.'
    )
    Color? primaryVariant = const Color(0xff3700B3),
    @Deprecated(
      'Use secondary or secondaryContainer instead. '
      'This feature was deprecated after v2.6.0-0.0.pre.'
    )
    Color? secondaryVariant = const Color(0xff03dac6),
  }) : assert(primary != null),
       assert(secondary != null),
       assert(surface != null),
       assert(background != null),
       assert(error != null),
       assert(onPrimary != null),
       assert(onSecondary != null),
       assert(onSurface != null),
       assert(onBackground != null),
       assert(onError != null),
       assert(brightness != null),
       _primaryContainer = primaryContainer,
       _onPrimaryContainer = onPrimaryContainer,
       _secondaryContainer = secondaryContainer,
       _onSecondaryContainer = onSecondaryContainer,
       _tertiary = tertiary,
       _onTertiary = onTertiary,
       _tertiaryContainer = tertiaryContainer,
       _onTertiaryContainer = onTertiaryContainer,
       _errorContainer = errorContainer,
       _onErrorContainer = onErrorContainer,
       _outline = outline,
       _surfaceVariant = surfaceVariant,
       _onSurfaceVariant = onSurfaceVariant,
       _inverseSurface = inverseSurface,
       _inverseOnSurface = inverseOnSurface,
       _inversePrimary = inversePrimary,
       _shadow = shadow,
       _primaryVariant = primaryVariant,
       _secondaryVariant = secondaryVariant;

  /// Create a high contrast ColorScheme based on a purple primary color that
  /// matches the [baseline Material color scheme](https://material.io/design/color/the-color-system.html#color-theme-creation).
  const ColorScheme.highContrastLight({
    this.primary = const Color(0xff0000ba),
    this.onPrimary = Colors.white,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    this.secondary = const Color(0xff66fff9),
    this.onSecondary = Colors.black,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    this.error = const Color(0xff790000),
    this.onError = Colors.white,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? outline,
    this.background = Colors.white,
    this.onBackground = Colors.black,
    this.surface = Colors.white,
    this.onSurface = Colors.black,
    Color? surfaceVariant,
    Color? onSurfaceVariant,
    Color? inverseSurface,
    Color? inverseOnSurface,
    Color? inversePrimary,
    Color? shadow,
    this.brightness = Brightness.light,
    @Deprecated(
      'Use primary or primaryContainer instead. '
      'This feature was deprecated after v2.6.0-0.0.pre.'
    )
    Color? primaryVariant = const Color(0xff000088),
    @Deprecated(
      'Use secondary or secondaryContainer instead. '
      'This feature was deprecated after v2.6.0-0.0.pre.'
    )
    Color? secondaryVariant = const Color(0xff018786),
  }) : assert(primary != null),
       assert(secondary != null),
       assert(surface != null),
       assert(background != null),
       assert(error != null),
       assert(onPrimary != null),
       assert(onSecondary != null),
       assert(onSurface != null),
       assert(onBackground != null),
       assert(onError != null),
       assert(brightness != null),
       _primaryContainer = primaryContainer,
       _onPrimaryContainer = onPrimaryContainer,
       _secondaryContainer = secondaryContainer,
       _onSecondaryContainer = onSecondaryContainer,
       _tertiary = tertiary,
       _onTertiary = onTertiary,
       _tertiaryContainer = tertiaryContainer,
       _onTertiaryContainer = onTertiaryContainer,
       _errorContainer = errorContainer,
       _onErrorContainer = onErrorContainer,
       _outline = outline,
       _surfaceVariant = surfaceVariant,
       _onSurfaceVariant = onSurfaceVariant,
       _inverseSurface = inverseSurface,
       _inverseOnSurface = inverseOnSurface,
       _inversePrimary = inversePrimary,
       _shadow = shadow,
       _primaryVariant = primaryVariant,
       _secondaryVariant = secondaryVariant;

  /// Create a high contrast ColorScheme based on the dark
  /// [baseline Material color scheme](https://material.io/design/color/dark-theme.html#ui-application).
  const ColorScheme.highContrastDark({
    this.primary = const Color(0xffefb7ff),
    this.onPrimary = Colors.black,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    this.secondary = const Color(0xff66fff9),
    this.onSecondary = Colors.black,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    this.error = const Color(0xff9b374d),
    this.onError = Colors.black,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? outline,
    this.background = const Color(0xff121212),
    this.onBackground = Colors.white,
    this.surface = const Color(0xff121212),
    this.onSurface = Colors.white,
    Color? surfaceVariant,
    Color? onSurfaceVariant,
    Color? inverseSurface,
    Color? inverseOnSurface,
    Color? inversePrimary,
    Color? shadow,
    this.brightness = Brightness.dark,
    @Deprecated(
      'Use primary or primaryContainer instead. '
      'This feature was deprecated after v2.6.0-0.0.pre.'
    )
    Color? primaryVariant = const Color(0xffbe9eff),
    @Deprecated(
      'Use secondary or secondaryContainer instead. '
      'This feature was deprecated after v2.6.0-0.0.pre.'
    )
    Color? secondaryVariant = const Color(0xff66fff9),
  }) : assert(primary != null),
       assert(secondary != null),
       assert(surface != null),
       assert(background != null),
       assert(error != null),
       assert(onPrimary != null),
       assert(onSecondary != null),
       assert(onSurface != null),
       assert(onBackground != null),
       assert(onError != null),
       assert(brightness != null),
       _primaryContainer = primaryContainer,
       _onPrimaryContainer = onPrimaryContainer,
       _secondaryContainer = secondaryContainer,
       _onSecondaryContainer = onSecondaryContainer,
       _tertiary = tertiary,
       _onTertiary = onTertiary,
       _tertiaryContainer = tertiaryContainer,
       _onTertiaryContainer = onTertiaryContainer,
       _errorContainer = errorContainer,
       _onErrorContainer = onErrorContainer,
       _outline = outline,
       _surfaceVariant = surfaceVariant,
       _onSurfaceVariant = onSurfaceVariant,
       _inverseSurface = inverseSurface,
       _inverseOnSurface = inverseOnSurface,
       _inversePrimary = inversePrimary,
       _shadow = shadow,
       _primaryVariant = primaryVariant,
       _secondaryVariant = secondaryVariant;

  /// Create a color scheme from a [MaterialColor] swatch.
  ///
  /// This constructor is used by [ThemeData] to create its default
  /// color scheme.
  factory ColorScheme.fromSwatch({
    MaterialColor primarySwatch = Colors.blue,
    Color? primaryColorDark,
    Color? accentColor,
    Color? cardColor,
    Color? backgroundColor,
    Color? errorColor,
    Brightness brightness = Brightness.light,
  }) {
    assert(primarySwatch != null);
    assert(brightness != null);

    final bool isDark = brightness == Brightness.dark;
    final bool primaryIsDark = _brightnessFor(primarySwatch) == Brightness.dark;
    final Color secondary = accentColor ?? (isDark ? Colors.tealAccent[200]! : primarySwatch);
    final bool secondaryIsDark = _brightnessFor(secondary) == Brightness.dark;

    return ColorScheme(
      primary: primarySwatch,
      primaryVariant: primaryColorDark ?? (isDark ? Colors.black : primarySwatch[700]!),
      secondary: secondary,
      secondaryVariant: isDark ? Colors.tealAccent[700]! : primarySwatch[700]!,
      surface: cardColor ?? (isDark ? Colors.grey[800]! : Colors.white),
      background: backgroundColor ?? (isDark ? Colors.grey[700]! : primarySwatch[200]!),
      error: errorColor ?? Colors.red[700]!,
      onPrimary: primaryIsDark ? Colors.white : Colors.black,
      onSecondary: secondaryIsDark ? Colors.white : Colors.black,
      onSurface: isDark ? Colors.white : Colors.black,
      onBackground: primaryIsDark ? Colors.white : Colors.black,
      onError: isDark ? Colors.black : Colors.white,
      brightness: brightness,
    );
  }

  static Brightness _brightnessFor(Color color) => ThemeData.estimateBrightnessForColor(color);

  /// The color displayed most frequently across your app’s screens and components.
  final Color primary;

  /// A color that's clearly legible when drawn on [primary].
  ///
  /// To ensure that an app is accessible, a contrast ratio of 4.5:1 for [primary]
  /// and [onPrimary] is recommended. See
  /// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
  final Color onPrimary;

  final Color? _primaryContainer;
  /// A color used for elements needing less emphasis than [primary].
  Color get primaryContainer => _primaryContainer ?? primary;

  final Color? _onPrimaryContainer;
  /// A color that's clearly legible when drawn on [primaryContainer].
  ///
  /// To ensure that an app is accessible, a contrast ratio of 4.5:1 for
  /// [primaryContainer] and [onPrimaryContainer] is recommended. See
  /// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
  Color get onPrimaryContainer => _onPrimaryContainer ?? onPrimary;

  /// An accent color used for less prominent components in the UI, such as
  /// filter chips, while expanding the opportunity for color expression.
  final Color secondary;

  /// A color that's clearly legible when drawn on [secondary].
  ///
  /// To ensure that an app is accessible, a contrast ratio of 4.5:1 for [secondary]
  /// and [onSecondary] is recommended. See
  /// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
  final Color onSecondary;

  final Color? _secondaryContainer;
  /// A color used for elements needing less emphasis than [secondary].
  Color get secondaryContainer => _secondaryContainer ?? secondary;

  final Color? _onSecondaryContainer;
  /// A color that's clearly legible when drawn on [secondaryContainer].
  ///
  /// To ensure that an app is accessible, a contrast ratio of 4.5:1 for
  /// [secondaryContainer] and [onSecondaryContainer] is recommended. See
  /// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
  Color get onSecondaryContainer => _onSecondaryContainer ?? onSecondary;

  final Color? _tertiary;
  /// A color used as a contrasting accent that can balance [primary]
  /// and [secondary] colors or bring heightened attention to an element,
  /// such as an input field.
  Color get tertiary => _tertiary ?? secondary;

  final Color? _onTertiary;
  /// A color that's clearly legible when drawn on [tertiary].
  ///
  /// To ensure that an app is accessible, a contrast ratio of 4.5:1 for
  /// [tertiary] and [onTertiary] is recommended. See
  /// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
  Color get onTertiary => _onTertiary ?? onSecondary;

  final Color? _tertiaryContainer;
  /// A color used for elements needing less emphasis than [tertiary].
  Color get tertiaryContainer => _tertiaryContainer ?? tertiary;

  final Color? _onTertiaryContainer;
  /// A color that's clearly legible when drawn on [tertiaryContainer].
  ///
  /// To ensure that an app is accessible, a contrast ratio of 4.5:1 for
  /// [tertiaryContainer] and [onTertiaryContainer] is recommended. See
  /// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
  Color get onTertiaryContainer => _onTertiaryContainer ?? onTertiary;

  /// The color to use for input validation errors, e.g. for
  /// [InputDecoration.errorText].
  final Color error;

  /// A color that's clearly legible when drawn on [error].
  ///
  /// To ensure that an app is accessible, a contrast ratio of 4.5:1 for [error]
  /// and [onError] is recommended. See
  /// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
  final Color onError;

  final Color? _errorContainer;
  /// A color used for error elements needing less emphasis than [error].
  Color get errorContainer => _errorContainer ?? error;

  final Color? _onErrorContainer;
  /// A color that's clearly legible when drawn on [errorContainer].
  ///
  /// To ensure that an app is accessible, a contrast ratio of 4.5:1 for
  /// [errorContainer] and [onErrorContainer] is recommended. See
  /// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
  Color get onErrorContainer => _onErrorContainer ?? onError;

  final Color? _outline;
  /// A utility color that creates boundaries and emphasis to improve usability.
  Color get outline => _outline ?? onBackground;

  /// A color that typically appears behind scrollable content.
  final Color background;

  /// A color that's clearly legible when drawn on [background].
  ///
  /// To ensure that an app is accessible, a contrast ratio of 4.5:1 for [background]
  /// and [onBackground] is recommended. See
  /// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
  final Color onBackground;

  /// The background color for widgets like [Card].
  final Color surface;

  /// A color that's clearly legible when drawn on [surface].
  ///
  /// To ensure that an app is accessible, a contrast ratio of 4.5:1 for [surface]
  /// and [onSurface] is recommended. See
  /// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
  final Color onSurface;

  final Color? _surfaceVariant;
  /// A color variant of [surface] that can be used for differentiation against
  /// a component using [surface].
  Color get surfaceVariant => _surfaceVariant ?? surface;

  final Color? _onSurfaceVariant;
  /// A color that's clearly legible when drawn on [surfaceVariant].
  ///
  /// To ensure that an app is accessible, a contrast ratio of 4.5:1 for
  /// [surfaceVariant] and [onSurfaceVariant] is recommended. See
  /// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
  Color get onSurfaceVariant => _onSurfaceVariant ?? onSurface;

  final Color? _inverseSurface;
  /// A surface color used for displaying the reverse of what’s seen in the
  /// surrounding UI, for example in a SnackBar to bring attention to
  /// an alert.
  Color get inverseSurface => _inverseSurface ?? onSurface;

  final Color? _inverseOnSurface;
  /// A color that's clearly legible when drawn on [inverseSurface].
  ///
  /// To ensure that an app is accessible, a contrast ratio of 4.5:1 for
  /// [inverseSurface] and [inverseOnSurface] is recommended. See
  /// <https://www.w3.org/TR/UNDERSTANDING-WCAG20/visual-audio-contrast-contrast.html>.
  Color get inverseOnSurface => _inverseOnSurface ?? surface;

  final Color? _inversePrimary;
  /// An accent color used for displaying the reverse of what’s seen in the
  /// surrounding UI, for example in a SnackBar to bring attention to
  /// an alert.
  Color get inversePrimary => _inversePrimary ?? onPrimary;

  final Color? _shadow;
  /// A color use to paint the drop shadows of elevated components.
  Color get shadow => _shadow ?? onBackground;

  /// The overall brightness of this color scheme.
  final Brightness brightness;

  final Color? _primaryVariant;
  /// A darker version of the primary color.
  @Deprecated(
    'Use primary or primaryContainer instead. '
    'This feature was deprecated after v2.6.0-0.0.pre.'
  )
  Color get primaryVariant => _primaryVariant ?? primary;

  final Color? _secondaryVariant;
  /// A darker version of the secondary color.
  @Deprecated(
    'Use secondary or secondaryContainer instead. '
    'This feature was deprecated after v2.6.0-0.0.pre.'
  )
  Color get secondaryVariant => _secondaryVariant ?? secondary;

  /// Creates a copy of this color scheme with the given fields
  /// replaced by the non-null parameter values.
  ColorScheme copyWith({
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? outline,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? surfaceVariant,
    Color? onSurfaceVariant,
    Color? inverseSurface,
    Color? inverseOnSurface,
    Color? inversePrimary,
    Color? shadow,
    Brightness? brightness,
    @Deprecated(
      'Use primary or primaryContainer instead. '
      'This feature was deprecated after v2.6.0-0.0.pre.'
    )
    Color? primaryVariant,
    @Deprecated(
      'Use secondary or secondaryContainer instead. '
      'This feature was deprecated after v2.6.0-0.0.pre.'
    )
    Color? secondaryVariant,
  }) {
    return ColorScheme(
      primary : primary ?? this.primary,
      onPrimary : onPrimary ?? this.onPrimary,
      primaryContainer : primaryContainer ?? this.primaryContainer,
      onPrimaryContainer : onPrimaryContainer ?? this.onPrimaryContainer,
      secondary : secondary ?? this.secondary,
      onSecondary : onSecondary ?? this.onSecondary,
      secondaryContainer : secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer : onSecondaryContainer ?? this.onSecondaryContainer,
      tertiary : tertiary ?? this.tertiary,
      onTertiary : onTertiary ?? this.onTertiary,
      tertiaryContainer : tertiaryContainer ?? this.tertiaryContainer,
      onTertiaryContainer : onTertiaryContainer ?? this.onTertiaryContainer,
      error : error ?? this.error,
      onError : onError ?? this.onError,
      errorContainer : errorContainer ?? this.errorContainer,
      onErrorContainer : onErrorContainer ?? this.onErrorContainer,
      outline : outline ?? this.outline,
      background : background ?? this.background,
      onBackground : onBackground ?? this.onBackground,
      surface : surface ?? this.surface,
      onSurface : onSurface ?? this.onSurface,
      surfaceVariant : surfaceVariant ?? this.surfaceVariant,
      onSurfaceVariant : onSurfaceVariant ?? this.onSurfaceVariant,
      inverseSurface : inverseSurface ?? this.inverseSurface,
      inverseOnSurface : inverseOnSurface ?? this.inverseOnSurface,
      inversePrimary : inversePrimary ?? this.inversePrimary,
      shadow : shadow ?? this.shadow,
      brightness: brightness ?? this.brightness,
      primaryVariant: primaryVariant ?? this.primaryVariant,
      secondaryVariant: secondaryVariant ?? this.secondaryVariant,
    );
  }

  /// Linearly interpolate between two [ColorScheme] objects.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static ColorScheme lerp(ColorScheme a, ColorScheme b, double t) {
    return ColorScheme(
      primary: Color.lerp(a.primary, b.primary, t)!,
      onPrimary: Color.lerp(a.onPrimary, b.onPrimary, t)!,
      primaryContainer: Color.lerp(a.primaryContainer, b.primaryContainer, t),
      onPrimaryContainer: Color.lerp(a.onPrimaryContainer, b.onPrimaryContainer, t),
      secondary: Color.lerp(a.secondary, b.secondary, t)!,
      onSecondary: Color.lerp(a.onSecondary, b.onSecondary, t)!,
      secondaryContainer: Color.lerp(a.secondaryContainer, b.secondaryContainer, t),
      onSecondaryContainer: Color.lerp(a.onSecondaryContainer, b.onSecondaryContainer, t),
      tertiary: Color.lerp(a.tertiary, b.tertiary, t),
      onTertiary: Color.lerp(a.onTertiary, b.onTertiary, t),
      tertiaryContainer: Color.lerp(a.tertiaryContainer, b.tertiaryContainer, t),
      onTertiaryContainer: Color.lerp(a.onTertiaryContainer, b.onTertiaryContainer, t),
      error: Color.lerp(a.error, b.error, t)!,
      onError: Color.lerp(a.onError, b.onError, t)!,
      errorContainer: Color.lerp(a.errorContainer, b.errorContainer, t),
      onErrorContainer: Color.lerp(a.onErrorContainer, b.onErrorContainer, t),
      outline: Color.lerp(a.outline, b.outline, t),
      background: Color.lerp(a.background, b.background, t)!,
      onBackground: Color.lerp(a.onBackground, b.onBackground, t)!,
      surface: Color.lerp(a.surface, b.surface, t)!,
      onSurface: Color.lerp(a.onSurface, b.onSurface, t)!,
      surfaceVariant: Color.lerp(a.surfaceVariant, b.surfaceVariant, t),
      onSurfaceVariant: Color.lerp(a.onSurfaceVariant, b.onSurfaceVariant, t),
      inverseSurface: Color.lerp(a.inverseSurface, b.inverseSurface, t),
      inverseOnSurface: Color.lerp(a.inverseOnSurface, b.inverseOnSurface, t),
      inversePrimary: Color.lerp(a.inversePrimary, b.inversePrimary, t),
      shadow: Color.lerp(a.shadow, b.shadow, t),
      brightness: t < 0.5 ? a.brightness : b.brightness,
      primaryVariant: Color.lerp(a.primaryVariant, b.primaryVariant, t),
      secondaryVariant: Color.lerp(a.secondaryVariant, b.secondaryVariant, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other))
      return true;
    if (other.runtimeType != runtimeType)
      return false;
    return other is ColorScheme
      && other.primary == primary
      && other.onPrimary == onPrimary
      && other.primaryContainer == primaryContainer
      && other.onPrimaryContainer == onPrimaryContainer
      && other.secondary == secondary
      && other.onSecondary == onSecondary
      && other.secondaryContainer == secondaryContainer
      && other.onSecondaryContainer == onSecondaryContainer
      && other.tertiary == tertiary
      && other.onTertiary == onTertiary
      && other.tertiaryContainer == tertiaryContainer
      && other.onTertiaryContainer == onTertiaryContainer
      && other.error == error
      && other.onError == onError
      && other.errorContainer == errorContainer
      && other.onErrorContainer == onErrorContainer
      && other.outline == outline
      && other.background == background
      && other.onBackground == onBackground
      && other.surface == surface
      && other.onSurface == onSurface
      && other.surfaceVariant == surfaceVariant
      && other.onSurfaceVariant == onSurfaceVariant
      && other.inverseSurface == inverseSurface
      && other.inverseOnSurface == inverseOnSurface
      && other.inversePrimary == inversePrimary
      && other.shadow == shadow
      && other.brightness == brightness
      && other.primaryVariant == primaryVariant
      && other.secondaryVariant == secondaryVariant;
  }

  @override
  int get hashCode {
    return hashList(<Object?>[
      primary,
      onPrimary,
      primaryContainer,
      onPrimaryContainer,
      secondary,
      onSecondary,
      secondaryContainer,
      onSecondaryContainer,
      tertiary,
      onTertiary,
      tertiaryContainer,
      onTertiaryContainer,
      error,
      onError,
      errorContainer,
      onErrorContainer,
      outline,
      background,
      onBackground,
      surface,
      onSurface,
      surfaceVariant,
      onSurfaceVariant,
      inverseSurface,
      inverseOnSurface,
      inversePrimary,
      shadow,
      brightness,
      primaryVariant,
      secondaryVariant,
    ]);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    const ColorScheme defaultScheme = ColorScheme.light();
    properties.add(ColorProperty('primary', primary, defaultValue: defaultScheme.primary));
    properties.add(ColorProperty('onPrimary', onPrimary, defaultValue: defaultScheme.onPrimary));
    properties.add(ColorProperty('primaryContainer', primaryContainer, defaultValue: defaultScheme.primaryContainer));
    properties.add(ColorProperty('onPrimaryContainer', onPrimaryContainer, defaultValue: defaultScheme.onPrimaryContainer));
    properties.add(ColorProperty('secondary', secondary, defaultValue: defaultScheme.secondary));
    properties.add(ColorProperty('onSecondary', onSecondary, defaultValue: defaultScheme.onSecondary));
    properties.add(ColorProperty('secondaryContainer', secondaryContainer, defaultValue: defaultScheme.secondaryContainer));
    properties.add(ColorProperty('onSecondaryContainer', onSecondaryContainer, defaultValue: defaultScheme.onSecondaryContainer));
    properties.add(ColorProperty('tertiary', tertiary, defaultValue: defaultScheme.tertiary));
    properties.add(ColorProperty('onTertiary', onTertiary, defaultValue: defaultScheme.onTertiary));
    properties.add(ColorProperty('tertiaryContainer', tertiaryContainer, defaultValue: defaultScheme.tertiaryContainer));
    properties.add(ColorProperty('onTertiaryContainer', onTertiaryContainer, defaultValue: defaultScheme.onTertiaryContainer));
    properties.add(ColorProperty('error', error, defaultValue: defaultScheme.error));
    properties.add(ColorProperty('onError', onError, defaultValue: defaultScheme.onError));
    properties.add(ColorProperty('errorContainer', errorContainer, defaultValue: defaultScheme.errorContainer));
    properties.add(ColorProperty('onErrorContainer', onErrorContainer, defaultValue: defaultScheme.onErrorContainer));
    properties.add(ColorProperty('outline', outline, defaultValue: defaultScheme.outline));
    properties.add(ColorProperty('background', background, defaultValue: defaultScheme.background));
    properties.add(ColorProperty('onBackground', onBackground, defaultValue: defaultScheme.onBackground));
    properties.add(ColorProperty('surface', surface, defaultValue: defaultScheme.surface));
    properties.add(ColorProperty('onSurface', onSurface, defaultValue: defaultScheme.onSurface));
    properties.add(ColorProperty('surfaceVariant', surfaceVariant, defaultValue: defaultScheme.surfaceVariant));
    properties.add(ColorProperty('onSurfaceVariant', onSurfaceVariant, defaultValue: defaultScheme.onSurfaceVariant));
    properties.add(ColorProperty('inverseSurface', inverseSurface, defaultValue: defaultScheme.inverseSurface));
    properties.add(ColorProperty('inverseOnSurface', inverseOnSurface, defaultValue: defaultScheme.inverseOnSurface));
    properties.add(ColorProperty('inversePrimary', inversePrimary, defaultValue: defaultScheme.inversePrimary));
    properties.add(ColorProperty('shadow', shadow, defaultValue: defaultScheme.shadow));
    properties.add(DiagnosticsProperty<Brightness>('brightness', brightness, defaultValue: defaultScheme.brightness));
    properties.add(ColorProperty('primaryVariant', primaryVariant, defaultValue: defaultScheme.primaryVariant));
    properties.add(ColorProperty('secondaryVariant', secondaryVariant, defaultValue: defaultScheme.secondaryVariant));
  }
}
