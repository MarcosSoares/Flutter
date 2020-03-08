// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import '../widgets/semantics_tester.dart';

void main() {
  testWidgets('Renders at the correct default width - [labelType]=none (default)', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        destinations: _destinations(),
      ),
    );

    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 72.0);
  });

  testWidgets('Renders at the correct default width - [labelType]=selected', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        labelType: NavigationRailLabelType.selected,
        destinations: _destinations(),
      ),
    );

    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 72.0);
  });

  testWidgets('Renders at the correct default width - [labelType]=all', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        labelType: NavigationRailLabelType.all,
        destinations: _destinations(),
      ),
    );

    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 72.0);
  });

  testWidgets('Renders wider for a destination with a long label - [labelType]=all', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        labelType: NavigationRailLabelType.all,
        destinations: const <NavigationRailDestination>[
          NavigationRailDestination(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: Text('Abc'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.bookmark_border),
            activeIcon: Icon(Icons.bookmark),
            label: Text('Longer Label'),
          ),
        ],
      ),
    );

    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 184.0);
  });

  testWidgets('Renders only icons - [labelType]=none (default)', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        destinations: _destinations(),
      ),
    );

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsOneWidget);
    expect(find.byIcon(Icons.hotel), findsOneWidget);
    expect(find.byIcon(Icons.remove_circle), findsOneWidget);

    // When there are no labels, a 0 opacity label is still shown for semantics.
    expect(_labelOpacity(tester, 'Abc'), 0);
    expect(_labelOpacity(tester, 'Def'), 0);
    expect(_labelOpacity(tester, 'Ghi'), 0);
    expect(_labelOpacity(tester, 'Jkl'), 0);
    expect(_labelOpacity(tester, 'Mno'), 0);
  });

  testWidgets('Renders icons and labels - [labelType]=all', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.all,
      ),
    );

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsOneWidget);
    expect(find.byIcon(Icons.hotel), findsOneWidget);
    expect(find.byIcon(Icons.remove_circle), findsOneWidget);

    expect(find.text('Abc'), findsOneWidget);
    expect(find.text('Def'), findsOneWidget);
    expect(find.text('Ghi'), findsOneWidget);
    expect(find.text('Jkl'), findsOneWidget);
    expect(find.text('Mno'), findsOneWidget);

    // When displaying all labels, there is no opacity.
    expect(_opacityAboveLabel('Abc'), findsNothing);
    expect(_opacityAboveLabel('Def'), findsNothing);
    expect(_opacityAboveLabel('Ghi'), findsNothing);
    expect(_opacityAboveLabel('Jkl'), findsNothing);
    expect(_opacityAboveLabel('Mno'), findsNothing);
  });

  testWidgets('Renders icons and selected label - [labelType]=selected', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.selected,
      ),
    );

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.bookmark_border), findsOneWidget);
    expect(find.byIcon(Icons.star_border), findsOneWidget);
    expect(find.byIcon(Icons.hotel), findsOneWidget);
    expect(find.byIcon(Icons.remove_circle), findsOneWidget);

    // Only the selected label is visible.
    expect(_labelOpacity(tester, 'Abc'), 1);
    expect(_labelOpacity(tester, 'Def'), 0);
    expect(_labelOpacity(tester, 'Ghi'), 0);
    expect(_labelOpacity(tester, 'Jkl'), 0);
    expect(_labelOpacity(tester, 'Mno'), 0);
  });

  testWidgets('Destination spacing is correct - [labelType]=none, [textScaleFactor]=1.0', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.none,
      ),
    );

    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 72.0);
    expect(renderBox.localToGlobal(Offset.zero), Offset.zero);

    final Offset iconAdjustment = _iconAdjustment(tester);

    // The destination padding is 24, but the top has additional padding of 8.
    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 32.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 104.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 176.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 248.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 320.0)),
    );
  });

  testWidgets('Destination spacing is correct - [labelType]=none, [textScaleFactor]=3.0', (WidgetTester tester) async {
    // Since the rail is icon only, its destinations should not be affected by
    // textScaleFactor.
    await _pumpNavigationRail(
      tester,
      textScaleFactor: 3.0,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.none,
      ),
    );

    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 72.0);

    final Offset iconAdjustment = _iconAdjustment(tester);

    // The destination padding is 24, but the top has additional padding of 8.
    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 32.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 104.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 176.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 248.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 320.0)),
    );
  });

  testWidgets('Destination spacing is correct - [labelType]=none, [textScaleFactor]=0.75', (WidgetTester tester) async {
    // Since the rail is icon only, its destinations should not be affected by
    // textScaleFactor.
    await _pumpNavigationRail(
      tester,
      textScaleFactor: 0.75,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.none,
      ),
    );

    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 72.0);

    final Offset iconAdjustment = _iconAdjustment(tester);

    // The destination padding is 24, but the top has additional padding of 8.
    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 32.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 104.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 176.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 248.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 320.0)),
    );
  });

  testWidgets('Destination spacing is correct - [labelType]=selected, [textScaleFactor]=1.0', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.selected,
      ),
    );

    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 72.0);

    final Offset iconAdjustment = _iconAdjustment(tester);

    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 24.0)),
    );
    expect(
      _labelRenderBox(tester, 'Abc').localToGlobal(Offset.zero),
      equals(const Offset(15.0, 48.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 104.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 176.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 248.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 320.0)),
    );
  });

  testWidgets('Destination spacing is correct - [labelType]=selected, [textScaleFactor]=3.0', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      textScaleFactor: 3.0,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.selected,
      ),
    );

    // The rail and destinations sizes grow to fit the larger text labels.
    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 142);

    final Offset iconAdjustment = _iconAdjustment(tester);

    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(59.0, 24.0)),
    );
    expect(
      _labelRenderBox(tester, 'Abc').localToGlobal(Offset.zero),
      equals(const Offset(8.0, 48.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(59.0, 130.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(59.0, 202.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(59.0, 274.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(59.0, 346.0)),
    );
  });

  testWidgets('Destination spacing is correct - [labelType]=selected, [textScaleFactor]=0.75', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      textScaleFactor: 0.75,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.selected,
      ),
    );

    // A smaller textScaleFactor will not reduce the default size of the rail.
    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 72.0);

    final Offset iconAdjustment = _iconAdjustment(tester);

    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 24.0)),
    );

    expect(
      _labelRenderBox(tester, 'Abc').localToGlobal(Offset.zero),
      equals(Offset(_verticalLabelXOffset(tester, 'Abc'), 48.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 104.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 176.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 248.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 320.0)),
    );
  });

  testWidgets('Destination spacing is correct - [labelType]=all, [textScaleFactor]=1', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.all,
      ),
    );

    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 72.0);

    final Offset iconAdjustment = _iconAdjustment(tester);

    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 24.0)),
    );
    expect(
      _labelRenderBox(tester, 'Abc').localToGlobal(Offset.zero),
      equals(const Offset(15.0, 48.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 96.0)),
    );
    expect(
      _labelRenderBox(tester, 'Def').localToGlobal(Offset.zero),
      equals(const Offset(15.0, 120.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 168.0)),
    );
    expect(
      _labelRenderBox(tester, 'Ghi').localToGlobal(Offset.zero),
      equals(const Offset(15.0, 192.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 240.0)),
    );
    expect(
      _labelRenderBox(tester, 'Jkl').localToGlobal(Offset.zero),
      equals(const Offset(15.0, 264.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 312.0)),
    );
    expect(
      _labelRenderBox(tester, 'Mno').localToGlobal(Offset.zero),
      equals(const Offset(15.0, 336.0)),
    );
  });

  testWidgets('Destination spacing is correct - [labelType]=all, [textScaleFactor]=3.0', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      textScaleFactor: 3.0,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.all,
      ),
    );

    // The rail and destinations sizes grow to fit the larger text labels.
    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 142);

    final Offset iconAdjustment = _iconAdjustment(tester);

    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(59.0, 24.0)),
    );
    expect(
      _labelRenderBox(tester, 'Abc').localToGlobal(Offset.zero),
      equals(const Offset(8.0, 48.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(59.0, 122.0)),
    );
    expect(
      _labelRenderBox(tester, 'Def').localToGlobal(Offset.zero),
      equals(const Offset(8.0, 146.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(59.0, 220.0)),
    );
    expect(
      _labelRenderBox(tester, 'Ghi').localToGlobal(Offset.zero),
      equals(const Offset(8.0, 244.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(59.0, 318.0)),
    );
    expect(
      _labelRenderBox(tester, 'Jkl').localToGlobal(Offset.zero),
      equals(const Offset(8.0, 342.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(59.0, 416.0)),
    );
    expect(
      _labelRenderBox(tester, 'Mno').localToGlobal(Offset.zero),
      equals(const Offset(8.0, 440.0)),
    );
  });

  testWidgets('Destination spacing is correct - [labelType]=all, [textScaleFactor]=0.75', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      textScaleFactor: 0.75,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.all,
      ),
    );

    // A smaller textScaleFactor will not reduce the default size of the rail.
    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 72.0);

    final Offset iconAdjustment = _iconAdjustment(tester);

    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 24.0)),
    );
    expect(
      _labelRenderBox(tester, 'Abc').localToGlobal(Offset.zero),
      equals(Offset(_verticalLabelXOffset(tester, 'Abc'), 48.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 96.0)),
    );
    expect(
      _labelRenderBox(tester, 'Def').localToGlobal(Offset.zero),
      equals(Offset(_verticalLabelXOffset(tester, 'Def'), 120.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 168.0)),
    );
    expect(
      _labelRenderBox(tester, 'Ghi').localToGlobal(Offset.zero),
      equals(Offset(_verticalLabelXOffset(tester, 'Ghi'), 192.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 240.0)),
    );
    expect(
      _labelRenderBox(tester, 'Jkl').localToGlobal(Offset.zero),
      equals(Offset(_verticalLabelXOffset(tester, 'Jkl'), 264.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 312.0)),
    );
    expect(
      _labelRenderBox(tester, 'Mno').localToGlobal(Offset.zero),
      equals(Offset(_verticalLabelXOffset(tester, 'Mno'), 336.0)),
    );
  });

  testWidgets('Destination spacing is correct for a compact rail - [preferredWidth]=56, [textScaleFactor]=1.0', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        minWidth: 56.0,
        destinations: _destinations(),
      ),
    );

    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 56.0);

    final Offset iconAdjustment = _iconAdjustment(tester);

    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(16.0, 24.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(16.0, 80.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(16.0, 136.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(16.0, 192.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(16.0, 248.0)),
    );
  });

  testWidgets('Destination spacing is correct for a compact rail - [preferredWidth]=56, [textScaleFactor]=3.0', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      textScaleFactor: 3.0,
      navigationRail: NavigationRail(
        minWidth: 56.0,
        destinations: _destinations(),
      ),
    );

    // Since the rail is icon only, its preferred width should not be affected
    // by  textScaleFactor.
    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 56.0);

    final Offset iconAdjustment = _iconAdjustment(tester);

    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(16.0, 24.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(16.0, 80.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(16.0, 136.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(16.0, 192.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(16.0, 248.0)),
    );
  });

  testWidgets('Destination spacing is correct for a compact rail - [preferredWidth]=56, [textScaleFactor]=0.75', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      textScaleFactor: 3.0,
      navigationRail: NavigationRail(
        minWidth: 56.0,
        destinations: _destinations(),
      ),
    );

    // Since the rail is icon only, its preferred width should not be affected
    // by  textScaleFactor.
    final RenderBox renderBox = tester.renderObject(find.byType(NavigationRail));
    expect(renderBox.size.width, 56.0);

    final Offset iconAdjustment = _iconAdjustment(tester);

    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(16.0, 24.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(16.0, 80.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(16.0, 136.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(16.0, 192.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(16.0, 248.0)),
    );
  });

  testWidgets('Group alignment works - [groupAlignment]=-1.0', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        groupAlignment: -1.0,
        destinations: _destinations(),
      ),
    );

    final Offset iconAdjustment = _iconAdjustment(tester);

    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 32.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 104.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 176.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 248.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 320.0)),
    );
  });

  testWidgets('Group alignment works - [groupAlignment]=0.0', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        groupAlignment: 0.0,
        destinations: _destinations(),
      ),
    );

    final Offset iconAdjustment = _iconAdjustment(tester);

    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 148.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 220.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 292.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 364.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 436.0)),
    );
  });

  testWidgets('Group alignment works - [groupAlignment]=1.0', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        groupAlignment: 1.0,
        destinations: _destinations(),
      ),
    );

    final Offset iconAdjustment = _iconAdjustment(tester);

    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 264.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 336.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 408.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 480.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 552.0)),
    );
  });

  testWidgets('Leading and trailing appear in the correct places', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        leading: FloatingActionButton(onPressed: () { }),
        trailing: FloatingActionButton(onPressed: () { }),
        destinations: _destinations(),
      ),
    );

    final RenderBox leading = tester.renderObject<RenderBox>(find.byType(FloatingActionButton).at(0));
    final RenderBox trailing = tester.renderObject<RenderBox>(find.byType(FloatingActionButton).at(1));
    expect(leading.localToGlobal(Offset.zero), const Offset(8.0, 8.0));
    expect(trailing.localToGlobal(Offset.zero), const Offset(8.0, 432.0));
  });

  testWidgets('Extended rail animates the width and labels appear - LTR', (WidgetTester tester) async {
    bool extended = false;
    StateSetter stateSetter;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            stateSetter = setState;
            return Scaffold(
              body: Row(
                children: <Widget>[
                  NavigationRail(
                    destinations: _destinations(),
                    extended: extended,
                  ),
                  const Expanded(
                    child: Text('body'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    final RenderBox rail = tester.firstRenderObject<RenderBox>(find.byType(NavigationRail));

    expect(rail.size.width, equals(72.0));

    stateSetter(() {
      extended = true;
    });

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(rail.size.width, equals(164.0));

    await tester.pumpAndSettle();
    expect(rail.size.width, equals(256.0));

    final Offset iconAdjustment = _iconAdjustment(tester);

    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 32.0)),
    );
    expect(
      _labelRenderBox(tester, 'Abc').localToGlobal(Offset.zero),
      equals(const Offset(72.0, 37.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 104.0)),
    );
    expect(
      _labelRenderBox(tester, 'Def').localToGlobal(Offset.zero),
      equals(const Offset(72.0, 109.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 176.0)),
    );
    expect(
      _labelRenderBox(tester, 'Ghi').localToGlobal(Offset.zero),
      equals(const Offset(72.0, 181.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 248.0)),
    );
    expect(
      _labelRenderBox(tester, 'Jkl').localToGlobal(Offset.zero),
      equals(const Offset(72.0, 253.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(24.0, 320.0)),
    );
    expect(
      _labelRenderBox(tester, 'Mno').localToGlobal(Offset.zero),
      equals(const Offset(72.0, 325.0)),
    );
  });

  testWidgets('Extended rail animates the width and labels appear - RTL', (WidgetTester tester) async {
    bool extended = false;
    StateSetter stateSetter;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            stateSetter = setState;
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: Row(
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    NavigationRail(
                      destinations: _destinations(),
                      extended: extended,
                    ),
                    const Expanded(
                      child: Text('body'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    final RenderBox rail = tester.firstRenderObject<RenderBox>(find.byType(NavigationRail));

    final Offset iconAdjustment = _iconAdjustment(tester);

    expect(rail.size.width, equals(72.0));
    expect(rail.localToGlobal(Offset.zero), equals(const Offset(728.0, 0.0)));

    stateSetter(() {
      extended = true;
    });

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(rail.size.width, equals(164.0));
    expect(rail.localToGlobal(Offset.zero), equals(const Offset(636.0, 0.0)));

    await tester.pumpAndSettle();
    expect(rail.size.width, equals(256.0));
    expect(rail.localToGlobal(Offset.zero), equals(const Offset(544.0, 0.0)));

    expect(
      _iconRenderBox(tester, Icons.favorite).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(752.0, 32.0)),
    );
    expect(
      _labelRenderBox(tester, 'Abc').localToGlobal(Offset.zero),
      equals(const Offset(686.0, 37.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.bookmark_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(752.0, 104.0)),
    );
    expect(
      _labelRenderBox(tester, 'Def').localToGlobal(Offset.zero),
      equals(const Offset(686.0, 109.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.star_border).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(752.0, 176.0)),
    );
    expect(
      _labelRenderBox(tester, 'Ghi').localToGlobal(Offset.zero),
      equals(const Offset(686.0, 181.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.hotel).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(752.0, 248.0)),
    );
    expect(
      _labelRenderBox(tester, 'Jkl').localToGlobal(Offset.zero),
      equals(const Offset(686.0, 253.0)),
    );
    expect(
      _iconRenderBox(tester, Icons.remove_circle).localToGlobal(Offset.zero),
      equals(iconAdjustment + const Offset(752.0, 320.0)),
    );
    expect(
      _labelRenderBox(tester, 'Mno').localToGlobal(Offset.zero),
      equals(const Offset(686.0, 325.0)),
    );
  });

  testWidgets('Extended rail final width can be changed', (WidgetTester tester) async {
    bool extended = false;
    StateSetter stateSetter;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            stateSetter = setState;
            return Scaffold(
              body: Row(
                children: <Widget>[
                  NavigationRail(
                    minExtendedWidth: 300,
                    destinations: _destinations(),
                    extended: extended,
                  ),
                  const Expanded(
                    child: Text('body'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    final RenderBox rail = tester.firstRenderObject<RenderBox>(find.byType(NavigationRail));

    expect(rail.size.width, equals(72.0));

    stateSetter(() {
      extended = true;
    });

    await tester.pumpAndSettle();
    expect(rail.size.width, equals(300.0));
  });

  testWidgets('Extended rail animation can be consumed', (WidgetTester tester) async {
    bool extended = false;
    Animation<double> animation;
    StateSetter stateSetter;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            stateSetter = setState;
            return Scaffold(
              body: Row(
                children: <Widget>[
                  NavigationRail(
                    leading: Builder(
                      builder: (BuildContext context) {
                        animation = NavigationRail.extendedAnimation(context);
                        return FloatingActionButton(onPressed: () { },);
                      },
                    ),
                    destinations: _destinations(),
                    extended: extended,
                  ),
                  const Expanded(
                    child: Text('body'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    expect(animation.isDismissed, isTrue);

    stateSetter(() {
      extended = true;
    });
    await tester.pumpAndSettle();

    expect(animation.isCompleted, isTrue);
  });

  testWidgets('Custom selected and unselected textStyles are honored', (WidgetTester tester) async {
    const TextStyle selectedTextStyle = TextStyle(fontWeight: FontWeight.w300, fontSize: 17.0);
    const TextStyle unselectedTextStyle = TextStyle(fontWeight: FontWeight.w800, fontSize: 11.0);

    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.all,
        selectedLabelTextStyle: selectedTextStyle,
        unselectedLabelTextStyle: unselectedTextStyle,
      ),
    );

    final TextStyle actualSelectedTextStyle = tester.renderObject<RenderParagraph>(find.text('Abc')).text.style;
    final TextStyle actualUnselectedTextStyle = tester.renderObject<RenderParagraph>(find.text('Def')).text.style;
    expect(actualSelectedTextStyle.fontSize, equals(selectedTextStyle.fontSize));
    expect(actualSelectedTextStyle.fontWeight, equals(selectedTextStyle.fontWeight));
    expect(actualUnselectedTextStyle.fontSize, equals(actualUnselectedTextStyle.fontSize));
    expect(actualUnselectedTextStyle.fontWeight, equals(actualUnselectedTextStyle.fontWeight));
  });

  testWidgets('Custom selected and unselected iconThemes are honored', (WidgetTester tester) async {
    const IconThemeData selectedIconTheme = IconThemeData(size: 36, color: Color(0x00000001));
    const IconThemeData unselectedIconTheme = IconThemeData(size: 18, color: Color(0x00000002));

    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.all,
        selectedIconTheme: selectedIconTheme,
        unselectedIconTheme: unselectedIconTheme,
      ),
    );

    final TextStyle actualSelectedIconTheme = _iconStyle(tester, Icons.favorite);
    final TextStyle actualUnselectedIconTheme = _iconStyle(tester, Icons.bookmark_border);
    expect(actualSelectedIconTheme.color, equals(selectedIconTheme.color));
    expect(actualSelectedIconTheme.fontSize, equals(selectedIconTheme.size));
    expect(actualUnselectedIconTheme.color, equals(unselectedIconTheme.color));
    expect(actualUnselectedIconTheme.fontSize, equals(unselectedIconTheme.size));
  });

  testWidgets('Rail backgroundColor can be changed', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.all,
      ),
    );

    expect(_railMaterial(tester).color, equals(Colors.white));

    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.all,
        backgroundColor: Colors.green,
      ),
    );

    expect(_railMaterial(tester).color, equals(Colors.green));
  });

  testWidgets('Rail elevation can be changed', (WidgetTester tester) async {
    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.all,
      ),
    );

    expect(_railMaterial(tester).elevation, equals(0));

    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        labelType: NavigationRailLabelType.all,
        elevation: 7,
      ),
    );

    expect(_railMaterial(tester).elevation, equals(7));
  });

  testWidgets('onDestinationSelected is called', (WidgetTester tester) async {
    int selectedIndex;

    await _pumpNavigationRail(
      tester,
      navigationRail: NavigationRail(
        destinations: _destinations(),
        onDestinationSelected: (int index) {
          selectedIndex = index;
        },
        labelType: NavigationRailLabelType.all,
      ),
    );

    await tester.tap(find.text('Def'));
    expect(selectedIndex, 1);

    await tester.tap(find.text('Ghi'));
    expect(selectedIndex, 2);
  });

  testWidgets('Changing destinations animate when [labelType]=selected', (WidgetTester tester) async {
    int selectedIndex = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Scaffold(
              body: Row(
                children: <Widget>[
                  NavigationRail(
                    destinations: _destinations(),
                    selectedIndex: selectedIndex,
                    labelType: NavigationRailLabelType.selected,
                    onDestinationSelected: (int index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text('body'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    // Tap the second destination.
    await tester.tap(find.byIcon(Icons.bookmark_border));
    expect(selectedIndex, 1);

    // The second destination animates in.
    expect(_labelOpacity(tester, 'Def'), equals(0.0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(_labelOpacity(tester, 'Def'), equals(0.5));
    await tester.pumpAndSettle();
    expect(_labelOpacity(tester, 'Def'), equals(1.0));

    // Tap the third destination.
    await tester.tap(find.byIcon(Icons.star_border));
    expect(selectedIndex, 2);

    // The second destination animates out quickly and the third destination
    // animates in.
    expect(_labelOpacity(tester, 'Ghi'), equals(0.0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 25));
    expect(_labelOpacity(tester, 'Def'), equals(0.5));
    expect(_labelOpacity(tester, 'Ghi'), equals(0.0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 25));
    expect(_labelOpacity(tester, 'Def'), equals(0.0));
    expect(_labelOpacity(tester, 'Ghi'), equals(0.0));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
    expect(_labelOpacity(tester, 'Ghi'), equals(0.5));
    await tester.pumpAndSettle();
    expect(_labelOpacity(tester, 'Ghi'), equals(1.0));
  });

  testWidgets('Semantics - labelType=[none]', (WidgetTester tester) async {
    final SemanticsTester semantics = SemanticsTester(tester);

    await _pumpLocalizedTestRail(tester, labelType: NavigationRailLabelType.none);

    expect(semantics, hasSemantics(_expectedSemantics(), ignoreId: true, ignoreTransform: true, ignoreRect: true));

    semantics.dispose();
  });

  testWidgets('Semantics - labelType=[selected]', (WidgetTester tester) async {
    final SemanticsTester semantics = SemanticsTester(tester);

    await _pumpLocalizedTestRail(tester, labelType: NavigationRailLabelType.selected);

    expect(semantics, hasSemantics(_expectedSemantics(), ignoreId: true, ignoreTransform: true, ignoreRect: true));

    semantics.dispose();
  });

  testWidgets('Semantics - labelType=[all]', (WidgetTester tester) async {
    final SemanticsTester semantics = SemanticsTester(tester);

    await _pumpLocalizedTestRail(tester, labelType: NavigationRailLabelType.all);

    expect(semantics, hasSemantics(_expectedSemantics(), ignoreId: true, ignoreTransform: true, ignoreRect: true));

    semantics.dispose();
  });

  testWidgets('Semantics - extended', (WidgetTester tester) async {
    final SemanticsTester semantics = SemanticsTester(tester);

    await _pumpLocalizedTestRail(tester, extended: true);

    expect(semantics, hasSemantics(_expectedSemantics(), ignoreId: true, ignoreTransform: true, ignoreRect: true));

    semantics.dispose();
  });
}

TestSemantics _expectedSemantics() {
  return TestSemantics.root(
    children: <TestSemantics>[
      TestSemantics(
        textDirection: TextDirection.ltr,
        children: <TestSemantics>[
          TestSemantics(
            flags: <SemanticsFlag>[SemanticsFlag.scopesRoute],
            children: <TestSemantics>[
              TestSemantics(
                flags: <SemanticsFlag>[
                  SemanticsFlag.isSelected,
                  SemanticsFlag.isFocusable,
                ],
                actions: <SemanticsAction>[SemanticsAction.tap],
                label: 'Abc\nTab 1 of 5',
                textDirection: TextDirection.ltr,
              ),
              TestSemantics(
                flags: <SemanticsFlag>[SemanticsFlag.isFocusable],
                actions: <SemanticsAction>[SemanticsAction.tap],
                label: 'Def\nTab 2 of 5',
                textDirection: TextDirection.ltr,
              ),
              TestSemantics(
                flags: <SemanticsFlag>[SemanticsFlag.isFocusable],
                actions: <SemanticsAction>[SemanticsAction.tap],
                label: 'Ghi\nTab 3 of 5',
                textDirection: TextDirection.ltr,
              ),
              TestSemantics(
                flags: <SemanticsFlag>[SemanticsFlag.isFocusable],
                actions: <SemanticsAction>[SemanticsAction.tap],
                label: 'Jkl\nTab 4 of 5',
                textDirection: TextDirection.ltr,
              ),
              TestSemantics(
                flags: <SemanticsFlag>[SemanticsFlag.isFocusable],
                actions: <SemanticsAction>[SemanticsAction.tap],
                label: 'Mno\nTab 5 of 5',
                textDirection: TextDirection.ltr,
              ),
              TestSemantics(
                label: 'body',
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

List<NavigationRailDestination> _destinations() {
  return const <NavigationRailDestination>[
    NavigationRailDestination(
      icon: Icon(Icons.favorite_border),
      activeIcon: Icon(Icons.favorite),
      label: Text('Abc'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.bookmark_border),
      activeIcon: Icon(Icons.bookmark),
      label: Text('Def'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.star_border),
      activeIcon: Icon(Icons.star),
      label: Text('Ghi'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.hotel),
      activeIcon: Icon(Icons.home),
      label: Text('Jkl'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.remove_circle),
      activeIcon: Icon(Icons.add_circle),
      label: Text('Mno'),
    ),
  ];
}

Future<void> _pumpNavigationRail(
  WidgetTester tester, {
  double textScaleFactor = 1.0,
  NavigationRail navigationRail,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (BuildContext context) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: textScaleFactor),
            child: Scaffold(
              body: Row(
                children: <Widget>[
                  navigationRail,
                  const Expanded(
                    child: Text('body'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ),
  );
}

Future<void> _pumpLocalizedTestRail(WidgetTester tester, { NavigationRailLabelType labelType, bool extended = false }) async {
  await tester.pumpWidget(
    Localizations(
      locale: const Locale('en', 'US'),
      delegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      child: MaterialApp(
        home: Scaffold(
          body: Row(
            children: <Widget>[
              NavigationRail(
                extended: extended,
                destinations: _destinations(),
                labelType: labelType,
              ),
              const Expanded(
                child: Text('body'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

RenderBox _iconRenderBox(WidgetTester tester, IconData iconData) {
  return tester.firstRenderObject<RenderBox>(
    find.descendant(
      of: find.byIcon(iconData),
      matching: find.byType(RichText),
    ),
  );
}

RenderBox _labelRenderBox(WidgetTester tester, String text) {
  return tester.firstRenderObject<RenderBox>(
    find.descendant(
      of: find.text(text),
      matching: find.byType(RichText),
    ),
  );
}

TextStyle _iconStyle(WidgetTester tester, IconData icon) {
  return tester.widget<RichText>(
    find.descendant(
      of: find.byIcon(icon),
      matching: find.byType(RichText),
    ),
  ).text.style;
}

Finder _opacityAboveLabel(String text) {
  return find.ancestor(
    of: find.text(text),
    matching: find.byType(Opacity),
  );
}

// Only valid when labelType != all.
double _labelOpacity(WidgetTester tester, String text) {
  final Opacity opacityWidget = tester.firstWidget<Opacity>(
    find.ancestor(
      of: find.text(text),
      matching: find.byType(Opacity),
    ),
  );
  return opacityWidget.opacity;
}

Material _railMaterial(WidgetTester tester) {
  return tester.firstWidget<Material>(
    find.descendant(
      of: find.byType(NavigationRail),
      matching: find.byType(Material),
    ),
  );
}

// The icon size is expected to be 24x24, but may be different depending
// on the platform (e.g. web).
Offset _iconAdjustment(WidgetTester tester) {
  final Size iconSize = _iconRenderBox(tester, Icons.favorite).size;
  return Offset(24.0 - iconSize.width, 24 - iconSize.height) / 2.0;
}

// Used to calculate x offset for labels because smaller scale texts differ in
// sizes in different platforms (e.g. web).
double _verticalLabelXOffset(WidgetTester tester, String text) {
  return (72.0 - _labelRenderBox(tester, text).size.width) / 2.0;
}