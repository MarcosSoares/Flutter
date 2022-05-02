// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:vector_math/vector_math_64.dart';

import 'layer.dart';
import 'object.dart';

/// The result after handling a [SelectionEvent].
///
/// This is used by the [SelectionContainer] to determine how a selection
/// expands across its [Selectable] children.
enum SelectionResult {
  /// There is nothing left to select forward, and further selection should
  /// extend to the next [Selectable] in screen order.
  next,
  /// Selection does not reach this [Selectable] and should look at the
  /// previous [Selectable] in screen order.
  previous,
  /// Selection ends in this [Selectable].
  ///
  /// Part of the [Selectable] may or may not be selected, but there are still
  /// content to select forward or backward.
  end,
  /// The result can't be determined in this frame.
  ///
  /// This is typically used when the subtree is scrolling to reveal more content.
  pending,
  /// There is no result for the selection event.
  ///
  /// This is used when the a selection result is not applicable, e.g.
  /// [SelectAllSelectionEvent], [ClearSelectionEvent], and
  /// [SelectWordSelectionEvent].
  none,
}

/// The abstract interface to handle selection events.
///
/// {@template flutter.rendering.SelectionHandler}
/// This class returns a [SelectionGeometry] as its [value], and is responsible
/// to notify its listener when its selection geometry has changed as the result
/// of receiving selection events.
/// {@endtemplate}
abstract class SelectionHandler implements ValueListenable<SelectionGeometry> {
  /// Marks this handler to be responsible for painting leader layers for the
  /// selection handles.
  ///
  /// This handler is responsible for painting the leader layers with the
  /// given layer links if they are not null. It is possible that only one layer
  /// is non-null if this handler is only responsible for painting one layer
  /// link.
  ///
  /// The `startHandle` needs to be placed at the visual location of selection
  /// start, the `endHandle` needs to be placed at the visual location of selection
  /// end
  void pushHandleLayers(LayerLink? startHandle, LayerLink? endHandle);

  /// Gets the selected content in this object.
  ///
  /// Return `null` if nothing is selected.
  SelectedContent? getSelectedContent();

  /// Handles the [SelectionEvent] sent to this object.
  ///
  /// The subclasses need to update their selections or delegate the
  /// [SelectionEvent]s to its subtree.
  ///
  /// The `event`s are subclasses of [SelectionEvent]. Use runtime type check to
  /// determine what kinds of event are dispatched to this handler and handle
  /// them accordingly.
  SelectionResult dispatchSelectionEvent(SelectionEvent event);
}

/// The selected content in a [Selectable].
class SelectedContent {
  /// Creates a selected content object.
  ///
  /// Only supports plain text.
  const SelectedContent({required this.plainText});

  /// The selected content in plain text format.
  final String plainText;
}

/// A mixin that can be selected by users when under a [SelectionArea] widget.
///
/// This object receives selection events and the [value] must reflect the
/// current selection in this [Selectable]. The object must also notify its
/// listener if the [value] ever changes.
///
/// This object is responsible for drawing selection highlight.
///
/// In order to receive the selection event, the mixer need to register
/// themselves to [SelectionRegistrar]s. Use the
/// [SelectionRegistrarScope.maybeOf] to get the the selection registrar, and
/// mix the [SelectionRegistrant] to subscribe to the [SelectionRegistrar]
/// automatically.
///
/// The mixer also need to paints [LayerLink]s of selection handles in a
/// mobile application.
///
/// {@macro flutter.rendering.SelectionHandler}
///
/// See also:
///  * [SelectionArea]: which provides the overview of selection system.
mixin Selectable implements SelectionHandler {
  /// {@macro flutter.rendering.RenderObject.getTransformTo}
  Matrix4 getTransformTo(RenderObject? ancestor);

  /// The size of this [Selectable].
  Size get size;

  /// The dispose method to enable mixer to use [SelectionRegistrant].
  void dispose();
}

