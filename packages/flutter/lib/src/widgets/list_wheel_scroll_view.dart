// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'dart:collection';
import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import 'framework.dart';
import 'notification_listener.dart';
import 'scroll_context.dart';
import 'scroll_controller.dart';
import 'scroll_metrics.dart';
import 'scroll_notification.dart';
import 'scroll_physics.dart';
import 'scroll_position.dart';
import 'scroll_position_with_single_context.dart';
import 'scrollable.dart';

/// Class that supplies children for the [ListWheelScrollView].
///
/// Instead of providing a concrete list of children to [ListWheelScrollView],
/// this class allows several methods to lazily provide children. This is more
/// efficient when there are too many or infinite children, by bringing in
/// only the children that are visible in viewport, and removing them when they
/// are no longer visible.
///
/// See also:
///  * [ListWheelChildListDelegate], a delegate that supplies children using an
///    explicit list.
///  * [ListWheelChildLoopingListDelegate], a delegate that supplies infinite
///    children by looping an explicit list.
///  * [ListWheelChildBuilderDelegate], a delegate that supplies children using
///    a builder callback.
abstract class ListWheelChildDelegate {
  /// Return the child at the given index. If the child at the given
  /// index does not exist, return null.
  Widget build(BuildContext context, int index);

  /// Returns an estimate of the number of children this delegate will build.
  int get estimatedChildCount;

  /// Returns the true index for a child built at a given index. Defaults to
  /// the given index, however if the delegate is [ListWheelChildLoopingListDelegate],
  /// this value is the index of the true element that the delegate is looping to.
  int trueIndexOf(int index) => index;

  /// Called to check whether this and the old delegate are actually 'different',
  /// so that the caller can decide to rebuild or not.
  bool shouldRebuild(covariant ListWheelChildDelegate oldDelegate);
}

/// Class that supplies children for the [ListWheelScrollView].
///
/// Instead of providing a concrete list of children to [ListWheelScrollView],
/// this class lazily supplies children using an explicit list. This is more
/// efficient when there are too many children in the list, by bringing in
/// only the children that are visible in viewport, and removing them when they
/// are no longer visible.
///
/// Children are available in the range [0, explicit_list.length - 1], outside
/// of that range a null child will be returned.
class ListWheelChildListDelegate extends ListWheelChildDelegate {
  /// Constructs the delegate from a concrete list of children.
  ListWheelChildListDelegate({@required this.children}) : assert(children != null);

  /// The list containing all children that can be supply.
  final List<Widget> children;

  @override
  int get estimatedChildCount => children.length;

  @override
  Widget build(BuildContext context, int index) {
    if (index < 0 || index >= children.length)
      return null;
    return children[index];
  }

  @override
  bool shouldRebuild(covariant ListWheelChildListDelegate oldDelegate) {
    return children != oldDelegate.children;
  }
}


/// Class that supplies children for the [ListWheelScrollView].
///
/// Instead of providing a concrete list of children to [ListWheelScrollView],
/// this class lazily supplies an infinite amount of children from an explicit
/// list by looping the list. The class only brings in children that are visible
/// in the viewport, and removes them when they are no longer visible.
class ListWheelChildLoopingListDelegate extends ListWheelChildDelegate {
  /// Constructs the delegate from a concrete list of children.
  ListWheelChildLoopingListDelegate({@required this.children}) : assert(children != null);

  /// The list containing all children that can be supply.
  final List<Widget> children;

  @override
  int get estimatedChildCount => null;

  @override
  int trueIndexOf(int index) => index % children.length;

  @override
  Widget build(BuildContext context, int index) {
    if (children.isEmpty)
      return null;
    return children[index % children.length];
  }

  @override
  bool shouldRebuild(covariant ListWheelChildLoopingListDelegate oldDelegate) {
    return children != oldDelegate.children;
  }
}

