// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:leak_tracker_flutter_testing/leak_tracker_flutter_testing.dart';

import 'utils/leaking_classes.dart';

late final String _test1TrackingOnNoLeaks;
late final String _test2TrackingOffLeaks;
late final String _test3TrackingOnLeaks;
late final String _test4TrackingOnWithCreationStackTrace;
late final String _test5TrackingOnWithDisposalStackTrace;
late final String _test61TrackingOnNoLeaks;
late final String _test62TrackingOnNoLeaks;
late final String _test63TrackingOnNotDisposed;

void main() {
  collectedLeaksReporter = (Leaks leaks) => verifyLeaks(leaks);
  LeakTesting.settings = LeakTesting.settings.copyWith(ignoredLeaks: const IgnoredLeaks(), ignore: false);

  // It is important that the test file starts with group, to test that leaks are collected for all tests after group too.
  group('Group', () {
    testWidgets('test', (_) async {
      StatelessLeakingWidget();
    });
  });

  testWidgets(_test1TrackingOnNoLeaks = 'test1, tracking-on, no leaks', (WidgetTester widgetTester) async {
    expect(LeakTracking.isStarted, true);
    expect(LeakTracking.phase.name, _test1TrackingOnNoLeaks);
    expect(LeakTracking.phase.ignoreLeaks, false);
    await widgetTester.pumpWidget(Container());
  });

  testWidgets(
    _test2TrackingOffLeaks = 'test2, tracking-off, leaks',
    experimentalLeakTesting: LeakTesting.settings.withIgnoredAll(),
  (WidgetTester widgetTester) async {
    expect(LeakTracking.isStarted, true);
    expect(LeakTracking.phase.name, null);
    expect(LeakTracking.phase.ignoreLeaks, true);
    await widgetTester.pumpWidget(StatelessLeakingWidget());
  });

  testWidgets(_test3TrackingOnLeaks = 'test3, tracking-on, leaks', (WidgetTester widgetTester) async {
    expect(LeakTracking.isStarted, true);
    expect(LeakTracking.phase.name, _test3TrackingOnLeaks);
    expect(LeakTracking.phase.ignoreLeaks, false);
    await widgetTester.pumpWidget(StatelessLeakingWidget());
  });

  testWidgets(
    _test4TrackingOnWithCreationStackTrace = 'test4, tracking-on, with creation stack trace',
    experimentalLeakTesting: LeakTesting.settings.withCreationStackTrace(),
  (WidgetTester widgetTester) async {
      expect(LeakTracking.isStarted, true);
      expect(LeakTracking.phase.name, _test4TrackingOnWithCreationStackTrace);
      expect(LeakTracking.phase.ignoreLeaks, false);
      await widgetTester.pumpWidget(StatelessLeakingWidget());
    },
  );

  testWidgets(
    _test5TrackingOnWithDisposalStackTrace = 'test5, tracking-on, with disposal stack trace',
  experimentalLeakTesting: LeakTesting.settings.withDisposalStackTrace(),
    (WidgetTester widgetTester) async {
      expect(LeakTracking.isStarted, true);
      expect(LeakTracking.phase.name, _test5TrackingOnWithDisposalStackTrace);
      expect(LeakTracking.phase.ignoreLeaks, false);
      await widgetTester.pumpWidget(StatelessLeakingWidget());
    },
  );

  group('dispose in tear down', () {
    test(_test61TrackingOnNoLeaks = 'test61, tracking-on, no leaks', () {
      LeakTrackedClass().dispose();
    });

    test(_test62TrackingOnNoLeaks = 'test62, tracking-on, no leaks', () {
      final LeakTrackedClass myClass = LeakTrackedClass();
      addTearDown(myClass.dispose);
    });

    test(_test63TrackingOnNotDisposed = 'test63, tracking-on, not disposed leak', () {
      LeakTrackedClass();
    });
  });
}

bool _leakReporterIsInvoked = false;

