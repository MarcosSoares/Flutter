// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart = 2.8

import 'dart:convert';

import 'package:args/command_runner.dart';
import 'package:flutter_tools/src/android/android_sdk.dart';
import 'package:flutter_tools/src/android/android_studio.dart';
import 'package:flutter_tools/src/base/context.dart';
import 'package:flutter_tools/src/build_info.dart';
import 'package:flutter_tools/src/cache.dart';
import 'package:flutter_tools/src/commands/config.dart';
import 'package:flutter_tools/src/globals.dart' as globals;
import 'package:flutter_tools/src/reporting/reporting.dart';
import 'package:flutter_tools/src/version.dart';
import 'package:mockito/mockito.dart';

import '../../src/common.dart';
import '../../src/context.dart';

void main() {
  MockAndroidStudio mockAndroidStudio;
  MockAndroidSdk mockAndroidSdk;
  MockFlutterVersion mockFlutterVersion;
  TestUsage testUsage;

  setUpAll(() {
    Cache.disableLocking();
  });

  setUp(() {
    mockAndroidStudio = MockAndroidStudio();
    mockAndroidSdk = MockAndroidSdk();
    mockFlutterVersion = MockFlutterVersion();
    testUsage = TestUsage();
  });

  void verifyNoAnalytics() {
    expect(testUsage.commands, isEmpty);
    expect(testUsage.events, isEmpty);
    expect(testUsage.timings, isEmpty);
  }

  group('config', () {
    testUsingContext('machine flag', () async {
      final ConfigCommand command = ConfigCommand();
      await command.handleMachine();

      expect(testLogger.statusText, isNotEmpty);
      final dynamic jsonObject = json.decode(testLogger.statusText);
      expect(jsonObject, isMap);

      expect(jsonObject.containsKey('android-studio-dir'), true);
      expect(jsonObject['android-studio-dir'], isNotNull);

      expect(jsonObject.containsKey('android-sdk'), true);
      expect(jsonObject['android-sdk'], isNotNull);
      verifyNoAnalytics();
    }, overrides: <Type, Generator>{
      AndroidStudio: () => mockAndroidStudio,
      AndroidSdk: () => mockAndroidSdk,
      Usage: () => testUsage,
    });

    testUsingContext('Can set build-dir', () async {
      final ConfigCommand configCommand = ConfigCommand();
      final CommandRunner<void> commandRunner = createTestCommandRunner(configCommand);

      await commandRunner.run(<String>[
        'config',
        '--build-dir=foo',
      ]);

      expect(getBuildDirectory(), 'foo');
      verifyNoAnalytics();
    }, overrides: <Type, Generator>{
      Usage: () => testUsage,
    });

    testUsingContext('throws error on absolute path to build-dir', () async {
      final ConfigCommand configCommand = ConfigCommand();
      final CommandRunner<void> commandRunner = createTestCommandRunner(configCommand);

      expect(() => commandRunner.run(<String>[
        'config',
        '--build-dir=/foo',
      ]), throwsToolExit());
      verifyNoAnalytics();
    }, overrides: <Type, Generator>{
      Usage: () => testUsage,
    });

    testUsingContext('allows setting and removing feature flags', () async {
      final ConfigCommand configCommand = ConfigCommand();
      final CommandRunner<void> commandRunner = createTestCommandRunner(configCommand);

      await commandRunner.run(<String>[
        'config',
        '--enable-web',
        '--enable-linux-desktop',
        '--enable-windows-desktop',
        '--enable-macos-desktop',
      ]);

      expect(globals.config.getValue('enable-web'), true);
      expect(globals.config.getValue('enable-linux-desktop'), true);
      expect(globals.config.getValue('enable-windows-desktop'), true);
      expect(globals.config.getValue('enable-macos-desktop'), true);

      await commandRunner.run(<String>[
        'config', '--clear-features',
      ]);

      expect(globals.config.getValue('enable-web'), null);
      expect(globals.config.getValue('enable-linux-desktop'), null);
      expect(globals.config.getValue('enable-windows-desktop'), null);
      expect(globals.config.getValue('enable-macos-desktop'), null);

      await commandRunner.run(<String>[
        'config',
        '--no-enable-web',
        '--no-enable-linux-desktop',
        '--no-enable-windows-desktop',
        '--no-enable-macos-desktop',
      ]);

      expect(globals.config.getValue('enable-web'), false);
      expect(globals.config.getValue('enable-linux-desktop'), false);
      expect(globals.config.getValue('enable-windows-desktop'), false);
      expect(globals.config.getValue('enable-macos-desktop'), false);
      verifyNoAnalytics();
    }, overrides: <Type, Generator>{
      AndroidStudio: () => mockAndroidStudio,
      AndroidSdk: () => mockAndroidSdk,
      Usage: () => testUsage,
    });

    testUsingContext('warns the user to reload IDE', () async {
      final ConfigCommand configCommand = ConfigCommand();
      final CommandRunner<void> commandRunner = createTestCommandRunner(configCommand);

      await commandRunner.run(<String>[
        'config',
        '--enable-web'
      ]);

      expect(
        testLogger.statusText,
        containsIgnoringWhitespace('You may need to restart any open editors'),
      );
    }, overrides: <Type, Generator>{
      Usage: () => testUsage,
    });

    testUsingContext('displays which config settings are available on stable', () async {
      when(mockFlutterVersion.channel).thenReturn('stable');
      final ConfigCommand configCommand = ConfigCommand();
      final CommandRunner<void> commandRunner = createTestCommandRunner(configCommand);

      await commandRunner.run(<String>[
        'config',
        '--enable-web',
        '--enable-linux-desktop',
        '--enable-windows-desktop',
        '--enable-macos-desktop',
      ]);

      await commandRunner.run(<String>[
        'config',
      ]);

      expect(
        testLogger.statusText,
        containsIgnoringWhitespace('enable-web: true'),
      );
      expect(
        testLogger.statusText,
        containsIgnoringWhitespace('enable-linux-desktop: true'),
      );
      expect(
        testLogger.statusText,
        containsIgnoringWhitespace('enable-windows-desktop: true'),
      );
      expect(
        testLogger.statusText,
        containsIgnoringWhitespace('enable-macos-desktop: true'),
      );
      verifyNoAnalytics();
    }, overrides: <Type, Generator>{
      AndroidStudio: () => mockAndroidStudio,
      AndroidSdk: () => mockAndroidSdk,
      FlutterVersion: () => mockFlutterVersion,
      Usage: () => testUsage,
    });

    testUsingContext('no-analytics flag flips usage flag and sends event', () async {
      final ConfigCommand configCommand = ConfigCommand();
      final CommandRunner<void> commandRunner = createTestCommandRunner(configCommand);

      expect(testUsage.enabled, true);
      await commandRunner.run(<String>[
        'config',
        '--no-analytics',
      ]);

      expect(testUsage.enabled, false);

      // Verify that we flushed the analytics queue.
      expect(testUsage.ensureAnalyticsSentCalls, 1);

      // Verify that we only send the analytics disable event, and no other
      // info.
      expect(testUsage.events, equals(<TestUsageEvent>[
        const TestUsageEvent('analytics', 'enabled', label: 'false'),
      ]));
      expect(testUsage.commands, isEmpty);
      expect(testUsage.timings, isEmpty);
    }, overrides: <Type, Generator>{
      Usage: () => testUsage,
    });

    testUsingContext('analytics flag flips usage flag and sends event', () async {
      final ConfigCommand configCommand = ConfigCommand();
      final CommandRunner<void> commandRunner = createTestCommandRunner(configCommand);

      await commandRunner.run(<String>[
        'config',
        '--analytics',
      ]);

      expect(testUsage.enabled, true);

      // Verify that we only send the analytics enable event, and no other
      // info.
      expect(testUsage.events, equals(<TestUsageEvent>[
        const TestUsageEvent('analytics', 'enabled', label: 'true'),
      ]));
      expect(testUsage.commands, isEmpty);
      expect(testUsage.timings, isEmpty);
    }, overrides: <Type, Generator>{
      Usage: () => testUsage,
    });

    testUsingContext('analytics reported disabled when suppressed', () async {
      final ConfigCommand configCommand = ConfigCommand();
      final CommandRunner<void> commandRunner = createTestCommandRunner(configCommand);

      testUsage.suppressAnalytics = true;

      await commandRunner.run(<String>[
        'config',
      ]);

      expect(
        testLogger.statusText,
        containsIgnoringWhitespace('Analytics reporting is currently disabled'),
      );
    }, overrides: <Type, Generator>{
      Usage: () => testUsage,
    });
  });
}

class MockAndroidStudio extends Mock implements AndroidStudio, Comparable<AndroidStudio> {
  @override
  String get directory => 'path/to/android/stdio';
}

class MockAndroidSdk extends Mock implements AndroidSdk {
  @override
  String get directory => 'path/to/android/sdk';
}

class MockFlutterVersion extends Mock implements FlutterVersion {}
