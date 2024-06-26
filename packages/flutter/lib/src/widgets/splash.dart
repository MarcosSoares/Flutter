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

/// Signature for the callback used by [SplashEffect]s to obtain the appropriate [Rect].
typedef RectCallback = Rect Function();

/// An effect shown on a [SplashBox].
///
/// This class is only extended directly for non-animated effects,
/// such as [InkDecoration]. For a [SplashEffect] that reacts to user input,
/// consider using an instance of [Splash].
///
/// To add a splash, obtain the [SplashController] via [Splash.of]
/// and call [SplashController.addSplash].
abstract class SplashEffect {
  /// Initializes fields for subclasses.
  SplashEffect({required this.controller, required this.referenceBox, this.onRemoved}) {
    // TODO(polina-c): stop duplicating code across disposables
    // https://github.com/flutter/flutter/issues/137435
    if (kFlutterMemoryAllocationsEnabled) {
      FlutterMemoryAllocations.instance.dispatchObjectCreated(
        library: 'package:flutter/widgets.dart',
        className: '$SplashEffect',
        object: this,
      );
    }
  }

  /// {@macro flutter.widgets.splash.SplashController}
  final SplashController controller;

  /// The render box whose visual position defines the splash effect's
  /// frame of reference.
  final RenderBox referenceBox;

  /// Called when the splash is no longer visible on the material.
  final VoidCallback? onRemoved;

  /// If asserts are enabled, this value tracks whether the feature has been disposed.
  ///
  /// Ensures that [dispose] is only called once, and [paint] is not called afterward.
  bool debugDisposed = false;

  /// Frees up the splash effect's associated resources.
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
    controller.removeSplash(this);
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
  /// Then, [paintFeature] creates the [SplashEffect] effect within the [referenceBox].
  void paint(Canvas canvas) {
    assert(referenceBox.attached);
    assert(!debugDisposed);
    final Matrix4? transform = getPaintTransform(controller, referenceBox);
    if (transform != null) {
      paintFeature(canvas, transform);
    }
  }

  /// Override this method to paint the splash effect.
  ///
  /// The transform argument gives the coordinate conversion from the coordinate
  /// system of the canvas to the coordinate system of the [referenceBox].
  @protected
  void paintFeature(Canvas canvas, Matrix4 transform);

  @override
  String toString() => describeIdentity(this);
}

/// A splash of [color] shown in response to a user gesture that
/// can be confirmed or canceled.
///
/// Subclasses call [confirm] when an input gesture is recognized. For
/// example, a press event might trigger a [SplashEffect] effect that's confirmed
/// when the corresponding up event is seen.
///
/// Subclasses call [cancel] when an input gesture is aborted before it
/// is recognized. For example, a press event might trigger a canceled
/// [SplashEffect] effect when the pointer is dragged out of the reference box.
///
/// The [InkWell] and [InkResponse] widgets generate instances of this
/// class.
abstract class Splash extends SplashEffect {
  /// Creates an interactive splash effect.
  Splash({
    required super.controller,
    required super.referenceBox,
    required Color color,
    ShapeBorder? customBorder,
    super.onRemoved,
  }) : _color = color,
       _customBorder = customBorder;

  /// The closest ancestor [SplashController] found within the closest
  /// [LookupBoundary].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// SplashController splashController = Splash.of(context);
  /// ```
  ///
  /// This method can be expensive (it walks the element tree).
  ///
  /// See also:
  /// * [Splash.maybeOf], which is similar to this method, but returns `null` if
  ///   no [SplashController] ancestor is found.
  static SplashController of(BuildContext context) {
    final SplashController? controller = maybeOf(context);
    assert(() {
      if (controller == null) {
        if (LookupBoundary.debugIsHidingAncestorRenderObjectOfType<SplashController>(context)) {
          throw FlutterError(
            'Splash.of() was called with a context that does not have access to a SplashController.\n'
            'The context provided to Splash.of() does have a SplashController ancestor, but it is '
            'hidden by a LookupBoundary. This can happen because you are using a widget that looks '
            'for an SplashController ancestor, but no such ancestor exists within the closest LookupBoundary.\n'
            'The context used was:\n'
            '  $context',
          );
        }
        throw FlutterError(
          'Splash.of() was called with a context that does not contain a SplashController.\n'
          'No SplashController ancestor could be found starting from the context that was passed to '
          'Splash.of(). This can happen because you are using a widget that looks for a SplashController '
          'ancestor, but no such ancestor exists.\n'
          'The context used was:\n'
          '  $context',
        );
      }
      return true;
    }());
    return controller!;
  }

