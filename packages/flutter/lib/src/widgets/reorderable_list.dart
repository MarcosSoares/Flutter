// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';

import 'basic.dart';
import 'debug.dart';
import 'framework.dart';
import 'inherited_theme.dart';
import 'overlay.dart';
import 'scroll_controller.dart';
import 'scroll_physics.dart';
import 'scroll_position.dart';
import 'scroll_view.dart';
import 'scrollable.dart';
import 'sliver.dart';
import 'ticker_provider.dart';
import 'transitions.dart';

// Examples can assume:
// class MyDataObject {}

/// A callback used by [ReorderableList] to report that a list item has moved
/// to a new position in the list.
///
/// Implementations should remove the corresponding list item at [oldIndex]
/// and reinsert it at [newIndex].
///
/// If [oldIndex] is before [newIndex], removing the item at [oldIndex] from the
/// list will reduce the list's length by one. Implementations will need to
/// account for this when inserting before [newIndex].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=3fB1mxOsqJE}
///
/// {@tool snippet}
///
/// ```dart
/// final List<MyDataObject> backingList = <MyDataObject>[/* ... */];
///
/// void handleReorder(int oldIndex, int newIndex) {
///   if (oldIndex < newIndex) {
///     // removing the item at oldIndex will shorten the list by 1.
///     newIndex -= 1;
///   }
///   final MyDataObject element = backingList.removeAt(oldIndex);
///   backingList.insert(newIndex, element);
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [ReorderableList], a widget list that allows the user to reorder
///    its items.
///  * [SliverReorderableList], a sliver list that allows the user to reorder
///    its items.
///  * [ReorderableListView], a material design list that allows the user to
///    reorder its items.
typedef ReorderCallback = void Function(int oldIndex, int newIndex);

/// Signature for the builder callback used to decorate the dragging item in
/// [ReorderableList] and [SliverReorderableList].
typedef ReorderItemProxyDecorator = Widget Function(Widget child, int index, Animation<double> animation);

/// A scrolling container that allows the user to interactively reorder the
/// list items.
///
/// This widget is similar to one created by [ListView.builder], and uses
/// an [IndexedWidgetBuilder] to create each item.
///
/// It is up to the application to wrap each child (or an internal part of the
/// child such as a drag handle) with a drag listener that will recognize
/// the start of an item drag and then start the reorder by calling
/// [ReorderableListState.startItemDragReorder].
///
/// This is most easily achieved by wrapping each child in a
/// [ReorderableDragStartListener] or a [ReorderableDelayedDragStartListener].
/// These will take care of recognizing the start of a drag gesture and call
/// the list state's start item drag method.
///
/// This widget's [ReorderableListState] can be used manually start a item
/// reorder, or cancel a current drag. To refer to the
/// [ReorderableListState] either provide a [GlobalKey] or use the static
/// [ReorderableList.of] method from an item's build method.
///
/// See also:
///
///  * [SliverReorderableList], a sliver list that allows the user to reorder
///    its items.
///  * [ReorderableListView], a material design list that allows the user to
///    reorder its items.
class ReorderableList extends StatefulWidget {
  /// Creates a scrolling container that allows the user to interactively
  /// reorder the list items.
  ///
  /// [itemCount] must be greater than or equal to zero.
  const ReorderableList({
    Key? key,
    required this.itemBuilder,
    this.itemCount = 0,
    required this.onReorder,
    this.proxyDecorator,
    this.scrollDirection = Axis.vertical,
    this.reverse = false,
    this.controller,
    this.primary,
    this.physics,
    this.shrinkWrap = false,
    this.padding,
  }) : assert(itemCount >= 0),
       super(key: key);

  /// Called, as needed, to build list item widgets.
  ///
  /// List items are only built when they're scrolled into view.
  ///
  /// The [IndexedWidgetBuilder] index parameter indicates the item's
  /// position in the list. The value of the index parameter will equal to zero
  /// and less than [itemCount]. All items in the list should have a
  /// unique [Key], and should have some kind of listener to start the drag
  /// (usually a [ReorderableDragStartListener] or
  /// [ReorderableDelayedDragStartListener]).
  final IndexedWidgetBuilder itemBuilder;

  /// The number of items in the list.
  final int itemCount;

  /// A callback used by the list to report that a list item has been dragged
  /// to a new location in the list and the application should update the order
  /// of the items.
  final ReorderCallback onReorder;

  /// A callback that allows the app to add an animated decoration around
  /// an item when it is being dragged.
  final ReorderItemProxyDecorator? proxyDecorator;