/// Class that supplies children for the [ListWheelScrollView].
///
/// Instead of providing a concrete list of children to [ListWheelScrollView],
/// this class lazily supplies children by using a builder callback. By using
/// the builder, the delegate will be able to provide children in custom range
/// (infinite range, has either or both lower and upper limit, lower limit does
/// not have to be 0, etc.) However the builder is expected to provide children
/// for a contiguous segment, and returning null at some index means the segment
/// is terminated there.
///
/// The class only brings in children that are visible in the viewport, and
/// removes them when they are no longer visible.
class ListWheelChildBuilderDelegate extends ListWheelChildDelegate {
  /// Constructs the delegate from a builder callback.
  ListWheelChildBuilderDelegate({
    @required this.builder,
    this.childCount,
  }) : assert(builder != null);

  /// Called lazily to build children.
  final IndexedWidgetBuilder builder;

  /// {@template flutter.widgets.wheelList.childCount}
  /// If non-null, [childCount] is the maximum number of children that can be
  /// provided, and children are available from 0 to [childCount] - 1.
  ///
  /// If null, then the lower and upper limit are not known. However the [builder]
  /// must provide children for a contiguous segment and returning null at
  /// some index means the segment is terminated there.
  /// {@endtemplate}
  final int childCount;

  @override
  int get estimatedChildCount => childCount;

  @override
  Widget build(BuildContext context, int index) {
    if (childCount == null)
      return builder(context, index);
    if (index < 0 || index >= childCount)
      return null;
    return builder(context, index);
  }

  @override
  bool shouldRebuild(covariant ListWheelChildBuilderDelegate oldDelegate) {
    return builder != oldDelegate.builder || childCount != oldDelegate.childCount;
  }
}


/// A controller for scroll views whose items have the same size.
///
/// Similar to a standard [ScrollController] but with the added convenience
/// mechanisms to read and go to item indices rather than a raw pixel scroll
/// offset.
///
/// See also:
///
///  * [ListWheelScrollView], a scrollable view widget with fixed size items
///    that this widget controls.
///  * [FixedExtentMetrics], the `metrics` property exposed by
///    [ScrollNotification] from [ListWheelScrollView] which can be used
///    to listen to the current item index on a push basis rather than polling
///    the [FixedExtentScrollController].
class FixedExtentScrollController extends ScrollController {
  /// Creates a scroll controller for scrollables whose items have the same size.
  ///
  /// [initialItem] defaults to 0 and must not be null.
  FixedExtentScrollController({
    this.initialItem = 0,
  }) : assert(initialItem != null);

  /// The page to show when first creating the scroll view.
  ///
  /// Defaults to 0 and must not be null.
  final int initialItem;

  /// The currently selected item index that's closest to the center of the viewport.
  ///
  /// There are circumstances that this [FixedExtentScrollController] can't know
  /// the current item. Reading [selectedItem] will throw an [AssertionError] in
  /// the following cases:
  ///
  /// 1. No scroll view is currently using this [FixedExtentScrollController].
  /// 2. More than one scroll views using the same [FixedExtentScrollController].
  ///
  /// The [hasClients] property can be used to check if a scroll view is
  /// attached prior to accessing [selectedItem].
  int get selectedItem {
    assert(
      positions.isNotEmpty,
      'FixedExtentScrollController.selectedItem cannot be accessed before a '
      'scroll view is built with it.',
    );
    assert(
      positions.length == 1,
      'The selectedItem property cannot be read when multiple scroll views are '
      'attached to the same FixedExtentScrollController.',
    );
    final _FixedExtentScrollPosition position = this.position;
    return position.itemIndex;
  }

  /// Animates the controlled scroll view to the given item index.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  ///
  /// The `duration` and `curve` arguments must not be null.
  Future<Null> animateToItem(int itemIndex, {
    @required Duration duration,
    @required Curve curve,
  }) {
    if (!hasClients) {
      return new Future<Null>.value();
    }

    final List<Future<Null>> futures = <Future<Null>>[];
    for (_FixedExtentScrollPosition position in positions) {
      futures.add(position.animateTo(
        itemIndex * position.itemExtent,
        duration: duration,
        curve: curve,
      ));
    }
    return Future.wait(futures);
  }

