// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show hashValues;

import 'package:meta/meta.dart';

/// A object representation of a frame from a stack trace.
///
/// {@tool sample}
///
/// For example, a caller that wishes to traverse the stack could use
///
/// ```dart
/// final List<StackFrame> currentFrames = StackFrame.fromStackTrace(StackTrace.current);
/// ```
///
/// To create a traversable parsed stack.
/// {@end-tool}
@immutable
class StackFrame {
  /// Creates a new StackFrame instance.
  ///
  /// All parameters must not be null. The [className] may be the empty string
  /// if there is no class (e.g. for a top level library method).
  const StackFrame(
    this.number, {
    @required this.column,
    @required this.line,
    @required this.packageScheme,
    @required this.package,
    @required this.packagePath,
    this.className = '',
    @required this.method,
    this.isConstructor = false,
  })  : assert(number != null),
        assert(column != null),
        assert(line != null),
        assert(method != null),
        assert(packageScheme != null),
        assert(package != null),
        assert(packagePath != null),
        assert(className != null),
        assert(isConstructor != null);

  /// A stack frame representing an asynchronous suspension.
  static const StackFrame asynchronousSuspension = StackFrame(
    -1,
    column: -1,
    line: -1,
    method: 'asynchronous suspension',
    packageScheme: '',
    package: '',
    packagePath: '',
  );

  /// Parses a list of [StackFrame]s from a [StackTrace] object.
  ///
  /// This is normally useful with [StackTrace.current].
  static List<StackFrame> fromStackTrace(StackTrace stack) {
    assert(stack != null);
    return fromStackString(stack.toString());
  }

  /// Parses a list of [StackFrame]s from the [StackTrace.toString] method.
  static List<StackFrame> fromStackString(String stack) {
    assert(stack != null);
    return stack
        .trim()
        .split('\n')
        .map(fromStackTraceLine)
        .toList();
  }

  static StackFrame _parseWebFrame(String line) {
    final RegExp parser = RegExp(r'^(package:.+) (\d+):(\d+)\s+(.+)$');
    final Match match = parser.firstMatch(line);
    assert(match != null, 'Expecgted $line to match $parser.');

    final Uri packageUri = Uri.parse(match.group(1));

    return StackFrame(
      -1,
      packageScheme: 'package',
      package: packageUri.pathSegments[0],
      packagePath: packageUri.path.replaceFirst(packageUri.pathSegments[0] + '/', ''),
      line: int.parse(match.group(2)),
      column: int.parse(match.group(3)),
      className: '<unknown>',
      method: match.group(4),
    );
  }

  /// Parses a single [StackFrame] from a single line of a [StackTrace].
  static StackFrame fromStackTraceLine(String line) {
    assert(line != null);
    if (line == '<asynchronous suspension>') {
      return asynchronousSuspension;
    }

    // Web frames.
    if (line.startsWith('package')) {
      return _parseWebFrame(line);
    }

    final RegExp parser = RegExp(r'^#(\d+) +(.+) \((.+?):(\d+):?(\d+){0,1}\)$');
    final Match match = parser.firstMatch(line);
    assert(match != null, 'Expected $line to match $parser.');

    bool isConstructor = false;
    String className = '';
    String method = match.group(2).replaceAll('.<anonymous closure>', '');
    if (method.startsWith('new')) {
      className = method.split(' ')[1];
      method = '';
      if (className.contains('.')) {
        final List<String> parts  = className.split('.');
        className = parts[0];
        method = parts[1];
      }
      isConstructor = true;
    } else if (method.contains('.')) {
      final List<String> parts = method.split('.');
      className = parts[0];
      method = parts[1];
    }

    final Uri packageUri = Uri.parse(match.group(3));
    String package = '<unknown>';
    String packagePath = packageUri.path;
    if (packageUri.scheme == 'dart' || packageUri.scheme == 'package') {
      package = packageUri.pathSegments[0];
      packagePath = packageUri.path.replaceFirst(packageUri.pathSegments[0] + '/', '');
    }

    return StackFrame(
      int.parse(match.group(1)),
      className: className,
      method: method,
      packageScheme: packageUri.scheme,
      package: package,
      packagePath: packagePath,
      line: int.parse(match.group(4)),
      column: match.group(5) == null ? -1 : int.parse(match.group(5)),
      isConstructor: isConstructor,
    );
  }

  /// The zero-indexed frame number.
  final int number;

  /// The scheme of the package for this frame, e.g. "dart" for
  /// dart:core/errors_patch.dart or "package" for
  /// package:flutter/src/widgets/text.dart.
  ///
  /// The path property refers to the source file.
  final String packageScheme;

  /// The package for this frame, e.g. "core" for
  /// dart:core/errors_patch.dart or "flutter" for
  /// package:flutter/src/widgets/text.dart.
  final String package;

  /// The path of the file for this frame, e.g. "errors_patch.dart" for
  /// dart:core/errors_patch.dart or "src/widgets/text.dart" for
  /// package:flutter/src/widgets/text.dart.
  final String packagePath;

  /// The source line number.
  final int line;

  /// The source column number.
  final int column;

  /// The class name, if any, for this frame.
  ///
  /// This may be null for top level methods in a library or anonymous closure
  /// methods.
  final String className;

  /// The method name for this frame.
  ///
  /// This will be an empty string if the stack frame is from the default
  /// constructor.
  final String method;

  /// Whether or not this was thrown from a constructor.
  final bool isConstructor;

  @override
  int get hashCode => hashValues(number, package, line, column, className, method);

  @override
  bool operator ==(Object other) {
    if (runtimeType != other.runtimeType)
      return false;
    return other is StackFrame &&
        number == other.number &&
        package == other.package &&
        line == other.line &&
        column == other.column &&
        className == other.className &&
        method == other.method;
  }

  @override
  String toString() => '$runtimeType(#$number, $packageScheme:$package/$packagePath:$line:$column, className: $className, method: $method)';
}
