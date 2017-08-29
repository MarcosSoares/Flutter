// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show Color, hashValues;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'typography.dart';

/// Describes the contrast needs of a color.
enum Brightness {
  /// The color is dark and will require a light text color to achieve readable
  /// contrast.
  ///
  /// For example, the color might be dark grey, requiring white text.
  dark,

  /// The color is light and will require a dark text color to achieve readable
  /// contrast.
  ///
  /// For example, the color might be bright white, requiring black text.
  light,
}

// Deriving these values is black magic. The spec claims that pressed buttons
// have a highlight of 0x66999999, but that's clearly wrong. The videos in the
// spec show that buttons have a composited highlight of #E1E1E1 on a background
// of #FAFAFA. Assuming that the highlight really has an opacity of 0x66, we can
// solve for the actual color of the highlight:
const Color _kLightThemeHighlightColor = const Color(0x66BCBCBC);

// The same video shows the splash compositing to #D7D7D7 on a background of
// #E1E1E1. Again, assuming the splash has an opacity of 0x66, we can solve for
// the actual color of the splash:
const Color _kLightThemeSplashColor = const Color(0x66C8C8C8);

// Unfortunately, a similar video isn't available for the dark theme, which
// means we assume the values in the spec are actually correct.
const Color _kDarkThemeHighlightColor = const Color(0x40CCCCCC);
const Color _kDarkThemeSplashColor = const Color(0x40CCCCCC);