  /// Changes which item index is centered in the controlled scroll view.
  ///
  /// Jumps the item index position from its current value to the given value,
  /// without animation, and without checking if the new value is in range.
  void jumpToItem(int itemIndex) {
    for (_FixedExtentScrollPosition position in positions) {
      position.jumpTo(itemIndex * position.itemExtent);
    }
  }

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition oldPosition) {
    return new _FixedExtentScrollPosition(
      physics: physics,
      context: context,
      initialItem: initialItem,
      oldPosition: oldPosition,
    );
  }
}

/// Metrics for a [ScrollPosition] to a scroll view with fixed item sizes.
///
/// The metrics are available on [ScrollNotification]s generated from a scroll
/// views such as [ListWheelScrollView]s with a [FixedExtentScrollController] and
/// exposes the current [itemIndex] and the scroll view's [itemExtent].
///
/// `FixedExtent` refers to the fact that the scrollable items have the same size.
/// This is distinct from `Fixed` in the parent class name's [FixedScrollMetric]
/// which refers to its immutability.
class FixedExtentMetrics extends FixedScrollMetrics {
  /// Creates an immutable snapshot of values associated with a
  /// [ListWheelScrollView].
  FixedExtentMetrics({
    @required double minScrollExtent,
    @required double maxScrollExtent,
    @required double pixels,
    @required double viewportDimension,
    @required AxisDirection axisDirection,
    @required this.itemIndex,
  }) : super(
         minScrollExtent: minScrollExtent,
         maxScrollExtent: maxScrollExtent,
         pixels: pixels,
         viewportDimension: viewportDimension,
         axisDirection: axisDirection,
       );

  @override
  FixedExtentMetrics copyWith({
    double minScrollExtent,
    double maxScrollExtent,
    double pixels,
    double viewportDimension,
    AxisDirection axisDirection,
    int itemIndex,
  }) {
    return new FixedExtentMetrics(
      minScrollExtent: minScrollExtent ?? this.minScrollExtent,
      maxScrollExtent: maxScrollExtent ?? this.maxScrollExtent,
      pixels: pixels ?? this.pixels,
      viewportDimension: viewportDimension ?? this.viewportDimension,
      axisDirection: axisDirection ?? this.axisDirection,
      itemIndex: itemIndex ?? this.itemIndex,
    );
  }

  /// The scroll view's currently selected item index.
  final int itemIndex;
}

int _getItemFromOffset({
  double offset,
  double itemExtent,
  double minScrollExtent,
  double maxScrollExtent,
}) {
  return (_clipOffsetToScrollableRange(offset, minScrollExtent, maxScrollExtent) / itemExtent).round();
}

double _clipOffsetToScrollableRange(
  double offset,
  double minScrollExtent,
  double maxScrollExtent
) {
  return math.min(math.max(offset, minScrollExtent), maxScrollExtent);
}

/// A [ScrollPositionWithSingleContext] that can only be created based on
/// [_FixedExtentScrollable] and can access its `itemExtent` to derive [itemIndex].
class _FixedExtentScrollPosition extends ScrollPositionWithSingleContext implements FixedExtentMetrics {
  _FixedExtentScrollPosition({
    @required ScrollPhysics physics,
    @required ScrollContext context,
    @required int initialItem,
    bool keepScrollOffset = true,
    ScrollPosition oldPosition,
    String debugLabel,
  }) : assert(
         context is _FixedExtentScrollableState,
         'FixedExtentScrollController can only be used with ListWheelScrollViews'
       ),
       super(
         physics: physics,
         context: context,
         initialPixels: _getItemExtentFromScrollContext(context) * initialItem,
         keepScrollOffset: keepScrollOffset,
         oldPosition: oldPosition,
         debugLabel: debugLabel,
       );

  static double _getItemExtentFromScrollContext(ScrollContext context) {
    final _FixedExtentScrollableState scrollable = context;
    return scrollable.itemExtent;
  }

  double get itemExtent => _getItemExtentFromScrollContext(context);

  @override
  int get itemIndex {
    return _getItemFromOffset(
      offset: pixels,
      itemExtent: itemExtent,
      minScrollExtent: minScrollExtent,
      maxScrollExtent: maxScrollExtent,
    );
  }

