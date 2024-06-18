// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';

import 'framework.dart';
import 'lookup_boundary.dart';
import 'notification_listener.dart';
import 'ticker_provider.dart';

// Examples can assume:
// late Color color;
// late BuildContext context;

/// Signature for the callback used by [InkFeature]s to obtain the appropriate [Rect].
typedef RectCallback = Rect Function();

/// {@template flutter.widgets.ink_features.InkController}
/// An interface for creating [InkSplash]es and [InkHighlight]s on an [InkBox].
///
/// Typically obtained via [InkController.of].
/// {@endtemplate}
abstract interface class InkController implements RenderObject {
  /// The closest ancestor ink controller found within the closest
  /// [LookupBoundary].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// InkController inkController = InkController.of(context);
  /// ```
  ///
  /// This method can be expensive (it walks the element tree).
  ///
  /// See also:
  /// * [InkController.maybeOf], which is similar to this method, but returns `null` if
  ///   no [InkController] ancestor is found.
  factory InkController.of(BuildContext context) {
    final InkController? controller = maybeOf(context);
    assert(() {
      if (controller == null) {
        if (LookupBoundary.debugIsHidingAncestorRenderObjectOfType<InkController>(context)) {
          throw FlutterError(
            'InkController.of() was called with a context that does not have access to an InkBox widget.\n'
            'The context provided to InkController.of() does have a InkController ancestor, but it is '
            'hidden by a LookupBoundary. This can happen because you are using a widget that looks '
            'for an InkController ancestor, but no such ancestor exists within the closest LookupBoundary.\n'
            'The context used was:\n'
            '  $context',
          );
        }
        throw FlutterError(
          'InkController.of() was called with a context that does not contain an Inkbox widget.\n'
          'No InkController ancestor could be found starting from the context that was passed to '
          'InkController.of(). This can happen because you are using a widget that looks for a InkController '
          'ancestor, but no such ancestor exists.\n'
          'The context used was:\n'
          '  $context',
        );
      }
      return true;
    }());
    return controller!;
  }

  /// The closest ancestor ink controller found within the closest
  /// [LookupBoundary].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// InkController? inkController = InkController.maybeOf(context);
  /// ```
  ///
  /// This method can be expensive (it walks the element tree).
  ///
  /// See also:
  /// * [InkController.of], which is similar to this method, but asserts if
  ///   no [InkController] ancestor is found.
  static InkController? maybeOf(BuildContext context) {
    return LookupBoundary.findAncestorRenderObjectOfType<InkController>(context);
  }

  /// The color of the surface.
  Color? get color;

  /// The ticker provider used by the controller.
  ///
  /// Ink features that are added to this controller with [addInkFeature] should
  /// use this vsync to drive their animations.
  TickerProvider get vsync;

  /// Adds an [InkFeature], such as an [InkSplash] or an [InkHighlight].
  ///
  /// The ink feature will paint as part of this controller.
  void addInkFeature(InkFeature feature);

  /// Removes an [InkFeature] added by [addInkFeature].
  ///
  /// The ink feature will paint as part of this controller.
  void removeInkFeature(InkFeature feature);

  /// A function called when the controller's layout changes.
  ///
  /// [RenderObject.markNeedsPaint] should be called if there are
  /// any active [InkFeature]s.
  void didChangeLayout();
}

/// {@template flutter.widgets.ink_features.InkBox}
/// This widget allows ink splashes and highlights to be painted on top.
///
/// These [InkFeature]s are typically shown in response to user gestures.
///
/// There are a few reasons that using an `InkBox` might be preferable to
/// a `Material`:
///
/// * A [Decoration] can be added without the [downsides of the `Ink` widget](https://api.flutter.dev/flutter/widgets/Ink-class.html#limitations).
/// * `InkBox` doesn't use [implicit animations](https://docs.flutter.dev/codelabs/implicit-animations),
///   offering more granular control over UI properties.
///   (This is especially helpful when its properties come from values that
///   are already being animated, such as when `Theme.of(context).colorScheme`
///   inherits from a `MaterialApp`'s `AnimatedTheme`.)
/// * If a Flutter app isn't using the [Material design system](https://m3.material.io/),
///   `InkBox` is the easiest way to add [InkFeature]s.
/// {@endtemplate}
///
/// {@tool snippet}
/// Generally, a [InkBox] should be set as the child of widgets that
/// perform clipping and decoration, and it should be the parent of widgets
/// that create ink effects.
///
/// Example:
///
/// ```dart
/// ClipRRect(
///   borderRadius: BorderRadius.circular(8),
///   child: ColoredBox(
///     color: color,
///     child: const InkBox(
///       // add an InkWell here,
///       // or a different child that creates ink effects
///     ),
///   ),
/// );
/// ```
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows how to make a button using an [InkBox].
///
/// ** See code in examples/api/lib/widgets/ink_box/ink_box.0.dart **
/// {@end-tool}
///
/// See also:
/// * [InkController], a specialized [RenderBox] that this widget creates
///   to enable ink effects.
/// * [InkFeature], the class that holds ink effect data.
class InkBox extends StatefulWidget {
  /// {@macro flutter.widgets.ink_features.InkBox}
  const InkBox({super.key, this.color, this.child});

