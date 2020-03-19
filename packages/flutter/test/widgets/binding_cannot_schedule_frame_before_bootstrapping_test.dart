// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';

import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:quiver/testing/async.dart';

void main() {
  test('The frames will only be enabled after runApp has bootstrapped the app', () async {
    final WidgetsFlutterBinding binding = WidgetsFlutterBinding.ensureInitialized() as WidgetsFlutterBinding;
    expect(SchedulerBinding.instance.framesEnabled, isFalse);
    // Framework starts with detached statue. Sends resumed signal to enable frame.
    final ByteData message = const StringCodec().encodeMessage('AppLifecycleState.resumed');
    await ServicesBinding.instance.defaultBinaryMessenger.handlePlatformMessage('flutter/lifecycle', message, (_) { });

    binding.attachRootWidget(const Placeholder());
    expect(SchedulerBinding.instance.framesEnabled, isTrue);
  });
}