  @override
  FixedExtentMetrics copyWith({
    double minScrollExtent,
    double maxScrollExtent,
    double pixels,
    double viewportDimension,
    AxisDirection axisDirection,
    int itemIndex,
  }) {
    return new FixedExtentMetrics(
      minScrollExtent: minScrollExtent ?? this.minScrollExtent,
      maxScrollExtent: maxScrollExtent ?? this.maxScrollExtent,
      pixels: pixels ?? this.pixels,
      viewportDimension: viewportDimension ?? this.viewportDimension,
      axisDirection: axisDirection ?? this.axisDirection,
      itemIndex: itemIndex ?? this.itemIndex,
    );
  }
}

/// A [Scrollable] which must be given its viewport children's item extent
/// size so it can pass it on ultimately to the [FixedExtentScrollController].
class _FixedExtentScrollable extends Scrollable {
  const _FixedExtentScrollable({
    Key key,
    AxisDirection axisDirection = AxisDirection.down,
    ScrollController controller,
    ScrollPhysics physics,
    @required this.itemExtent,
    @required ViewportBuilder viewportBuilder,
  }) : super (
    key: key,
    axisDirection: axisDirection,
    controller: controller,
    physics: physics,
    viewportBuilder: viewportBuilder,
  );

  final double itemExtent;

  @override
  _FixedExtentScrollableState createState() => new _FixedExtentScrollableState();
}

/// This [ScrollContext] is used by [_FixedExtentScrollPosition] to read the
/// prescribed [itemExtent].
class _FixedExtentScrollableState extends ScrollableState {
  double get itemExtent {
    // Downcast because only _FixedExtentScrollable can make _FixedExtentScrollableState.
    final _FixedExtentScrollable actualWidget = widget;
    return actualWidget.itemExtent;
  }
}

/// A snapping physics that always lands directly on items instead of anywhere
/// within the scroll extent.
///
/// Behaves similarly to a slot machine wheel except the ballistics simulation
/// never overshoots and rolls back within a single item if it's to settle on
/// that item.
///
/// Must be used with a scrollable that uses a [FixedExtentScrollController].
///
/// Defers back to the parent beyond the scroll extents.
class FixedExtentScrollPhysics extends ScrollPhysics {
  /// Creates a scroll physics that always lands on items.
  const FixedExtentScrollPhysics({ ScrollPhysics parent }) : super(parent: parent);

  @override
  FixedExtentScrollPhysics applyTo(ScrollPhysics ancestor) {
    return new FixedExtentScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    assert(
      position is _FixedExtentScrollPosition,
      'FixedExtentScrollPhysics can only be used with Scrollables that uses '
      'the FixedExtentScrollController'
    );

    final _FixedExtentScrollPosition metrics = position;

    // Scenario 1:
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at the scrollable's boundary.
    if ((velocity <= 0.0 && metrics.pixels <= metrics.minScrollExtent) ||
        (velocity >= 0.0 && metrics.pixels >= metrics.maxScrollExtent)) {
      return super.createBallisticSimulation(metrics, velocity);
    }

    // Create a test simulation to see where it would have ballistically fallen
    // naturally without settling onto items.
    final Simulation testFrictionSimulation =
        super.createBallisticSimulation(metrics, velocity);

    // Scenario 2:
    // If it was going to end up past the scroll extent, defer back to the
    // parent physics' ballistics again which should put us on the scrollable's
    // boundary.
    if (testFrictionSimulation != null
        && (testFrictionSimulation.x(double.infinity) == metrics.minScrollExtent
            || testFrictionSimulation.x(double.infinity) == metrics.maxScrollExtent)) {
      return super.createBallisticSimulation(metrics, velocity);
    }

    // From the natural final position, find the nearest item it should have
    // settled to.
    final int settlingItemIndex = _getItemFromOffset(
      offset: testFrictionSimulation?.x(double.infinity) ?? metrics.pixels,
      itemExtent: metrics.itemExtent,
      minScrollExtent: metrics.minScrollExtent,
      maxScrollExtent: metrics.maxScrollExtent,
    );

    final double settlingPixels = settlingItemIndex * metrics.itemExtent;

    // Scenario 3:
    // If there's no velocity and we're already at where we intend to land,
    // do nothing.
    if (velocity.abs() < tolerance.velocity
        && (settlingPixels - metrics.pixels).abs() < tolerance.distance) {
      return null;
    }

    // Scenario 4:
    // If we're going to end back at the same item because initial velocity
    // is too low to break past it, use a spring simulation to get back.
    if (settlingItemIndex == metrics.itemIndex) {
      return new SpringSimulation(
        spring,
        metrics.pixels,
        settlingPixels,
        velocity,
        tolerance: tolerance,
      );
    }

    // Scenario 5:
    // Create a new friction simulation except the drag will be tweaked to land
    // exactly on the item closest to the natural stopping point.
    return new FrictionSimulation.through(
      metrics.pixels,
      settlingPixels,
      velocity,
      tolerance.velocity * velocity.sign,
    );
  }
}