  /// The axis along which the scroll view scrolls.
  ///
  /// Defaults to [Axis.vertical].
  final Axis scrollDirection;

  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the scroll view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the scroll view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// Must be null if [primary] is true.
  ///
  /// A [ScrollController] serves several purposes. It can be used to control
  /// the initial scroll position (see [ScrollController.initialScrollOffset]).
  /// It can be used to control whether the scroll view should automatically
  /// save and restore its scroll position in the [PageStorage] (see
  /// [ScrollController.keepScrollOffset]). It can be used to read the current
  /// scroll position (see [ScrollController.offset]), or change it (see
  /// [ScrollController.animateTo]).
  final ScrollController? controller;

  /// Whether this is the primary scroll view associated with the parent
  /// [PrimaryScrollController].
  ///
  /// On iOS, this identifies the scroll view that will scroll to top in
  /// response to a tap in the status bar.
  ///
  /// Defaults to true when [scrollDirection] is [Axis.vertical] and
  /// [controller] is null.
  final bool? primary;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics? physics;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  /// If the scroll view does not shrink wrap, then the scroll view will expand
  /// to the maximum allowed size in the [scrollDirection]. If the scroll view
  /// has unbounded constraints in the [scrollDirection], then [shrinkWrap] must
  /// be true.
  ///
  /// Shrink wrapping the content of the scroll view is significantly more
  /// expensive than expanding to the maximum allowed size because the content
  /// can expand and contract during scrolling, which means the size of the
  /// scroll view needs to be recomputed whenever the scroll position changes.
  ///
  /// Defaults to false.
  final bool shrinkWrap;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry? padding;

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// This method is typically used by [ReorderableList] item widgets that insert
  /// or remove items in response to user input.
  ///
  /// If no [ReorderableList] surrounds the context given, then this function will
  /// assert in debug mode and throw an exception in release mode.
  ///
  /// See also:
  ///
  ///  * [maybeOf], a similar function that will return null if no
  ///    [ReorderableList] ancestor is found.
  static ReorderableListState of(BuildContext context) {
    assert(context != null);
    final ReorderableListState? result = context.findAncestorStateOfType<ReorderableListState>();
    assert((){
      if (result == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
            'ReorderableList.of() called with a context that does not contain a ReorderableList.'),
          ErrorDescription(
            'No ReorderableList ancestor could be found starting from the context that was passed to ReorderableList.of().'),
          ErrorHint(
            'This can happen when the context provided is from the same StatefulWidget that '
            'built the ReorderableList. Please see the ReorderableList documentation for examples '
            'of how to refer to an ReorderableListState object:'
            '  https://api.flutter.dev/flutter/widgets/ReorderableListState-class.html'
          ),
          context.describeElement('The context used was')
        ]);
      }
      return true;
    }());
    return result!;
  }

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// This method is typically used by [ReorderableList] item widgets that insert
  /// or remove items in response to user input.
  ///
  /// If no [ReorderableList] surrounds the context given, then this function will
  /// return null.
  ///
  /// See also:
  ///
  ///  * [of], a similar function that will throw if no [ReorderableList] ancestor
  ///    is found.
  static ReorderableListState? maybeOf(BuildContext context) {
    assert(context != null);
    return context.findAncestorStateOfType<ReorderableListState>();
  }

  @override
  ReorderableListState createState() => ReorderableListState();
}

/// The state for a list that allows the user to interactively reorder
/// the list items.
///
/// An app that needs to start a new item drag or cancel an existing one
/// can refer to the [ReorderableList]'s state with a global key:
///
/// ```dart
/// GlobalKey<ReorderableListState> listKey = GlobalKey<ReorderableListState>();
/// ...
/// ReorderableList(key: listKey, ...);
/// ...
/// listKey.currentState.cancelReorder();
/// ```
class ReorderableListState extends State<ReorderableList> {
  final GlobalKey<SliverReorderableListState> _sliverReorderableListKey = GlobalKey();

  /// Initiate the dragging of the item at [index] that was started with
  /// the pointer down [event].
  ///
  /// The given [recognizer] will be used to recognize and start the drag
  /// item tracking and lead to either an item reorder, or a cancelled drag.
  ///
  /// Most applications will not use this directly, but will wrap the item
  /// (or part of the item, like a drag handle) in either a
  /// [ReorderableDragStartListener] or [ReorderableDelayedDragStartListener]
  /// which call this for the application.
  void startItemDragReorder({
    required int index,
    required PointerDownEvent event,
    required MultiDragGestureRecognizer<MultiDragPointerState> recognizer,
  }) {
    _sliverReorderableListKey.currentState!.startItemDragReorder(index: index, event: event, recognizer: recognizer);
  }

