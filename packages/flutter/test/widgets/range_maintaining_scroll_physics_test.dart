// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';

class ExpandingBox extends StatefulWidget {
  const ExpandingBox({ Key? key, required this.collapsedSize, required this.expandedSize }) : super(key: key);

  final double collapsedSize;
  final double expandedSize;

  @override
  State<ExpandingBox> createState() => _ExpandingBoxState();
}

class _ExpandingBoxState extends State<ExpandingBox> with AutomaticKeepAliveClientMixin<ExpandingBox>{
  late double _height;

  @override
  void initState() {
    super.initState();
    _height = widget.collapsedSize;
  }

  void toggleSize() {
    setState(() {
      _height = _height == widget.collapsedSize ? widget.expandedSize : widget.collapsedSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      height: _height,
      color: Colors.green,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: TextButton(
          child: const Text('Collapse'),
          onPressed: toggleSize,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

void main() {
  testWidgets('shrink listview', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ListView.builder(
        itemBuilder: (BuildContext context, int index) => index == 0
              ? const ExpandingBox(collapsedSize: 400, expandedSize: 1200)
              : Container(height: 300, color: Colors.red),
        itemCount: 2,
      ),
    ));

    final ScrollPosition position = tester.state<ScrollableState>(find.byType(Scrollable)).position;
    expect(position.activity, isInstanceOf<IdleScrollActivity>());
    expect(position.minScrollExtent, 0.0);
    expect(position.maxScrollExtent, 100.0);
    expect(position.pixels, 0.0);
    await tester.tap(find.byType(TextButton));
    await tester.pump();

    final TestGesture drag1 = await tester.startGesture(const Offset(10.0, 500.0));
    await tester.pump();
    await drag1.moveTo(const Offset(10.0, 0.0));
    await tester.pump();
    await drag1.up();
    await tester.pump();
    expect(position.pixels, moreOrLessEquals(500.0));
    expect(position.minScrollExtent, 0.0);
    expect(position.maxScrollExtent, 900.0);

    final TestGesture drag2 = await tester.startGesture(const Offset(10.0, 500.0));
    await tester.pump();
    await drag2.moveTo(const Offset(10.0, 100.0));
    await tester.pump();
    await drag2.up();
    await tester.pump();
    expect(position.maxScrollExtent, 900.0);
    expect(position.pixels, moreOrLessEquals(900.0));

    await tester.pump();
    await tester.tap(find.byType(TextButton));
    await tester.pump();
    expect(position.minScrollExtent, 0.0);
    expect(position.maxScrollExtent, 100.0);
    expect(position.pixels, 100.0);
  });

  testWidgets('shrink listview while dragging', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: ListView.builder(
        itemBuilder: (BuildContext context, int index) => index == 0
              ? const ExpandingBox(collapsedSize: 400, expandedSize: 1200)
              : Container(height: 300, color: Colors.red),
        itemCount: 2,
      ),
    ));

    final ScrollPosition position = tester.state<ScrollableState>(find.byType(Scrollable)).position;
    expect(position.activity, isInstanceOf<IdleScrollActivity>());
    expect(position.minScrollExtent, 0.0);
    expect(position.maxScrollExtent, 100.0);
    expect(position.pixels, 0.0);
    await tester.tap(find.byType(TextButton));
    await tester.pump(); // start button animation
    await tester.pump(const Duration(seconds: 1)); // finish button animation
    expect(position.minScrollExtent, 0.0);
    expect(position.maxScrollExtent, 1800.0);
    expect(position.pixels, 0.0);

    final TestGesture drag1 = await tester.startGesture(const Offset(10.0, 500.0));
    expect(await tester.pumpAndSettle(), 1); // Nothing to animate
    await drag1.moveTo(const Offset(10.0, 0.0));
    expect(await tester.pumpAndSettle(), 1); // Nothing to animate
    await drag1.up();
    expect(await tester.pumpAndSettle(), 1); // Nothing to animate
    expect(position.pixels, moreOrLessEquals(500.0));
    expect(position.minScrollExtent, 0.0);
    expect(position.maxScrollExtent, 900.0);

    final TestGesture drag2 = await tester.startGesture(const Offset(10.0, 500.0));
    expect(await tester.pumpAndSettle(), 1); // Nothing to animate
    await drag2.moveTo(const Offset(10.0, 100.0));
    expect(await tester.pumpAndSettle(), 1); // Nothing to animate
    expect(position.maxScrollExtent, 900.0);
    expect(position.pixels, lessThanOrEqualTo(900.0));
    expect(position.activity, isInstanceOf<DragScrollActivity>());

    final _ExpandingBoxState expandingBoxState = tester.state<_ExpandingBoxState>(find.byType(ExpandingBox));
    expandingBoxState.toggleSize();
    expect(await tester.pumpAndSettle(), 1); // Nothing to animate
    expect(position.activity, isInstanceOf<DragScrollActivity>());
    expect(position.minScrollExtent, 0.0);
    expect(position.maxScrollExtent, 100.0);
    expect(position.pixels, 100.0);

    await drag2.moveTo(const Offset(10.0, 150.0));
    await drag2.up();
    expect(position.minScrollExtent, 0.0);
    expect(position.maxScrollExtent, 100.0);
    expect(position.pixels, 50.0);
    expect(await tester.pumpAndSettle(), 1); // Nothing to animate
    expect(position.minScrollExtent, 0.0);
    expect(position.maxScrollExtent, 100.0);
    expect(position.pixels, 50.0);
  });

  testWidgets('shrink listview while ballistic', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: GestureDetector(
        onTap: () { assert(false); },
        child: ListView.builder(
          physics: const RangeMaintainingScrollPhysics(parent: BouncingScrollPhysics()),
          itemBuilder: (BuildContext context, int index) => index == 0
                ? const ExpandingBox(collapsedSize: 400, expandedSize: 1200)
                : Container(height: 300, color: Colors.red),
          itemCount: 2,
        ),
      ),
    ));

    final _ExpandingBoxState expandingBoxState = tester.state<_ExpandingBoxState>(find.byType(ExpandingBox));
    expandingBoxState.toggleSize();

    final ScrollPosition position = tester.state<ScrollableState>(find.byType(Scrollable)).position;
    expect(position.activity, isInstanceOf<IdleScrollActivity>());
    expect(position.minScrollExtent, 0.0);
    expect(position.maxScrollExtent, 100.0);
    expect(position.pixels, 0.0);
    await tester.pump();
    expect(position.minScrollExtent, 0.0);
    expect(position.maxScrollExtent, 1800.0);
    expect(position.pixels, 0.0);

    final TestGesture drag1 = await tester.startGesture(const Offset(10.0, 10.0));
    await tester.pump();
    expect(position.activity, isInstanceOf<HoldScrollActivity>());
    expect(position.minScrollExtent, 0.0);
    expect(position.maxScrollExtent, 1800.0);
    expect(position.pixels, 0.0);
    await drag1.moveTo(const Offset(10.0, 50.0)); // to get past the slop and trigger the drag
    await drag1.moveTo(const Offset(10.0, 550.0));
    expect(position.pixels, -500.0);
    await tester.pump();
    expect(position.activity, isInstanceOf<DragScrollActivity>());
    expect(position.minScrollExtent, 0.0);
    expect(position.maxScrollExtent, 1800.0);
    expect(position.pixels, -500.0);
    await drag1.up();
    await tester.pump();
    expect(position.activity, isInstanceOf<BallisticScrollActivity>());
    expect(position.minScrollExtent, 0.0);
    expect(position.maxScrollExtent, 1800.0);
    expect(position.pixels, -500.0);

    expandingBoxState.toggleSize();
    await tester.pump(); // apply physics without moving clock forward
    expect(position.activity, isInstanceOf<BallisticScrollActivity>());
    // TODO(ianh): Determine why the maxScrollOffset is 200.0 here instead of 100.0 or double.infinity.
    // expect(position.minScrollExtent, 0.0);
    // expect(position.maxScrollExtent, 100.0);
    expect(position.pixels, -500.0);

    await tester.pumpAndSettle(); // ignoring the exact effects of the animation
    expect(position.activity, isInstanceOf<IdleScrollActivity>());
    expect(position.minScrollExtent, 0.0);
    expect(position.maxScrollExtent, 100.0);
    expect(position.pixels, 0.0);
  });

  testWidgets('expanding page views', (WidgetTester tester) async {
    await tester.pumpWidget(const Padding(padding: EdgeInsets.only(right: 200.0), child: TabBarDemo()));
    await tester.tap(find.text('bike'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    final Rect bike1 = tester.getRect(find.byIcon(Icons.directions_bike));
    await tester.pumpWidget(const Padding(padding: EdgeInsets.zero, child: TabBarDemo()));
    final Rect bike2 = tester.getRect(find.byIcon(Icons.directions_bike));
    expect(bike2.center, bike1.shift(const Offset(100.0, 0.0)).center);
  });

  testWidgets('Changing the size of the viewport while you are overdragged', (WidgetTester tester) async {
    Widget build(double height) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: ScrollConfiguration(
          behavior: const RangeMaintainingTestScrollBehavior(),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: height,
              width: 100.0,
              child: ListView(
                children: const <Widget>[SizedBox(height: 100.0, child: Placeholder())],
              ),
            ),
          ),
        ),
      );
    }
    await tester.pumpWidget(build(200.0));
    // to verify that changing the size of the viewport while you are overdragged does not change the
    // scroll position, we must ensure that:
    // - velocity is zero
    // - scroll extents have changed
    // - position does not change at the same time
    // - old position is out of old range AND new range
    await tester.drag(find.byType(Placeholder), const Offset(0.0, 100.0), touchSlopY: 0.0, warnIfMissed: false); // it'll hit the scrollable
    await tester.pump();
    final Rect oldPosition = tester.getRect(find.byType(Placeholder));
    await tester.pumpWidget(build(220.0));
    final Rect newPosition = tester.getRect(find.byType(Placeholder));
    expect(oldPosition, newPosition);
  });
}

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: <Widget>[
                Tab(text: 'car'),
                Tab(text: 'transit'),
                Tab(text: 'bike'),
              ],
            ),
            title: const Text('Tabs Demo'),
          ),
          body: const TabBarView(
            children: <Widget>[
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}

class RangeMaintainingTestScrollBehavior extends ScrollBehavior {
  const RangeMaintainingTestScrollBehavior();

  @override
  TargetPlatform getPlatform(BuildContext context) => throw 'should not be called';

  @override
  Widget buildViewportDecoration(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }

  @override
  GestureVelocityTrackerBuilder velocityTrackerBuilder(BuildContext context) {
    return (PointerEvent event) => VelocityTracker.withKind(event.kind);
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: RangeMaintainingScrollPhysics());
  }
}