/// Holds the color and typography values for a material design theme.
///
/// Use this class to configure a [Theme] widget.
///
/// To obtain the current theme, use [Theme.of].
class ThemeData {
  /// Create a ThemeData given a set of preferred values.
  ///
  /// Default values will be derived for arguments that are omitted.
  ///
  /// The most useful values to give are, in order of importance:
  ///
  ///  * The desired theme [brightness].
  ///
  ///  * The primary color palette (the [primarySwatch]), chosen from
  ///    one of the swatches defined by the material design spec. This
  ///    should be one of the maps from the [Colors] class that do not
  ///    have "accent" in their name.
  ///
  ///  * The [accentColor], sometimes called the secondary color, and,
  ///    if the accent color is specified, its brightness
  ///    ([accentColorBrightness]), so that the right contrasting text
  ///    color will be used over the accent color.
  ///
  /// See <https://material.google.com/style/color.html> for
  /// more discussion on how to pick the right colors.
  factory ThemeData({
    Brightness brightness,
    MaterialColor primarySwatch,
    Color primaryColor,
    Brightness primaryColorBrightness,
    Color accentColor,
    Brightness accentColorBrightness,
    Color canvasColor,
    Color scaffoldBackgroundColor,
    Color cardColor,
    Color dividerColor,
    Color highlightColor,
    Color splashColor,
    Color selectedRowColor,
    Color unselectedWidgetColor,
    Color disabledColor,
    Color buttonColor,
    Color secondaryHeaderColor,
    Color textSelectionColor,
    Color textSelectionHandleColor,
    Color backgroundColor,
    Color dialogBackgroundColor,
    Color indicatorColor,
    Color hintColor,
    Color errorColor,
    String fontFamily,
    TextTheme textTheme,
    TextTheme primaryTextTheme,
    TextTheme accentTextTheme,
    IconThemeData iconTheme,
    IconThemeData primaryIconTheme,
    IconThemeData accentIconTheme,
    TargetPlatform platform
  }) {
    brightness ??= Brightness.light;
    final bool isDark = brightness == Brightness.dark;
    primarySwatch ??= Colors.blue;
    primaryColor ??= isDark ? Colors.grey[900] : primarySwatch[500];
    primaryColorBrightness ??= estimateBrightnessForColor(primaryColor);
    final bool primaryIsDark = primaryColorBrightness == Brightness.dark;
    accentColor ??= isDark ? Colors.tealAccent[200] : primarySwatch[500];
    accentColorBrightness ??= estimateBrightnessForColor(accentColor);
    final bool accentIsDark = accentColorBrightness == Brightness.dark;
    canvasColor ??= isDark ? Colors.grey[850] : Colors.grey[50];
    scaffoldBackgroundColor ??= canvasColor;
    cardColor ??= isDark ? Colors.grey[800] : Colors.white;
    dividerColor ??= isDark ? const Color(0x1FFFFFFF) : const Color(0x1F000000);
    highlightColor ??= isDark ? _kDarkThemeHighlightColor : _kLightThemeHighlightColor;
    splashColor ??= isDark ? _kDarkThemeSplashColor : _kLightThemeSplashColor;
    selectedRowColor ??= Colors.grey[100];
    unselectedWidgetColor ??= isDark ? Colors.white70 : Colors.black54;
    disabledColor ??= isDark ? Colors.white30 : Colors.black26;
    buttonColor ??= isDark ? primarySwatch[600] : Colors.grey[300];
    // Spec doesn't specify a dark theme secondaryHeaderColor, this is a guess.
    secondaryHeaderColor ??= isDark ? Colors.grey[700] : primarySwatch[50];
    textSelectionColor ??= isDark ? accentColor : primarySwatch[200];
    textSelectionHandleColor ??= isDark ? Colors.tealAccent[400] : primarySwatch[300];
    backgroundColor ??= isDark ? Colors.grey[700] : primarySwatch[200];
    dialogBackgroundColor ??= isDark ? Colors.grey[800] : Colors.white;
    indicatorColor ??= accentColor == primaryColor ? Colors.white : accentColor;
    hintColor ??= isDark ? const Color(0x42FFFFFF) : const Color(0x4C000000);
    errorColor ??= Colors.red[700];
    iconTheme ??= isDark ? const IconThemeData(color: Colors.white) : const IconThemeData(color: Colors.black);
    primaryIconTheme ??= primaryIsDark ? const IconThemeData(color: Colors.white) : const IconThemeData(color: Colors.black);
    accentIconTheme ??= accentIsDark ? const IconThemeData(color: Colors.white) : const IconThemeData(color: Colors.black);
    platform ??= defaultTargetPlatform;
    final Typography typography = new Typography(platform: platform);
    textTheme ??= isDark ? typography.white : typography.black;
    primaryTextTheme ??= primaryIsDark ? typography.white : typography.black;
    accentTextTheme ??= accentIsDark ? typography.white : typography.black;
    if (fontFamily != null) {
      textTheme = textTheme.apply(fontFamily: fontFamily);
      primaryTextTheme = primaryTextTheme.apply(fontFamily: fontFamily);
      accentTextTheme = accentTextTheme.apply(fontFamily: fontFamily);
    }
    return new ThemeData.raw(
      brightness: brightness,
      primaryColor: primaryColor,
      primaryColorBrightness: primaryColorBrightness,
      accentColor: accentColor,
      accentColorBrightness: accentColorBrightness,
      canvasColor: canvasColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardColor: cardColor,
      dividerColor: dividerColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      selectedRowColor: selectedRowColor,
      unselectedWidgetColor: unselectedWidgetColor,
      disabledColor: disabledColor,
      buttonColor: buttonColor,
      secondaryHeaderColor: secondaryHeaderColor,
      textSelectionColor: textSelectionColor,
      textSelectionHandleColor: textSelectionHandleColor,
      backgroundColor: backgroundColor,
      dialogBackgroundColor: dialogBackgroundColor,
      indicatorColor: indicatorColor,
      hintColor: hintColor,
      errorColor: errorColor,
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
      accentTextTheme: accentTextTheme,
      iconTheme: iconTheme,
      primaryIconTheme: primaryIconTheme,
      accentIconTheme: accentIconTheme,
      platform: platform
    );
  }

