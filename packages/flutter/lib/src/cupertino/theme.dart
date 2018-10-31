// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'text_theme.dart';

export 'package:flutter/services.dart' show Brightness;

// Values derived from https://developer.apple.com/design/resources/.
const Color _kDefaultBarLightBackgroundColor = Color(0xCCF8F8F8);

// Values derived from https://developer.apple.com/design/resources/.
const Color _kDefaultBarDarkBackgroundColor = Color(0xB7212121);

class CupertinoTheme extends InheritedModel<_ThemeDataProperties> {
  const CupertinoTheme({
    Key key,
    @required this.data,
    @required Widget child,
  }) : assert(child != null),
       assert(data != null),
       super(key: key, child: child);

  final CupertinoThemeData data;

  @override
  bool updateShouldNotify(CupertinoTheme old) => data != old.data;

  @override
  bool updateShouldNotifyDependent(CupertinoTheme oldWidget, Set<_ThemeDataProperties> dependencies) {
    return (data.barBackgroundColor != oldWidget.data.barBackgroundColor && dependencies.contains(_ThemeDataProperties.barBackgroundColor))
      || (data.brightness != oldWidget.data.brightness && dependencies.contains(_ThemeDataProperties.brightness))
      || (data.primaryColor != oldWidget.data.primaryColor && dependencies.contains(_ThemeDataProperties.primaryColor))
      || (data.primaryContrastingColor != oldWidget.data.primaryContrastingColor && dependencies.contains(_ThemeDataProperties.primaryContrastingColor))
      || (data.scaffoldBackgroundColor != oldWidget.data.scaffoldBackgroundColor && dependencies.contains(_ThemeDataProperties.scaffoldBackgroundColor))
      || (data.tableBackgroundColor != oldWidget.data.tableBackgroundColor && dependencies.contains(_ThemeDataProperties.tableBackgroundColor))
      || (data.textTheme != oldWidget.data.textTheme && dependencies.contains(_ThemeDataProperties.textTheme));
  }

  static CupertinoThemeData of(BuildContext context) => _CupertinoThemeInheritedData(context);
}

enum _ThemeDataProperties {
  barBackgroundColor,
  brightness,
  primaryColor,
  primaryContrastingColor,
  scaffoldBackgroundColor,
  tableBackgroundColor,
  textTheme,
}

class _CupertinoThemeInheritedData extends CupertinoThemeData {
  _CupertinoThemeInheritedData(this.context);

  final BuildContext context;

  @override
  Color get barBackgroundColor => getData(_ThemeDataProperties.barBackgroundColor).barBackgroundColor;

  @override
  Brightness get brightness => getData(_ThemeDataProperties.brightness).brightness;

  @override
  Color get primaryColor => getData(_ThemeDataProperties.primaryColor).primaryColor;

  @override
  Color get primaryContrastingColor => getData(_ThemeDataProperties.primaryContrastingColor).primaryContrastingColor;

  @override
  Color get scaffoldBackgroundColor => getData(_ThemeDataProperties.scaffoldBackgroundColor).scaffoldBackgroundColor;

  @override
  Color get tableBackgroundColor => getData(_ThemeDataProperties.tableBackgroundColor).tableBackgroundColor;

  @override
  CupertinoTextTheme get textTheme => getData(_ThemeDataProperties.textTheme).textTheme;

  CupertinoThemeData getData(_ThemeDataProperties property) {
    return InheritedModel.inheritFrom<CupertinoTheme>(context, aspect: property)?.data
        ?? const CupertinoThemeData();
  }
}

@immutable
class CupertinoThemeData {
  const CupertinoThemeData({
    Brightness brightness,
    Color primaryColor,
    Color primaryContrastingColor,
    CupertinoTextTheme textTheme,
    Color barBackgroundColor,
    Color scaffoldBackgroundColor,
    Color tableBackgroundColor,
  }) : _brightness = brightness,
       _primaryColor = primaryColor,
       _primaryContrastingColor = primaryContrastingColor,
       _textTheme = textTheme,
       _barBackgroundColor = barBackgroundColor,
       _scaffoldBackgroundColor = scaffoldBackgroundColor,
       _tableBackgroundColor = tableBackgroundColor;

  bool get _isLight => brightness == Brightness.light;

  final Brightness _brightness;
  Brightness get brightness => _brightness ?? Brightness.light;

  final Color _primaryColor;
  Color get primaryColor {
    return _primaryColor
        ?? (_isLight ? CupertinoColors.activeBlue : CupertinoColors.activeOrange);
  }

  final Color _primaryContrastingColor;
  Color get primaryContrastingColor {
    return _primaryContrastingColor
        ?? (_isLight ? CupertinoColors.white : CupertinoColors.black);
  }

  final CupertinoTextTheme _textTheme;
  CupertinoTextTheme get textTheme {
    return _textTheme ?? CupertinoTextTheme(
      isLight: _isLight,
      primaryColor: primaryColor,
    );
  }

  final Color _barBackgroundColor;
  Color get barBackgroundColor {
    return _barBackgroundColor ?? _isLight
        ? _kDefaultBarLightBackgroundColor
        : _kDefaultBarDarkBackgroundColor;
  }

  final Color _scaffoldBackgroundColor;
  Color get scaffoldBackgroundColor {
    return _scaffoldBackgroundColor
        ?? _isLight ? CupertinoColors.white : CupertinoColors.black;
  }

  final Color _tableBackgroundColor;
  Color get tableBackgroundColor {
    return _tableBackgroundColor ?? _isLight
        ? CupertinoColors.extraLightBackgroundGray
        : CupertinoColors.darkBackgroundGray;
  }

  CupertinoThemeData copyWith({
    Brightness brightness,
    Color primaryColor,
    Color primaryContrastingColor,
    CupertinoTextTheme textTheme,
    Color barBackgroundColor,
    Color scaffoldBackgroundColor,
    Color tableBackgroundColor,
  }) {
    return CupertinoThemeData(
      brightness: brightness ?? _brightness,
      primaryColor: primaryColor ?? _primaryColor,
      primaryContrastingColor: primaryContrastingColor ?? _primaryContrastingColor,
      textTheme: textTheme ?? _textTheme,
      barBackgroundColor: barBackgroundColor ?? _barBackgroundColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor ?? _scaffoldBackgroundColor,
      tableBackgroundColor: tableBackgroundColor ?? _tableBackgroundColor,
    );
  }
}
