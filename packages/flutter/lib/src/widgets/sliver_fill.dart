// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart = 2.8

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'basic.dart';
import 'framework.dart';
import 'sliver.dart';

/// A sliver that contains multiple box children that each fills the viewport.
///
/// [SliverFillViewport] places its children in a linear array along the main
/// axis. Each child is sized to fill the viewport, both in the main and cross
/// axis.
///
/// See also:
///
///  * [SliverFixedExtentList], which has a configurable
///    [SliverFixedExtentList.itemExtent].
///  * [SliverPrototypeExtentList], which is similar to [SliverFixedExtentList]
///    except that it uses a prototype list item instead of a pixel value to define
///    the main axis extent of each item.
///  * [SliverList], which does not require its children to have the same
///    extent in the main axis.
class SliverFillViewport extends StatelessWidget {
  /// Creates a sliver whose box children that each fill the viewport.
  const SliverFillViewport({
    Key key,
    @required this.delegate,
    this.viewportFraction = 1.0,
    this.padEnds = true,
  }) : assert(viewportFraction != null),
       assert(viewportFraction > 0.0),
       assert(padEnds != null),
       super(key: key);

  /// The fraction of the viewport that each child should fill in the main axis.
  ///
  /// If this fraction is less than 1.0, more than one child will be visible at
  /// once. If this fraction is greater than 1.0, each child will be larger than
  /// the viewport in the main axis.
  final double viewportFraction;

  /// Whether to add padding to both ends of the list.
  ///
  /// If this is set to true and [viewportFraction] < 1.0, padding will be added
  /// such that the first and last child slivers will be in the center of
  /// the viewport when scrolled all the way to the start or end, respectively.
  /// You may want to set this to false if this [SliverFillViewport] is not the only
  /// widget along this main axis, such as in a [CustomScrollView] with multiple
  /// children.
  ///
  /// This option cannot be [null]. If [viewportFraction] >= 1.0, this option has no
  /// effect. Defaults to [true].
  final bool padEnds;

  /// {@macro flutter.widgets.sliverMultiBoxAdaptor.delegate}
  final SliverChildDelegate delegate;

  @override
  Widget build(BuildContext context) {
    return _SliverFractionalPadding(
      viewportFraction: padEnds ? (1 - viewportFraction).clamp(0, 1) / 2 : 0,
      sliver: _SliverFillViewportRenderObjectWidget(
        viewportFraction: viewportFraction,
        delegate: delegate,
      ),
    );
  }
}

class _SliverFillViewportRenderObjectWidget extends SliverMultiBoxAdaptorWidget {
  const _SliverFillViewportRenderObjectWidget({
    Key key,
    @required SliverChildDelegate delegate,
    this.viewportFraction = 1.0,
  }) : assert(viewportFraction != null),
      assert(viewportFraction > 0.0),
      super(key: key, delegate: delegate);

  final double viewportFraction;

  @override
  RenderSliverFillViewport createRenderObject(BuildContext context) {
    final SliverMultiBoxAdaptorElement element = context as SliverMultiBoxAdaptorElement;
    return RenderSliverFillViewport(childManager: element, viewportFraction: viewportFraction);
  }

  @override
  void updateRenderObject(BuildContext context, RenderSliverFillViewport renderObject) {
    renderObject.viewportFraction = viewportFraction;
  }
}

class _SliverFractionalPadding extends SingleChildRenderObjectWidget {
  const _SliverFractionalPadding({
    this.viewportFraction = 0,
    Widget sliver,
  }) : assert(viewportFraction != null),
      assert(viewportFraction >= 0),
      assert(viewportFraction <= 0.5),
      super(child: sliver);

  final double viewportFraction;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderSliverFractionalPadding(viewportFraction: viewportFraction);

  @override
  void updateRenderObject(BuildContext context, _RenderSliverFractionalPadding renderObject) {
    renderObject.viewportFraction = viewportFraction;
  }
}

