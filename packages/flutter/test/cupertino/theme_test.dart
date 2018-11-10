// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

int buildCount;
CupertinoThemeData actualTheme;

final Widget singletonThemeSubtree = Builder(
  builder: (BuildContext context) {
    buildCount++;
    actualTheme = CupertinoTheme.of(context);
    return const Placeholder();
  },
);

Future<CupertinoThemeData> testTheme(WidgetTester tester, CupertinoThemeData theme) async {
  await tester.pumpWidget(
    CupertinoTheme(
      data: theme,
      child: singletonThemeSubtree,
    ),
  );
  return actualTheme;
}

void main() {
  setUp(() {
    buildCount = 0;
    actualTheme = null;
  });

  testWidgets('Default theme has defaults', (WidgetTester tester) async {
    final CupertinoThemeData theme = await testTheme(tester, const CupertinoThemeData());

    expect(theme.brightness, Brightness.light);
    expect(theme.primaryColor, CupertinoColors.activeBlue);
    expect(theme.textTheme.textStyle.fontSize, 17.0);
  });

  testWidgets('Theme attributes cascade', (WidgetTester tester) async {
    final CupertinoThemeData theme = await testTheme(tester, const CupertinoThemeData(
      primaryColor: CupertinoColors.destructiveRed,
    ));

    expect(theme.textTheme.actionTextStyle.color, CupertinoColors.destructiveRed);
  });

  testWidgets('Dependent attribute can be overridden from cascaded value', (WidgetTester tester) async {
    final CupertinoThemeData theme = await testTheme(tester, const CupertinoThemeData(
      brightness: Brightness.dark,
      textTheme: CupertinoTextTheme(
        textStyle: TextStyle(color: CupertinoColors.black),
      )
    ));

    // The brightness still cascaded down to the background color.
    expect(theme.scaffoldBackgroundColor, CupertinoColors.black);
    // But not to the font color which we overrode.
    expect(theme.textTheme.textStyle.color, CupertinoColors.black);
  });

  testWidgets(
    'Reading themes creates dependencies',
    (WidgetTester tester) async {
      // Reading the theme creates a dependency.
      CupertinoThemeData theme = await testTheme(tester, const CupertinoThemeData(
        // Default brightness is light,
        barBackgroundColor: Color(0x11223344),
        textTheme: CupertinoTextTheme(
          textStyle: TextStyle(fontFamily: 'Skeuomorphic'),
        ),
      ));

      expect(buildCount, 1);
      expect(theme.textTheme.textStyle.fontFamily, 'Skeuomorphic');

      // Changing another property also triggers a rebuild.
      theme = await testTheme(tester, const CupertinoThemeData(
        brightness: Brightness.light,
        barBackgroundColor: Color(0x11223344),
        textTheme: CupertinoTextTheme(
          textStyle: TextStyle(fontFamily: 'Skeuomorphic'),
        ),
      ));

      expect(buildCount, 2);
      // Re-reading the same value doesn't change anything.
      expect(theme.textTheme.textStyle.fontFamily, 'Skeuomorphic');

      theme = await testTheme(tester, const CupertinoThemeData(
        brightness: Brightness.light,
        barBackgroundColor: Color(0x11223344),
        textTheme: CupertinoTextTheme(
          textStyle: TextStyle(fontFamily: 'Flat'),
        ),
      ));

      expect(buildCount, 3);
      expect(theme.textTheme.textStyle.fontFamily, 'Flat');
    },
  );

  testWidgets(
    'copyWith works',
    (WidgetTester tester) async {
      const CupertinoThemeData originalTheme = CupertinoThemeData(
        brightness: Brightness.dark,
      );

      final CupertinoThemeData theme = await testTheme(tester, originalTheme.copyWith(
        primaryColor: CupertinoColors.activeGreen,
      ));

      expect(theme.brightness, Brightness.dark);
      expect(theme.primaryColor, CupertinoColors.activeGreen);
      // Now check calculated derivatives.
      expect(theme.textTheme.actionTextStyle.color, CupertinoColors.activeGreen);
      expect(theme.scaffoldBackgroundColor, CupertinoColors.black);
    },
  );
}