  /// Create a ThemeData given a set of exact values. All the values
  /// must be specified.
  ///
  /// This will rarely be used directly. It is used by [lerp] to
  /// create intermediate themes based on two themes created with the
  /// [new ThemeData] constructor.
  const ThemeData.raw({
    @required this.brightness,
    @required this.primaryColor,
    @required this.primaryColorBrightness,
    @required this.accentColor,
    @required this.accentColorBrightness,
    @required this.canvasColor,
    @required this.scaffoldBackgroundColor,
    @required this.cardColor,
    @required this.dividerColor,
    @required this.highlightColor,
    @required this.splashColor,
    @required this.selectedRowColor,
    @required this.unselectedWidgetColor,
    @required this.disabledColor,
    @required this.buttonColor,
    @required this.secondaryHeaderColor,
    @required this.textSelectionColor,
    @required this.textSelectionHandleColor,
    @required this.backgroundColor,
    @required this.dialogBackgroundColor,
    @required this.indicatorColor,
    @required this.hintColor,
    @required this.errorColor,
    @required this.textTheme,
    @required this.primaryTextTheme,
    @required this.accentTextTheme,
    @required this.iconTheme,
    @required this.primaryIconTheme,
    @required this.accentIconTheme,
    @required this.platform
  }) : assert(brightness != null),
       assert(primaryColor != null),
       assert(primaryColorBrightness != null),
       assert(accentColor != null),
       assert(accentColorBrightness != null),
       assert(canvasColor != null),
       assert(scaffoldBackgroundColor != null),
       assert(cardColor != null),
       assert(dividerColor != null),
       assert(highlightColor != null),
       assert(splashColor != null),
       assert(selectedRowColor != null),
       assert(unselectedWidgetColor != null),
       assert(disabledColor != null),
       assert(buttonColor != null),
       assert(secondaryHeaderColor != null),
       assert(textSelectionColor != null),
       assert(textSelectionHandleColor != null),
       assert(backgroundColor != null),
       assert(dialogBackgroundColor != null),
       assert(indicatorColor != null),
       assert(hintColor != null),
       assert(errorColor != null),
       assert(textTheme != null),
       assert(primaryTextTheme != null),
       assert(accentTextTheme != null),
       assert(iconTheme != null),
       assert(primaryIconTheme != null),
       assert(accentIconTheme != null),
       assert(platform != null);

  /// A default light blue theme.
  factory ThemeData.light() => new ThemeData(brightness: Brightness.light);

  /// A default dark theme with a teal accent color.
  factory ThemeData.dark() => new ThemeData(brightness: Brightness.dark);

  /// The default theme. Same as [new ThemeData.light].
  ///
  /// This is used by [Theme.of] when no theme has been specified.
  factory ThemeData.fallback() => new ThemeData.light();

  /// The brightness of the overall theme of the application. Used by widgets
  /// like buttons to determine what color to pick when not using the primary or
  /// accent color.
  ///
  /// When the [Brightness] is dark, the canvas, card, and primary colors are
  /// all dark. When the [Brightness] is light, the canvas and card colors
  /// are bright, and the primary color's darkness varies as described by
  /// primaryColorBrightness. The primaryColor does not contrast well with the
  /// card and canvas colors when the brightness is dark; when the brightness is
  /// dark, use Colors.white or the accentColor for a contrasting color.
  final Brightness brightness;

  /// The background color for major parts of the app (toolbars, tab bars, etc)
  final Color primaryColor;

  /// The brightness of the [primaryColor]. Used to determine the color of text and
  /// icons placed on top of the primary color (e.g. toolbar text).
  final Brightness primaryColorBrightness;

  /// The foreground color for widgets (knobs, text, etc)
  final Color accentColor;

  /// The brightness of the [accentColor]. Used to determine the color of text
  /// and icons placed on top of the accent color (e.g. the icons on a floating
  /// action button).
  final Brightness accentColorBrightness;

  /// The default color of [MaterialType.canvas] [Material].
  final Color canvasColor;

  /// The default color of the [Material] that underlies the [Scaffold]. The
  /// background color for a typical material app or a page within the app.
  final Color scaffoldBackgroundColor;

  /// The color of [Material] when it is used as a [Card].
  final Color cardColor;

  /// The color of [Divider]s and [PopupMenuDivider]s, also used
  /// between [ListTile]s, between rows in [DataTable]s, and so forth.
  final Color dividerColor;

  /// The highlight color used during ink splash animations or to
  /// indicate an item in a menu is selected.
  final Color highlightColor;

  /// The color of ink splashes. See [InkWell].
  final Color splashColor;

  /// The color used to highlight selected rows.
  final Color selectedRowColor;