/// A mixin to auto-register the mixer to the [registrar].
///
/// To use this mixin, the mixer needs to set the [registrar] to the
/// [SelectionRegistrar] it wants to register to.
///
/// This mixin only registers the mixer with the [registrar] if the
/// [SelectionGeometry.hasContent] returned by the mixer is true.
mixin SelectionRegistrant on Selectable {
  /// The [SelectionRegistrar] the mixer will be or is registered to.
  ///
  /// This [Selectable] only registers mixer if the
  /// [SelectionGeometry.hasContent] returned by the [Selectable] is true.
  SelectionRegistrar? get registrar => _registrar;
  SelectionRegistrar? _registrar;
  set registrar(SelectionRegistrar? value) {
    if (value == _registrar)
      return;
    if (value == null) {
      // when registrar go from non-null to null;
      removeListener(_updateSelectionRegistrarSubscription);
    } else if (_registrar == null) {
      // when registrar go from null to non-null;
      addListener(_updateSelectionRegistrarSubscription);
    }
    _removeSelectionRegistrarSubscription();
    _registrar = value;
    _updateSelectionRegistrarSubscription();
  }

  @override
  void dispose() {
    _removeSelectionRegistrarSubscription();
    super.dispose();
  }

  bool _subscribedToSelectionRegistrar = false;
  void _updateSelectionRegistrarSubscription() {
    if (_registrar == null) {
      _subscribedToSelectionRegistrar = false;
      return;
    }
    if (_subscribedToSelectionRegistrar && !value.hasContent) {
      _registrar!.remove(this);
      _subscribedToSelectionRegistrar = false;
    } else if (!_subscribedToSelectionRegistrar && value.hasContent) {
      _registrar!.add(this);
      _subscribedToSelectionRegistrar = true;
    }
  }

  void _removeSelectionRegistrarSubscription() {
    if (_subscribedToSelectionRegistrar) {
      _registrar!.remove(this);
      _subscribedToSelectionRegistrar = false;
    }
  }
}

/// A utility class that provides useful methods for handling selection events.
class SelectionUtil {
  SelectionUtil._();

  /// Determine [SelectionResult] purely based on the target rectangle.
  ///
  /// This method only returns [SelectionResult.previous] or
  /// [SelectionResult.next]. This is useful when the drag offset is outside of
  /// the target rectangle or the target does not contain any selectable
  /// contents; therefore, the selection can't end in this [Selectable].
  static SelectionResult selectionBasedOnRect(Rect targetRect, Offset point) {
    if (point.dy < targetRect.top)
      return SelectionResult.previous;
    if (point.dy > targetRect.bottom)
      return SelectionResult.next;
    return point.dx >= targetRect.right
        ? SelectionResult.next
        : SelectionResult.previous;
  }

  /// Adjust the dragging offset based on target rect.
  ///
  /// This method moves the offsets to be within the target rect in case they are
  /// outside the rect.
  ///
  /// This is used in the case where a drag happens outside of the rectangle
  /// of a [Selectable].
  ///
  /// The logic works as the following:
  ///
  ///     Area 1
  ///
  ///            +============+ - - - - - -
  ///            | Rect       |
  ///  - - - - - +============+
  ///                              Area 2
  ///
  /// For points inside the rect:
  ///   Their effective locations are unchanged.
  ///
  /// For points in Area 1:
  ///   Move them to top-left of the rect if text direction is ltr, or top-right
  ///   if rtl.
  ///
  /// For points in Area 2:
  ///   Move them to bottom-right of the rect if text direction is ltr, or
  ///   bottom-left if rtl.
  static Offset adjustDragOffset(Rect targetRect, Offset point, {TextDirection direction = TextDirection.ltr}) {
    if (targetRect.contains(point)) {
      return point;
    }
    if (point.dy <= targetRect.top ||
        point.dy <= targetRect.bottom && point.dx <= targetRect.left) {
      // Area 1
      return direction == TextDirection.ltr ? targetRect.topLeft : targetRect.topRight;
    } else {
      // Area 2
      return direction == TextDirection.ltr ? targetRect.bottomRight : targetRect.bottomLeft;
    }
  }
}

/// The type of selection event.
///
/// Used by [SelectionEvent.type] to distinguish different types of events.
enum SelectionEventType {
  /// An event to indicate the selection start edge has changed.
  ///
  /// Used by [SelectionEdgeUpdateEvent].
  startEdgeUpdate,

  /// An event to indicate the selection end edge has changed.
  ///
  /// Used by [SelectionEdgeUpdateEvent].
  endEdgeUpdate,

  /// An event to clear the current selection.
  ///
  /// Used by [ClearSelectionEvent].
  clear,

  /// An event to select all the available content.
  ///
  /// Used by [SelectAllSelectionEvent].
  selectAll,

  /// An event to select a word at the location.
  ///
  /// Used by [SelectWordSelectionEvent].
  selectWord,
}

/// An abstract base class for selection events.
///
/// This should not be directly used. To handle a selection event, it should
/// be downcast to a specific subclass. One can use [type] to look up which
/// subclasses to downcast to.
///
/// See also:
/// * [SelectAllSelectionEvent], for events to select all contents.
/// * [ClearSelectionEvent], for events to clear selections.
/// * [SelectWordSelectionEvent], for events to select words at the locations.
/// * [SelectionEdgeUpdateEvent], for events to update selection edges.
/// * [SelectionEventType], for determining the subclass types.
abstract class SelectionEvent {
  const SelectionEvent._(this.type);

