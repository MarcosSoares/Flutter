// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'message.dart';

/// A Flutter Driver command that enables or disables the FrameSync mechanism.
class SetFrameSync extends Command {
  /// Creates a command to toggle the FrameSync mechanism.
  const SetFrameSync(this.enabled, { super.timeout });

  /// Deserializes this command from the value generated by [serialize].
  SetFrameSync.deserialize(super.params)
    : enabled = params['enabled']!.toLowerCase() == 'true',
      super.deserialize();

  /// Whether frameSync should be enabled or disabled.
  final bool enabled;

  @override
  String get kind => 'set_frame_sync';

  @override
  Map<String, String> serialize() => super.serialize()..addAll(<String, String>{
    'enabled': '$enabled',
  });
}