/// A box in which children on a wheel can be scrolled.
///
/// This widget is similar to a [ListView] but with the restriction that all
/// children must be the same size along the scrolling axis.
///
/// When the list is at the zero scroll offset, the first child is aligned with
/// the middle of the viewport. When the list is at the final scroll offset,
/// the last child is aligned with the middle of the viewport
///
/// The children are rendered as if rotating on a wheel instead of scrolling on
/// a plane.
class ListWheelScrollView extends StatefulWidget {
  /// Constructs a list in which children are scrolled a wheel. Its children
  /// are passed to a delegate and lazily built during layout.
  ListWheelScrollView({
    Key key,
    this.controller,
    this.physics,
    this.diameterRatio = RenderListWheelViewport.defaultDiameterRatio,
    this.perspective = RenderListWheelViewport.defaultPerspective,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    @required this.itemExtent,
    this.onSelectedItemChanged,
    this.clipToSize = true,
    this.renderChildrenOutsideViewport = false,
    @required List<Widget> children,
  }) : assert(children != null),
       assert(diameterRatio != null),
       assert(diameterRatio > 0.0, RenderListWheelViewport.diameterRatioZeroMessage),
       assert(perspective != null),
       assert(perspective > 0),
       assert(perspective <= 0.01, RenderListWheelViewport.perspectiveTooHighMessage),
       assert(magnification > 0),
       assert(itemExtent != null),
       assert(itemExtent > 0),
       assert(clipToSize != null),
       assert(renderChildrenOutsideViewport != null),
       assert(
         !renderChildrenOutsideViewport || !clipToSize,
         RenderListWheelViewport.clipToSizeAndRenderChildrenOutsideViewportConflict,
       ),
       childDelegate = new ListWheelChildListDelegate(children: children),
       super(key: key);

  /// Constructs a list in which children are scrolled a wheel. Its children
  /// are managed by a delegate and are lazily built during layout.
  const ListWheelScrollView.useDelegate({
    Key key,
    this.controller,
    this.physics,
    this.diameterRatio = RenderListWheelViewport.defaultDiameterRatio,
    this.perspective = RenderListWheelViewport.defaultPerspective,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    @required this.itemExtent,
    this.onSelectedItemChanged,
    this.clipToSize = true,
    this.renderChildrenOutsideViewport = false,
    @required this.childDelegate,
  }) : assert(childDelegate != null),
       assert(diameterRatio != null),
       assert(diameterRatio > 0.0, RenderListWheelViewport.diameterRatioZeroMessage),
       assert(perspective != null),
       assert(perspective > 0),
       assert(perspective <= 0.01, RenderListWheelViewport.perspectiveTooHighMessage),
       assert(magnification > 0),
       assert(itemExtent != null),
       assert(itemExtent > 0),
       assert(clipToSize != null),
       assert(renderChildrenOutsideViewport != null),
       assert(
         !renderChildrenOutsideViewport || !clipToSize,
         RenderListWheelViewport.clipToSizeAndRenderChildrenOutsideViewportConflict,
       ),
       super(key: key);

  /// Typically a [FixedExtentScrollController] used to control the current item.
  ///
  /// A [FixedExtentScrollController] can be used to read the currently
  /// selected/centered child item and can be used to change the current item.
  ///
  /// If none is provided, a new [FixedExtentScrollController] is implicitly
  /// created.
  ///
  /// If a [ScrollController] is used instead of [FixedExtentScrollController],
  /// [ScrollNotification.metrics] will no longer provide [FixedExtentMetrics]
  /// to indicate the current item index and [onSelectedItemChanged] will not
  /// work.
  ///
  /// To read the current selected item only when the value changes, use
  /// [onSelectedItemChanged].
  final ScrollController controller;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics physics;