  /// The type of this selection event.
  final SelectionEventType type;
}

/// Selects all selectable contents.
///
/// This event can be sent as the result of keyboard select-all, i.e.
/// ctrl + A, or cmd + A in macOS.
class SelectAllSelectionEvent extends SelectionEvent {
  /// Creates a select all selection event.
  const SelectAllSelectionEvent(): super._(SelectionEventType.selectAll);
}

/// Clear the selection from the [Selectable] and remove any existing
/// highlight as if there is no selection at all.
class ClearSelectionEvent extends SelectionEvent {
  /// Create a clear selection event.
  const ClearSelectionEvent(): super._(SelectionEventType.clear);
}

/// Select the whole word at the location.
///
/// This event can be sent as the result of mobile long press selection.
class SelectWordSelectionEvent extends SelectionEvent {
  /// Creates a select word event at the [globalPosition].
  const SelectWordSelectionEvent({required this.globalPosition}): super._(SelectionEventType.selectWord);

  /// The position in global coordinates to select word at.
  final Offset globalPosition;
}

/// An abstract subclass for all of the selection edge related selection events.
///
/// This event is dispatched when the framework detects [DragStartDetails] in
/// [SelectionArea]'s gesture recognizer for mouse devices, or the selection
/// handles have been dragged to a new location. The [globalPosition]
/// contains the location of the selection edge.
class SelectionEdgeUpdateEvent extends SelectionEvent {
  /// Creates a selection start edge update event.
  ///
  /// The [globalPosition] contains the location of the selection start edge.
  const SelectionEdgeUpdateEvent.forStart({
    required this.globalPosition
  }) : super._(SelectionEventType.startEdgeUpdate);

  /// Creates a selection end edge update event.
  ///
  /// The [globalPosition] contains the new location of the selection end edge.
  const SelectionEdgeUpdateEvent.forEnd({
    required this.globalPosition
  }) : super._(SelectionEventType.endEdgeUpdate);

  /// The new location of the selection edge.
  final Offset globalPosition;

  @override
  String toString() {
    return '${objectRuntimeType(this, 'SelectionEdgeUpdateEvent')}(offset: $globalPosition)';
  }
}

/// A registrar that keeps track of [Selectable]s in the subtree.
///
/// A [Selectable] is only included in the selection event loop if they are
/// registered with its immediate [SelectionRegistrar] in its ancestor chain.
///
/// Use [SelectionRegistrarScope.maybeOf] to get the immediate [SelectionRegistrar]
/// in the ancestor chain above the build context.
///
/// See also:
///  * [SelectionRegistrarScope], which hosts the [SelectionRegistrar] for the
///    subtree.
///  * [SelectionRegistrant], which auto registers the object with the mixin to
///    [SelectionRegistrar].
abstract class SelectionRegistrar {
  /// Adds the [selectable] into the registrar.
  ///
  /// A [Selectable] must register with the [SelectionRegistrar] in order to
  /// receive selection events.
  void add(Selectable selectable);

  /// Remove the [selectable] from the registrar.
  ///
  /// A [Selectable] must unregister itself if it is removed from the rendering
  /// tree.
  void remove(Selectable selectable);
}

/// The status that indicates whether and how a selection is collapsed.
///
/// A collapsed selection means the selection starts and ends at the same
/// location.
///
/// For example if {} represent the selection edges:
///   'ab{cd}', the collapsing status is [uncollapsed].
///   'ab{}cd', the collapsing status is [collapsed].
///   '{}abcd', the collapsing status is [collapsed].
///   'abcd{}', the collapsing status is [collapsed].
///   'abcd', the collapsing status is [none].
enum SelectionStatus {
  /// The selection is not collapsed.
  uncollapsed,

  /// The selection is collapsed.
  collapsed,

  /// No selection.
  none,
}

/// The geometry of the current selection.
///
/// This includes details such as the location of the selection start or end,
/// line height, etc. This information is used for drawing selection handles
/// for mobile platforms.
///
/// The positions in geometry are in local coordinate.
@immutable
class SelectionGeometry {
  /// Creates a selection geometry object with the input.
  ///
  /// the [startSelectionPoint] and [endSelectionPoint] must not be null.
  const SelectionGeometry({
    this.startSelectionPoint,
    this.endSelectionPoint,
    required this.status,
    required this.hasContent,
  }) : assert((startSelectionPoint == null && endSelectionPoint == null) || status != SelectionStatus.none);