  /// Cancel any item drag in progress.
  ///
  /// This should be called before any major changes to the item list
  /// occur so that any item drags will not get confused by
  /// changes to the underlying list.
  ///
  /// If no drag is active, this will do nothing.
  void cancelReorder() {
    _sliverReorderableListKey.currentState!.cancelReorder();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollDirection: widget.scrollDirection,
      reverse: widget.reverse,
      controller: widget.controller,
      primary: widget.primary,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      slivers: <Widget>[
        SliverPadding(
          padding: widget.padding ?? const EdgeInsets.all(0),
          sliver: SliverReorderableList(
            key: _sliverReorderableListKey,
            itemBuilder: widget.itemBuilder,
            itemCount: widget.itemCount,
            onReorder: widget.onReorder,
            proxyDecorator: widget.proxyDecorator,
          ),
        ),
      ],
    );
  }
}

/// A sliver list that allows the user to interactively reorder the list items.
///
/// It is up to the application to wrap each child (or an internal part of the
/// child) with a drag listener that will recognize the start of an item drag
/// and then start the reorder by calling
/// [SliverReorderableListState.startItemDragReorder].
///
/// This is most easily achieved by wrapping each child in a
/// [ReorderableDragStartListener] or a [ReorderableDelayedDragStartListener].
/// These will take care of recognizing the start of a drag gesture and call
/// the list state's start item drag method.
///
/// This widget's [SliverReorderableListState] can be used to manually start an item
/// reorder, or cancel a current drag. To refer to the
/// [SliverReorderableListState] either provide a [GlobalKey] or use the static
/// [SliverReorderableList.of] method from an item's build method.
///
/// See also:
///
///  * [ReorderableList], a regular widget list that allows the user to reorder
///    its items.
///  * [ReorderableListView], a material design list that allows the user to
///    reorder its items.
class SliverReorderableList extends StatefulWidget {
  /// Creates a sliver list that allows the user to interactively reorder its
  /// items.
  ///
  /// The [itemCount] must be greater than or equal to zero.
  const SliverReorderableList({
    Key? key,
    required this.itemBuilder,
    this.itemCount = 0,
    required this.onReorder,
    this.proxyDecorator,
  }) : assert(itemCount >= 0),
       super(key: key);

  /// Called, as needed, to build list item widgets.
  ///
  /// List items are only built when they're scrolled into view.
  ///
  /// The [IndexedWidgetBuilder] index parameter indicates the item's
  /// position in the list. The value of the index parameter will equal to zero
  /// and less than [itemCount]. All items in the list should have a
  /// unique [Key], and should have some kind of listener to start the drag
  /// (usually a [ReorderableDragStartListener] or
  /// [ReorderableDelayedDragStartListener]).
  final IndexedWidgetBuilder itemBuilder;

  /// The number of items in the list.
  final int itemCount;

  /// A callback used by the list to report that a list item has been dragged
  /// to a new location in the list and the application should update the order
  /// of the items.
  final ReorderCallback onReorder;

  /// A callback that allows the app to add an animated decoration around
  /// an item when it is being dragged.
  final ReorderItemProxyDecorator? proxyDecorator;

  @override
  SliverReorderableListState createState() => SliverReorderableListState();

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// This method is typically used by [SliverReorderableList] item widgets to
  /// start or cancel an item drag operation.
  ///
  /// If no [SliverReorderableList] surrounds the context given, this function
  /// will assert in debug mode and throw an exception in release mode.
  ///
  /// See also:
  ///
  ///  * [maybeOf], a similar function that will return null if no
  ///    [SliverReorderableList] ancestor is found.
  static SliverReorderableListState of(BuildContext context) {
    assert(context != null);
    final SliverReorderableListState? result = context.findAncestorStateOfType<SliverReorderableListState>();
    assert((){
      if (result == null) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary(
              'SliverReorderableList.of() called with a context that does not contain a SliverReorderableList.'),
          ErrorDescription(
              'No SliverReorderableList ancestor could be found starting from the context that was passed to SliverReorderableList.of().'),
          ErrorHint(
              'This can happen when the context provided is from the same StatefulWidget that '
              'built the SliverReorderableList. Please see the SliverReorderableList documentation for examples '
              'of how to refer to an SliverReorderableList object:'
              '  https://api.flutter.dev/flutter/widgets/SliverReorderableListState-class.html'
          ),
          context.describeElement('The context used was')
        ]);
      }
      return true;
    }());
    return result!;
  }

  /// The state from the closest instance of this class that encloses the given
  /// context.
  ///
  /// This method is typically used by [SliverReorderableList] item widgets that
  /// insert or remove items in response to user input.
  ///
  /// If no [SliverReorderableList] surrounds the context given, this function
  /// will return null.
  ///
  /// See also:
  ///
  ///  * [of], a similar function that will throw if no [SliverReorderableList]
  ///    ancestor is found.
  static SliverReorderableListState? maybeOf(BuildContext context) {
    assert(context != null);
    return context.findAncestorStateOfType<SliverReorderableListState>();
  }
}