  /// {@macro flutter.rendering.wheelList.diameterRatio}
  final double diameterRatio;

  /// {@macro flutter.rendering.wheelList.perspective}
  final double perspective;

  /// {@macro flutter.rendering.wheelList.offAxisFraction}
  final double offAxisFraction;

  /// {@macro flutter.rendering.wheelList.useMagnifier}
  final bool useMagnifier;

  /// {@macro RenderListWheelViewport.magnification}
  final double magnification;

  /// Size of each child in the main axis. Must not be null and must be
  /// positive.
  final double itemExtent;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<int> onSelectedItemChanged;

  /// {@macro flutter.rendering.wheelList.clipToSize}
  final bool clipToSize;

  /// {@macro flutter.rendering.wheelList.renderChildrenOutsideViewport}
  final bool renderChildrenOutsideViewport;

  /// A delegate that helps lazily instantiating child.
  final ListWheelChildDelegate childDelegate;

  @override
  _ListWheelScrollViewState createState() => new _ListWheelScrollViewState();
}

class _ListWheelScrollViewState extends State<ListWheelScrollView> {
  int _lastReportedItemIndex = 0;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = widget.controller ?? new FixedExtentScrollController();
    if (widget.controller is FixedExtentScrollController) {
      final FixedExtentScrollController controller = widget.controller;
      _lastReportedItemIndex = controller.initialItem;
    }
  }

  @override
  void didUpdateWidget(ListWheelScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && widget.controller != scrollController) {
      final ScrollController oldScrollController = scrollController;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        oldScrollController.dispose();
      });
      scrollController = widget.controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.depth == 0
            && widget.onSelectedItemChanged != null
            && notification is ScrollUpdateNotification
            && notification.metrics is FixedExtentMetrics) {
          final FixedExtentMetrics metrics = notification.metrics;
          final int currentItemIndex = metrics.itemIndex;
          if (currentItemIndex != _lastReportedItemIndex) {
            _lastReportedItemIndex = currentItemIndex;
            final int trueIndex = widget.childDelegate.trueIndexOf(currentItemIndex);
            widget.onSelectedItemChanged(trueIndex);
          }
        }
        return false;
      },
      child: new _FixedExtentScrollable(
        controller: scrollController,
        physics: widget.physics,
        itemExtent: widget.itemExtent,
        viewportBuilder: (BuildContext context, ViewportOffset offset) {
          return new ListWheelViewport(
            diameterRatio: widget.diameterRatio,
            perspective: widget.perspective,
            offAxisFraction: widget.offAxisFraction,
            useMagnifier: widget.useMagnifier,
            magnification: widget.magnification,
            itemExtent: widget.itemExtent,
            clipToSize: widget.clipToSize,
            renderChildrenOutsideViewport: widget.renderChildrenOutsideViewport,
            offset: offset,
            childDelegate: widget.childDelegate,
          );
        },
      ),
    );
  }
}

/// Element that supports building children lazily for [ListWheelViewport].
class ListWheelElement extends RenderObjectElement implements ListWheelChildManager {
  /// Creates an element that lazily builds children for the given widget.
  ListWheelElement(ListWheelViewport widget) : super(widget);

  @override
  ListWheelViewport get widget => super.widget;

  @override
  RenderListWheelViewport get renderObject => super.renderObject;

  // We inflate widgets at two different times:
  //  1. When we ourselves are told to rebuild (see performRebuild).
  //  2. When our render object needs a new child (see createChild).
  // In both cases, we cache the results of calling into our delegate to get the widget,
  // so that if we do case 2 later, we don't call the builder again.
  // Any time we do case 1, though, we reset the cache.

  /// A cache of widgets so that we don't have to rebuild every time.
  final Map<int, Widget> _childWidgets = new HashMap<int, Widget>();