  /// The color used for widgets in their inactive (but enabled)
  /// state. For example, an unchecked checkbox. Usually contrasted
  /// with the [accentColor]. See also [disabledColor].
  final Color unselectedWidgetColor;

  /// The color used for widgets that are inoperative, regardless of
  /// their state. For example, a disabled checkbox (which may be
  /// checked or unchecked).
  final Color disabledColor;

  /// The default color of the [Material] used in [RaisedButton]s.
  final Color buttonColor;

  /// The color of the header of a [PaginatedDataTable] when there are selected rows.
  // According to the spec for data tables:
  // https://material.google.com/components/data-tables.html#data-tables-tables-within-cards
  // ...this should be the "50-value of secondary app color".
  final Color secondaryHeaderColor;

  /// The color of text selections in text fields, such as [TextField].
  final Color textSelectionColor;

  /// The color of the handles used to adjust what part of the text is currently selected.
  final Color textSelectionHandleColor;

  /// A color that contrasts with the [primaryColor], e.g. used as the
  /// remaining part of a progress bar.
  final Color backgroundColor;

  /// The background color of [Dialog] elements.
  final Color dialogBackgroundColor;

  /// The color of the selected tab indicator in a tab bar.
  final Color indicatorColor;

  /// The color to use for hint text or placeholder text, e.g. in
  /// [TextField] fields.
  final Color hintColor;

  /// The color to use for input validation errors, e.g. in [TextField] fields.
  final Color errorColor;

  /// Text with a color that contrasts with the card and canvas colors.
  final TextTheme textTheme;

  /// A text theme that contrasts with the primary color.
  final TextTheme primaryTextTheme;

  /// A text theme that contrasts with the accent color.
  final TextTheme accentTextTheme;

  /// An icon theme that contrasts with the card and canvas colors.
  final IconThemeData iconTheme;

  /// An icon theme that contrasts with the primary color.
  final IconThemeData primaryIconTheme;

  /// An icon theme that contrasts with the accent color.
  final IconThemeData accentIconTheme;

  /// The platform the material widgets should adapt to target.
  ///
  /// Defaults to the current platform.
  final TargetPlatform platform;

  /// Creates a copy of this theme but with the given fields replaced with the new values.
  ThemeData copyWith({
    Brightness brightness,
    Color primaryColor,
    Brightness primaryColorBrightness,
    Color accentColor,
    Brightness accentColorBrightness,
    Color canvasColor,
    Color scaffoldBackgroundColor,
    Color cardColor,
    Color dividerColor,
    Color highlightColor,
    Color splashColor,
    Color selectedRowColor,
    Color unselectedWidgetColor,
    Color disabledColor,
    Color buttonColor,
    Color secondaryHeaderColor,
    Color textSelectionColor,
    Color textSelectionHandleColor,
    Color backgroundColor,
    Color dialogBackgroundColor,
    Color indicatorColor,
    Color hintColor,
    Color errorColor,
    TextTheme textTheme,
    TextTheme primaryTextTheme,
    TextTheme accentTextTheme,
    IconThemeData iconTheme,
    IconThemeData primaryIconTheme,
    IconThemeData accentIconTheme,
    TargetPlatform platform,
  }) {
    return _copyThemeDataWith(
      this,
      brightness: brightness,
      primaryColor: primaryColor,
      primaryColorBrightness: primaryColorBrightness,
      accentColor: accentColor,
      accentColorBrightness: accentColorBrightness,
      canvasColor: canvasColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardColor: cardColor,
      dividerColor: dividerColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      selectedRowColor: selectedRowColor,
      unselectedWidgetColor: unselectedWidgetColor,
      disabledColor: disabledColor,
      buttonColor: buttonColor,
      secondaryHeaderColor: secondaryHeaderColor,
      textSelectionColor: textSelectionColor,
      textSelectionHandleColor: textSelectionHandleColor,
      backgroundColor: backgroundColor,
      dialogBackgroundColor: dialogBackgroundColor,
      indicatorColor: indicatorColor,
      hintColor: hintColor,
      errorColor: errorColor,
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
      accentTextTheme: accentTextTheme,
      iconTheme: iconTheme,
      primaryIconTheme: primaryIconTheme,
      accentIconTheme: accentIconTheme,
      platform: platform,
    );
  }

