// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SearchBarThemeData copyWith, ==, hashCode basics', () {
    expect(const SearchBarThemeData(), const SearchBarThemeData().copyWith());
    expect(const SearchBarThemeData().hashCode, const SearchBarThemeData()
        .copyWith()
        .hashCode);
  });

  test('SearchBarThemeData lerp special cases', () {
    expect(SearchBarThemeData.lerp(null, null, 0), null);
    const SearchBarThemeData data = SearchBarThemeData();
    expect(identical(SearchBarThemeData.lerp(data, data, 0.5), data), true);
  });

  test('SearchBarThemeData defaults', () {
    const SearchBarThemeData themeData = SearchBarThemeData();
    expect(themeData.elevation, null);
    expect(themeData.backgroundColor, null);
    expect(themeData.shadowColor, null);
    expect(themeData.surfaceTintColor, null);
    expect(themeData.overlayColor, null);
    expect(themeData.side, null);
    expect(themeData.shape, null);
    expect(themeData.padding, null);
    expect(themeData.textStyle, null);
    expect(themeData.hintStyle, null);
    expect(themeData.constraints, null);
    expect(themeData.textCapitalization, null);

    const SearchBarTheme theme = SearchBarTheme(data: SearchBarThemeData(), child: SizedBox());
    expect(theme.data.elevation, null);
    expect(theme.data.backgroundColor, null);
    expect(theme.data.shadowColor, null);
    expect(theme.data.surfaceTintColor, null);
    expect(theme.data.overlayColor, null);
    expect(theme.data.side, null);
    expect(theme.data.shape, null);
    expect(theme.data.padding, null);
    expect(theme.data.textStyle, null);
    expect(theme.data.hintStyle, null);
    expect(theme.data.constraints, null);
    expect(theme.data.textCapitalization, null);
  });

  testWidgets('Default SearchBarThemeData debugFillProperties', (WidgetTester tester) async {
    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    const SearchBarThemeData().debugFillProperties(builder);

    final List<String> description = builder.properties
      .where((DiagnosticsNode node) => !node.isFiltered(DiagnosticLevel.info))
      .map((DiagnosticsNode node) => node.toString())
      .toList();

    expect(description, <String>[]);
  });

  testWidgets('SearchBarThemeData implements debugFillProperties', (
      WidgetTester tester) async {
    final DiagnosticPropertiesBuilder builder = DiagnosticPropertiesBuilder();
    const SearchBarThemeData(
      elevation: WidgetStatePropertyAll<double>(3.0),
      backgroundColor: WidgetStatePropertyAll<Color>(Color(0xfffffff1)),
      shadowColor: WidgetStatePropertyAll<Color>(Color(0xfffffff2)),
      surfaceTintColor: WidgetStatePropertyAll<Color>(Color(0xfffffff3)),
      overlayColor: WidgetStatePropertyAll<Color>(Color(0xfffffff4)),
      side: WidgetStatePropertyAll<BorderSide>(BorderSide(width: 2.0, color: Color(0xfffffff5))),
      shape: WidgetStatePropertyAll<OutlinedBorder>(StadiumBorder()),
      padding: WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.all(16.0)),
      textStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(fontSize: 24.0)),
      hintStyle: WidgetStatePropertyAll<TextStyle>(TextStyle(fontSize: 16.0)),
      constraints: BoxConstraints(minWidth: 350, maxWidth: 850),
      textCapitalization: TextCapitalization.characters,
    ).debugFillProperties(builder);

    final List<String> description = builder.properties
      .where((DiagnosticsNode node) => !node.isFiltered(DiagnosticLevel.info))
      .map((DiagnosticsNode node) => node.toString())
      .toList();

    expect(description[0], 'elevation: WidgetStatePropertyAll(3.0)');
    expect(description[1], 'backgroundColor: WidgetStatePropertyAll(Color(0xfffffff1))');
    expect(description[2], 'shadowColor: WidgetStatePropertyAll(Color(0xfffffff2))');
    expect(description[3], 'surfaceTintColor: WidgetStatePropertyAll(Color(0xfffffff3))');
    expect(description[4], 'overlayColor: WidgetStatePropertyAll(Color(0xfffffff4))');
    expect(description[5], 'side: WidgetStatePropertyAll(BorderSide(color: Color(0xfffffff5), width: 2.0))');
    expect(description[6], 'shape: WidgetStatePropertyAll(StadiumBorder(BorderSide(width: 0.0, style: none)))');
    expect(description[7], 'padding: WidgetStatePropertyAll(EdgeInsets.all(16.0))');
    expect(description[8], 'textStyle: WidgetStatePropertyAll(TextStyle(inherit: true, size: 24.0))');
    expect(description[9], 'hintStyle: WidgetStatePropertyAll(TextStyle(inherit: true, size: 16.0))');
    expect(description[10], 'constraints: BoxConstraints(350.0<=w<=850.0, 0.0<=h<=Infinity)');
    expect(description[11], 'textCapitalization: TextCapitalization.characters');
  });

  group('[Theme, SearchBarTheme, SearchBar properties overrides]', () {
    const double elevationValue = 5.0;
    const Color backgroundColorValue = Color(0xff000001);
    const Color shadowColorValue = Color(0xff000001);
    const Color surfaceTintColorValue = Color(0xff000001);
    const Color overlayColorValue = Color(0xff000001);
    const BorderSide sideValue = BorderSide(color: Color(0xff000004), width: 2.0);
    const OutlinedBorder shapeValue = RoundedRectangleBorder(side: sideValue, borderRadius: BorderRadius.all(Radius.circular(2.0)));
    const EdgeInsets paddingValue = EdgeInsets.symmetric(horizontal: 16.0);
    const TextStyle textStyleValue = TextStyle(color: Color(0xff000005), fontSize: 20.0);
    const TextStyle hintStyleValue = TextStyle(color: Color(0xff000006), fontSize: 18.0);

    const WidgetStateProperty<double?> elevation = WidgetStatePropertyAll<double>(elevationValue);
    const WidgetStateProperty<Color?> backgroundColor = WidgetStatePropertyAll<Color>(backgroundColorValue);
    const WidgetStateProperty<Color?> shadowColor = WidgetStatePropertyAll<Color>(shadowColorValue);
    const WidgetStateProperty<Color?> surfaceTintColor = WidgetStatePropertyAll<Color>(surfaceTintColorValue);
    const WidgetStateProperty<Color?> overlayColor = WidgetStatePropertyAll<Color>(overlayColorValue);
    const WidgetStateProperty<BorderSide?> side = WidgetStatePropertyAll<BorderSide>(sideValue);
    const WidgetStateProperty<OutlinedBorder?> shape = WidgetStatePropertyAll<OutlinedBorder>(shapeValue);
    const WidgetStateProperty<EdgeInsetsGeometry?> padding = WidgetStatePropertyAll<EdgeInsets>(paddingValue);
    const WidgetStateProperty<TextStyle?> textStyle = WidgetStatePropertyAll<TextStyle>(textStyleValue);
    const WidgetStateProperty<TextStyle?> hintStyle = WidgetStatePropertyAll<TextStyle>(hintStyleValue);
    const BoxConstraints constraints = BoxConstraints(minWidth: 250.0, maxWidth: 300.0, minHeight: 80.0);
    const TextCapitalization textCapitalization = TextCapitalization.words;

    const SearchBarThemeData searchBarTheme = SearchBarThemeData(
      elevation: elevation,
      backgroundColor: backgroundColor,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      overlayColor: overlayColor,
      side: side,
      shape: shape,
      padding: padding,
      textStyle: textStyle,
      hintStyle: hintStyle,
      constraints: constraints,
      textCapitalization: textCapitalization,
    );

    Widget buildFrame({
      bool useSearchBarProperties = false,
      SearchBarThemeData? searchBarThemeData,
      SearchBarThemeData? overallTheme
    }) {
      final Widget child = Builder(
        builder: (BuildContext context) {
          if (!useSearchBarProperties) {
            return const SearchBar(
              hintText: 'hint',
              leading: Icon(Icons.search),
              trailing: <Widget>[ Icon(Icons.menu)],
            );
          }
          return const SearchBar(
            hintText: 'hint',
            leading: Icon(Icons.search),
            trailing: <Widget>[ Icon(Icons.menu)],
            elevation: elevation,
            backgroundColor: backgroundColor,
            shadowColor: shadowColor,
            surfaceTintColor: surfaceTintColor,
            overlayColor: overlayColor,
            side: side,
            shape: shape,
            padding: padding,
            textStyle: textStyle,
            hintStyle: hintStyle,
            constraints: constraints,
            textCapitalization: textCapitalization,
          );
        },
      );
      return MaterialApp(
        theme: ThemeData.from(
          colorScheme: const ColorScheme.light(), useMaterial3: true)
          .copyWith(
            searchBarTheme: overallTheme,
        ),
        home: Scaffold(
          body: Center(
            // If the SearchBarThemeData widget is present, it's used
            // instead of the Theme's ThemeData.searchBarTheme.
            child: searchBarThemeData == null ? child : SearchBarTheme(
              data: searchBarThemeData,
              child: child,
            ),
          ),
        ),
      );
    }

    final Finder findMaterial = find.descendant(
      of: find.byType(SearchBar),
      matching: find.byType(Material),
    );

    final Finder findInkWell = find.descendant(
      of: find.byType(SearchBar),
      matching: find.byType(InkWell),
    );

    const Set<WidgetState> hovered = <WidgetState>{ WidgetState.hovered};
    const Set<WidgetState> focused = <WidgetState>{ WidgetState.focused};
    const Set<WidgetState> pressed = <WidgetState>{ WidgetState.pressed};

    Future<void> checkSearchBar(WidgetTester tester) async {
      final Material material = tester.widget<Material>(findMaterial);
      final InkWell inkWell = tester.widget<InkWell>(findInkWell);
      expect(material.elevation, elevationValue);
      expect(material.color, backgroundColorValue);
      expect(material.shadowColor, shadowColorValue);
      expect(material.surfaceTintColor, surfaceTintColorValue);
      expect(material.shape, shapeValue);
      expect(inkWell.overlayColor!.resolve(hovered), overlayColor.resolve(hovered));
      expect(inkWell.overlayColor!.resolve(focused), overlayColor.resolve(focused));
      expect(inkWell.overlayColor!.resolve(pressed), overlayColor.resolve(pressed));
      expect(inkWell.customBorder, shapeValue);

      expect(tester.getSize(find.byType(SearchBar)), const Size(300.0, 80.0));

      final Text hintText = tester.widget(find.text('hint'));
      expect(hintText.style?.color, hintStyleValue.color);
      expect(hintText.style?.fontSize, hintStyleValue.fontSize);

      await tester.enterText(find.byType(TextField), 'input');
      final EditableText inputText = tester.widget(find.text('input'));
      expect(inputText.style.color, textStyleValue.color);
      expect(inputText.style.fontSize, textStyleValue.fontSize);
      expect(inputText.textCapitalization, textCapitalization);

      final Rect barRect = tester.getRect(find.byType(SearchBar));
      final Rect leadingRect = tester.getRect(find.byIcon(Icons.search));
      final Rect textFieldRect = tester.getRect(find.byType(TextField));
      final Rect trailingRect = tester.getRect(find.byIcon(Icons.menu));

      expect(barRect.left, leadingRect.left - 16.0);
      expect(leadingRect.right, textFieldRect.left - 16.0);
      expect(textFieldRect.right, trailingRect.left - 16.0);
      expect(trailingRect.right, barRect.right - 16.0);
    }

    testWidgets('SearchBar properties overrides defaults', (WidgetTester tester) async {
      await tester.pumpWidget(buildFrame(useSearchBarProperties: true));
      await tester.pumpAndSettle(); // allow the animations to finish
      checkSearchBar(tester);
    });

    testWidgets('SearchBar theme data overrides defaults', (WidgetTester tester) async {
      await tester.pumpWidget(buildFrame(searchBarThemeData: searchBarTheme));
      await tester.pumpAndSettle();
      checkSearchBar(tester);
    });

    testWidgets('Overall Theme SearchBar theme overrides defaults', (WidgetTester tester) async {
      await tester.pumpWidget(buildFrame(overallTheme: searchBarTheme));
      await tester.pumpAndSettle();
      checkSearchBar(tester);
    });

    // Same as the previous tests with empty SearchBarThemeData's instead of null.

    testWidgets('SearchBar properties overrides defaults, empty theme and overall theme', (WidgetTester tester) async {
      await tester.pumpWidget(buildFrame(useSearchBarProperties: true,
        searchBarThemeData: const SearchBarThemeData(),
        overallTheme: const SearchBarThemeData()));
      await tester.pumpAndSettle(); // allow the animations to finish
      checkSearchBar(tester);
    });

    testWidgets('SearchBar theme overrides defaults and overall theme', (WidgetTester tester) async {
      await tester.pumpWidget(buildFrame(searchBarThemeData: searchBarTheme,
        overallTheme: const SearchBarThemeData()));
      await tester.pumpAndSettle(); // allow the animations to finish
      checkSearchBar(tester);
    });

    testWidgets('Overall Theme SearchBar theme overrides defaults and null theme', (WidgetTester tester) async {
      await tester.pumpWidget(buildFrame(overallTheme: searchBarTheme));
      await tester.pumpAndSettle(); // allow the animations to finish
      checkSearchBar(tester);
    });
  });
}