class _RenderSliverFractionalPadding extends RenderSliverEdgeInsetsPadding {
  _RenderSliverFractionalPadding({
    double viewportFraction = 0,
  }) : assert(viewportFraction != null),
      assert(viewportFraction <= 0.5),
      assert(viewportFraction >= 0),
      _viewportFraction = viewportFraction;

  SliverConstraints _lastResolvedConstraints;

  double get viewportFraction => _viewportFraction;
  double _viewportFraction;
  set viewportFraction(double newValue) {
    assert(newValue != null);
    if (_viewportFraction == newValue)
      return;
    _viewportFraction = newValue;
    _markNeedsResolution();
  }

  @override
  EdgeInsets get resolvedPadding => _resolvedPadding;
  EdgeInsets _resolvedPadding;

  void _markNeedsResolution() {
    _resolvedPadding = null;
    markNeedsLayout();
  }

  void _resolve() {
    if (_resolvedPadding != null && _lastResolvedConstraints == constraints)
      return;

    assert(constraints.axis != null);
    final double paddingValue = constraints.viewportMainAxisExtent * viewportFraction;
    _lastResolvedConstraints = constraints;
    switch (constraints.axis) {
      case Axis.horizontal:
        _resolvedPadding = EdgeInsets.symmetric(horizontal: paddingValue);
        break;
      case Axis.vertical:
        _resolvedPadding = EdgeInsets.symmetric(vertical: paddingValue);
        break;
    }

    return;
  }

  @override
  void performLayout() {
    _resolve();
    super.performLayout();
  }
}