  /// Returns a new theme built by merging [baseTheme] into the text geometry
  /// provided by the [localTextGeometry].
  ///
  /// The [TextStyle.inherit] field in the text styles provided by
  /// [localTextGeometry] must be set to `true`.
  static ThemeData localize(ThemeData baseTheme, TextTheme localTextGeometry) {
    assert(baseTheme != null);
    assert(localTextGeometry != null);
    return new _LocalizedThemeData(baseTheme, localTextGeometry);
  }

  // See <https://www.w3.org/TR/WCAG20/#relativeluminancedef>
  static double _linearizeColorComponent(double component) {
    if (component <= 0.03928)
      return component / 12.92;
    return math.pow((component + 0.055) / 1.055, 2.4);
  }

  /// Determines whether the given [Color] is [Brightness.light] or
  /// [Brightness.dark].
  ///
  /// This compares the luminosity of the given color to a threshold value that
  /// matches the material design specification.
  static Brightness estimateBrightnessForColor(Color color) {
    // See <https://www.w3.org/TR/WCAG20/#relativeluminancedef>
    final double R = _linearizeColorComponent(color.red / 0xFF);
    final double G = _linearizeColorComponent(color.green / 0xFF);
    final double B = _linearizeColorComponent(color.blue / 0xFF);
    final double L = 0.2126 * R + 0.7152 * G + 0.0722 * B;

    // See <https://www.w3.org/TR/WCAG20/#contrast-ratiodef>
    // The spec says to use kThreshold=0.0525, but Material Design appears to bias
    // more towards using light text than WCAG20 recommends. Material Design spec
    // doesn't say what value to use, but 0.15 seemed close to what the Material
    // Design spec shows for its color palette on
    // <https://material.io/guidelines/style/color.html#color-color-palette>.
    const double kThreshold = 0.15;
    if ((L + 0.05) * (L + 0.05) > kThreshold )
      return Brightness.light;
    return Brightness.dark;
  }