  /// The closest ancestor [SplashController] found within the closest
  /// [LookupBoundary].
  ///
  /// Typical usage is as follows:
  ///
  /// ```dart
  /// SplashController? splashController = Splash.maybeOf(context);
  /// ```
  ///
  /// This method can be expensive (it walks the element tree).
  ///
  /// See also:
  /// * [Splash.of], which is similar to this method, but asserts if
  ///   no [SplashController] ancestor is found.
  static SplashController? maybeOf(BuildContext context) {
    return LookupBoundary.findAncestorRenderObjectOfType<SplashController>(context);
  }

  /// Called when the user input that triggered this feature's appearance was confirmed.
  ///
  /// Typically causes the [Splash] to propagate faster across the surface.
  /// By default this method does nothing.
  void confirm() {}

  /// Called when the user input that triggered this feature's appearance was canceled.
  ///
  /// Typically causes the [Splash] to gradually disappear.
  /// By default this method does nothing.
  void cancel() {}

  /// A (typically translucent) color used for this [Splash].
  Color get color => _color;
  Color _color;
  set color(Color value) {
    if (value == _color) {
      return;
    }
    _color = value;
    controller.markNeedsPaint();
  }

  /// A [ShapeBorder] that may optionally be applied to the [Splash].
  ShapeBorder? get customBorder => _customBorder;
  ShapeBorder? _customBorder;
  set customBorder(ShapeBorder? value) {
    if (value == _customBorder) {
      return;
    }
    _customBorder = value;
    controller.markNeedsPaint();
  }

  /// Draws a [Splash] on the provided [Canvas].
  ///
  /// The [transform] argument is the [Matrix4] transform that typically
  /// shifts the coordinate space of the canvas to the space in which
  /// the circle is to be painted.
  ///
  /// If a [customBorder] is provided, then it (along with the [textDirection]) will
  /// be used to create a path used to clip the effect.
  ///
  /// Otherwise, the [clipCallback] clips the splash to a [RRect] (created by
  /// applying the [borderRadius] to its result).
  ///
  /// If both [customBorder] and [clipCallback] are null, no clipping takes place.
  ///
  /// For examples on how the function is used, see [InkSplash] and [InkRipple].
  @protected
  void paintCircle({
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

  /// Draws an ink circle on the provided [Canvas].
  @protected
  @Deprecated(
    'Use paintCircle instead. '
    '"Splash effects" no longer rely on a MaterialInkController. '
    'This feature was deprecated after v3.23.0-0.1.pre.',
  )
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
    return paintCircle(
      canvas: canvas,
      transform: transform,
      paint: paint,
      center: center,
      radius: radius,
      textDirection: textDirection,
      customBorder: customBorder,
      borderRadius: borderRadius,
      clipCallback: clipCallback,
    );
  }

}


/// An encapsulation of a [Splash] constructor used by
/// [InkWell], [InkResponse], and [ThemeData].
///
/// [Splash] implementations should provide a static const
/// `splashFactory` value that's an instance of this class. The `splashFactory`
/// can be used to configure an [InkWell], [InkResponse] or [ThemeData].
///
/// See also:
///
///  * [InkSplash.splashFactory]
///  * [InkRipple.splashFactory]
abstract class SplashFactory {
  /// SplashFactory subclasses should provide a const constructor.
  ///
  /// There is no benefit to extending this class, but an abstract `const`
  /// constructor is included for backward compatibility.
  const SplashFactory();