  /// The map containing all active child elements. SplayTreeMap is used so that
  /// we have all elements ordered and iterable by their keys.
  final SplayTreeMap<int, Element> _childElements = new SplayTreeMap<int, Element>();

  @override
  void update(covariant ListWheelViewport newWidget) {
    final ListWheelViewport oldWidget = widget;
    super.update(newWidget);
    final ListWheelChildDelegate newDelegate = newWidget.childDelegate;
    final ListWheelChildDelegate oldDelegate = oldWidget.childDelegate;
    if (newDelegate != oldDelegate &&
        (newDelegate.runtimeType != oldDelegate.runtimeType || newDelegate.shouldRebuild(oldDelegate)))
      performRebuild();
  }

  @override
  int get childCount => widget.childDelegate.estimatedChildCount;

  @override
  void performRebuild() {
    _childWidgets.clear();
    super.performRebuild();
    if (_childElements.isEmpty)
      return;

    final int firstIndex = _childElements.firstKey();
    final int lastIndex = _childElements.lastKey();

    for (int index = firstIndex; index <= lastIndex; ++index) {
      final Element newChild = updateChild(_childElements[index], retrieveWidget(index), index);
      if (newChild != null) {
        _childElements[index] = newChild;
      } else {
        _childElements.remove(index);
      }
    }
  }

  /// Asks the underlying delegate for a widget at the given index.
  ///
  /// Normally the builder is only called once for each index and the result
  /// will be cached. However when the element is rebuilt, the cache will be
  /// cleared.
  ///
  /// This function is often called when a new child needs to be created.
  Widget retrieveWidget(int index) {
    return _childWidgets.putIfAbsent(index, () => widget.childDelegate.build(this, index));
  }

  @override
  bool childExistsAt(int index) => retrieveWidget(index) != null;

  @override
  void createChild(int index, { @required RenderBox after }) {
    owner.buildScope(this, () {
      final bool insertFirst = after == null;
      assert(insertFirst || _childElements[index - 1] != null);
      final Element newChild =
        updateChild(_childElements[index], retrieveWidget(index), index);
      if (newChild != null) {
        _childElements[index] = newChild;
      } else {
        _childElements.remove(index);
      }
    });
  }

  @override
  void removeChild(RenderBox child) {
    final int index = renderObject.indexOf(child);
    owner.buildScope(this, () {
      assert(_childElements.containsKey(index));
      final Element result = updateChild(_childElements[index], null, index);
      assert(result == null);
      _childElements.remove(index);
      assert(!_childElements.containsKey(index));
    });
  }

  @override
  Element updateChild(Element child, Widget newWidget, dynamic newSlot) {
    final ListWheelParentData oldParentData = child?.renderObject?.parentData;
    final Element newChild = super.updateChild(child, newWidget, newSlot);
    final ListWheelParentData newParentData = newChild?.renderObject?.parentData;
    if (newParentData != null) {
      newParentData.index = newSlot;
      if (oldParentData != null)
        newParentData.offset = oldParentData.offset;
    }

    return newChild;
  }

  @override
  void insertChildRenderObject(RenderObject child, int slot) {
    final RenderListWheelViewport renderObject = this.renderObject;
    assert(renderObject.debugValidateChild(child));
    renderObject.insert(child, after: _childElements[slot - 1]?.renderObject);
    assert(renderObject == this.renderObject);
  }

  @override
  void moveChildRenderObject(RenderObject child, dynamic slot) {

    const String moveChildRenderObjectErrorMessage =
        'Currently we maintain the list in contiguous increasing order, so '
        'moving children around is not allowed.';
    assert(false, moveChildRenderObjectErrorMessage);
  }

  @override
  void removeChildRenderObject(RenderObject child) {
    assert(child.parent == renderObject);
    renderObject.remove(child);
  }

  @override
  void visitChildren(ElementVisitor visitor) {
    _childElements.forEach((int key, Element child) {
      visitor(child);
    });
  }

  @override
  void forgetChild(Element child) {
    _childElements.remove(child.slot);
  }

}