  /// Linearly interpolate between two themes.
  ///
  /// The arguments must not be null.
  static ThemeData lerp(ThemeData begin, ThemeData end, double t) {
    assert(begin != null);
    assert(end != null);
    return new ThemeData.raw(
      brightness: t < 0.5 ? begin.brightness : end.brightness,
      primaryColor: Color.lerp(begin.primaryColor, end.primaryColor, t),
      primaryColorBrightness: t < 0.5 ? begin.primaryColorBrightness : end.primaryColorBrightness,
      canvasColor: Color.lerp(begin.canvasColor, end.canvasColor, t),
      scaffoldBackgroundColor: Color.lerp(begin.scaffoldBackgroundColor, end.scaffoldBackgroundColor, t),
      cardColor: Color.lerp(begin.cardColor, end.cardColor, t),
      dividerColor: Color.lerp(begin.dividerColor, end.dividerColor, t),
      highlightColor: Color.lerp(begin.highlightColor, end.highlightColor, t),
      splashColor: Color.lerp(begin.splashColor, end.splashColor, t),
      selectedRowColor: Color.lerp(begin.selectedRowColor, end.selectedRowColor, t),
      unselectedWidgetColor: Color.lerp(begin.unselectedWidgetColor, end.unselectedWidgetColor, t),
      disabledColor: Color.lerp(begin.disabledColor, end.disabledColor, t),
      buttonColor: Color.lerp(begin.buttonColor, end.buttonColor, t),
      secondaryHeaderColor: Color.lerp(begin.secondaryHeaderColor, end.secondaryHeaderColor, t),
      textSelectionColor: Color.lerp(begin.textSelectionColor, end.textSelectionColor, t),
      textSelectionHandleColor: Color.lerp(begin.textSelectionHandleColor, end.textSelectionHandleColor, t),
      backgroundColor: Color.lerp(begin.backgroundColor, end.backgroundColor, t),
      dialogBackgroundColor: Color.lerp(begin.dialogBackgroundColor, end.dialogBackgroundColor, t),
      accentColor: Color.lerp(begin.accentColor, end.accentColor, t),
      accentColorBrightness: t < 0.5 ? begin.accentColorBrightness : end.accentColorBrightness,
      indicatorColor: Color.lerp(begin.indicatorColor, end.indicatorColor, t),
      hintColor: Color.lerp(begin.hintColor, end.hintColor, t),
      errorColor: Color.lerp(begin.errorColor, end.errorColor, t),
      textTheme: TextTheme.lerp(begin.textTheme, end.textTheme, t),
      primaryTextTheme: TextTheme.lerp(begin.primaryTextTheme, end.primaryTextTheme, t),
      accentTextTheme: TextTheme.lerp(begin.accentTextTheme, end.accentTextTheme, t),
      iconTheme: IconThemeData.lerp(begin.iconTheme, end.iconTheme, t),
      primaryIconTheme: IconThemeData.lerp(begin.primaryIconTheme, end.primaryIconTheme, t),
      accentIconTheme: IconThemeData.lerp(begin.accentIconTheme, end.accentIconTheme, t),
      platform: t < 0.5 ? begin.platform : end.platform
    );
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType)
      return false;
    final ThemeData otherData = other;
    return (otherData.brightness == brightness) &&
           (otherData.primaryColor == primaryColor) &&
           (otherData.primaryColorBrightness == primaryColorBrightness) &&
           (otherData.canvasColor == canvasColor) &&
           (otherData.scaffoldBackgroundColor == scaffoldBackgroundColor) &&
           (otherData.cardColor == cardColor) &&
           (otherData.dividerColor == dividerColor) &&
           (otherData.highlightColor == highlightColor) &&
           (otherData.splashColor == splashColor) &&
           (otherData.selectedRowColor == selectedRowColor) &&
           (otherData.unselectedWidgetColor == unselectedWidgetColor) &&
           (otherData.disabledColor == disabledColor) &&
           (otherData.buttonColor == buttonColor) &&
           (otherData.secondaryHeaderColor == secondaryHeaderColor) &&
           (otherData.textSelectionColor == textSelectionColor) &&
           (otherData.textSelectionHandleColor == textSelectionHandleColor) &&
           (otherData.backgroundColor == backgroundColor) &&
           (otherData.dialogBackgroundColor == dialogBackgroundColor) &&
           (otherData.accentColor == accentColor) &&
           (otherData.accentColorBrightness == accentColorBrightness) &&
           (otherData.indicatorColor == indicatorColor) &&
           (otherData.hintColor == hintColor) &&
           (otherData.errorColor == errorColor) &&
           (otherData.textTheme == textTheme) &&
           (otherData.primaryTextTheme == primaryTextTheme) &&
           (otherData.accentTextTheme == accentTextTheme) &&
           (otherData.iconTheme == iconTheme) &&
           (otherData.primaryIconTheme == primaryIconTheme) &&
           (otherData.accentIconTheme == accentIconTheme) &&
           (otherData.platform == platform);
  }

  @override
  int get hashCode {
    return hashValues(
      brightness,
      primaryColor,
      primaryColorBrightness,
      canvasColor,
      scaffoldBackgroundColor,
      cardColor,
      dividerColor,
      highlightColor,
      splashColor,
      selectedRowColor,
      unselectedWidgetColor,
      disabledColor,
      buttonColor,
      secondaryHeaderColor,
      textSelectionColor,
      textSelectionHandleColor,
      backgroundColor,
      accentColor,
      accentColorBrightness,
      hashValues( // Too many values.
        indicatorColor,
        dialogBackgroundColor,
        hintColor,
        errorColor,
        textTheme,
        primaryTextTheme,
        accentTextTheme,
        iconTheme,
        primaryIconTheme,
        accentIconTheme,
        platform,
      )
    );
  }

  @override
  String toString() => '$runtimeType(${ platform != defaultTargetPlatform ? "$platform " : ''}$brightness $primaryColor etc...)';
}

/// A lazily evaluated theme that provides the properties of the given
/// [delegate] theme localized using the properties of the given
/// [localTextGeometry].
///
/// The localization is done by merging of the [TextTheme] fields of the
/// [delegate] into the [localTextGeometry] and caching the results.
class _LocalizedThemeData implements ThemeData {
  _LocalizedThemeData(this.delegate, this.localTextGeometry);