  /// The value assigned to [InkController.color].
  ///
  /// The [InkBox] widget doesn't paint this color, but the [child]
  /// and its descendants can access its value using [InkController.of].
  ///
  /// If non-null, the widget will absorb hit tests.
  final Color? color;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  @override
  State<InkBox> createState() => _InkBoxState();
}

class _InkBoxState extends State<InkBox> with TickerProviderStateMixin {
  final GlobalKey _inkFeatureRenderer = GlobalKey(debugLabel: 'ink renderer');

  @override
  Widget build(BuildContext context) {
    final Color? color = widget.color;
    return NotificationListener<LayoutChangedNotification>(
      onNotification: (LayoutChangedNotification notification) {
        final InkController controller = _inkFeatureRenderer.currentContext!.findRenderObject()! as InkController;
        controller.didChangeLayout();
        return false;
      },
      child: _InkFeatures(
        key: _inkFeatureRenderer,
        absorbHitTest: color != null,
        color: color,
        vsync: this,
        child: widget.child,
      ),
    );
  }
}

/// A visual reaction shown on an [InkBox].
///
/// To add an ink feature, obtain the
/// [InkController] via [InkController.of] and call
/// [InkController.addInkFeature].
abstract class InkFeature {
  /// Initializes fields for subclasses.
  InkFeature({required this.controller, required this.referenceBox, this.onRemoved}) {
    // TODO(polina-c): stop duplicating code across disposables
    // https://github.com/flutter/flutter/issues/137435
    if (kFlutterMemoryAllocationsEnabled) {
      FlutterMemoryAllocations.instance.dispatchObjectCreated(
        library: 'package:flutter/material.dart',
        className: '$InkFeature',
        object: this,
      );
    }
  }

  /// {@macro flutter.widgets.ink_features.InkController}
  final InkController controller;

  /// The render box whose visual position defines the frame of reference
  /// for this ink feature.
  final RenderBox referenceBox;

  /// Called when the ink feature is no longer visible on the material.
  final VoidCallback? onRemoved;

  /// If asserts are enabled, this value tracks whether the feature has been disposed.
  ///
  /// Ensures that [dispose] is only called once, and [paint] is not called afterward.
  bool debugDisposed = false;

  /// Free up the resources associated with this ink feature.
  @mustCallSuper
  void dispose() {
    assert(!debugDisposed);
    assert(() {
      debugDisposed = true;
      return true;
    }());
    // TODO(polina-c): stop duplicating code across disposables
    // https://github.com/flutter/flutter/issues/137435
    if (kFlutterMemoryAllocationsEnabled) {
      FlutterMemoryAllocations.instance.dispatchObjectDisposed(object: this);
    }
    controller.removeInkFeature(this);
    onRemoved?.call();
  }

  /// Computes the [Matrix4] that allows [fromRenderObject] to perform paint
  /// in [toRenderObject]'s coordinate space.
  ///
  /// Typically, this is used to find the transformation to apply to the [controller]
  /// so it matches the [referenceBox].
  ///
  /// Returns null if either [fromRenderObject] or [toRenderObject] is not
  /// in the same render tree, or either of them is in an offscreen subtree
  /// (see [RenderObject.paintsChild]).
  static Matrix4? getPaintTransform(
    RenderObject fromRenderObject,
    RenderObject toRenderObject,
  ) {
    // The paths to fromRenderObject and toRenderObject's common ancestor.
    final List<RenderObject> fromPath = <RenderObject>[fromRenderObject];
    final List<RenderObject> toPath = <RenderObject>[toRenderObject];

    RenderObject from = fromRenderObject;
    RenderObject to = toRenderObject;

    while (!identical(from, to)) {
      final int fromDepth = from.depth;
      final int toDepth = to.depth;

      if (fromDepth >= toDepth) {
        final RenderObject? fromParent = from.parent;
        // Return early if the 2 render objects are not in the same render tree,
        // or either of them is offscreen and thus won't get painted.
        if (fromParent is! RenderObject || !fromParent.paintsChild(from)) {
          return null;
        }
        fromPath.add(fromParent);
        from = fromParent;
      }

      if (fromDepth <= toDepth) {
        final RenderObject? toParent = to.parent;
        if (toParent is! RenderObject || !toParent.paintsChild(to)) {
          return null;
        }
        toPath.add(toParent);
        to = toParent;
      }
    }
    assert(identical(from, to));

    final Matrix4 transform = Matrix4.identity();
    final Matrix4 inverseTransform = Matrix4.identity();

    for (int index = toPath.length - 1; index > 0; index -= 1) {
      toPath[index].applyPaintTransform(toPath[index - 1], transform);
    }
    for (int index = fromPath.length - 1; index > 0; index -= 1) {
      fromPath[index].applyPaintTransform(fromPath[index - 1], inverseTransform);
    }

    final double det = inverseTransform.invert();
    return det != 0 ? (inverseTransform..multiply(transform)) : null;
  }