/// The state for a sliver list that allows the user to interactively reorder
/// the list items.
///
/// An app that needs to start a new item drag or cancel an existing one
/// can refer to the [SliverReorderableList]'s state with a global key:
///
/// ```dart
/// GlobalKey<SliverReorderableListState> listKey = GlobalKey<SliverReorderableListState>();
/// ...
/// SliverReorderableList(key: listKey, ...);
/// ...
/// listKey.currentState.cancelReorder();
/// ```
///
/// [ReorderableDragStartListener] and [ReorderableDelayedDragStartListener]
/// refer to their [SliverReorderableList] with the static
/// [SliverReorderableList.of] method.
class SliverReorderableListState extends State<SliverReorderableList> with TickerProviderStateMixin {
  late Axis _scrollDirection;

  final Map<int, _ReorderableItemState> _items = <int, _ReorderableItemState>{};

  bool _reorderingDrag = false;
  bool _autoScrolling = false;
  OverlayEntry? _overlayEntry;
  _ReorderableItemState? _dragItem;
  _DragInfo? _dragInfo;
  int? _insertIndex;
  Offset? _finalDropPosition;
  MultiDragGestureRecognizer<MultiDragPointerState>? _recognizer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollDirection = axisDirectionToAxis(Scrollable.of(context)!.axisDirection);
  }

  @override
  void dispose() {
    _dragInfo?.dispose();
    super.dispose();
  }

  /// Initiate the dragging of the item at [index] that was started with
  /// the pointer down [event].
  ///
  /// The given [recognizer] will be used to recognize and start the drag
  /// item tracking and lead to either an item reorder, or a cancelled drag.
  ///
  /// Most applications will not use this directly, but will wrap the item
  /// (or part of the item, like a drag handle) in either a
  /// [ReorderableDragStartListener] or [ReorderableDelayedDragStartListener]
  /// which call this for the application.
  void startItemDragReorder({
    required int index,
    required PointerDownEvent event,
    required MultiDragGestureRecognizer<MultiDragPointerState> recognizer,
  }) {
    assert(0 <= index && index < widget.itemCount);
    setState(() {
      if (_reorderingDrag) {
        cancelReorder();
      }
      if (_items.containsKey(index)) {
        _dragItem = _items[index]!;
        _recognizer = recognizer
          ..onStart = _dragStart
          ..addPointer(event);
      }
      // TODO(darrenaustin): What to do if they ask to drag an item we haven't seen?
    });
  }

  /// Cancel any item drag in progress.
  ///
  /// This should be called before any major changes to the item list
  /// occur so that any item drags will not get confused by
  /// changes to the underlying list.
  ///
  /// If no drag is active, this will do nothing.
  void cancelReorder() {
    _dragReset();
  }

  void _registerItem(_ReorderableItemState item) {
    _items[item.index] = item;
  }

  void _unregisterItem(int index) {
    _items.remove(index);
  }

  Drag? _dragStart(Offset position) {
    final _ReorderableItemState item = _dragItem!;

    _insertIndex = item.index;
    _reorderingDrag = true;
    _dragInfo = _DragInfo(
      item: item,
      initialPosition: position,
      scrollDirection: _scrollDirection,
      onUpdate: _dragUpdate,
      onCancel: _dragCancel,
      onEnd: _dragEnd,
      onDropCompleted: _dropCompleted,
      proxyDecorator: widget.proxyDecorator,
      tickerProvider: this,
    );

    final OverlayState overlay = Overlay.of(context)!;
    _overlayEntry = OverlayEntry(builder: _dragInfo!.createProxy);
    overlay.insert(_overlayEntry!);

    _dragInfo!.startDrag();

    item.dragging = true;
    for (final _ReorderableItemState childItem in _items.values) {
      if (childItem == item || !childItem.mounted)
        continue;
      childItem.updateForGap(_insertIndex!, _dragInfo!.itemExtent, false);
    }
    return _dragInfo;
  }

  void _dragUpdate(_DragInfo item, Offset position, Offset delta) {
    setState(() {
      _overlayEntry?.markNeedsBuild();
      _dragUpdateItems();
      _autoScroll();
    });
  }

  void _dragCancel(_DragInfo item) {
    _dragReset();
  }

  void _dragEnd(_DragInfo item) {
    setState(() {
      if (_insertIndex! < widget.itemCount - 1) {
        // Find the location of the item we want to insert before
        final RenderBox itemRenderBox =  _items[_insertIndex!]!.context.findRenderObject()! as RenderBox;
        _finalDropPosition = itemRenderBox.localToGlobal(Offset.zero);
      } else {
        // Inserting into the last spot on the list. If it's the only spot, put
        // it back where it was. Otherwise, grab the second to last and move
        // down by the gap.
        final int itemIndex = _items.length > 1 ? _insertIndex! - 1 : _insertIndex!;
        final RenderBox itemRenderBox =  _items[itemIndex]!.context.findRenderObject()! as RenderBox;
        _finalDropPosition = itemRenderBox.localToGlobal(Offset.zero) + _extentOffset(item.itemExtent, _scrollDirection);
      }
    });
  }

  void _dropCompleted() {
    final int fromIndex = _dragItem!.index;
    final int toIndex = _insertIndex!;
    if (fromIndex != toIndex) {
      widget.onReorder.call(fromIndex, toIndex);
    }
    _dragReset();
  }

  void _dragReset() {
    setState(() {
      if (_reorderingDrag) {
        _reorderingDrag = false;
        _dragItem!.dragging = false;
        _dragItem = null;
        _dragInfo?.dispose();
        _dragInfo = null;
        _resetItemGap();
        _recognizer?.dispose();
        _recognizer = null;
        _overlayEntry?.remove();
        _overlayEntry = null;
        _finalDropPosition = null;
      }
    });
  }

  void _resetItemGap() {
    for (final _ReorderableItemState item in _items.values) {
      item.resetGap();
    }
  }

  void _dragUpdateItems() {
    assert(_reorderingDrag);
    assert(_dragItem != null);
    assert(_dragInfo != null);
    final _ReorderableItemState gapItem = _dragItem!;
    final double gapExtent = _dragInfo!.itemExtent;
    final double proxyItemStart = _offsetExtent(_dragInfo!.dragPosition - _dragInfo!.dragOffset, _scrollDirection);
    final double proxyItemEnd = proxyItemStart + gapExtent;

    int newIndex = _insertIndex!;
    for (final _ReorderableItemState item in _items.values) {
      if (item == gapItem || !item.mounted)
        continue;

      final Rect geometry = item.targetGeometry();
      final double itemStart = _scrollDirection == Axis.vertical ? geometry.top : geometry.left;
      final double itemExtent = _scrollDirection == Axis.vertical ? geometry.height : geometry.width;
      final double itemEnd = itemStart + itemExtent;
      final double itemMiddle = itemStart + itemExtent / 2;

      if (itemStart <= proxyItemStart && proxyItemStart <= itemMiddle) {
        // The start of the proxy is in the beginning half of the item, so
        // we should swap the item with the gap and we are done looking for
        // the new index.
        newIndex = item.index;
        break;

      } else if (itemMiddle <= proxyItemEnd && proxyItemEnd <= itemEnd) {
        // The end of the proxy is in the ending half of the item, so
        // we should swap the item with the gap and we are done looking for
        // the new index.
        newIndex = item.index + 1;
        break;

      } else
        if (itemEnd < proxyItemStart && newIndex < (item.index + 1)) {
        newIndex = item.index + 1;
      } else if (proxyItemEnd < itemStart && newIndex > item.index) {
        newIndex = item.index;
      }
    }

    if (newIndex != _insertIndex) {
      _insertIndex = newIndex;
      for (final _ReorderableItemState item in _items.values) {
        if (item == gapItem || !item.mounted)
          continue;
        item.updateForGap(newIndex, gapExtent, true);
      }
    }
  }

  Future<void> _autoScroll() async {
    if (!_autoScrolling && _dragInfo != null && _dragInfo!.scrollable != null) {
      final ScrollPosition position = _dragInfo!.scrollable!.position;
      double? newOffset;
      const Duration duration = Duration(milliseconds: 14);
      const double step = 1.0;
      const double overDragMax = 20.0;
      const double overDragCoef = 10;

      final RenderBox scrollRenderBox = _dragInfo!.scrollable!.context.findRenderObject()! as RenderBox;
      final Offset scrollOrigin = scrollRenderBox.localToGlobal(Offset.zero);
      final double scrollStart = _offsetExtent(scrollOrigin, _scrollDirection);
      final double scrollEnd = scrollStart + _sizeExtent(scrollRenderBox.size, _scrollDirection);

      final double dragStart = _offsetExtent(_dragInfo!.dragPosition, _scrollDirection);
      final double dragEnd = dragStart + _dragInfo!.itemExtent;
      if (dragStart < scrollStart && position.pixels > position.minScrollExtent) {
        final double overDrag = max(scrollStart - dragStart, overDragMax);
        newOffset = max(position.minScrollExtent, position.pixels - step * overDrag / overDragCoef);
      } else if (dragEnd > scrollEnd && position.pixels < position.maxScrollExtent) {
        final double overDrag = max(dragEnd - scrollEnd, overDragMax);
        newOffset = min(position.maxScrollExtent, position.pixels + step * overDrag / overDragCoef);
      }

      if (newOffset != null && (newOffset - position.pixels).abs() >= 1.0) {
        _autoScrolling = true;
        await position.animateTo(newOffset,
            duration: duration,
            curve: Curves.linear
        );
        _autoScrolling = false;
        if (_dragItem != null) {
          _dragUpdateItems();
          _autoScroll();
        }
      }
    }
  }

  SliverChildDelegate _createDelegate() {
    return SliverChildBuilderDelegate(_itemBuilder, childCount: widget.itemCount + (_reorderingDrag ? 1 : 0));
  }

  Widget _itemBuilder(BuildContext context, int index) {
    if (_dragInfo != null && index >= widget.itemCount) {
      switch (_scrollDirection) {
        case Axis.horizontal:
          return SizedBox(width: _dragInfo!.itemExtent);
        case Axis.vertical:
          return SizedBox(height: _dragInfo!.itemExtent);
      }
    }
    final Widget child = widget.itemBuilder(context, index);
    final OverlayState overlay = Overlay.of(context)!;
    return _ReorderableItem(
      key: _ReorderableItemGlobalKey(child.key!, index, this),
      index: index,
      child: child,
      capturedThemes: InheritedTheme.capture(from: context, to: overlay.context),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasOverlay(context));
    return SliverList(
      delegate: _createDelegate(),
    );
  }
}