  final ThemeData delegate;
  final TextTheme localTextGeometry;

  @override
  Color get accentColor => delegate.accentColor;

  @override
  Brightness get accentColorBrightness => delegate.accentColorBrightness;

  @override
  IconThemeData get accentIconTheme => delegate.accentIconTheme;

  @override
  Color get backgroundColor => delegate.backgroundColor;

  @override
  Brightness get brightness => delegate.brightness;

  @override
  Color get buttonColor => delegate.buttonColor;

  @override
  Color get canvasColor => delegate.canvasColor;

  @override
  Color get cardColor => delegate.cardColor;

  @override
  Color get dialogBackgroundColor => delegate.dialogBackgroundColor;

  @override
  Color get disabledColor => delegate.disabledColor;

  @override
  Color get dividerColor => delegate.dividerColor;

  @override
  Color get errorColor => delegate.errorColor;

  @override
  Color get highlightColor => delegate.highlightColor;

  @override
  Color get hintColor => delegate.hintColor;

  @override
  IconThemeData get iconTheme => delegate.iconTheme;

  @override
  Color get indicatorColor => delegate.indicatorColor;

  @override
  TargetPlatform get platform => delegate.platform;

  @override
  Color get primaryColor => delegate.primaryColor;

  @override
  Brightness get primaryColorBrightness => delegate.primaryColorBrightness;

  @override
  IconThemeData get primaryIconTheme => delegate.primaryIconTheme;

  @override
  Color get scaffoldBackgroundColor => delegate.scaffoldBackgroundColor;

  @override
  Color get secondaryHeaderColor => delegate.secondaryHeaderColor;

  @override
  Color get selectedRowColor => delegate.selectedRowColor;

  @override
  Color get splashColor => delegate.splashColor;

  @override
  Color get textSelectionColor => delegate.textSelectionColor;

  @override
  Color get textSelectionHandleColor => delegate.textSelectionHandleColor;

  @override
  Color get unselectedWidgetColor => delegate.unselectedWidgetColor;

  @override
  TextTheme get primaryTextTheme => _primaryTextTheme ??= delegate.primaryTextTheme.merge(localTextGeometry);
  TextTheme _primaryTextTheme;

  @override
  TextTheme get accentTextTheme => _accentTextTheme ??= delegate.accentTextTheme.merge(localTextGeometry);
  TextTheme _accentTextTheme;

  @override
  TextTheme get textTheme => _textTheme ??= delegate.textTheme.merge(localTextGeometry);
  TextTheme _textTheme;

  /// This should be identical to [ThemeData.copyWith].
  @override
  ThemeData copyWith({
    Brightness brightness,
    Color primaryColor,
    Brightness primaryColorBrightness,
    Color accentColor,
    Brightness accentColorBrightness,
    Color canvasColor,
    Color scaffoldBackgroundColor,
    Color cardColor,
    Color dividerColor,
    Color highlightColor,
    Color splashColor,
    Color selectedRowColor,
    Color unselectedWidgetColor,
    Color disabledColor,
    Color buttonColor,
    Color secondaryHeaderColor,
    Color textSelectionColor,
    Color textSelectionHandleColor,
    Color backgroundColor,
    Color dialogBackgroundColor,
    Color indicatorColor,
    Color hintColor,
    Color errorColor,
    TextTheme textTheme,
    TextTheme primaryTextTheme,
    TextTheme accentTextTheme,
    IconThemeData iconTheme,
    IconThemeData primaryIconTheme,
    IconThemeData accentIconTheme,
    TargetPlatform platform,
  }) {
    return _copyThemeDataWith(
      this,
      brightness: brightness,
      primaryColor: primaryColor,
      primaryColorBrightness: primaryColorBrightness,
      accentColor: accentColor,
      accentColorBrightness: accentColorBrightness,
      canvasColor: canvasColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardColor: cardColor,
      dividerColor: dividerColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      selectedRowColor: selectedRowColor,
      unselectedWidgetColor: unselectedWidgetColor,
      disabledColor: disabledColor,
      buttonColor: buttonColor,
      secondaryHeaderColor: secondaryHeaderColor,
      textSelectionColor: textSelectionColor,
      textSelectionHandleColor: textSelectionHandleColor,
      backgroundColor: backgroundColor,
      dialogBackgroundColor: dialogBackgroundColor,
      indicatorColor: indicatorColor,
      hintColor: hintColor,
      errorColor: errorColor,
      textTheme: textTheme,
      primaryTextTheme: primaryTextTheme,
      accentTextTheme: accentTextTheme,
      iconTheme: iconTheme,
      primaryIconTheme: primaryIconTheme,
      accentIconTheme: accentIconTheme,
      platform: platform,
    );
  }
}