/// A sliver that contains a single box child that fills the remaining space in
/// the viewport.
///
/// [SliverFillRemaining] will size its [child] to fill the viewport in the
/// cross axis. The extent of the sliver and its child's size in the main axis
/// is computed conditionally, described in further detail below.
///
/// Typically this will be the last sliver in a viewport, since (by definition)
/// there is never any room for anything beyond this sliver.
///
/// ## Main Axis Extent
///
/// ### When [SliverFillRemaining] has a scrollable child
///
/// The [hasScrollBody] flag indicates whether the sliver's child has a
/// scrollable body. This value is never null, and defaults to true. A common
/// example of this use is a [NestedScrollView]. In this case, the sliver will
/// size its child to fill the maximum available extent. [SliverFillRemaining]
/// will not constrain the scrollable area, as it could potentially have an
/// infinite depth. This is also true for use cases such as a [ScrollView] when
/// [ScrollView.shrinkwrap] is true.
///
/// ### When [SliverFillRemaining] does not have a scrollable child
///
/// When [hasScrollBody] is set to false, the child's size is taken into account
/// when considering the extent to which it should fill the space. The extent to
/// which the preceding slivers have been scrolled is also taken into
/// account in deciding how to layout this sliver.
///
/// [SliverFillRemaining] will size its [child] to fill the viewport in the
/// main axis if that space is larger than the child's extent, and the
/// the amount of space that has been scrolled beforehand has not exceeded the
/// main axis extent of the viewport.
///
/// {@tool dartpad --template=stateless_widget_scaffold}
///
/// In this sample the [SliverFillRemaining] sizes its [child] to fill the
/// remaining extent of the viewport in both axes. The icon is centered in the
/// sliver, and would be in any computed extent for the sliver.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return CustomScrollView(
///     slivers: <Widget>[
///       SliverToBoxAdapter(
///         child: Container(
///           color: Colors.amber[300],
///           height: 150.0,
///         ),
///       ),
///       SliverFillRemaining(
///         hasScrollBody: false,
///         child: Container(
///           color: Colors.blue[100],
///           child: Icon(
///             Icons.sentiment_very_satisfied,
///             size: 75,
///             color: Colors.blue[900],
///           ),
///         ),
///       ),
///     ],
///   );
/// }
/// ```
/// {@end-tool}
///
/// [SliverFillRemaining] will defer to the size of its [child] if the
/// child's size exceeds the remaining space in the viewport.
///
/// {@tool dartpad --template=stateless_widget_scaffold}
///
/// In this sample the [SliverFillRemaining] defers to the size of its [child]
/// because the child's extent exceeds that of the remaining extent of the
/// viewport's main axis.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return CustomScrollView(
///     slivers: <Widget>[
///       SliverFixedExtentList(
///         itemExtent: 100.0,
///         delegate: SliverChildBuilderDelegate(
///           (BuildContext context, int index) {
///             return Container(
///               color: index % 2 == 0
///                 ? Colors.amber[200]
///                 : Colors.blue[200],
///             );
///           },
///           childCount: 3,
///         ),
///       ),
///       SliverFillRemaining(
///         hasScrollBody: false,
///         child: Container(
///           color: Colors.orange[300],
///           child: Padding(
///             padding: const EdgeInsets.all(50.0),
///             child: FlutterLogo(size: 100),
///           ),
///         ),
///       ),
///     ],
///   );
/// }
/// ```
/// {@end-tool}
///
/// [SliverFillRemaining] will defer to the size of its [child] if the
/// [precedingScrollExtent] exceeded the length of the viewport's main axis.
///
/// {@tool dartpad --template=stateless_widget_scaffold}
///
/// In this sample the [SliverFillRemaining] defers to the size of its [child]
/// because the [precedingScrollExtent] of the [SliverConstraints] has gone
/// beyond that of the viewport's main axis.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return CustomScrollView(
///     slivers: <Widget>[
///       SliverFixedExtentList(
///         itemExtent: 130.0,
///         delegate: SliverChildBuilderDelegate(
///           (BuildContext context, int index) {
///             return Container(
///               color: index % 2 == 0
///                 ? Colors.indigo[200]
///                 : Colors.orange[200],
///             );
///           },
///           childCount: 5,
///         ),
///       ),
///       SliverFillRemaining(
///         hasScrollBody: false,
///         child: Container(
///           child: Padding(
///             padding: const EdgeInsets.all(50.0),
///             child: Icon(
///               Icons.pan_tool,
///               size: 60,
///               color: Colors.blueGrey,
///             ),
///           ),
///         ),
///       ),
///     ],
///   );
/// }
/// ```
/// {@end-tool}
///
/// For [ScrollPhysics] that allow overscroll, such as
/// [BouncingScrollPhysics], setting the [fillOverscroll] flag to true allows
/// the size of the [child] to _stretch_, filling the overscroll area. It does
/// this regardless of the path chosen to provide the child's size.
///
/// {@animation 250 500 https://flutter.github.io/assets-for-api-docs/assets/widgets/sliver_fill_remaining_fill_overscroll.mp4}
///
/// {@tool sample --template=stateless_widget_scaffold}
///
/// In this sample the [SliverFillRemaining]'s child stretches to fill the
/// overscroll area when [fillOverscroll] is true. This sample also features a
/// button that is pinned to the bottom of the sliver, regardless of size or
/// overscroll behavior. Try switching [fillOverscroll] to see the difference.
///
/// This sample only shows the overscroll behavior on devices that support
/// overscroll.
///
/// ```dart
/// Widget build(BuildContext context) {
///   return CustomScrollView(
///     // The ScrollPhysics are overridden here to illustrate the functionality
///     // of fillOverscroll on all devices this sample may be run on.
///     // fillOverscroll only changes the behavior of your layout when applied
///     // to Scrollables that allow for overscroll. BouncingScrollPhysics are
///     // one example, which are provided by default on the iOS platform.
///     // BouncingScrollPhysics is combined with AlwaysScrollableScrollPhysics
///     // to allow for the overscroll, regardless of the depth of the
///     // scrollable.
///     physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
///     slivers: <Widget>[
///       SliverToBoxAdapter(
///         child: Container(
///           color: Colors.tealAccent[700],
///           height: 150.0,
///         ),
///       ),
///       SliverFillRemaining(
///         hasScrollBody: false,
///         // Switch for different overscroll behavior in your layout.
///         // If your ScrollPhysics do not allow for overscroll, setting
///         // fillOverscroll to true will have no effect.
///         fillOverscroll: true,
///         child: Container(
///           color: Colors.teal[100],
///           child: Align(
///             alignment: Alignment.bottomCenter,
///             child: Padding(
///               padding: const EdgeInsets.all(16.0),
///               child: RaisedButton(
///                 onPressed: () {
///                   /* Place your onPressed code here! */
///                 },
///                 child: Text('Bottom Pinned Button!'),
///               ),
///             ),
///           ),
///         ),
///       ),
///     ],
///   );
/// }
/// ```
/// {@end-tool}
///
///
/// See also:
///
///  * [SliverFillViewport], which sizes its children based on the
///    size of the viewport, regardless of what else is in the scroll view.
///  * [SliverList], which shows a list of variable-sized children in a
///    viewport.
class SliverFillRemaining extends StatelessWidget {
  /// Creates a sliver that fills the remaining space in the viewport.
  const SliverFillRemaining({
    Key key,
    this.child,
    this.hasScrollBody = true,
    this.fillOverscroll = false,
  }) : assert(hasScrollBody != null),
       assert(fillOverscroll != null),
       super(key: key);