class _ReorderableItem extends StatefulWidget {
  const _ReorderableItem({
    required Key key,
    required this.index,
    required this.child,
    required this.capturedThemes,
  }) : super(key: key);

  final int index;
  final Widget child;
  final CapturedThemes capturedThemes;

  @override
  _ReorderableItemState createState() => _ReorderableItemState();
}

class _ReorderableItemState extends State<_ReorderableItem> {
  late SliverReorderableListState _listState;

  Offset _startOffset = Offset.zero;
  Offset _targetOffset = Offset.zero;
  AnimationController? _offsetAnimation;

  Key get key => widget.key!;
  int get index => widget.index;

  bool get dragging => _dragging;
  set dragging(bool dragging) {
    if (mounted) {
      setState(() {
        _dragging = dragging;
      });
    }
  }
  bool _dragging = false;

  @override
  void initState() {
    _listState = SliverReorderableList.of(context);
    _listState._registerItem(this);
    super.initState();
  }

  @override
  void dispose() {
    _offsetAnimation?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _ReorderableItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.key != widget.key || oldWidget.index != widget.index) {
      _listState._unregisterItem(oldWidget.index);
      _listState._registerItem(this);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_dragging) {
      return const SizedBox();
    }
    return Transform(
      transform: Matrix4.translationValues(offset.dx, offset.dy, 0.0),
      child: widget.child,
    );
  }

  @override
  void deactivate() {
    _listState._unregisterItem(widget.index);
    super.deactivate();
  }

  Offset get offset {
    if (_offsetAnimation != null) {
      final double animValue = Curves.easeIn.transform(_offsetAnimation!.value);
      return (_targetOffset - _startOffset) * animValue + _startOffset;
    }
    return _targetOffset;
  }

  void updateForGap(int gapIndex, double gapExtent, bool animate) {
    final Offset newTargetOffset = (gapIndex <= index)
        ? _extentOffset(gapExtent, _listState._scrollDirection)
        : Offset.zero;
    if (newTargetOffset != _targetOffset) {
      _targetOffset = newTargetOffset;
      if (animate) {
        if (_offsetAnimation == null) {
          _offsetAnimation = AnimationController(
            vsync: _listState,
            duration: const Duration(milliseconds: 250),
          )
            ..addListener(_update)
            ..addStatusListener((AnimationStatus status) {
              if (status == AnimationStatus.completed) {
                _startOffset = _targetOffset;
                _offsetAnimation!.dispose();
                _offsetAnimation = null;
              }
            })
            ..forward();
        } else {
          _startOffset = offset;
          _offsetAnimation!.forward(from: 0.0);
        }
      } else {
        if (_offsetAnimation != null) {
          _offsetAnimation!.dispose();
          _offsetAnimation = null;
        }
        _startOffset = _targetOffset;
      }
      _update();
    }
  }

  void resetGap() {
    if (_offsetAnimation != null) {
      _offsetAnimation!.dispose();
      _offsetAnimation = null;
    }
    _startOffset = Offset.zero;
    _targetOffset = Offset.zero;
    _update();
  }

  Rect targetGeometry() {
    final RenderBox itemRenderBox = context.findRenderObject()! as RenderBox;
    final Offset itemPosition = itemRenderBox.localToGlobal(Offset.zero) + _targetOffset;
    return itemPosition & itemRenderBox.size;
  }

  void _update() {
    if (mounted) {
      setState(() {});
    }
  }
}