void verifyLeaks(Leaks leaks) {
  expect(_leakReporterIsInvoked, false);
  _leakReporterIsInvoked = true;

  try {
    expect(leaks, isLeakFree);
  } on TestFailure catch (e) {
    expect(e.message, contains('https://github.com/dart-lang/leak_tracker'));

    expect(e.message, isNot(contains(_test1TrackingOnNoLeaks)));
    expect(e.message, isNot(contains(_test2TrackingOffLeaks)));
    expect(e.message, contains('test: $_test3TrackingOnLeaks'));
    expect(e.message, contains('test: $_test4TrackingOnWithCreationStackTrace'));
    expect(e.message, contains('test: $_test5TrackingOnWithDisposalStackTrace'));
    expect(e.message, isNot(contains(_test61TrackingOnNoLeaks)));
    expect(e.message, isNot(contains(_test62TrackingOnNoLeaks)));
    expect(e.message, contains('test: $_test63TrackingOnNotDisposed'));
  }

  _verifyLeaks(
    leaks,
    _test3TrackingOnLeaks,
    notDisposed: 1,
    notGCed: 1,
    expectedContextKeys: <LeakType, List<String>>{
      LeakType.notGCed: <String>[],
      LeakType.notDisposed: <String>[],
    },
  );
  _verifyLeaks(
    leaks,
    _test4TrackingOnWithCreationStackTrace,
    notDisposed: 1,
    notGCed: 1,
    expectedContextKeys: <LeakType, List<String>>{
      LeakType.notGCed: <String>['start'],
      LeakType.notDisposed: <String>['start'],
    },
  );
  _verifyLeaks(
    leaks,
    _test5TrackingOnWithDisposalStackTrace,
    notDisposed: 1,
    notGCed: 1,
    expectedContextKeys: <LeakType, List<String>>{
      LeakType.notGCed: <String>['disposal'],
      LeakType.notDisposed: <String>[],
    },
  );
  _verifyLeaks(
    leaks,
    _test63TrackingOnNotDisposed,
    notDisposed: 1,
    expectedContextKeys: <LeakType, List<String>>{},
  );
}

/// Verifies [allLeaks] contains expected number of leaks for the test [testName].
///
/// [notDisposed] and [notGCed] set number for expected leaks by leak type.
void _verifyLeaks(
  Leaks allLeaks,
  String testName, {
  int notDisposed = 0,
  int notGCed = 0,
  Map<LeakType, List<String>> expectedContextKeys = const <LeakType, List<String>>{},
}) {

  const String linkToLeakTracker = 'https://github.com/dart-lang/leak_tracker';

  final Leaks testLeaks = Leaks(
    allLeaks.byType.map(
      (LeakType key, List<LeakReport> value) =>
          MapEntry<LeakType, List<LeakReport>>(key, value.where((LeakReport leak) => leak.phase == testName).toList()),
    ),
  );

  for (final LeakType type in expectedContextKeys.keys) {
    final List<LeakReport> leaks = testLeaks.byType[type]!;
    final List<String> expectedKeys = expectedContextKeys[type]!..sort();
    for (final LeakReport leak in leaks) {
      final List<String> actualKeys = leak.context?.keys.toList() ?? <String>[];
      expect(actualKeys..sort(), equals(expectedKeys), reason: '$testName, $type');
    }
  }

  if (notDisposed + notGCed > 0) {
    expect(
      () => expect(testLeaks, isLeakFree),
      throwsA(
        predicate((Object? e) {
          return e is TestFailure && e.toString().contains(linkToLeakTracker);
        }),
      ),
    );
  } else {
    expect(testLeaks, isLeakFree);
  }

  _verifyLeakList(
    testLeaks.notDisposed,
    notDisposed,
  );
  _verifyLeakList(
    testLeaks.notGCed,
    notGCed,
  );
}

void _verifyLeakList(
  List<LeakReport> list,
  int expectedCount,
) {
  expect(list.length, expectedCount);

  for (final LeakReport leak in list) {
    expect(leak.trackedClass, contains(LeakTrackedClass.library));
    expect(leak.trackedClass, contains('$LeakTrackedClass'));
  }
}