  /// The factory method.
  ///
  /// Subclasses should override this method to return a new instance of a
  /// [Splash].
  @factory
  Splash create({
    required SplashController controller,
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

/// {@template flutter.widgets.splash.SplashController}
/// An interface for creating [SplashEffect] effects on a [SplashBox].
///
/// Typically obtained via [Splash.of].
/// {@endtemplate}
abstract interface class SplashController implements RenderObject {
  /// The color of the surface.
  Color? get color;

  /// The ticker provider used by the controller.
  ///
  /// The [SplashEffect]es added to this controller with [addSplash] should
  /// use this vsync to drive their animations.
  TickerProvider get vsync;

  /// Adds an [InkFeature], such as an [InkSplash] or an [InkHighlight].
  ///
  /// The ink feature will paint as part of this controller.
  @Deprecated(
    'Use addSplash instead. '
    '"Splash effects" no longer rely on a MaterialInkController. '
    'This feature was deprecated after v3.23.0-0.1.pre.',
  )
  void addInkFeature(SplashEffect feature);

  /// Adds a [SplashEffect], such as an [InkSplash] or an [InkHighlight].
  ///
  /// The splash will paint as part of this controller.
  void addSplash(SplashEffect splash);

  /// Removes a [SplashEffect] added by [addSplash].
  void removeSplash(SplashEffect splash);

  /// A function called when the controller's layout changes.
  ///
  /// [RenderBox.markNeedsPaint] should be called if there are
  /// any active [SplashEffect]es.
  void didChangeLayout();
}

/// {@template flutter.widgets.splash.SplashBox}
/// This widget allows [SplashEffect]es to be painted on top, typically
/// in response to user gestures.
///
/// There are a few reasons that using a `SplashBox` might be preferred
/// over a `Material`:
///
/// * A [Decoration] can be added without the [downsides of the `Ink` widget](https://api.flutter.dev/flutter/widgets/Ink-class.html#limitations).
/// * `SplashBox` doesn't use [implicit animations](https://docs.flutter.dev/codelabs/implicit-animations),
///   offering more granular control over UI properties.
///   (This is especially helpful when its properties come from values that
///   are already being animated, such as when `Theme.of(context).colorScheme`
///   inherits from a `MaterialApp`'s `AnimatedTheme`.)
/// * If a Flutter app isn't using the [Material design system](https://m3.material.io/),
///   `SplashBox` is the easiest way to add [SplashEffect]es.
/// {@endtemplate}
///
/// {@tool snippet}
/// Generally, a [SplashBox] should be set as the child of widgets that
/// perform clipping and decoration, and it should be the parent of widgets
/// that create [SplashEffect] effects.
///
/// Example:
///
/// ```dart
/// ClipRRect(
///   borderRadius: BorderRadius.circular(8),
///   child: ColoredBox(
///     color: color,
///     child: const SplashBox(
///       // add an InkWell here,
///       // or a different child that creates Splash effects
///     ),
///   ),
/// );
/// ```
/// {@end-tool}
///
/// {@tool dartpad}
/// This example shows how to make a button using an [SplashBox].
///
/// ** See code in examples/api/lib/widgets/splash_box/splash_box.0.dart **
/// {@end-tool}
///
/// See also:
/// * [SplashController], used by this widget to enable splash effects.
/// * [SplashEffect], the class that holds splash effect data.
class SplashBox extends StatefulWidget {
  /// {@macro flutter.widgets.splash.SplashBox}
  const SplashBox({super.key, this.color, this.child});

  /// The value assigned to [SplashController.color].
  ///
  /// The [SplashBox] widget doesn't paint this color, but the [child]
  /// and its descendants can access its value using [Splash.of].
  ///
  /// If non-null, the widget will absorb hit tests.
  final Color? color;

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final Widget? child;

  @override
  State<SplashBox> createState() => _SplashBoxState();
}

class _SplashBoxState extends State<SplashBox> with TickerProviderStateMixin {
  final GlobalKey _inkFeatureRenderer = GlobalKey(debugLabel: 'ink renderer');

  @override
  Widget build(BuildContext context) {
    final Color? color = widget.color;
    return NotificationListener<LayoutChangedNotification>(
      onNotification: (LayoutChangedNotification notification) {
        final SplashController controller = _inkFeatureRenderer.currentContext!.findRenderObject()! as SplashController;
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

// TODO(nate-thegrate): rename private classes (will involve many test updates)
class _RenderInkFeatures extends RenderProxyBox implements SplashController {
  _RenderInkFeatures({
    RenderBox? child,
    required this.vsync,
    required this.absorbHitTest,
    this.color,
  }) : super(child);

  // This class should exist in a 1:1 relationship with a _SplashBoxState
  // object, since there's no current support for dynamically changing
  // the ticker provider.
  @override
  final TickerProvider vsync;

  // This is here to satisfy the SplashController contract.
  // The actual painting of this color is usually done by the SplashBox's
  // parent.
  @override
  Color? color;

  bool absorbHitTest;

  @visibleForTesting
  List<SplashEffect>? get debugInkFeatures => kDebugMode ? _inkFeatures : null;
  List<SplashEffect>? _inkFeatures;

  @override
  void addSplash(SplashEffect splash) {
    assert(!splash.debugDisposed);
    assert(splash.controller == this);
    _inkFeatures ??= <SplashEffect>[];
    assert(!_inkFeatures!.contains(splash));
    _inkFeatures!.add(splash);
    markNeedsPaint();
  }

  @override
  void addInkFeature(SplashEffect feature) => addSplash(feature);

  @override
  void removeSplash(SplashEffect splash) {
    assert(_inkFeatures != null);
    _inkFeatures!.remove(splash);
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
    final List<SplashEffect>? inkFeatures = _inkFeatures;
    if (inkFeatures != null && inkFeatures.isNotEmpty) {
      final Canvas canvas = context.canvas;
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.clipRect(Offset.zero & size);
      for (final SplashEffect inkFeature in inkFeatures) {
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

  /// This [TickerProvider] will always be an [_SplashBoxState] object.
  ///
  /// This relationship is 1:1 and cannot change for the lifetime of the
  /// widget's state.
  final TickerProvider vsync;

  final bool absorbHitTest;

  @override
  SplashController createRenderObject(BuildContext context) {
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