/// A wrapper widget that will recognize the start of a drag on a by a
/// [PointerDownEvent], and immediately initiate dragging the wrapped
/// item to a new location in a reorderable list.
///
/// See also:
///
///  * [ReorderableDelayedDragStartListener], a similar wrapper that will
///    only recognize the start after a long press event.
///  * [ReorderableList], a widget list that allows the user to reorder
///    its items.
///  * [SliverReorderableList], a sliver list that allows the user to reorder
///    its items.
///  * [ReorderableListView], a material design list that allows the user to
///    reorder its items.
class ReorderableDragStartListener extends StatelessWidget {
  /// Creates a listener for an drag immediately following a pointer down
  /// event over the given child widget.
  ///
  /// This is most commonly used to wrap part of a list item like a drag
  /// handle.
  const ReorderableDragStartListener({
    Key? key,
    required this.child,
    required this.index,
  }) : super(key: key);

  /// The widget for which the application would like to respond to a tap and
  /// drag gesture by starting a reordering drag on a reorderable list.
  final Widget child;

  /// The index of the associated item that will be dragged in the list.
  final int index;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (PointerDownEvent event) => _startDragging(context, event),
      child: child,
    );
  }

  /// Provides the gesture recognizer used to indicate the start of a reordering
  /// drag operation.
  ///
  /// By default this returns an [ImmediateMultiDragGestureRecognizer] but
  /// subclasses can use this to customize the drag start gesture.
  @protected
  MultiDragGestureRecognizer<MultiDragPointerState> createRecognizer({
    Object? debugOwner,
    PointerDeviceKind? kind,
  }) {
    return ImmediateMultiDragGestureRecognizer(
      debugOwner: debugOwner,
      kind: kind,
    );
  }

  void _startDragging(BuildContext context, PointerDownEvent event) {
    final SliverReorderableListState? list = SliverReorderableList.maybeOf(context);
    list?.startItemDragReorder(
        index: index,
        event: event,
        recognizer: createRecognizer(debugOwner: this, kind: event.kind)
    );
  }
}

