// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';

import 'message.dart';

/// A Flutter Driver command that waits until a given [condition] is satisfied.
class WaitForCondition extends Command {
  /// Creates a command that waits for the given [condition] is met.
  const WaitForCondition(this.condition, {super.timeout});

  /// Deserializes this command from the value generated by [serialize].
  ///
  /// The [json] argument cannot be null.
  WaitForCondition.deserialize(super.json)
      : condition = _deserialize(json),
        super.deserialize();

  /// The condition that this command shall wait for.
  final SerializableWaitCondition condition;

  @override
  Map<String, String> serialize() => super.serialize()..addAll(condition.serialize());

  @override
  String get kind => 'waitForCondition';

  @override
  bool get requiresRootWidgetAttached => condition.requiresRootWidgetAttached;
}

/// Thrown to indicate a serialization error.
class SerializationException implements Exception {
  /// Creates a [SerializationException] with an optional error message.
  const SerializationException([this.message]);

  /// The error message, possibly null.
  final String? message;

  @override
  String toString() => 'SerializationException($message)';
}

/// Base class for Flutter Driver wait conditions, objects that describe conditions
/// the driver can wait for.
///
/// This class is sent from the driver script running on the host to the driver
/// extension on device to perform waiting on a given condition. In the extension,
/// it will be converted to a `WaitCondition` that actually defines the wait logic.
///
/// If you subclass this, you also need to implement a `WaitCondition` in the extension.
abstract class SerializableWaitCondition {
  /// A const constructor to allow subclasses to be const.
  const SerializableWaitCondition();

  /// Identifies the name of the wait condition.
  String get conditionName;

  /// Serializes the object to JSON.
  Map<String, String> serialize() {
    return <String, String>{
      'conditionName': conditionName,
    };
  }

  /// Whether this command requires the widget tree to be initialized before
  /// the command may be run.
  ///
  /// This defaults to true to force the application under test to call [runApp]
  /// before attempting to remotely drive the application. Subclasses may
  /// override this to return false if they allow invocation before the
  /// application has started.
  ///
  /// See also:
  ///
  ///  * [WidgetsBinding.isRootWidgetAttached], which indicates whether the
  ///    widget tree has been initialized.
  bool get requiresRootWidgetAttached => true;
}

/// A condition that waits until no transient callbacks are scheduled.
class NoTransientCallbacks extends SerializableWaitCondition {
  /// Creates a [NoTransientCallbacks] condition.
  const NoTransientCallbacks();

  /// Factory constructor to parse a [NoTransientCallbacks] instance from the
  /// given JSON map.
  factory NoTransientCallbacks.deserialize(Map<String, String> json) {
    if (json['conditionName'] != 'NoTransientCallbacksCondition') {
      throw SerializationException('Error occurred during deserializing the NoTransientCallbacksCondition JSON string: $json');
    }
    return const NoTransientCallbacks();
  }

  @override
  String get conditionName => 'NoTransientCallbacksCondition';
}

/// A condition that waits until no pending frame is scheduled.
class NoPendingFrame extends SerializableWaitCondition {
  /// Creates a [NoPendingFrame] condition.
  const NoPendingFrame();

  /// Factory constructor to parse a [NoPendingFrame] instance from the given
  /// JSON map.
  factory NoPendingFrame.deserialize(Map<String, String> json) {
    if (json['conditionName'] != 'NoPendingFrameCondition') {
      throw SerializationException('Error occurred during deserializing the NoPendingFrameCondition JSON string: $json');
    }
    return const NoPendingFrame();
  }

  @override
  String get conditionName => 'NoPendingFrameCondition';
}

/// A condition that waits until the Flutter engine has rasterized the first frame.
class FirstFrameRasterized extends SerializableWaitCondition {
  /// Creates a [FirstFrameRasterized] condition.
  const FirstFrameRasterized();

  /// Factory constructor to parse a [FirstFrameRasterized] instance from the
  /// given JSON map.
  factory FirstFrameRasterized.deserialize(Map<String, String> json) {
    if (json['conditionName'] != 'FirstFrameRasterizedCondition') {
      throw SerializationException('Error occurred during deserializing the FirstFrameRasterizedCondition JSON string: $json');
    }
    return const FirstFrameRasterized();
  }

  @override
  String get conditionName => 'FirstFrameRasterizedCondition';

  @override
  bool get requiresRootWidgetAttached => false;
}

/// A condition that waits until there are no pending platform messages.
class NoPendingPlatformMessages extends SerializableWaitCondition {
  /// Creates a [NoPendingPlatformMessages] condition.
  const NoPendingPlatformMessages();

  /// Factory constructor to parse a [NoPendingPlatformMessages] instance from the
  /// given JSON map.
  factory NoPendingPlatformMessages.deserialize(Map<String, String> json) {
    if (json['conditionName'] != 'NoPendingPlatformMessagesCondition') {
      throw SerializationException('Error occurred during deserializing the NoPendingPlatformMessagesCondition JSON string: $json');
    }
    return const NoPendingPlatformMessages();
  }

  @override
  String get conditionName => 'NoPendingPlatformMessagesCondition';
}

/// A combined condition that waits until all the given [conditions] are met.
class CombinedCondition extends SerializableWaitCondition {
  /// Creates a [CombinedCondition] condition.
  const CombinedCondition(this.conditions);

  /// Factory constructor to parse a [CombinedCondition] instance from the
  /// given JSON map.
  factory CombinedCondition.deserialize(Map<String, String> jsonMap) {
    if (jsonMap['conditionName'] != 'CombinedCondition') {
      throw SerializationException('Error occurred during deserializing the CombinedCondition JSON string: $jsonMap');
    }
    if (jsonMap['conditions'] == null) {
      return const CombinedCondition(<SerializableWaitCondition>[]);
    }

    final List<SerializableWaitCondition> conditions = <SerializableWaitCondition>[];
    for (final Map<String, dynamic> condition in (json.decode(jsonMap['conditions']!) as List<dynamic>).cast<Map<String, dynamic>>()) {
      conditions.add(_deserialize(condition.cast<String, String>()));
    }
    return CombinedCondition(conditions);
  }

  /// A list of conditions it waits for.
  final List<SerializableWaitCondition> conditions;

  @override
  String get conditionName => 'CombinedCondition';

  @override
  Map<String, String> serialize() {
    final Map<String, String> jsonMap = super.serialize();
    final List<Map<String, String>> jsonConditions = conditions.map(
      (SerializableWaitCondition condition) {
        return condition.serialize();
      }).toList();
    jsonMap['conditions'] = json.encode(jsonConditions);
    return jsonMap;
  }
}

/// Parses a [SerializableWaitCondition] or its subclass from the given [json] map.
SerializableWaitCondition _deserialize(Map<String, String> json) {
  final String conditionName = json['conditionName']!;
  switch (conditionName) {
    case 'NoTransientCallbacksCondition':
      return NoTransientCallbacks.deserialize(json);
    case 'NoPendingFrameCondition':
      return NoPendingFrame.deserialize(json);
    case 'FirstFrameRasterizedCondition':
      return FirstFrameRasterized.deserialize(json);
    case 'NoPendingPlatformMessagesCondition':
      return NoPendingPlatformMessages.deserialize(json);
    case 'CombinedCondition':
      return CombinedCondition.deserialize(json);
  }
  throw SerializationException(
      'Unsupported wait condition $conditionName in the JSON string $json');
}