/// A viewport showing a subset of children on a wheel.
///
/// Typically used with [ListWheelScrollView], this viewport is similar to
/// [Viewport] in that it shows a subset of children in a scrollable based
/// on the scrolling offset and the childrens' dimensions. But uses
/// [RenderListWheelViewport] to display the children on a wheel.
///
/// See also:
///
///  * [ListWheelScrollView], widget that combines this viewport with a scrollable.
///  * [RenderListWheelViewport], the render object that renders the children
///    on a wheel.
class ListWheelViewport extends RenderObjectWidget {
  /// Creates a viewport where children are rendered onto a wheel.
  ///
  /// The [diameterRatio] argument defaults to 2.0 and must not be null.
  ///
  /// The [perspective] argument defaults to 0.003 and must not be null.
  ///
  /// The [itemExtent] argument in pixels must be provided and must be positive.
  ///
  /// The [clipToSize] argument defaults to true and must not be null.
  ///
  /// The [renderChildrenOutsideViewport] argument defaults to false and must
  /// not be null.
  ///
  /// The [offset] argument must be provided and must not be null.
  const ListWheelViewport({
    Key key,
    this.diameterRatio = RenderListWheelViewport.defaultDiameterRatio,
    this.perspective = RenderListWheelViewport.defaultPerspective,
    this.offAxisFraction = 0.0,
    this.useMagnifier = false,
    this.magnification = 1.0,
    @required this.itemExtent,
    this.clipToSize = true,
    this.renderChildrenOutsideViewport = false,
    @required this.offset,
    @required this.childDelegate,
  }) : assert(childDelegate != null),
       assert(offset != null),
       assert(diameterRatio != null),
       assert(diameterRatio > 0, RenderListWheelViewport.diameterRatioZeroMessage),
       assert(perspective != null),
       assert(perspective > 0),
       assert(perspective <= 0.01, RenderListWheelViewport.perspectiveTooHighMessage),
       assert(itemExtent != null),
       assert(itemExtent > 0),
       assert(clipToSize != null),
       assert(renderChildrenOutsideViewport != null),
       assert(
         !renderChildrenOutsideViewport || !clipToSize,
         RenderListWheelViewport.clipToSizeAndRenderChildrenOutsideViewportConflict,
       ),
       super(key: key);

  /// {@macro flutter.rendering.wheelList.diameterRatio}
  final double diameterRatio;

  /// {@macro flutter.rendering.wheelList.perspective}
  final double perspective;

  /// {@macro flutter.rendering.wheelList.offAxisFraction}
  final double offAxisFraction;

  /// {@macro flutter.rendering.wheelList.useMagnifier}
  final bool useMagnifier;

  /// {@macro flutter.rendering.wheelList.magnification}
  final double magnification;

  /// {@macro flutter.rendering.wheelList.itemExtent}
  final double itemExtent;

  /// {@macro flutter.rendering.wheelList.clipToSize}
  final bool clipToSize;

  /// {@macro flutter.rendering.wheelList.renderChildrenOutsideViewport}
  final bool renderChildrenOutsideViewport;

  /// [ViewportOffset] object describing the content that should be visible
  /// in the viewport.
  final ViewportOffset offset;

  /// A delegate that lazily instantiates children.
  final ListWheelChildDelegate childDelegate;

  @override
  ListWheelElement createElement() => new ListWheelElement(this);

  @override
  RenderListWheelViewport createRenderObject(BuildContext context) {
    final ListWheelElement childManager = context;
    return new RenderListWheelViewport(
      childManager: childManager,
      offset: offset,
      diameterRatio: diameterRatio,
      perspective: perspective,
      offAxisFraction: offAxisFraction,
      useMagnifier: useMagnifier,
      magnification: magnification,
      itemExtent: itemExtent,
      clipToSize: clipToSize,
      renderChildrenOutsideViewport: renderChildrenOutsideViewport,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderListWheelViewport renderObject) {
    renderObject
      ..diameterRatio = diameterRatio
      ..perspective = perspective
      ..offAxisFraction = offAxisFraction
      ..useMagnifier = useMagnifier
      ..magnification = magnification
      ..itemExtent = itemExtent
      ..clipToSize = clipToSize
      ..renderChildrenOutsideViewport = renderChildrenOutsideViewport
      ..offset = offset;
  }
}