/// A wrapper widget that will recognize the start of a drag operation by
/// looking for a long press event. Once it is recognized, it will start
/// a drag operation on the wrapped item in the reorderable list.
///
/// See also:
///
///  * [ReorderableDragStartListener], a similar wrapper that will
///    recognize the start of the drag immediately after a pointer down event.
///  * [ReorderableList], a widget list that allows the user to reorder
///    its items.
///  * [SliverReorderableList], a sliver list that allows the user to reorder
///    its items.
///  * [ReorderableListView], a material design list that allows the user to
///    reorder its items.
class ReorderableDelayedDragStartListener extends ReorderableDragStartListener {
  /// Creates a listener for an drag following a long press event over the
  /// given child widget.
  ///
  /// This is most commonly used to wrap an entire list item in a reorderable
  /// list.
  const ReorderableDelayedDragStartListener({
    Key? key,
    required Widget child,
    required int index,
  }) : super(key: key, child: child, index: index);

  @override
  MultiDragGestureRecognizer<MultiDragPointerState> createRecognizer({
    Object? debugOwner,
    PointerDeviceKind? kind,
  }) {
    return DelayedMultiDragGestureRecognizer(
      debugOwner: debugOwner,
      kind: kind,
    );
  }
}

typedef _DragItemUpdate = void Function(_DragInfo item, Offset position, Offset delta);
typedef _DragItemCallback = void Function(_DragInfo item);

class _DragInfo extends Drag {
  _DragInfo({
    required this.item,
    Offset initialPosition = Offset.zero,
    this.scrollDirection = Axis.vertical,
    this.onUpdate,
    this.onEnd,
    this.onCancel,
    this.onDropCompleted,
    this.proxyDecorator,
    required this.tickerProvider,
  }) {
    final RenderBox itemRenderBox = item.context.findRenderObject()! as RenderBox;
    dragPosition = initialPosition;
    dragOffset = itemRenderBox.globalToLocal(initialPosition);
    itemSize = item.context.size!;
    itemExtent = _sizeExtent(itemSize, scrollDirection);
    scrollable = Scrollable.of(item.context);
  }

  final _ReorderableItemState item;
  final Axis scrollDirection;
  final _DragItemUpdate? onUpdate;
  final _DragItemCallback? onEnd;
  final _DragItemCallback? onCancel;
  final VoidCallback? onDropCompleted;
  final ReorderItemProxyDecorator? proxyDecorator;
  final TickerProvider tickerProvider;