  /// The geometry information at the selection start.
  ///
  /// This information is used for drawing mobile selections. The
  /// [SelectionPoint.localPosition] of the selection start is usually at the start
  /// of the selection highlight at where the start selection handle should be
  /// drawn.
  ///
  /// The [SelectionPoint.handleType] should be [TextSelectionHandleType.left]
  /// for forward selection or [TextSelectionHandleType.right] for backward
  /// selection in most cases.
  ///
  /// Can be null if the selection end is offstage, for example, when the
  /// selection is outside of the viewport or is kept alive by a scrollable.
  final SelectionPoint? startSelectionPoint;

  /// The geometry information at the selection end.
  ///
  /// This information is used for drawing mobile selections. The
  /// [SelectionPoint.localPosition] of the selection end is usually at the end
  /// of the selection highlight at where the end selection handle should be
  /// drawn.
  ///
  /// The [SelectionPoint.handleType] should be [TextSelectionHandleType.right]
  /// for forward selection or [TextSelectionHandleType.left] for backward
  /// selection in most cases.
  ///
  /// Can be null if the selection end is offstage, for example, when the
  /// selection is outside of the viewport or is kept alive by a scrollable.
  final SelectionPoint? endSelectionPoint;

  /// The status of ongoing selection in the [Selectable] or [SelectionHandler].
  final SelectionStatus status;

  /// Whether there is any selectable content in the [Selectable] or
  /// [SelectionHandler].
  final bool hasContent;

  /// Whether there is an ongoing selection.
  bool get hasSelection => status != SelectionStatus.none;

  /// Makes a copy of this object with the given values updated.
  SelectionGeometry copyWith({
    SelectionPoint? startSelectionPoint,
    SelectionPoint? endSelectionPoint,
    SelectionStatus? status,
    bool? hasContent,
  }) {
    return SelectionGeometry(
      startSelectionPoint: startSelectionPoint ?? this.startSelectionPoint,
      endSelectionPoint: endSelectionPoint ?? this.endSelectionPoint,
      status: status ?? this.status,
      hasContent: hasContent ?? this.hasContent,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other))
      return true;
    if (other.runtimeType != runtimeType)
      return false;
    return other is SelectionGeometry
        && other.startSelectionPoint == startSelectionPoint
        && other.endSelectionPoint == endSelectionPoint
        && other.status == status
        && other.hasContent == hasContent;
  }

  @override
  int get hashCode {
    return hashValues(
      startSelectionPoint,
      endSelectionPoint,
      status,
      hasContent,
    );
  }
}

/// The geometry information of a selection point.
@immutable
class SelectionPoint {
  /// Creates a selection point object.
  ///
  /// All the properties must not be null.
  const SelectionPoint({
    required this.localPosition,
    required this.lineHeight,
    required this.handleType,
  }) : assert(localPosition != null),
       assert(lineHeight != null),
       assert(handleType != null);

  /// The position of the selection point in the local coordinates of the
  /// containing [Selectable].
  final Offset localPosition;

  /// The line height at the selection point.
  final double lineHeight;

  /// The selection handle type that should be used at the selection point.
  ///
  /// This is used for building the mobile selection handle.
  final TextSelectionHandleType handleType;

  @override
  bool operator ==(Object other) {
    if (identical(this, other))
      return true;
    if (other.runtimeType != runtimeType)
      return false;
    return other is SelectionPoint
        && other.localPosition == localPosition
        && other.lineHeight == lineHeight
        && other.handleType == handleType;
  }

  @override
  int get hashCode {
    return hashValues(
      localPosition,
      lineHeight,
      handleType,
    );
  }
}

/// The type of selection handle to be displayed.
///
/// With mixed-direction text, both handles may be the same type. Examples:
///
/// * LTR text: 'the &lt;quick brown&gt; fox':
///
///   The '&lt;' is drawn with the [left] type, the '&gt;' with the [right]
///
/// * RTL text: 'XOF &lt;NWORB KCIUQ&gt; EHT':
///
///   Same as above.
///
/// * mixed text: '&lt;the NWOR&lt;B KCIUQ fox'
///
///   Here 'the QUICK B' is selected, but 'QUICK BROWN' is RTL. Both are drawn
///   with the [left] type.
///
/// See also:
///
///  * [TextDirection], which discusses left-to-right and right-to-left text in
///    more detail.
enum TextSelectionHandleType {
  /// The selection handle is to the left of the selection end point.
  left,

  /// The selection handle is to the right of the selection end point.
  right,

  /// The start and end of the selection are co-incident at this point.
  collapsed,
}