  /// Doc
  final Widget child;

  /// Indicates whether the child has a scrollable body, this value cannot be
  /// null.
  ///
  /// Defaults to true such that the child will extend beyond the viewport and
  /// scroll, as seen in [NestedScrollView].
  ///
  /// Setting this value to false will allow the child to fill the remainder of
  /// the viewport and not extend further. However, if the
  /// [precedingScrollExtent] of the [SliverConstraints] and/or the [child]'s
  /// extent exceeds the size of the viewport, the sliver will defer to the
  /// child's size rather than overriding it.
  final bool hasScrollBody;

  /// Indicates whether the child should stretch to fill the overscroll area
  /// created by certain scroll physics, such as iOS' default scroll physics.
  /// This value cannot be null. This flag is only relevant when the
  /// [hasScrollBody] value is false.
  ///
  /// Defaults to false, meaning the default behavior is for the child to
  /// maintain its size and not extend into the overscroll area.
  final bool fillOverscroll;

  @override
  Widget build(BuildContext context) {
    if (hasScrollBody)
      return _SliverFillRemainingWithScrollable(child: child);
    if (!fillOverscroll)
      return _SliverFillRemainingWithoutScrollable(child: child);
    return _SliverFillRemainingAndOverscroll(child: child);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<Widget>(
        'child',
        child,
      )
    );
    final List<String> flags = <String>[
      if (hasScrollBody) 'scrollable',
      if (fillOverscroll) 'fillOverscroll',
    ];
    if (flags.isEmpty)
      flags.add('nonscrollable');
    properties.add(IterableProperty<String>('mode', flags));
  }
}

class _SliverFillRemainingWithScrollable extends SingleChildRenderObjectWidget {
  const _SliverFillRemainingWithScrollable({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  RenderSliverFillRemainingWithScrollable createRenderObject(BuildContext context) => RenderSliverFillRemainingWithScrollable();
}

class _SliverFillRemainingWithoutScrollable extends SingleChildRenderObjectWidget {
  const _SliverFillRemainingWithoutScrollable({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  RenderSliverFillRemaining createRenderObject(BuildContext context) => RenderSliverFillRemaining();
}

class _SliverFillRemainingAndOverscroll extends SingleChildRenderObjectWidget {
  const _SliverFillRemainingAndOverscroll({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  RenderSliverFillRemainingAndOverscroll createRenderObject(BuildContext context) => RenderSliverFillRemainingAndOverscroll();
}