  late Offset dragPosition;
  late Offset dragOffset;
  late Size itemSize;
  late double itemExtent;
  ScrollableState? scrollable;
  AnimationController? _proxyAnimation;

  void dispose() {
    _proxyAnimation?.dispose();
  }

  void startDrag() {
    _proxyAnimation = AnimationController(
      vsync: tickerProvider,
      duration: const Duration(milliseconds: 250),
    )
    ..addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.dismissed) {
        _dropCompleted();
      }
    })
    ..forward();
  }

  @override
  void update(DragUpdateDetails details) {
    final Offset delta = _restrictAxis(details.delta, scrollDirection);
    dragPosition += delta;
    onUpdate?.call(this, dragPosition, details.delta);
  }

  @override
  void end(DragEndDetails details) {
    _proxyAnimation!.reverse();
    onEnd?.call(this);
  }

  @override
  void cancel() {
    _proxyAnimation?.dispose();
    _proxyAnimation = null;
    onCancel?.call(this);
  }

  void _dropCompleted() {
    _proxyAnimation?.dispose();
    _proxyAnimation = null;
    onDropCompleted?.call();
  }

  Widget createProxy(BuildContext context) {
    return item.widget.capturedThemes.wrap(
      _DragItemProxy(
        item: item,
        size: itemSize,
        animation: _proxyAnimation!,
        position: dragPosition - dragOffset - _overlayOrigin(context),
        proxyDecorator: proxyDecorator,
      )
    );
  }
}

Offset _overlayOrigin(BuildContext context) {
  final OverlayState overlay = Overlay.of(context)!;
  final RenderBox overlayBox = overlay.context.findRenderObject()! as RenderBox;
  return overlayBox.localToGlobal(Offset.zero);
}

class _DragItemProxy extends StatelessWidget {
  const _DragItemProxy({
    Key? key,
    required this.item,
    required this.position,
    required this.size,
    required this.animation,
    required this.proxyDecorator,
  }) : super(key: key);

  final _ReorderableItemState item;
  final Offset position;
  final Size size;
  final AnimationController animation;
  final ReorderItemProxyDecorator? proxyDecorator;

  @override
  Widget build(BuildContext context) {
    final Widget child = item.widget.child;
    final Widget proxyChild = proxyDecorator?.call(child, item.index, animation.view) ?? child;
    final Offset overlayOrigin = _overlayOrigin(context);

    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          Offset effectivePosition = position;
          final Offset? dropPosition = item._listState._finalDropPosition;
          if (dropPosition != null) {
            effectivePosition = Offset.lerp(dropPosition - overlayOrigin, effectivePosition, Curves.easeOut.transform(animation.value))!;
          }
        return Positioned(
            child: SizedBox(
              width: size.width,
              height: size.height,
              child: child,
            ),
            left: effectivePosition.dx,
            top: effectivePosition.dy,
          );
        },
        child: proxyChild,
    );
  }
}

double _sizeExtent(Size size, Axis scrollDirection) {
  switch (scrollDirection) {
    case Axis.horizontal:
      return size.width;
    case Axis.vertical:
      return size.height;
  }
}

double _offsetExtent(Offset offset, Axis scrollDirection) {
  switch (scrollDirection) {
    case Axis.horizontal:
      return offset.dx;
    case Axis.vertical:
      return offset.dy;
  }
}

Offset _extentOffset(double extent, Axis scrollDirection) {
  switch (scrollDirection) {
    case Axis.horizontal:
      return Offset(extent, 0.0);
    case Axis.vertical:
      return Offset(0.0, extent);
  }
}

Offset _restrictAxis(Offset offset, Axis scrollDirection) {
  switch (scrollDirection) {
    case Axis.horizontal:
      return Offset(offset.dx, 0.0);
    case Axis.vertical:
      return Offset(0.0, offset.dy);
  }
}

// A global key that takes its identity from the object and uses a value of a
// particular type to identify itself.
//
// The difference with GlobalObjectKey is that it uses [==] instead of [identical]
// of the objects used to generate widgets.
@optionalTypeArgs
class _ReorderableItemGlobalKey extends GlobalObjectKey {

  const _ReorderableItemGlobalKey(this.subKey, this.index, this.state) : super(subKey);

  final Key subKey;
  final int index;
  final SliverReorderableListState state;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType)
      return false;
    return other is _ReorderableItemGlobalKey
        && other.subKey == subKey
        && other.index == index
        && other.state == state;
  }

  @override
  int get hashCode => hashValues(subKey, index, state);
}