/// Implementation of [ThemeData.copyWith], shared with [_LocalizedThemeData.copyWith].
ThemeData _copyThemeDataWith(
  ThemeData base, {
  @required Brightness brightness,
  @required Color primaryColor,
  @required Brightness primaryColorBrightness,
  @required Color accentColor,
  @required Brightness accentColorBrightness,
  @required Color canvasColor,
  @required Color scaffoldBackgroundColor,
  @required Color cardColor,
  @required Color dividerColor,
  @required Color highlightColor,
  @required Color splashColor,
  @required Color selectedRowColor,
  @required Color unselectedWidgetColor,
  @required Color disabledColor,
  @required Color buttonColor,
  @required Color secondaryHeaderColor,
  @required Color textSelectionColor,
  @required Color textSelectionHandleColor,
  @required Color backgroundColor,
  @required Color dialogBackgroundColor,
  @required Color indicatorColor,
  @required Color hintColor,
  @required Color errorColor,
  @required TextTheme textTheme,
  @required TextTheme primaryTextTheme,
  @required TextTheme accentTextTheme,
  @required IconThemeData iconTheme,
  @required IconThemeData primaryIconTheme,
  @required IconThemeData accentIconTheme,
  @required TargetPlatform platform,
}) {
  return new ThemeData.raw(
    brightness: brightness ?? base.brightness,
    primaryColor: primaryColor ?? base.primaryColor,
    primaryColorBrightness: primaryColorBrightness ?? base.primaryColorBrightness,
    accentColor: accentColor ?? base.accentColor,
    accentColorBrightness: accentColorBrightness ?? base.accentColorBrightness,
    canvasColor: canvasColor ?? base.canvasColor,
    scaffoldBackgroundColor: scaffoldBackgroundColor ?? base.scaffoldBackgroundColor,
    cardColor: cardColor ?? base.cardColor,
    dividerColor: dividerColor ?? base.dividerColor,
    highlightColor: highlightColor ?? base.highlightColor,
    splashColor: splashColor ?? base.splashColor,
    selectedRowColor: selectedRowColor ?? base.selectedRowColor,
    unselectedWidgetColor: unselectedWidgetColor ?? base.unselectedWidgetColor,
    disabledColor: disabledColor ?? base.disabledColor,
    buttonColor: buttonColor ?? base.buttonColor,
    secondaryHeaderColor: secondaryHeaderColor ?? base.secondaryHeaderColor,
    textSelectionColor: textSelectionColor ?? base.textSelectionColor,
    textSelectionHandleColor: textSelectionHandleColor ?? base.textSelectionHandleColor,
    backgroundColor: backgroundColor ?? base.backgroundColor,
    dialogBackgroundColor: dialogBackgroundColor ?? base.dialogBackgroundColor,
    indicatorColor: indicatorColor ?? base.indicatorColor,
    hintColor: hintColor ?? base.hintColor,
    errorColor: errorColor ?? base.errorColor,
    textTheme: textTheme ?? base.textTheme,
    primaryTextTheme: primaryTextTheme ?? base.primaryTextTheme,
    accentTextTheme: accentTextTheme ?? base.accentTextTheme,
    iconTheme: iconTheme ?? base.iconTheme,
    primaryIconTheme: primaryIconTheme ?? base.primaryIconTheme,
    accentIconTheme: accentIconTheme ?? base.accentIconTheme,
    platform: platform ?? base.platform,
  );
}