  /// Determines the appropriate transformation using [getPaintTransform].
  ///
  /// Then, [paintFeature] is creates the ink effect within the [referenceBox].
  void paint(Canvas canvas) {
    assert(referenceBox.attached);
    assert(!debugDisposed);
    final Matrix4? transform = getPaintTransform(controller, referenceBox);
    if (transform != null) {
      paintFeature(canvas, transform);
    }
  }

  /// Override this method to paint the ink feature.
  ///
  /// The transform argument gives the coordinate conversion from the coordinate
  /// system of the canvas to the coordinate system of the [referenceBox].
  @protected
  void paintFeature(Canvas canvas, Matrix4 transform);

  @override
  String toString() => describeIdentity(this);
}

class _RenderInkFeatures extends RenderProxyBox implements InkController {
  _RenderInkFeatures({
    RenderBox? child,
    required this.vsync,
    required this.absorbHitTest,
    this.color,
  }) : super(child);

  // This class should exist in a 1:1 relationship with an _InkState object,
  // since there's no current support for dynamically changing the ticker
  // provider.
  @override
  final TickerProvider vsync;

  // This is here to satisfy the InkController contract.
  // The actual painting of this color is done by a Material (or other
  // ancestor widget).
  @override
  Color? color;

  bool absorbHitTest;

  @visibleForTesting
  List<InkFeature>? get debugInkFeatures => kDebugMode ? _inkFeatures : null;
  List<InkFeature>? _inkFeatures;

  @override
  void addInkFeature(InkFeature feature) {
    assert(!feature.debugDisposed);
    assert(feature.controller == this);
    _inkFeatures ??= <InkFeature>[];
    assert(!_inkFeatures!.contains(feature));
    _inkFeatures!.add(feature);
    markNeedsPaint();
  }

  @override
  void removeInkFeature(InkFeature feature) {
    assert(_inkFeatures != null);
    _inkFeatures!.remove(feature);
    markNeedsPaint();
  }

  @override
  void didChangeLayout() {
    if (_inkFeatures?.isNotEmpty ?? false) {
      markNeedsPaint();
    }
  }

  @override
  bool hitTestSelf(Offset position) => absorbHitTest;

  @override
  void paint(PaintingContext context, Offset offset) {
    final List<InkFeature>? inkFeatures = _inkFeatures;
    if (inkFeatures != null && inkFeatures.isNotEmpty) {
      final Canvas canvas = context.canvas;
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.clipRect(Offset.zero & size);
      for (final InkFeature inkFeature in inkFeatures) {
        inkFeature.paint(canvas);
      }
      canvas.restore();
    }
    assert(inkFeatures == _inkFeatures);
    super.paint(context, offset);
  }
}

class _InkFeatures extends SingleChildRenderObjectWidget {
  const _InkFeatures({
    super.key,
    this.color,
    required this.vsync,
    required this.absorbHitTest,
    super.child,
  });

  final Color? color;

  /// This [TickerProvider] will always be an [_InkBoxState] object.
  ///
  /// This relationship is 1:1 and cannot change for the lifetime of the
  /// widget's state.
  final TickerProvider vsync;

  final bool absorbHitTest;

  @override
  InkController createRenderObject(BuildContext context) {
    return _RenderInkFeatures(
      color: color,
      absorbHitTest: absorbHitTest,
      vsync: vsync,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderInkFeatures renderObject) {
    renderObject
      ..color = color
      ..absorbHitTest = absorbHitTest;
    assert(vsync == renderObject.vsync);
  }
}

/// An ink feature that displays a [color] "splash" in response to a user
/// gesture that can be confirmed or canceled.
///
/// Subclasses call [confirm] when an input gesture is recognized. For
/// example a press event might trigger an ink feature that's confirmed
/// when the corresponding up event is seen.
///
/// Subclasses call [cancel] when an input gesture is aborted before it
/// is recognized. For example a press event might trigger an ink feature
/// that's canceled when the pointer is dragged out of the reference
/// box.
///
/// The [InkWell] and [InkResponse] widgets generate instances of this
/// class.
abstract class InteractiveInkFeature extends InkFeature {
  /// Creates an InteractiveInkFeature.
  InteractiveInkFeature({
    required super.controller,
    required super.referenceBox,
    required Color color,
    ShapeBorder? customBorder,
    super.onRemoved,
  }) : _color = color,
       _customBorder = customBorder;

