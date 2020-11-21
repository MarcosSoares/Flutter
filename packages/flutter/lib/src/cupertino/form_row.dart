// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'colors.dart';
import 'theme.dart';

// Prefix widget padding determined via SwiftUI's `Form` view.
const EdgeInsetsGeometry _kDefaultMargins =
    EdgeInsetsDirectional.fromSTEB(16.0, 6.0, 6.0, 6.0);

/// An iOS-style form row.
///
/// Creates an iOS-style split form row with a standard prefix and child widget.
/// Also provides a space for error and helper widgets that appear underneath.
///
/// The [child] parameter is required. This widget is displayed at the end of
/// the row.
///
/// The [prefix] parameter is optional and is displayed at the start of the
/// row. Standard iOS guidelines encourage passing a [Text] widget to [prefix]
/// to detail the nature of the row's [child] widget.
///
/// The [margins] parameter is used to pad the contents of the row. It defaults
/// to the standard iOS padding. If no edge insets are intended, explicitly pass
/// [EdgeInsets.zero] to [margins].
///
/// The [helper] and [error] parameters are both widgets targeted at displaying
/// more information about the row. Both widgets are placed underneath the
/// [prefix] and [child]. When a [Text] is given to [error], it will be shown in
/// [CupertinoColors.destructiveRed] coloring and medium-weighted font.
///
/// {@tool snippet}
///
/// Creates a [CupertinoFormSection] containing a [CupertinoFormRow] with the
/// [prefix], [child], [helper] and [error] widgets.
///
/// ```dart
/// class FlutterDemo extends StatefulWidget {
///   FlutterDemo({Key key}) : super(key: key);
///
///   @override
///   _FlutterDemoState createState() => _FlutterDemoState();
/// }
///
/// class _FlutterDemoState extends State<FlutterDemo> {
///   bool toggleValue = false;
///
///   @override
///   void initState() {
///     super.initState();
///   }
///
///   @override
///   Widget build(BuildContext context) {
///     return CupertinoPageScaffold(
///       child: Center(
///         child: CupertinoFormSection(
///           title: "Section 1",
///           children: [
///             CupertinoFormRow(
///               prefix: Text('Toggle'),
///               helper: Text('Use your instincts'),
///               error: toggleValue ? Text('Can't be true') : null,
///               child: CupertinoSwitch(
///                 value: this.toggleValue,
///                 onChanged: (value) {
///                   setState(() {
///                     this.toggleValue = value;
///                   });
///                 },
///               ),
///             ),
///           ],
///         ),
///       ),
///     );
///   }
/// }
/// ```
/// {@end-tool}
class CupertinoFormRow extends StatelessWidget {
  /// Creates an iOS-style split form row with a standard prefix and child widget.
  /// Also provides a space for error and helper widgets that appear underneath.
  ///
  /// The [child] parameter is required. This widget is displayed at the end of
  /// the row.
  ///
  /// The [prefix] parameter is optional and is displayed at the start of the
  /// row. Standard iOS guidelines encourage passing a [Text] widget to [prefix]
  /// to detail the nature of the row's [child] widget.
  ///
  /// The [margins] parameter is used to pad the contents of the row. It defaults
  /// to the standard iOS padding. If no edge insets are intended, explicitly
  /// pass [EdgeInsets.zero] to [margins].
  ///
  /// The [helper] and [error] parameters are both widgets targeted at displaying
  /// more information about the row. Both widgets are placed underneath the
  /// [prefix] and [child]. When a [Text] is given to [error], it will be shown in
  /// [CupertinoColors.destructiveRed] coloring and medium-weighted font.
  const CupertinoFormRow({
    Key? key,
    required this.child,
    this.prefix,
    this.margins,
    this.helper,
    this.error,
  }) : super(key: key);

  /// A widget that is displayed at the start of the row.
  ///
  /// The [prefix] parameter is displayed at the start of the row. Standard iOS
  /// guidelines encourage passing a [Text] widget to [prefix] to detail the
  /// nature of the row's [child] widget.
  final Widget? prefix;

  /// Margins used to pad the contents of the row.
  ///
  /// Defaults to the standard iOS padding for form rows. If no edge insets are
  /// intended, explicitly pass [EdgeInsets.zero] to [margins].
  final EdgeInsetsGeometry? margins;

  /// A widget that is displayed underneath the [prefix] and [child] widgets.
  ///
  /// The [helper] appears in primary label coloring, and is meant to inform the
  /// user about interaction with the child widget.
  final Widget? helper;

  /// A widget that is displayed underneath the [prefix] and [child] widgets.
  ///
  /// The [error] widget is primarily used to inform users of input errors. When
  /// a [Text] is given to [error], it will be shown in
  /// [CupertinoColors.destructiveRed] coloring and medium-weighted font.
  final Widget? error;

  /// Child widget.
  ///
  /// The [child] widget is primarily used for input. It end-aligned and
  /// flexible, taking up the entire space trailing past the [prefix] widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final CupertinoThemeData themeData = CupertinoTheme.of(context);
    final TextStyle textStyle = themeData.textTheme.textStyle;

    final List<Widget> rowChildren = <Widget>[
      if (prefix != null)
        DefaultTextStyle(
          style: textStyle,
          child: prefix!,
        ),
      Flexible(
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          child: child,
        ),
      ),
    ];

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: CupertinoColors.systemBackground,
      ),
      child: Padding(
        padding: margins ?? _kDefaultMargins,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowChildren,
            ),
            if (helper != null)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: DefaultTextStyle(
                  style: textStyle,
                  textAlign: TextAlign.start,
                  child: helper!,
                ),
              ),
            if (error != null)
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    color: CupertinoColors.destructiveRed,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.start,
                  child: error!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
