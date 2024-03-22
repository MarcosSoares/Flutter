// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'rendering_tester.dart';

void main() {
  TestRenderingFlutterBinding.ensureInitialized();

  test('Overconstrained flex', () {
    final RenderDecoratedBox box = RenderDecoratedBox(decoration: const BoxDecoration());
    final RenderFlex flex = RenderFlex(textDirection: TextDirection.ltr, children: <RenderBox>[box]);
    layout(flex, constraints: const BoxConstraints(
      minWidth: 200.0,
      maxWidth: 200.0,
      minHeight: 200.0,
      maxHeight: 200.0,
    ));

    expect(flex.size.width, equals(200.0), reason: 'flex width');
    expect(flex.size.height, equals(200.0), reason: 'flex height');
  });

  test('Inconsequential overflow is ignored', () {
    // These values are meant to simulate slight rounding errors in addition
    // or subtraction in the layout code for Flex.
    const double slightlyLarger = 438.8571428571429;
    const double slightlySmaller = 438.85714285714283;
    final List<dynamic> exceptions = <dynamic>[];
    final FlutterExceptionHandler? oldHandler = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      exceptions.add(details.exception);
    };
    const BoxConstraints square = BoxConstraints.tightFor(width: slightlyLarger, height: 100.0);
    final RenderConstrainedBox box1 = RenderConstrainedBox(additionalConstraints: square);
    final RenderFlex flex = RenderFlex(
      textDirection: TextDirection.ltr,
      mainAxisSize: MainAxisSize.min,
    );
    final RenderConstrainedOverflowBox parent = RenderConstrainedOverflowBox(
      minWidth: 0.0,
      maxWidth: slightlySmaller,
      minHeight: 0.0,
      maxHeight: 400.0,
      child: flex,
    );
    flex.add(box1);
    layout(parent);
    expect(flex.size, const Size(slightlySmaller, 100.0));
    pumpFrame(phase: EnginePhase.paint);

    expect(exceptions, isEmpty);
    FlutterError.onError = oldHandler;
  });

  test('Clip behavior is respected', () {
    const BoxConstraints viewport = BoxConstraints(maxHeight: 100.0, maxWidth: 100.0);
    final TestClipPaintingContext context = TestClipPaintingContext();
    bool hadErrors = false;

    for (final Clip? clip in <Clip?>[null, ...Clip.values]) {
      final RenderFlex flex;
      switch (clip) {
        case Clip.none:
        case Clip.hardEdge:
        case Clip.antiAlias:
        case Clip.antiAliasWithSaveLayer:
          flex = RenderFlex(direction: Axis.vertical, children: <RenderBox>[box200x200], clipBehavior: clip!);
        case null:
          flex = RenderFlex(direction: Axis.vertical, children: <RenderBox>[box200x200]);
      }
      layout(flex, constraints: viewport, phase: EnginePhase.composite, onErrors: () {
        absorbOverflowedErrors();
        hadErrors = true;
      });
      context.paintChild(flex, Offset.zero);
      // By default, clipBehavior should be Clip.none
      expect(context.clipBehavior, equals(clip ?? Clip.none));
      expect(hadErrors, isTrue);
      hadErrors = false;
    }
  });

  test('Vertical Overflow', () {
    final RenderConstrainedBox flexible = RenderConstrainedBox(
      additionalConstraints: const BoxConstraints.expand(),
    );
    final RenderFlex flex = RenderFlex(
      direction: Axis.vertical,
      children: <RenderBox>[
        RenderConstrainedBox(additionalConstraints: const BoxConstraints.tightFor(height: 200.0)),
        flexible,
      ],
    );
    final FlexParentData flexParentData = flexible.parentData! as FlexParentData;
    flexParentData.flex = 1;
    const BoxConstraints viewport = BoxConstraints(maxHeight: 100.0, maxWidth: 100.0);
    layout(flex, constraints: viewport);
    expect(flexible.size.height, equals(0.0));
    expect(flex.getMinIntrinsicHeight(100.0), equals(200.0));
    expect(flex.getMaxIntrinsicHeight(100.0), equals(200.0));
    expect(flex.getMinIntrinsicWidth(100.0), equals(0.0));
    expect(flex.getMaxIntrinsicWidth(100.0), equals(0.0));
  });

  test('Horizontal Overflow', () {
    final RenderConstrainedBox flexible = RenderConstrainedBox(
      additionalConstraints: const BoxConstraints.expand(),
    );
    final RenderFlex flex = RenderFlex(
      textDirection: TextDirection.ltr,
      children: <RenderBox>[
        RenderConstrainedBox(additionalConstraints: const BoxConstraints.tightFor(width: 200.0)),
        flexible,
      ],
    );
    final FlexParentData flexParentData = flexible.parentData! as FlexParentData;
    flexParentData.flex = 1;
    const BoxConstraints viewport = BoxConstraints(maxHeight: 100.0, maxWidth: 100.0);
    layout(flex, constraints: viewport);
    expect(flexible.size.width, equals(0.0));
    expect(flex.getMinIntrinsicHeight(100.0), equals(0.0));
    expect(flex.getMaxIntrinsicHeight(100.0), equals(0.0));
    expect(flex.getMinIntrinsicWidth(100.0), equals(200.0));
    expect(flex.getMaxIntrinsicWidth(100.0), equals(200.0));
  });

  test('Vertical Flipped Constraints', () {
    final RenderFlex flex = RenderFlex(
      direction: Axis.vertical,
      children: <RenderBox>[
        RenderAspectRatio(aspectRatio: 1.0),
      ],
    );
    const BoxConstraints viewport = BoxConstraints(maxHeight: 200.0, maxWidth: 1000.0);
    layout(flex, constraints: viewport);
    expect(flex.getMaxIntrinsicWidth(200.0), equals(0.0));
  });

  // We can't write a horizontal version of the above test due to
  // RenderAspectRatio being height-in, width-out.

  test('Defaults', () {
    final RenderFlex flex = RenderFlex();
    expect(flex.crossAxisAlignment, equals(CrossAxisAlignment.center));
    expect(flex.direction, equals(Axis.horizontal));
    expect(flex, hasAGoodToStringDeep);
    expect(
      flex.toStringDeep(minLevel: DiagnosticLevel.info),
      equalsIgnoringHashCodes(
        'RenderFlex#00000 NEEDS-LAYOUT NEEDS-PAINT DETACHED\n'
        '   parentData: MISSING\n'
        '   constraints: MISSING\n'
        '   size: MISSING\n'
        '   direction: horizontal\n'
        '   mainAxisAlignment: start\n'
        '   mainAxisSize: max\n'
        '   crossAxisAlignment: center\n'
        '   verticalDirection: down\n',
      ),
    );
  });

  test('Parent data', () {
    final RenderDecoratedBox box1 = RenderDecoratedBox(decoration: const BoxDecoration());
    final RenderDecoratedBox box2 = RenderDecoratedBox(decoration: const BoxDecoration());
    final RenderFlex flex = RenderFlex(textDirection: TextDirection.ltr, children: <RenderBox>[box1, box2]);
    layout(flex, constraints: const BoxConstraints(
      maxWidth: 100.0,
      maxHeight: 100.0,
    ));
    expect(box1.size.width, equals(0.0));
    expect(box1.size.height, equals(0.0));
    expect(box2.size.width, equals(0.0));
    expect(box2.size.height, equals(0.0));

    final FlexParentData box2ParentData = box2.parentData! as FlexParentData;
    box2ParentData.flex = 1;
    flex.markNeedsLayout();
    pumpFrame();
    expect(box1.size.width, equals(0.0));
    expect(box1.size.height, equals(0.0));
    expect(box2.size.width, equals(100.0));
    expect(box2.size.height, equals(0.0));
  });

  test('Stretch', () {
    final RenderDecoratedBox box1 = RenderDecoratedBox(decoration: const BoxDecoration());
    final RenderDecoratedBox box2 = RenderDecoratedBox(decoration: const BoxDecoration());
    final RenderFlex flex = RenderFlex(textDirection: TextDirection.ltr);
    flex.setupParentData(box2);
    final FlexParentData box2ParentData = box2.parentData! as FlexParentData;
    box2ParentData.flex = 2;
    flex.addAll(<RenderBox>[box1, box2]);
    layout(flex, constraints: const BoxConstraints(
      maxWidth: 100.0,
      maxHeight: 100.0,
    ));
    expect(box1.size.width, equals(0.0));
    expect(box1.size.height, equals(0.0));
    expect(box2.size.width, equals(100.0));
    expect(box2.size.height, equals(0.0));

    flex.crossAxisAlignment = CrossAxisAlignment.stretch;
    pumpFrame();
    expect(box1.size.width, equals(0.0));
    expect(box1.size.height, equals(100.0));
    expect(box2.size.width, equals(100.0));
    expect(box2.size.height, equals(100.0));

    flex.direction = Axis.vertical;
    pumpFrame();
    expect(box1.size.width, equals(100.0));
    expect(box1.size.height, equals(0.0));
    expect(box2.size.width, equals(100.0));
    expect(box2.size.height, equals(100.0));
  });

  test('Space evenly', () {
    final RenderConstrainedBox box1 = RenderConstrainedBox(additionalConstraints: const BoxConstraints.tightFor(width: 100.0, height: 100.0));
    final RenderConstrainedBox box2 = RenderConstrainedBox(additionalConstraints: const BoxConstraints.tightFor(width: 100.0, height: 100.0));
    final RenderConstrainedBox box3 = RenderConstrainedBox(additionalConstraints: const BoxConstraints.tightFor(width: 100.0, height: 100.0));
    final RenderFlex flex = RenderFlex(textDirection: TextDirection.ltr, mainAxisAlignment: MainAxisAlignment.spaceEvenly);
    flex.addAll(<RenderBox>[box1, box2, box3]);
    layout(flex, constraints: const BoxConstraints(
      maxWidth: 500.0,
      maxHeight: 400.0,
    ));
    Offset getOffset(RenderBox box) {
      final FlexParentData parentData = box.parentData! as FlexParentData;
      return parentData.offset;
    }
    expect(getOffset(box1).dx, equals(50.0));
    expect(box1.size.width, equals(100.0));
    expect(getOffset(box2).dx, equals(200.0));
    expect(box2.size.width, equals(100.0));
    expect(getOffset(box3).dx, equals(350.0));
    expect(box3.size.width, equals(100.0));

    flex.direction = Axis.vertical;
    pumpFrame();
    expect(getOffset(box1).dy, equals(25.0));
    expect(box1.size.height, equals(100.0));
    expect(getOffset(box2).dy, equals(150.0));
    expect(box2.size.height, equals(100.0));
    expect(getOffset(box3).dy, equals(275.0));
    expect(box3.size.height, equals(100.0));
  });

  test('Fit.loose', () {
    final RenderConstrainedBox box1 = RenderConstrainedBox(additionalConstraints: const BoxConstraints.tightFor(width: 100.0, height: 100.0));
    final RenderConstrainedBox box2 = RenderConstrainedBox(additionalConstraints: const BoxConstraints.tightFor(width: 100.0, height: 100.0));
    final RenderConstrainedBox box3 = RenderConstrainedBox(additionalConstraints: const BoxConstraints.tightFor(width: 100.0, height: 100.0));
    final RenderFlex flex = RenderFlex(textDirection: TextDirection.ltr, mainAxisAlignment: MainAxisAlignment.spaceBetween);
    flex.addAll(<RenderBox>[box1, box2, box3]);
    layout(flex, constraints: const BoxConstraints(
      maxWidth: 500.0,
      maxHeight: 400.0,
    ));
    Offset getOffset(RenderBox box) {
      final FlexParentData parentData = box.parentData! as FlexParentData;
      return parentData.offset;
    }
    expect(getOffset(box1).dx, equals(0.0));
    expect(box1.size.width, equals(100.0));
    expect(getOffset(box2).dx, equals(200.0));
    expect(box2.size.width, equals(100.0));
    expect(getOffset(box3).dx, equals(400.0));
    expect(box3.size.width, equals(100.0));

    void setFit(RenderBox box, FlexFit fit) {
      final FlexParentData parentData = box.parentData! as FlexParentData;
      parentData.flex = 1;
      parentData.fit = fit;
    }

    setFit(box1, FlexFit.loose);
    flex.markNeedsLayout();

    pumpFrame();
    expect(getOffset(box1).dx, equals(0.0));
    expect(box1.size.width, equals(100.0));
    expect(getOffset(box2).dx, equals(200.0));
    expect(box2.size.width, equals(100.0));
    expect(getOffset(box3).dx, equals(400.0));
    expect(box3.size.width, equals(100.0));

    box1.additionalConstraints = const BoxConstraints.tightFor(width: 1000.0, height: 100.0);

    pumpFrame();
    expect(getOffset(box1).dx, equals(0.0));
    expect(box1.size.width, equals(300.0));
    expect(getOffset(box2).dx, equals(300.0));
    expect(box2.size.width, equals(100.0));
    expect(getOffset(box3).dx, equals(400.0));
    expect(box3.size.width, equals(100.0));
  });

  test('Flexible with MainAxisSize.min', () {
    final RenderConstrainedBox box1 = RenderConstrainedBox(additionalConstraints: const BoxConstraints.tightFor(width: 100.0, height: 100.0));
    final RenderConstrainedBox box2 = RenderConstrainedBox(additionalConstraints: const BoxConstraints.tightFor(width: 100.0, height: 100.0));
    final RenderConstrainedBox box3 = RenderConstrainedBox(additionalConstraints: const BoxConstraints.tightFor(width: 100.0, height: 100.0));
    final RenderFlex flex = RenderFlex(
      textDirection: TextDirection.ltr,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    );
    flex.addAll(<RenderBox>[box1, box2, box3]);
    layout(flex, constraints: const BoxConstraints(
      maxWidth: 500.0,
      maxHeight: 400.0,
    ));
    Offset getOffset(RenderBox box) {
      final FlexParentData parentData = box.parentData! as FlexParentData;
      return parentData.offset;
    }
    expect(getOffset(box1).dx, equals(0.0));
    expect(box1.size.width, equals(100.0));
    expect(getOffset(box2).dx, equals(100.0));
    expect(box2.size.width, equals(100.0));
    expect(getOffset(box3).dx, equals(200.0));
    expect(box3.size.width, equals(100.0));
    expect(flex.size.width, equals(300.0));

    void setFit(RenderBox box, FlexFit fit) {
      final FlexParentData parentData = box.parentData! as FlexParentData;
      parentData.flex = 1;
      parentData.fit = fit;
    }

    setFit(box1, FlexFit.tight);
    flex.markNeedsLayout();

    pumpFrame();
    expect(getOffset(box1).dx, equals(0.0));
    expect(box1.size.width, equals(300.0));
    expect(getOffset(box2).dx, equals(300.0));
    expect(box2.size.width, equals(100.0));
    expect(getOffset(box3).dx, equals(400.0));
    expect(box3.size.width, equals(100.0));
    expect(flex.size.width, equals(500.0));

    setFit(box1, FlexFit.loose);
    flex.markNeedsLayout();

    pumpFrame();
    expect(getOffset(box1).dx, equals(0.0));
    expect(box1.size.width, equals(100.0));
    expect(getOffset(box2).dx, equals(100.0));
    expect(box2.size.width, equals(100.0));
    expect(getOffset(box3).dx, equals(200.0));
    expect(box3.size.width, equals(100.0));
    expect(flex.size.width, equals(300.0));
  });

  test('MainAxisSize.min inside unconstrained', () {
    FlutterError.onError = (FlutterErrorDetails details) => throw details.exception;
    const BoxConstraints square = BoxConstraints.tightFor(width: 100.0, height: 100.0);
    final RenderConstrainedBox box1 = RenderConstrainedBox(additionalConstraints: square);
    final RenderConstrainedBox box2 = RenderConstrainedBox(additionalConstraints: square);
    final RenderConstrainedBox box3 = RenderConstrainedBox(additionalConstraints: square);
    final RenderFlex flex = RenderFlex(
      textDirection: TextDirection.ltr,
      mainAxisSize: MainAxisSize.min,
    );
    final RenderConstrainedOverflowBox parent = RenderConstrainedOverflowBox(
      minWidth: 0.0,
      maxWidth: double.infinity,
      minHeight: 0.0,
      maxHeight: 400.0,
      child: flex,
    );
    flex.addAll(<RenderBox>[box1, box2, box3]);
    layout(parent);
    expect(flex.size, const Size(300.0, 100.0));
    final FlexParentData box2ParentData = box2.parentData! as FlexParentData;
    box2ParentData.flex = 1;
    box2ParentData.fit = FlexFit.loose;
    flex.markNeedsLayout();
    pumpFrame();
    expect(flex.size, const Size(300.0, 100.0));
    parent.maxWidth = 500.0; // NOW WITH CONSTRAINED BOUNDARIES
    pumpFrame();
    expect(flex.size, const Size(300.0, 100.0));
    flex.mainAxisSize = MainAxisSize.max;
    pumpFrame();
    expect(flex.size, const Size(500.0, 100.0));
    flex.mainAxisSize = MainAxisSize.min;
    box2ParentData.fit = FlexFit.tight;
    flex.markNeedsLayout();
    pumpFrame();
    expect(flex.size, const Size(500.0, 100.0));
    parent.maxWidth = 505.0;
    pumpFrame();
    expect(flex.size, const Size(505.0, 100.0));
  });

  test('MainAxisSize.min inside unconstrained', () {
    const BoxConstraints square = BoxConstraints.tightFor(width: 100.0, height: 100.0);
    final RenderConstrainedBox box1 = RenderConstrainedBox(additionalConstraints: square);
    final RenderConstrainedBox box2 = RenderConstrainedBox(additionalConstraints: square);
    final RenderConstrainedBox box3 = RenderConstrainedBox(additionalConstraints: square);
    final RenderFlex flex = RenderFlex(
      textDirection: TextDirection.ltr,
      mainAxisSize: MainAxisSize.min,
    );
    final RenderConstrainedOverflowBox parent = RenderConstrainedOverflowBox(
      minWidth: 0.0,
      maxWidth: double.infinity,
      minHeight: 0.0,
      maxHeight: 400.0,
      child: flex,
    );
    flex.addAll(<RenderBox>[box1, box2, box3]);
    final FlexParentData box2ParentData = box2.parentData! as FlexParentData;
    box2ParentData.flex = 1;
    final List<dynamic> exceptions = <dynamic>[];
    layout(parent, onErrors: () {
      exceptions.addAll(TestRenderingFlutterBinding.instance.takeAllFlutterExceptions());
    });
    expect(exceptions, isNotEmpty);
    expect(exceptions.first, isFlutterError);
  });

  test('MainAxisSize.min inside unconstrained', () {
    const BoxConstraints square = BoxConstraints.tightFor(width: 100.0, height: 100.0);
    final RenderConstrainedBox box1 = RenderConstrainedBox(additionalConstraints: square);
    final RenderConstrainedBox box2 = RenderConstrainedBox(additionalConstraints: square);
    final RenderConstrainedBox box3 = RenderConstrainedBox(additionalConstraints: square);
    final RenderFlex flex = RenderFlex(
      textDirection: TextDirection.ltr,
    );
    final RenderConstrainedOverflowBox parent = RenderConstrainedOverflowBox(
      minWidth: 0.0,
      maxWidth: double.infinity,
      minHeight: 0.0,
      maxHeight: 400.0,
      child: flex,
    );
    flex.addAll(<RenderBox>[box1, box2, box3]);
    final FlexParentData box2ParentData = box2.parentData! as FlexParentData;
    box2ParentData.flex = 1;
    box2ParentData.fit = FlexFit.loose;
    final List<dynamic> exceptions = <dynamic>[];
    layout(parent, onErrors: () {
      exceptions.addAll(TestRenderingFlutterBinding.instance.takeAllFlutterExceptions());
    });
    expect(exceptions, isNotEmpty);
    expect(exceptions.first, isFlutterError);
  });

  test('MainAxisSize.min inside tightly constrained', () {
    const BoxConstraints square = BoxConstraints.tightFor(width: 100.0, height: 100.0);
    final RenderConstrainedBox box1 = RenderConstrainedBox(additionalConstraints: square);
    final RenderConstrainedBox box2 = RenderConstrainedBox(additionalConstraints: square);
    final RenderConstrainedBox box3 = RenderConstrainedBox(additionalConstraints: square);
    final RenderFlex flex = RenderFlex(
      textDirection: TextDirection.rtl,
      mainAxisSize: MainAxisSize.min,
    );
    flex.addAll(<RenderBox>[box1, box2, box3]);
    layout(flex);
    expect(flex.constraints.hasTightWidth, isTrue);
    expect(box1.localToGlobal(Offset.zero), const Offset(700.0, 250.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(600.0, 250.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(500.0, 250.0));
    expect(box1.size, const Size(100.0, 100.0));
    expect(box2.size, const Size(100.0, 100.0));
    expect(box3.size, const Size(100.0, 100.0));
  });

  test('Flex RTL', () {
    const BoxConstraints square = BoxConstraints.tightFor(width: 100.0, height: 100.0);
    final RenderConstrainedBox box1 = RenderConstrainedBox(additionalConstraints: square);
    final RenderConstrainedBox box2 = RenderConstrainedBox(additionalConstraints: square);
    final RenderConstrainedBox box3 = RenderConstrainedBox(additionalConstraints: square);
    final RenderFlex flex = RenderFlex(textDirection: TextDirection.ltr, children: <RenderBox>[box1, box2, box3]);
    layout(flex);
    expect(box1.localToGlobal(Offset.zero), const Offset(0.0, 250.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(100.0, 250.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(200.0, 250.0));
    expect(box1.size, const Size(100.0, 100.0));
    expect(box2.size, const Size(100.0, 100.0));
    expect(box3.size, const Size(100.0, 100.0));

    flex.mainAxisAlignment = MainAxisAlignment.end;
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero), const Offset(500.0, 250.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(600.0, 250.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(700.0, 250.0));
    expect(box1.size, const Size(100.0, 100.0));
    expect(box2.size, const Size(100.0, 100.0));
    expect(box3.size, const Size(100.0, 100.0));

    flex.textDirection = TextDirection.rtl;
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero), const Offset(200.0, 250.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(100.0, 250.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(0.0, 250.0));
    expect(box1.size, const Size(100.0, 100.0));
    expect(box2.size, const Size(100.0, 100.0));
    expect(box3.size, const Size(100.0, 100.0));

    flex.mainAxisAlignment = MainAxisAlignment.start;
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero), const Offset(700.0, 250.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(600.0, 250.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(500.0, 250.0));
    expect(box1.size, const Size(100.0, 100.0));
    expect(box2.size, const Size(100.0, 100.0));
    expect(box3.size, const Size(100.0, 100.0));

    flex.crossAxisAlignment = CrossAxisAlignment.start; // vertical direction is down
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero), const Offset(700.0, 0.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(600.0, 0.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(500.0, 0.0));
    expect(box1.size, const Size(100.0, 100.0));
    expect(box2.size, const Size(100.0, 100.0));
    expect(box3.size, const Size(100.0, 100.0));

    flex.crossAxisAlignment = CrossAxisAlignment.end;
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero), const Offset(700.0, 500.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(600.0, 500.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(500.0, 500.0));
    expect(box1.size, const Size(100.0, 100.0));
    expect(box2.size, const Size(100.0, 100.0));
    expect(box3.size, const Size(100.0, 100.0));

    flex.verticalDirection = VerticalDirection.up;
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero), const Offset(700.0, 0.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(600.0, 0.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(500.0, 0.0));
    expect(box1.size, const Size(100.0, 100.0));
    expect(box2.size, const Size(100.0, 100.0));
    expect(box3.size, const Size(100.0, 100.0));

    flex.crossAxisAlignment = CrossAxisAlignment.start;
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero), const Offset(700.0, 500.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(600.0, 500.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(500.0, 500.0));
    expect(box1.size, const Size(100.0, 100.0));
    expect(box2.size, const Size(100.0, 100.0));
    expect(box3.size, const Size(100.0, 100.0));

    flex.direction = Axis.vertical; // and main=start, cross=start, up, rtl
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero), const Offset(700.0, 500.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(700.0, 400.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(700.0, 300.0));
    expect(box1.size, const Size(100.0, 100.0));
    expect(box2.size, const Size(100.0, 100.0));
    expect(box3.size, const Size(100.0, 100.0));

    flex.crossAxisAlignment = CrossAxisAlignment.end;
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero), const Offset(0.0, 500.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(0.0, 400.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(0.0, 300.0));
    expect(box1.size, const Size(100.0, 100.0));
    expect(box2.size, const Size(100.0, 100.0));
    expect(box3.size, const Size(100.0, 100.0));

    flex.crossAxisAlignment = CrossAxisAlignment.stretch;
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero), const Offset(0.0, 500.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(0.0, 400.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(0.0, 300.0));
    expect(box1.size, const Size(800.0, 100.0));
    expect(box2.size, const Size(800.0, 100.0));
    expect(box3.size, const Size(800.0, 100.0));

    flex.textDirection = TextDirection.ltr;
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero), const Offset(0.0, 500.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(0.0, 400.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(0.0, 300.0));
    expect(box1.size, const Size(800.0, 100.0));
    expect(box2.size, const Size(800.0, 100.0));
    expect(box3.size, const Size(800.0, 100.0));

    flex.crossAxisAlignment = CrossAxisAlignment.start;
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero), const Offset(0.0, 500.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(0.0, 400.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(0.0, 300.0));
    expect(box1.size, const Size(100.0, 100.0));
    expect(box2.size, const Size(100.0, 100.0));
    expect(box3.size, const Size(100.0, 100.0));

    flex.crossAxisAlignment = CrossAxisAlignment.end;
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero), const Offset(700.0, 500.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(700.0, 400.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(700.0, 300.0));
    expect(box1.size, const Size(100.0, 100.0));
    expect(box2.size, const Size(100.0, 100.0));
    expect(box3.size, const Size(100.0, 100.0));

    flex.verticalDirection = VerticalDirection.down;
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero), const Offset(700.0, 0.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(700.0, 100.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(700.0, 200.0));
    expect(box1.size, const Size(100.0, 100.0));
    expect(box2.size, const Size(100.0, 100.0));
    expect(box3.size, const Size(100.0, 100.0));

    flex.mainAxisAlignment = MainAxisAlignment.end;
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero), const Offset(700.0, 300.0));
    expect(box2.localToGlobal(Offset.zero), const Offset(700.0, 400.0));
    expect(box3.localToGlobal(Offset.zero), const Offset(700.0, 500.0));
    expect(box1.size, const Size(100.0, 100.0));
    expect(box2.size, const Size(100.0, 100.0));
    expect(box3.size, const Size(100.0, 100.0));
  });

  test('Vertical Flex Baseline', () {
    const BoxConstraints square = BoxConstraints.tightFor(width: 100.0, height: 100.0);
    final RenderConstrainedBox box1 = RenderConstrainedBox(additionalConstraints: square, child: RenderBaseline(baseline: 10, baselineType: TextBaseline.alphabetic, child: RenderBaseline(baseline: 10, baselineType: TextBaseline.alphabetic)));
    final RenderConstrainedBox box2 = RenderConstrainedBox(additionalConstraints: square, child: RenderBaseline(baseline: 10, baselineType: TextBaseline.alphabetic, child: RenderBaseline(baseline: 10, baselineType: TextBaseline.alphabetic)));
    final RenderFlex flex = RenderFlex(
      textDirection: TextDirection.ltr,
      children: <RenderBox>[box1, box2],
      direction: Axis.vertical,
    );
    layout(flex);

    // We can't call the getDistanceToBaseline method directly. Check the dry
    // baesline instead because in debug mode there are asserts that verify
    // the two methods return the same results.
    expect(flex.getDryBaseline(flex.constraints, TextBaseline.alphabetic), 10);

    flex.mainAxisAlignment = MainAxisAlignment.end;
    pumpFrame();
    expect(flex.getDryBaseline(flex.constraints, TextBaseline.alphabetic), 410);

    flex.verticalDirection = VerticalDirection.up;
    pumpFrame();
    expect(flex.getDryBaseline(flex.constraints, TextBaseline.alphabetic), 10);

    flex.mainAxisAlignment = MainAxisAlignment.start;
    pumpFrame();
    expect(flex.getDryBaseline(flex.constraints, TextBaseline.alphabetic), 410);
  });

  test('children with no baselines are top-aligned', () {
    const BoxConstraints square = BoxConstraints.tightFor(width: 100.0, height: 100.0);
    final RenderConstrainedBox box1 = RenderConstrainedBox(additionalConstraints: square);
    final RenderConstrainedBox box2 = RenderConstrainedBox(additionalConstraints: square);
    final RenderFlex flex = RenderFlex(
      textDirection: TextDirection.ltr,
      children: <RenderBox>[box1, box2],
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      verticalDirection: VerticalDirection.up,
    );
    layout(flex);

    // Not start-aligned.
    expect(box1.localToGlobal(Offset.zero).dy, 0.0);
    expect(box2.localToGlobal(Offset.zero).dy, 0.0);

    flex.verticalDirection = VerticalDirection.down;
    pumpFrame();
    expect(box1.localToGlobal(Offset.zero).dy, 0.0);
    expect(box2.localToGlobal(Offset.zero).dy, 0.0);
  });

  group('Intrinsics', () {
    test('main axis intrinsics with RenderAspectRatio 1', () {
      const BoxConstraints square = BoxConstraints.tightFor(width: 100.0, height: 100.0);
      final RenderConstrainedBox box1 = RenderConstrainedBox(additionalConstraints: square);
      final RenderConstrainedBox box2 = RenderConstrainedBox(additionalConstraints: square);
      final RenderAspectRatio box3 = RenderAspectRatio(aspectRatio: 1.0, child: RenderConstrainedBox(additionalConstraints: square));
      final RenderFlex flex = RenderFlex(
        textDirection: TextDirection.ltr,
      );
      flex.addAll(<RenderBox>[box1, box2, box3]);
      final FlexParentData box2ParentData = box2.parentData! as FlexParentData;
      box2ParentData.flex = 1;
      box2ParentData.fit = FlexFit.tight; // In intrinsics FlexFit.tight should have no effect.

      expect(flex.getMinIntrinsicWidth(double.infinity), 300.0);
      expect(flex.getMaxIntrinsicWidth(double.infinity), 300.0);

      expect(flex.getMinIntrinsicWidth(300.0), 200.0 + 300.0);
      expect(flex.getMaxIntrinsicWidth(300.0), 200.0 + 300.0);

      expect(flex.getMinIntrinsicWidth(500.0), 200.0 + 500.0);
      expect(flex.getMaxIntrinsicWidth(500.0), 200.0 + 500.0);
    });

    test('main axis intrinsics with RenderAspectRatio 2', () {
      const BoxConstraints square = BoxConstraints.tightFor(width: 100.0, height: 100.0);
      final RenderConstrainedBox box1 = RenderConstrainedBox(additionalConstraints: square);
      final RenderAspectRatio box2 = RenderAspectRatio(aspectRatio: 1.0, child: RenderConstrainedBox(additionalConstraints: square));
      final RenderAspectRatio box3 = RenderAspectRatio(aspectRatio: 1.0, child: RenderConstrainedBox(additionalConstraints: square));
      final RenderFlex flex = RenderFlex(
        textDirection: TextDirection.ltr,
      );
      flex.addAll(<RenderBox>[box1, box2, box3]);
      final FlexParentData box2ParentData = box2.parentData! as FlexParentData;
      box2ParentData.flex = 1;
      box2ParentData.fit = FlexFit.tight;
      final FlexParentData box3ParentData = box3.parentData! as FlexParentData;
      box3ParentData.flex = 2;
      box3ParentData.fit = FlexFit.tight;

      expect(flex.getMinIntrinsicWidth(double.infinity), 300.0);
      expect(flex.getMaxIntrinsicWidth(double.infinity), 300.0);

      expect(flex.getMinIntrinsicWidth(300.0), 100.0 + 300.0 * 2);
      expect(flex.getMaxIntrinsicWidth(300.0), 100.0 + 300.0 * 2);

      expect(flex.getMinIntrinsicWidth(500.0), 100.0 + 500.0 * 2);
      expect(flex.getMaxIntrinsicWidth(500.0), 100.0 + 500.0 * 2);
    });

    test('cross axis intrinsics, with ascending flex flow layout', () {
      const BoxConstraints square = BoxConstraints.tightFor(width: 5.0, height: 5.0);
      // 3 'A's separated by zero-width spaces. Max instrinsic width = 30, min intrinsic width = 10
      final TextSpan textSpan = TextSpan(text: List<String>.filled(3, 'A').join('\u200B') , style: const TextStyle(fontSize: 10));
      final RenderConstrainedBox box1 = RenderConstrainedBox(additionalConstraints: square);
      final RenderParagraph box2 = RenderParagraph(textSpan, textDirection: TextDirection.ltr);
      final RenderParagraph box3 = RenderParagraph(textSpan, textDirection: TextDirection.ltr);
      final RenderFlex flex = RenderFlex(textDirection: TextDirection.ltr);

      flex.addAll(<RenderBox>[box1, box2, box3]);
      final FlexParentData box2ParentData = box2.parentData! as FlexParentData;
      box2ParentData.flex = 1;
      box2ParentData.fit = FlexFit.tight; // In intrinsics FlexFit.tight should have no effect.
      final FlexParentData box3ParentData = box3.parentData! as FlexParentData;
      box3ParentData.flex = 2;
      box3ParentData.fit = FlexFit.tight; // In intrinsics FlexFit.tight should have no effect.

      expect(flex.getMinIntrinsicHeight(double.infinity), 10.0);
      expect(flex.getMaxIntrinsicHeight(double.infinity), 10.0);

      // 95.0 is the max intrinsic width of the RenderFlex.
      // width distribution = 5, 30, 60.
      expect(flex.getMinIntrinsicHeight(95.0), 10.0);
      expect(flex.getMaxIntrinsicHeight(95.0), 10.0);

      expect(flex.getMinIntrinsicHeight(94.0), 20.0);
      expect(flex.getMaxIntrinsicHeight(94.0), 20.0);

      // width distribution = 5, 20, 40
      expect(flex.getMinIntrinsicHeight(65.0), 20.0);
      expect(flex.getMaxIntrinsicHeight(65.0), 20.0);

      // width distribution = 5, 10, 20
      expect(flex.getMinIntrinsicHeight(35.0), 30.0);
      expect(flex.getMaxIntrinsicHeight(35.0), 30.0);
    });

    test('cross axis intrinsics, with descending flex flow layout', () {
      const BoxConstraints square = BoxConstraints.tightFor(width: 5.0, height: 5.0);
      // 3 'A's separated by zero-width spaces. Max instrinsic width = 30, min intrinsic width = 10
      final TextSpan textSpan = TextSpan(text: List<String>.filled(3, 'A').join('\u200B') , style: const TextStyle(fontSize: 10));
      final RenderConstrainedBox box1 = RenderConstrainedBox(additionalConstraints: square);
      final RenderParagraph box2 = RenderParagraph(textSpan, textDirection: TextDirection.ltr);
      final RenderParagraph box3 = RenderParagraph(textSpan, textDirection: TextDirection.ltr);
      final RenderFlex flex = RenderFlex(textDirection: TextDirection.ltr);

      flex.addAll(<RenderBox>[box1, box2, box3]);
      final FlexParentData box2ParentData = box2.parentData! as FlexParentData;
      box2ParentData.flex = 2;
      box2ParentData.fit = FlexFit.tight; // In intrinsics FlexFit.tight should have no effect.
      final FlexParentData box3ParentData = box3.parentData! as FlexParentData;
      box3ParentData.flex = 1;
      box3ParentData.fit = FlexFit.tight; // In intrinsics FlexFit.tight should have no effect.

      // The setup is exactly the same as the previous test, but the flex factors
      // are swapped.
      expect(flex.getMinIntrinsicHeight(double.infinity), 10.0);
      expect(flex.getMaxIntrinsicHeight(double.infinity), 10.0);

      // 65.0 is the max intrinsic width of the RenderFlex.
      // width distribution = 5, 30, 30.
      expect(flex.getMinIntrinsicHeight(65.0), 10.0);
      expect(flex.getMaxIntrinsicHeight(65.0), 10.0);

      expect(flex.getMinIntrinsicHeight(64.0), 20.0);
      expect(flex.getMaxIntrinsicHeight(64.0), 20.0);

      // width distribution = 5, 20, 10
      expect(flex.getMinIntrinsicHeight(35.0), 30.0);
      expect(flex.getMaxIntrinsicHeight(35.0), 30.0);
    });

    test('baseline aligned non-flex flow layout intrinsics', () {
      // box1 has its baseline placed at the top of the box.
      final RenderFlowBaselineTestBox box1 = RenderFlowBaselineTestBox()
        ..baselinePlacer = ((double height) => 0.0)
        ..gridCount = 10;

      // box2 has its baseline placed at the bottom of the box.
      final RenderFlowBaselineTestBox box2 = RenderFlowBaselineTestBox()
        ..baselinePlacer = ((double height) => height)
        ..gridCount = 10;

      final RenderFlex flex = RenderFlex(
        textDirection: TextDirection.ltr,
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: <RenderBox>[box1, box2],
      );

      expect(flex.getMinIntrinsicHeight(double.infinity), 10.0 + 10.0);
      expect(flex.getMaxIntrinsicHeight(double.infinity), 10.0 + 10.0);
      expect(flex.getMinIntrinsicWidth(double.infinity), 20.0);
      expect(flex.getMaxIntrinsicWidth(double.infinity), 200.0);

      expect(flex.getMinIntrinsicHeight(20), 20.0);
      expect(flex.getMaxIntrinsicHeight(20), 20.0);
      expect(flex.getMinIntrinsicWidth(100), 20.0);
      expect(flex.getMaxIntrinsicWidth(100), 200.0);

      expect(flex.getMinIntrinsicHeight(5), 20.0);
      expect(flex.getMaxIntrinsicHeight(5), 20.0);
      expect(flex.getMinIntrinsicWidth(5), 20.0);
      expect(flex.getMaxIntrinsicWidth(5), 200.0);
    });

    test('baseline aligned flex flow layout intrinsics', () {
      // box1 has its baseline placed at the top of the box.
      final RenderFlowBaselineTestBox box1 = RenderFlowBaselineTestBox()
        ..baselinePlacer = ((double height) => 0.0)
        ..gridCount = 10;

      // box2 has its baseline placed at the bottom of the box.
      final RenderFlowBaselineTestBox box2 = RenderFlowBaselineTestBox()
        ..baselinePlacer = ((double height) => height)
        ..gridCount = 10;

      final RenderFlex flex = RenderFlex(
        textDirection: TextDirection.ltr,
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: <RenderBox>[box1, box2],
      );
      final FlexParentData box1ParentData = box1.parentData! as FlexParentData;
      box1ParentData.flex = 2;
      box1ParentData.fit = FlexFit.tight; // In intrinsics FlexFit.tight should have no effect.
      final FlexParentData box2ParentData = box2.parentData! as FlexParentData;
      box2ParentData.flex = 1;

      expect(flex.getMinIntrinsicHeight(double.infinity), 10.0 + 10.0);
      expect(flex.getMaxIntrinsicHeight(double.infinity), 10.0 + 10.0);
      expect(flex.getMinIntrinsicWidth(double.infinity), 20.0);
      expect(flex.getMaxIntrinsicWidth(double.infinity), 200.0);

      expect(flex.getMinIntrinsicHeight(20), 200.0);
      expect(flex.getMaxIntrinsicHeight(20), 200.0);
      expect(flex.getMinIntrinsicWidth(100), 20.0);
      expect(flex.getMaxIntrinsicWidth(100), 200.0);

      expect(flex.getMinIntrinsicHeight(5), 200.0);
      expect(flex.getMaxIntrinsicHeight(5), 200.0);
      expect(flex.getMinIntrinsicWidth(5), 20.0);
      expect(flex.getMaxIntrinsicWidth(5), 200.0);
    });

    test('baseline aligned flex flow computeDryLayout', () {
      // box1 has its baseline placed at the top of the box.
      final RenderFlowBaselineTestBox box1 = RenderFlowBaselineTestBox()
        ..baselinePlacer = ((double height) => 0.0)
        ..gridCount = 10;

      // box2 has its baseline placed at the bottom of the box.
      final RenderFlowBaselineTestBox box2 = RenderFlowBaselineTestBox()
        ..baselinePlacer = ((double height) => height)
        ..gridCount = 10;

      final RenderFlex flex = RenderFlex(
        textDirection: TextDirection.ltr,
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: <RenderBox>[box1, box2],
      );
      final FlexParentData box1ParentData = box1.parentData! as FlexParentData;
      box1ParentData.flex = 2;
      box1ParentData.fit = FlexFit.tight;
      final FlexParentData box2ParentData = box2.parentData! as FlexParentData;
      box2ParentData.flex = 1;
      box2ParentData.fit = FlexFit.loose;

      Size size = const Size(200, 100);
      // box 1 one line, box 2 two lines.
      expect(flex.getDryLayout(BoxConstraints.loose(size)), const Size(200.0, 30.0));
      expect(flex.getDryBaseline(BoxConstraints.loose(size), TextBaseline.alphabetic), 20.0);
      size = const Size(300, 100);
      // box 1 one line, box 2 one.
      expect(flex.getDryLayout(BoxConstraints.loose(size)), const Size(300.0, 20.0));
      expect(flex.getDryBaseline(BoxConstraints.loose(size), TextBaseline.alphabetic), 10.0);
    });

    test('children with no baselines do not affect the baseline location', () {
      // box1 has its baseline placed at the bottom of the box.
      final RenderFlowBaselineTestBox box1 = RenderFlowBaselineTestBox()
        ..baselinePlacer = ((double height) => height)
        ..gridCount = 10;

      // box2 has its baseline placed at the bottom of the box.
      final RenderFlowBaselineTestBox box2 = RenderFlowBaselineTestBox()
        ..baselinePlacer = ((double height) => null)
        ..gridCount = 10;

      final RenderFlex flex = RenderFlex(
        textDirection: TextDirection.ltr,
        textBaseline: TextBaseline.alphabetic,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        children: <RenderBox>[box1, box2],
      );
      final FlexParentData box1ParentData = box1.parentData! as FlexParentData;
      box1ParentData.flex = 2;
      box1ParentData.fit = FlexFit.tight;
      final FlexParentData box2ParentData = box2.parentData! as FlexParentData;
      box2ParentData.flex = 1;
      box2ParentData.fit = FlexFit.loose;

      Size size = const Size(200, 100);
      // box 1 one line, box 2 two lines.
      expect(flex.getDryLayout(BoxConstraints.loose(size)), const Size(200.0, 20.0));
      expect(flex.getDryBaseline(BoxConstraints.loose(size), TextBaseline.alphabetic), 10.0);
      size = const Size(300, 100);
      // box 1 one line, box 2 one.
      expect(flex.getDryLayout(BoxConstraints.loose(size)), const Size(300.0, 10.0));
      expect(flex.getDryBaseline(BoxConstraints.loose(size), TextBaseline.alphabetic), 10.0);
    });
  });

  test('Can call methods that check overflow even if overflow value is not set', () {
    final List<dynamic> exceptions = <dynamic>[];
    final RenderFlex flex = RenderFlex(children: const <RenderBox>[]);
    // This forces a check for _hasOverflow
    expect(flex.toStringShort(), isNot(contains('OVERFLOWING')));
    layout(flex, phase: EnginePhase.paint, onErrors: () {
      exceptions.addAll(TestRenderingFlutterBinding.instance.takeAllFlutterExceptions());
    });
    // We expect the RenderFlex to throw during performLayout() for not having
    // a text direction, thus leaving it with a null overflow value. It'll then
    // try to paint(), which also checks _hasOverflow, and it should be able to
    // do so without an ancillary error.
    expect(exceptions, hasLength(1));
    // ignore: avoid_dynamic_calls
    expect(exceptions.first.message, isNot(contains('Null check operator')));
  });
}

class RenderFlowBaselineTestBox extends RenderBox {
  static const Size gridSize = Size(10, 10);
  int gridCount = 0;

  int lineGridCount(double width) {
    final int gridsPerLine = width >= gridCount * gridSize.width
      ? gridCount
      : width ~/ gridSize.width;
    return math.max(1, gridsPerLine);
  }
  int lineCount(double width) => (gridCount / lineGridCount(width)).ceil();

  double? Function(double height) baselinePlacer = (double height) => null;

  @override
  double computeMinIntrinsicWidth(double height) => gridSize.width;
  @override
  double computeMaxIntrinsicWidth(double height) => gridSize.width * gridCount;
  @override
  double computeMinIntrinsicHeight(double width) => gridSize.height * lineCount(width);
  @override
  double computeMaxIntrinsicHeight(double width) => computeMinIntrinsicHeight(width);
  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return constraints.constrain(Size(
      gridSize.width * lineGridCount(constraints.maxWidth),
      gridSize.height * lineCount(constraints.maxWidth),
    ));
  }
  @override
  double? computeDryBaseline(covariant BoxConstraints constraints, TextBaseline baseline) => baselinePlacer(getDryLayout(constraints).height);
  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) => baselinePlacer(size.height);

  @override
  void performLayout() {
    size = computeDryLayout(constraints);
  }
}