  /// Called when the user input that triggered this feature's appearance was confirmed.
  ///
  /// Typically causes the ink to propagate faster across the surface. By default this
  /// method does nothing.
  void confirm() {}

  /// Called when the user input that triggered this feature's appearance was canceled.
  ///
  /// Typically causes the ink to gradually disappear. By default this method does
  /// nothing.
  void cancel() {}

  /// The ink's color.
  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (value == _color) {
      return;
    }
    _color = value;
    controller.markNeedsPaint();
  }

  /// The ink's optional custom border.
  ShapeBorder? get customBorder => _customBorder;
  ShapeBorder? _customBorder;
  set customBorder(ShapeBorder? value) {
    if (value == _customBorder) {
      return;
    }
    _customBorder = value;
    controller.markNeedsPaint();
  }

  /// Draws an ink splash or ink ripple on the passed in [Canvas].
  ///
  /// The [transform] argument is the [Matrix4] transform that typically
  /// shifts the coordinate space of the canvas to the space in which
  /// the ink circle is to be painted.
  ///
  /// [center] is the [Offset] from origin of the canvas where the center
  /// of the circle is drawn.
  ///
  /// [paint] takes a [Paint] object that describes the styles used to draw the ink circle.
  /// For example, [paint] can specify properties like color, strokewidth, colorFilter.
  ///
  /// [radius] is the radius of ink circle to be drawn on canvas.
  ///
  /// [clipCallback] is the callback used to obtain the [Rect] used for clipping the ink effect.
  /// If [clipCallback] is null, no clipping is performed on the ink circle.
  ///
  /// Clipping can happen in 3 different ways:
  ///  1. If [customBorder] is provided, it is used to determine the path
  ///     for clipping.
  ///  2. If [customBorder] is null, and [borderRadius] is provided, the canvas
  ///     is clipped by an [RRect] created from [clipCallback] and [borderRadius].
  ///  3. If [borderRadius] is the default [BorderRadius.zero], then the [Rect] provided
  ///      by [clipCallback] is used for clipping.
  ///
  /// [textDirection] is used by [customBorder] if it is non-null. This allows the [customBorder]'s path
  /// to be properly defined if it was the path was expressed in terms of "start" and "end" instead of
  /// "left" and "right".
  ///
  /// For examples on how the function is used, see [InkSplash] and [InkRipple].
  @protected
  void paintInkCircle({
    required Canvas canvas,
    required Matrix4 transform,
    required Paint paint,
    required Offset center,
    required double radius,
    TextDirection? textDirection,
    ShapeBorder? customBorder,
    BorderRadius borderRadius = BorderRadius.zero,
    RectCallback? clipCallback,
  }) {
    final Offset? originOffset = MatrixUtils.getAsTranslation(transform);
    canvas.save();
    if (originOffset == null) {
      canvas.transform(transform.storage);
    } else {
      canvas.translate(originOffset.dx, originOffset.dy);
    }
    if (clipCallback != null) {
      final Rect rect = clipCallback();
      if (customBorder != null) {
        canvas.clipPath(customBorder.getOuterPath(rect, textDirection: textDirection));
      } else if (borderRadius != BorderRadius.zero) {
        canvas.clipRRect(RRect.fromRectAndCorners(
          rect,
          topLeft: borderRadius.topLeft, topRight: borderRadius.topRight,
          bottomLeft: borderRadius.bottomLeft, bottomRight: borderRadius.bottomRight,
        ));
      } else {
        canvas.clipRect(rect);
      }
    }
    canvas.drawCircle(center, radius, paint);
    canvas.restore();
  }
}


/// An encapsulation of an [InteractiveInkFeature] constructor used by
/// [InkWell], [InkResponse], and [ThemeData].
///
/// Interactive ink feature implementations should provide a static const
/// `splashFactory` value that's an instance of this class. The `splashFactory`
/// can be used to configure an [InkWell], [InkResponse] or [ThemeData].
///
/// See also:
///
///  * [InkSplash.splashFactory]
///  * [InkRipple.splashFactory]
abstract class InteractiveInkFeatureFactory {
  /// Abstract const constructor. This constructor enables subclasses to provide
  /// const constructors so that they can be used in const expressions.
  ///
  /// Subclasses should provide a const constructor.
  const InteractiveInkFeatureFactory();

  /// The factory method.
  ///
  /// Subclasses should override this method to return a new instance of an
  /// [InteractiveInkFeature].
  @factory
  InteractiveInkFeature create({
    required InkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  });
}
